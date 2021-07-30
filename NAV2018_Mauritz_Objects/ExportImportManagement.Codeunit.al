Codeunit 80000 "Export/Import Management"
{
    TableNo = "Export/Import Header";

    trigger OnRun()
    begin
        Header := Rec;
        Log.InitLog(Header.Code);

        case Header.Direction of
          Header.Direction::Import:  ProceedImport;
          Header.Direction::Export:  ProceedExport;
        end;
    end;

    var
        InfoDlg: Dialog;
        ImportedRecords: Integer;
        ImportBuffer: Record "Import Buffer";
        Log: Record "Export/Import Log Entry";
        Header: Record "Export/Import Header";
        PreviewMode: Boolean;
        SEPARATOR_NOT_FOUND: label 'Datensatz %1 konnte nicht anhand des Trennzeichens [%2] zerlegt werden.';
        RECORD_SEPARATOR_NOT_FOUND: label 'Datei konnte nicht anhand des Trennzeichens [%1] zerlegt werden.';
        FILE_MOVED: label 'Datei %1 wurde in den Ordner %2 verschoben.';


    procedure Preview(PreviewHeader: Record "Export/Import Header"): Text
    begin
        Header := PreviewHeader;
        Log.InitLog(Header.Code);

        PreviewMode := true;
        case Header.Direction of
          Header.Direction::Import:  ProceedImport;
          Header.Direction::Export:  exit(ProceedExport);
        end;
        PreviewMode := false;
    end;

    local procedure ProceedImport()
    var
        FileList: dotnet List_Of_T;
        ServerFileList: dotnet List_Of_T;
        i: Integer;
        WorkFileName: Text;
        OriginalFileName: Text;
        FILE_COULD_NOT_BE_MOVED: label 'Die Datei %1 konnte nicht verschoben werden.';
        DestinationFolder: Text;
        ImportOk: Boolean;
    begin
        if GuiAllowed then
          InfoDlg.Open('Import läuft ...\ \'+
                       'Datei:     #1#################################################\' +
                       'Datensatz: #2#######');

        Log.LogInfo(Log.Class::ExportImport, 'Import gestartet.');

        if not GetFilesToImport(FileList, ServerFileList) then begin
          Log.LogResult(2);
          if GuiAllowed then
            if TryCloseDialog then;
          exit;
        end;

        ImportBuffer.InitBuffer(Header.Code);
        ImportOk := true;

        for i := 0 to FileList.Count - 1 do begin
          if TryUpdateDialog(1, FileList.Item(i)) then;

          OriginalFileName := FileList.Item(i);
          if GuiAllowed then
            WorkFileName := ServerFileList.Item(i)
          else
            WorkFileName := FileList.Item(i);

          ImportOk := ImportFileRegEx(WorkFileName, OriginalFileName, ImportedRecords);
          if not PreviewMode then begin
            if ImportOk then
              DestinationFolder := Header."Move File On Success"
            else
              DestinationFolder := Header."Move File On Error";

            if DestinationFolder <> '' then begin
              if not MoveFile(OriginalFileName, DestinationFolder) then begin
                Log.LogError(Log.Class::File, StrSubstNo(FILE_COULD_NOT_BE_MOVED, OriginalFileName), false);
                ImportOk := false;
              end else
                Log.LogInfo(Log.Class::File, StrSubstNo(FILE_MOVED, OriginalFileName, DestinationFolder));
            end;
          end;
        end;

        if ImportOk then
          Log.LogResult(0)
        else
          Log.LogResult(3);

        case Header."Post Processing Object Type" of
          Header."post processing object type"::Codeunit:
            if not PreviewMode then
              Codeunit.Run(Header."Post Processing Object ID", ImportBuffer);
          Header."post processing object type"::Report:
            if not PreviewMode then
              Report.Run(Header."Post Processing Object ID", false, false, ImportBuffer);
          else
              ProceedBuffer;
        end;
        if GuiAllowed then
          if TryCloseDialog then;
    end;

    local procedure GetFilesToImport(var FileList: dotnet List_Of_T;var ServerFileList: dotnet List_Of_T) FilesFound: Boolean
    var
        ImportFileFilter: Text;
        Path: Text;
        [RunOnClient]
        Directory: dotnet Directory;
        [RunOnClient]
        TempFileList: dotnet List_Of_T;
        LOCAL_SELECT_FILE: label 'Select file';
        FileMgt: Codeunit "File Management";
        i: Integer;
        IMPORT_FILE_FILTER_MISSING: label 'Ein %1 muss angegeben werden, wenn der Import automatisch gestartet werden soll.';
    begin
        ImportFileFilter := Header."Import File Filter";

        if IsNull(FileList) then
          FileList := FileList.List();
        if GuiAllowed then
          if IsNull(ServerFileList) then
            ServerFileList := ServerFileList.List();

        if ImportFileFilter = '' then begin
          if not PreviewMode then begin
            if not GuiAllowed then
              Log.LogError(Log.Class::ExportImport, StrSubstNo(IMPORT_FILE_FILTER_MISSING, Header.FieldCaption("Import File Filter")), true)
            else
              ServerFileList.Add(FileMgt.UploadFile(LOCAL_SELECT_FILE, ''));
            exit(true);
          end;
          exit(true);
        end else begin
          while StrPos(ImportFileFilter, '\') > 0 do begin
            Path += CopyStr(ImportFileFilter, 1, StrPos(ImportFileFilter, '\'));
            ImportFileFilter := CopyStr(ImportFileFilter, StrPos(ImportFileFilter, '\') + 1);
          end;
          Path := CopyStr(Path, 1, StrLen(Path)-1);

          TempFileList := TempFileList.List();
          TempFileList.AddRange(Directory.GetFiles(Path, ImportFileFilter));

          Log.LogInfo(Log.Class::ExportImport, StrSubstNo('%1 Datei(en) gefunden (Filter="%2")', TempFileList.Count, Header."Import File Filter"));

          if TempFileList.Count = 0 then
            exit(false)
          else begin
            for i := 0 to TempFileList.Count - 1 do begin
              if GuiAllowed then
                ServerFileList.Add(FileMgt.UploadFileSilent(Format(TempFileList.Item(i))));
              FileList.Add(TempFileList.Item(i));
            end;
            exit(true);
          end;
        end;
    end;

    local procedure ImportFileFixLength(Filename: Text) ImportedRecords: Integer
    var
        ImportedText: Text;
        ImportedValue: Text;
        Line: Record "Import Line";
        Fld: Record "Field";
        Separator: Text[2];
        NOSMgmt: Codeunit NoSeriesManagement;
        TempImportBuffer: Record "Import Buffer" temporary;
        SkipRecord: Boolean;
        SkipTopLines: Integer;
    begin
        if ReadFile(Filename, ImportedText) then
          Log.LogInfo(Log.Class::File, StrSubstNo('%1 erfolgreich gelesen', Filename))
        else begin
          Log.LogError(Log.Class::File, StrSubstNo('%1 konnte nicht gelesen werden: %2', Filename, GetLastErrorText), false);
          exit(0);
        end;

        TempImportBuffer.InitBuffer(Header.Code);

        Line.SetRange(Code, Header.Code);
        if Line.FindSet(false) then
          repeat
            if Line."Source Type" = Line."source type"::Field then begin
              Line.TestField("Source Position");
              Line.TestField("Source Length");
            end;
          until Line.Next = 0;

        Line.FindSet(false);
        SkipTopLines := Header."Skip First Lines";

        while StrLen(ImportedText) > 0 do begin
          if not SkipRecord then
            case Line."Source Type" of
              Line."source type"::Field:
                begin
                  ImportedValue := CopyStr(ImportedText, Line."Source Position", Line."Source Length");
                  TempImportBuffer.StoreValue(Line, ImportedValue);
                  if Line."Source Filter" <> '' then
                    if Fld.Get(Line."Destination Table No.", Line."Destination Field No.") then
                      SkipRecord := SkipRecord or not ValueMatchesFilter(ImportedValue, Format(Fld.Type), Line."Source Filter");
                end;
              Line."source type"::FixValue:
                TempImportBuffer.StoreValue(Line, Line."Source Value");
              Line."source type"::NumberSeries:
                TempImportBuffer.StoreValue(Line, NOSMgmt.GetNextNo(Line."Source Number Series", WorkDate, true));
            end;

          if Line.Next = 0 then begin
            Line.FindSet(false);
            if not SkipRecord then begin
              TempImportBuffer.SetNewRecord;
              ImportedRecords += 1;
            end else begin
              TempImportBuffer.DeleteRecord;
              ImportedRecords -= 1;
            end;
            if TryUpdateDialog(2, ImportedRecords) then;

            if Separator = '' then
              Separator := GetSeparator(ImportedText);
            if StrPos(ImportedText, Separator) > 0 then
              ImportedText := CopyStr(ImportedText, StrPos(ImportedText, Separator) + StrLen(Separator))
            else
              Clear(ImportedText);
            Clear(SkipRecord);
          end;
        end;

        if SkipTopLines > 0 then
          if TempImportBuffer.FindFirst then begin
            TempImportBuffer.SetRange("Record No.", TempImportBuffer."Record No.");
            TempImportBuffer.DeleteAll;
            TempImportBuffer.Reset;
            SkipTopLines -= 1;
          end;

        ImportBuffer.StoreBuffer(TempImportBuffer);
        Log.LogResult(0);
    end;

    local procedure ImportFileRegEx(Filename: Text;OriginalFileName: Text;var ImportedRecords: Integer) ImportOk: Boolean
    var
        ImportedText: Text;
        TempImportBuffer: Record "Import Buffer" temporary;
        RecordList: dotnet List_Of_T;
        ValuesArray: dotnet Array;
        Regex: dotnet Regex;
        i: Integer;
        SplitRegEx: Text;
        ImportLine: Record "Import Line";
        Value: Text;
        NOSMgmt: Codeunit NoSeriesManagement;
        SkipRecord: Boolean;
        Fld: Record "Field";
        File: dotnet File;
        DestFolderName: Text;
        FIELD_NOT_FOUND: label 'Der Datensatz %1 enthält kein Feld %2.';
        RECORD_IS_EMPTY: label 'Der Datensatz %1 ist leer.';
    begin
        ImportOk := true;

        ImportOk := ReadFile(Filename, ImportedText);
        if ImportOk then
          Log.LogInfo(Log.Class::File, StrSubstNo('%1 erfolgreich gelesen', OriginalFileName))
        else begin
          Log.LogError(Log.Class::File, StrSubstNo('%1 konnte nicht gelesen werden: %2', OriginalFileName, GetLastErrorText), false);
          exit(false);
        end;

        TempImportBuffer.InitBuffer(Header.Code);

        GetRecordsRegEx(ImportedText, RecordList);
        ImportOk := ImportOk;
        if not ImportOk then
          Log.LogError(Log.Class::File, GetLastErrorText, false);

        SplitRegEx := Header."Field Separator";

        ImportLine.SetRange(Code, Header.Code);

        i:= Header."Skip First Lines";

        repeat
          ImportedText := RecordList.Item(i);
          if ImportedText = '' then
            Log.LogInfo(Log.Class::Record, StrSubstNo(RECORD_IS_EMPTY, i+1))
          else begin
            if Header.Type = Header.Type::VarText then begin
              ValuesArray := Regex.Split(ImportedText, SplitRegEx);
              if ValuesArray.Length < 2 then begin
                Log.LogWarning(Log.Class::Record, StrSubstNo(SEPARATOR_NOT_FOUND, i, SplitRegEx));
                ImportOk := false;
              end;
            end;

            with ImportLine do begin
              if FindSet(false) then
                repeat
                  Clear(Value);
                  case "Source Type" of
                    "source type"::AutoIncrement: ;
                    "source type"::Field:
                      case Header.Type of
                        Header.Type::FixText:
                          begin
                            Value := CopyStr(ImportedText, "Source Position", "Source Length");
                          end;
                        Header.Type::VarText:
                          begin
                            if (ValuesArray.Length >= "Source Field No.") and ("Source Field No." > 0) then
                              Value := ValuesArray.GetValue("Source Field No." - 1)
                            else begin
                              Value := '';
                              Log.LogWarning(Log.Class::Field, StrSubstNo(FIELD_NOT_FOUND, i+1, "Source Field No."));
                            end;
                          end;
                      end;
                    "source type"::FixValue: Value := "Source Value";
                    "source type"::NumberSeries: Value := NOSMgmt.GetNextNo("Source Number Series", WorkDate, not(PreviewMode));
                  end;
                  TempImportBuffer.StoreValue(ImportLine, Value);

                  if "Source Filter" <> '' then begin
                    if Fld.Get("Destination Table No.", "Destination Field No.") then
                      SkipRecord := SkipRecord or not ValueMatchesFilter(Value, Format(Fld.Type), "Source Filter")
                    else
                      SkipRecord := SkipRecord or not ValueMatchesFilter(Value, 'Text', "Source Filter");
                  end;

                until Next = 0;
            end;

            if not SkipRecord then
              ImportBuffer.StoreBuffer(TempImportBuffer);
            TempImportBuffer.DeleteRecord;
            // TempImportBuffer.SetNewRecord;
            ImportedRecords += 1;
            if TryUpdateDialog(2, ImportedRecords) then;
          end;

          Clear(SkipRecord);

          i += 1;
        until i = RecordList.Count;
    end;

    local procedure GetSplitRegEx() SplitRegEx: Text
    var
        Line: Record "Import Line";
    begin
        Clear(SplitRegEx);

        case Header.Type of
          Header.Type::FixText:
            begin
              Line.SetRange(Code, Header.Code);
              if Line.FindSet then
                repeat

                until Line.Next = 0;
            end;
          Header.Type::VarText:
            SplitRegEx := Header."Field Separator";
        end;

        exit(SplitRegEx);
    end;

    local procedure ProceedBuffer()
    var
        RecordIdx: Record "Integer";
        ImportSetupLine: Record "Import Line";
        RecordNo: array [2] of Integer;
        DestRecRef: RecordRef;
        DestFieldRef: FieldRef;
        InsertedRecords: Integer;
    begin
        if GuiAllowed then
          InfoDlg.Open('Verarbeite Datensätze ...\'+
                       '#1###### von #2######');

        ImportBuffer.Reset;
        ImportBuffer.SetRange(Code, Header.Code);
        if ImportBuffer.FindFirst then
          RecordNo[1] := ImportBuffer."Record No.";
        if ImportBuffer.FindLast then
          RecordNo[2] := ImportBuffer."Record No.";

        RecordIdx.SetRange(Number, RecordNo[1], RecordNo[2]);
        if GuiAllowed then
          if TryUpdateDialog(2, RecordIdx.Count) then;
        if RecordIdx.FindSet then repeat
          ImportBuffer.SetRange("Record No.", RecordIdx.Number);
          if ImportBuffer.FindSet then begin
            if not PreviewMode then begin
              DestRecRef.Open(Header."Table No.");
              DestRecRef.Init;
              repeat
                ImportSetupLine.Get(Header.Code, ImportBuffer."Source Line No.");
                if ImportSetupLine."Destination Field No." <> 0 then begin
                  DestFieldRef := DestRecRef.Field(ImportSetupLine."Destination Field No.");

                  if ImportSetupLine."Source Type" = ImportSetupLine."source type"::AutoIncrement then
                    AutoIncrementField(DestRecRef, DestFieldRef)
                  else
                    ApplyFieldValue(DestFieldRef, ImportBuffer, ImportSetupLine);
                end;
              until ImportBuffer.Next = 0;
              case Header.OnExistingRecord of
                Header.Onexistingrecord::"Break":
                  begin
                    DestRecRef.Insert;
                    InsertedRecords += 1;
                  end;
                Header.Onexistingrecord::Update:
                  if not DestRecRef.Insert then
                    if DestRecRef.Modify then
                      InsertedRecords += 1;
                Header.Onexistingrecord::Skip:
                  if DestRecRef.Insert then
                    InsertedRecords += 1;
              end;
              DestRecRef.Close;

              if GuiAllowed then
                if TryUpdateDialog(1, InsertedRecords) then;
            end;
          end;
        until RecordIdx.Next = 0;

        if GuiAllowed then
          if TryCloseDialog then;
    end;


    procedure ProceedBufferToRec(var DestRecRef: RecordRef)
    var
        RecordIdx: Record "Integer";
        ImportSetupLine: Record "Import Line";
        RecordNo: array [2] of Integer;
        DestFieldRef: FieldRef;
    begin
        if ImportBuffer.FindFirst then
          RecordNo[1] := ImportBuffer."Record No.";
        if ImportBuffer.FindLast then
          RecordNo[2] := ImportBuffer."Record No.";

        Header.Get(ImportBuffer.Code);

        RecordIdx.SetRange(Number, RecordNo[1], RecordNo[2]);
        if RecordIdx.FindSet then repeat
          ImportBuffer.SetRange("Record No.", RecordIdx.Number);
          if ImportBuffer.FindSet then begin
            DestRecRef.Init;
            repeat
              ImportSetupLine.Get(Header.Code, ImportBuffer."Source Line No.");
              if ImportSetupLine."Destination Field No." <> 0 then begin
                DestFieldRef := DestRecRef.Field(ImportSetupLine."Destination Field No.");
                if ImportSetupLine."Source Type" = ImportSetupLine."source type"::AutoIncrement then
                  AutoIncrementField(DestRecRef, DestFieldRef)
                else
                  ApplyFieldValue(DestFieldRef, ImportBuffer, ImportSetupLine);
              end;
            until ImportBuffer.Next = 0;
            DestRecRef.Insert;
            DestRecRef.Close;
          end;
        until RecordIdx.Next = 0;
    end;

    local procedure ApplyFieldValue(var DestFieldRef: FieldRef;Buffer: Record "Import Buffer";SetupLine: Record "Import Line")
    var
        ValueText: Text;
        ValueInt: BigInteger;
        ValueDec: Decimal;
        ValueDate: Date;
        ValueTime: Time;
        ValueDateTime: DateTime;
        ValueBool: Boolean;
    begin
        case Format(DestFieldRef.Type) of
          'Code', 'Text':
            if Buffer.Value <> '' then
              if SetupLine."Source Field Format String" <> '' then
                ValueText := StrSubstNo(SetupLine."Source Field Format String", Buffer.Value)
              else
                ValueText := Buffer.Value;
          'Integer', 'BigInteger': Evaluate(ValueInt, Buffer.Value);
          'Decimal': Evaluate(ValueDec, Buffer.Value);
          'Boolean': Evaluate(ValueBool, Buffer.Value);
          'Date': ValueDate := ParseDate(Buffer.Value, SetupLine."Source Field Format String");
          'Time': Evaluate(ValueTime, Buffer.Value);
          'Datetime': Evaluate(ValueDateTime, Buffer.Value);
          'Option':
            case true of
              StrPos(DestFieldRef.OptionCaption, Buffer.Value) > 0:
                begin
                  ValueText := CopyStr(DestFieldRef.OptionCaption, 1, StrPos(DestFieldRef.OptionCaption, Buffer.Value));
                  ValueInt := StrLen(ValueText) - StrLen(DelChr(ValueText, '=', ','));
                end;
              StrPos(DestFieldRef.OptionString, Buffer.Value) > 0:
                begin
                  ValueText := CopyStr(DestFieldRef.OptionString, 1, StrPos(DestFieldRef.OptionCaption, Buffer.Value));
                  ValueInt := StrLen(ValueText) - StrLen(DelChr(ValueText, '=', ','));
                end;
            end;
          else
            Error('Unhandled Datatype: %1', DestFieldRef.Type);
        end;

        case Format(DestFieldRef.Type) of
          'Code', 'Text': DestFieldRef.Value(ValueText);
          'Integer', 'BigInteger': DestFieldRef.Value(ValueInt);
          'Decimal': DestFieldRef.Value(ValueDec);
          'Boolean': DestFieldRef.Value(ValueBool);
          'Date': DestFieldRef.Value(ValueDate);
          'Time': DestFieldRef.Value(ValueTime);
          'Datetime': DestFieldRef.Value(ValueDateTime);
          'Option': DestFieldRef.Value(ValueInt);
        end;

        if SetupLine."Validate Field" then
          DestFieldRef.Validate;
    end;

    local procedure AutoIncrementField(var DestRecRef: RecordRef;var DestFieldRef: FieldRef)
    var
        ExistingRecRef: RecordRef;
        ExistingFieldRef: FieldRef;
        ExistingKeyRef: KeyRef;
        PRIMARYKEY_NOT_FOUND: label 'Primärschlüssel der Tabelle %1 konnte nicht ermittelt werden.';
        DestFieldRef2: FieldRef;
        DestKeyRef: KeyRef;
        KeyFields: Text;
        KeyFieldName: Text;
        i: Integer;
        newValue: Integer;
    begin
        DestKeyRef := DestRecRef.KeyIndex(1);

        ExistingRecRef.Open(DestRecRef.Number);
        ExistingKeyRef := ExistingRecRef.KeyIndex(1);

        for i := 1 to ExistingKeyRef.FieldCount do begin
          ExistingFieldRef := ExistingKeyRef.FieldIndex(i);
          DestFieldRef2 := DestKeyRef.FieldIndex(i);
          if DestFieldRef.Number <> DestFieldRef2.Number then
            ExistingFieldRef.SetRange(DestFieldRef2.Value);
        end;

        if ExistingRecRef.FindLast then begin
          ExistingFieldRef := ExistingRecRef.Field(DestFieldRef.Number);
          Evaluate(newValue, Format(ExistingFieldRef.Value));
          DestFieldRef.Value(newValue+1);
        end;
    end;

    [TryFunction]
    local procedure ReadFile(Filename: Text;var ImportedText: Text)
    var
        ImportFile: File;
        ReadBuffer: Text[1000];
        StreamReader: dotnet StreamReader;
        Encoding: dotnet Encoding;
    begin
        case Header.Encoding of
          Header.Encoding::MSDos:   StreamReader := StreamReader.StreamReader(Filename, Encoding.GetEncoding(850), true);
          Header.Encoding::UTF16:   StreamReader := StreamReader.StreamReader(Filename, Encoding.Unicode, true);
          Header.Encoding::UTF8:    StreamReader := StreamReader.StreamReader(Filename, Encoding.UTF8, true);
          Header.Encoding::Windows: StreamReader := StreamReader.StreamReader(Filename, Encoding.GetEncoding(1252), true);
        end;

        ImportedText := StreamReader.ReadToEnd();
        StreamReader.Dispose();
        Clear(StreamReader);
    end;

    local procedure GetSeparator(ImportedText: Text) Separator: Text
    var
        CHAR10: Char;
        CHAR13: Char;
    begin
        if Header."Record Separator" = '' then begin
          Separator[1] := 13;
          Separator[2] := 10;
        end else
          Separator := Header."Record Separator";
    end;

    local procedure Chr(CharAsInt: Integer): Char
    begin
        exit(CharAsInt);
    end;

    local procedure GetRecordsRegEx(TextToSplit: Text;RecordList: dotnet List_Of_T)
    var
        Regex: dotnet Regex;
        ArrayOfRecords: dotnet Array;
        i: Integer;
        SplitRegEx: Text;
    begin
        SplitRegEx := Header."Record Separator";
        if SplitRegEx = '' then
          SplitRegEx := '\n\r|\r\n|\n|\r';

        ArrayOfRecords := Regex.Split(TextToSplit, SplitRegEx);
        if ArrayOfRecords.Length < 2 then
          Log.LogError(Log.Class::File, StrSubstNo(RECORD_SEPARATOR_NOT_FOUND, SplitRegEx), true)
        else begin
          RecordList := RecordList.List();
          for i := 0 to ArrayOfRecords.Length - 1 do
            RecordList.Add(ArrayOfRecords.GetValue(i));

          Log.LogInfo(Log.Class::File, StrSubstNo('%1 Datensätze', ArrayOfRecords.Length));
        end;
    end;

    local procedure ProceedExport(): Text
    var
        SourceRecRef: RecordRef;
        ExportLine: Record "Export Line";
        ExportedText: Text;
        ExportedRecordText: Text;
        RecordExported: Boolean;
        RecordSeparator: Text;
        ServerFilename: Text;
        ClientFilename: Text;
        FileMgmt: Codeunit "File Management";
    begin
        SourceRecRef.Open(Header."Table No.");
        ApplyFilters(SourceRecRef);

        RecordSeparator := GetSeparator('');
        ExportLine.SetRange(Code, Header.Code);
        if SourceRecRef.FindSet then
          while true do begin
            Clear(ExportedRecordText);
            RecordExported := ExportRecord(SourceRecRef, ExportedRecordText);
            if RecordExported then
              ExportedText += ExportedRecordText;

            if SourceRecRef.Next = 0 then begin
              if PreviewMode then
                exit(ExportedText);

              ServerFilename := '';
              ClientFilename := GetFilenameToExport;
              if GuiAllowed then begin
                WriteFile(ExportedText, ServerFilename);
              end else
                WriteFile(ExportedText, ClientFilename);



              if ClientFilename = '' then begin
                case Header.Type of
                  Header.Type::FixText: ClientFilename := Header.Code + '.txt';
                  Header.Type::VarText: ClientFilename := Header.Code + '.csv';
                  else
                    ClientFilename := Header.Code + '.txt';
                end;
                Download(ServerFilename, '', '', '', ClientFilename);
              end else
                if GuiAllowed then
                  FileMgmt.DownloadToFile(ServerFilename, ClientFilename);

              exit;
            end;

            if RecordExported then
              ExportedText += RecordSeparator;
          end;
    end;

    local procedure ApplyFilters(var SourceRecRef: RecordRef)
    var
        ExportLine: Record "Export Line";
        FldRef: FieldRef;
    begin
        ExportLine.SetRange(Code, Header.Code);
        ExportLine.SetRange("Source Type", ExportLine."source type"::Field);
        ExportLine.SetFilter("Source Field Filter", '<>%1', '');
        if ExportLine.FindSet then
          repeat
            FldRef := SourceRecRef.Field(ExportLine."Source Field No.");
            FldRef.SetFilter(ExportLine."Source Field Filter");
          until ExportLine.Next = 0;
    end;

    local procedure ExportRecord(SourceRecRef: RecordRef;var ExportedText: Text): Boolean
    var
        ExportLine: Record "Export Line";
        ExportValue: Text;
        FldRef: FieldRef;
        FillCharacter: Text[1];
        FilterDataType: Text;
    begin
        ExportLine.SetRange(Code, Header.Code);
        if ExportLine.FindSet(false) then
          while true do begin
            case ExportLine."Source Type" of
              ExportLine."source type"::Field:
                begin
                  FldRef := SourceRecRef.Field(ExportLine."Source Field No.");
                  if ExportLine."Format Pattern" <> '' then
                    ExportValue := Format(FldRef.Value, 0, ExportLine."Format Pattern")
                  else
                    ExportValue := Format(FldRef.Value);
                end;
              ExportLine."source type"::FixText:
                ExportValue := ExportLine."Source Value";
              ExportLine."source type"::"Function":
                begin
                  ExportValue := CalcFunction(ExportLine."Source Value", SourceRecRef, FilterDataType);
                  if ExportLine."Source Field Filter" <> '' then
                    if not(ValueMatchesFilter(ExportValue, FilterDataType, ExportLine."Source Field Filter")) then
                      exit(false);
                end;
            end;

            if ExportLine.Length <> 0 then begin
              FillCharacter := ' ';
              if ExportLine."Fill Character" <> '' then
                FillCharacter := ExportLine."Fill Character";

              while StrLen(ExportValue) < ExportLine.Length do
                case ExportLine."Fill Before/After" of
                  ExportLine."fill before/after"::Before: ExportValue := FillCharacter + ExportValue;
                  ExportLine."fill before/after"::After:  ExportValue := ExportValue + FillCharacter;
                end;
            end;

            ExportValue := StrSubstNo('%1%2%3', ExportLine."Field Start Delimiter", ExportValue, ExportLine."Field End Delimiter");

            if not ExportLine."Do not export" then
              ExportedText += ExportValue;

            if ExportLine.Next = 0 then
              exit(true);

            ExportedText += Header."Field Separator";
          end;
    end;

    local procedure GetFilenameToExport() Filename: Text
    var
        DestFileNamePattern: Text;
    begin
        DestFileNamePattern := Header."Export File Name";
        while StrPos(DestFileNamePattern, '%') > 0 do begin
          Filename += CopyStr(DestFileNamePattern, 1, StrPos(DestFileNamePattern, '%') - 1);
          DestFileNamePattern := CopyStr(DestFileNamePattern, StrPos(DestFileNamePattern, '%'));
          case DestFileNamePattern[2] of
            'd':  Filename += Format(CurrentDatetime, 0, '<Day,2>');
            'M':  Filename += Format(CurrentDatetime, 0, '<Month,2>');
            'y':  Filename += Format(CurrentDatetime, 0, '<Year>');
            'Y':  Filename += Format(CurrentDatetime, 0, '<Year4>');
            'w':  Filename += Format(CurrentDatetime, 0, '<Week>');
            'W':  Filename += Format(CurrentDatetime, 0, '<Week,2>');
            'H':  Filename += Format(CurrentDatetime, 0, '<Hours24,2>');
            'h':  Filename += Format(CurrentDatetime, 0, '<Hours24>');
            'm':  Filename += Format(CurrentDatetime, 0, '<Minutes,2>');
            's':  Filename += Format(CurrentDatetime, 0, '<Seconds,2>');
            'U':  Filename += PathEncode(UserId);
            'C':  Filename += PathEncode(COMPANYNAME);
            'c':  Filename += PathEncode(Header.Code);
          end;
          DestFileNamePattern := CopyStr(DestFileNamePattern, StrPos(DestFileNamePattern, '%') + 2);
        end;
        Filename += DestFileNamePattern;
    end;

    local procedure WriteFile(TextToExport: Text;var Filename: Text)
    var
        FileMgmt: Codeunit "File Management";
        ExportFile: File;
        WriteIdx: BigInteger;
        WriteLength: BigInteger;
        WriteChar: Char;
        StreamWriter: dotnet StreamWriter;
        Encoding: dotnet Encoding;
    begin
        if Filename = '' then
          Filename := FileMgmt.ServerTempFileName('');

        case Header.Encoding of
          Header.Encoding::MSDos:    StreamWriter := StreamWriter.StreamWriter(Filename, false, Encoding.GetEncoding(850));
          Header.Encoding::UTF16:    StreamWriter := StreamWriter.StreamWriter(Filename, false, Encoding.Unicode);
          Header.Encoding::UTF8:     StreamWriter := StreamWriter.StreamWriter(Filename, false, Encoding.UTF8);
          Header.Encoding::Windows:  StreamWriter := StreamWriter.StreamWriter(Filename, false, Encoding.GetEncoding(1252));
        end;

        StreamWriter.Write(TextToExport);
        StreamWriter.Close();
    end;

    local procedure PathEncode(TextToEncode: Text) EncodedText: Text
    begin
        EncodedText := ConvertStr(TextToEncode, ':\%', '___');
    end;


    procedure GetAvailableFunctions() FunctionList: Text
    begin
        FunctionList := 'COMPANYNAME';
        FunctionList += ',TableRelation';
        FunctionList += ',USERID';
        FunctionList += ',WORKDATE';
    end;


    procedure GetFunctionArguments(FunctionName: Text) ArgumentList: Text
    begin
        case UpperCase(FunctionName) of
          'TABLERELATION': exit(';<Related Table No.>;<Related Field No.>[;Filter ::= {<Related Field No.> = { <ThisRecordFieldNo.> | CONST(<Value>) | FUNCTION(<FunctionString>) } } ...]');
          'WORKDATE': exit('[;FormatString]');
          else
            exit('keine zusätzlichen Argumente');
        end;
    end;

    local procedure CalcFunction(Arguments: Text;var SourceRecRef: RecordRef;var FilterDataType: Text) Value: Text
    var
        FunctionName: Text;
        RelatedRecRef: RecordRef;
        RelatedFieldRef: FieldRef;
        TableNo: Integer;
        FieldNo: Integer;
        ArgIdx: Integer;
        FilterString: Text;
        FilterRelatedFieldRef: FieldRef;
        FilterThisFieldRef: FieldRef;
    begin
        FunctionName := GetArgument(Arguments, 1, ';');

        case UpperCase(FunctionName) of
          'COMPANYNAME':
            begin
              Value := COMPANYNAME;
              FilterDataType := 'Text';
            end;
          'TABLERELATION':
            begin
              Evaluate(TableNo, GetArgument(Arguments, 2, ';'));
              RelatedRecRef.Open(TableNo);
              ArgIdx := 4;
              FilterString := GetArgument(Arguments, 4, ';');
              while FilterString <> '' do begin
                Evaluate(FieldNo, GetArgument(FilterString, 1, '='));
                RelatedFieldRef := RelatedRecRef.Field(FieldNo);
                FilterString := GetArgument(FilterString, 2, '=');
                case true of
                  StrPos(FilterString, 'CONST(') = 1:
                    begin
                      FilterString := CopyStr(FilterString, 7, StrLen(FilterString)-8);
                      RelatedFieldRef.SetFilter(FilterString);
                    end;
                  StrPos(FilterString, 'FUNCTION(') = 1:
                    begin
                      FilterString := CopyStr(FilterString, 10, StrLen(FilterString) - 11);
                      RelatedFieldRef.SetFilter(CalcFunction(FilterString, SourceRecRef, FilterDataType));
                    end;
                  else begin
                    Evaluate(FieldNo, FilterString);
                    FilterThisFieldRef := SourceRecRef.Field(FieldNo);
                    RelatedFieldRef.SetRange(FilterThisFieldRef.Value);
                  end;
                end;
                ArgIdx += 1;
                FilterString := GetArgument(Arguments, ArgIdx, ';');
              end;
              if RelatedRecRef.FindFirst then begin
                Evaluate(FieldNo, GetArgument(Arguments, 3, ';'));
                RelatedFieldRef := RelatedRecRef.Field(FieldNo);
                Value := Format(RelatedFieldRef.Value);
                FilterDataType := Format(RelatedFieldRef.Type);
              end;
              RelatedRecRef.Close;
            end;
          'USERID':
            begin
              Value := UserId;
              FilterDataType := 'Text';
            end;
          'WORKDATE':
            begin
              if GetArgument(Arguments, 2, ';') = '' then
                Value := Format(WorkDate)
              else
                Value := Format(WorkDate, 0, GetArgument(Arguments, 2, ';'));
              FilterDataType := 'Date';
            end;
        end;
    end;

    local procedure GetArgument(ArgumentList: Text;ArgumentIdx: Integer;ArgumentSeparator: Text) Argument: Text
    var
        i: Integer;
    begin
        for i := 1 to ArgumentIdx do begin
          if ArgumentList = '' then
            exit('');
          if StrPos(ArgumentList, ArgumentSeparator) > 0 then begin
            Argument := CopyStr(ArgumentList, 1, StrPos(ArgumentList, ArgumentSeparator) - 1);
            ArgumentList := CopyStr(ArgumentList, StrPos(ArgumentList, ArgumentSeparator) + 1);
          end else begin
            Argument := ArgumentList;
            ArgumentList := '';
          end;

          if i = ArgumentIdx then
            exit(Argument);
        end;
    end;

    local procedure ValueMatchesFilter(Value: Text;Datatype: Text;FilterString: Text): Boolean
    var
        FilterTest: Record "Import Buffer" temporary;
    begin
        FilterTest.Init;
        case Datatype of
          'Integer':    Evaluate(FilterTest."Filter Test Integer", Value);
          'BigInteger': Evaluate(FilterTest."Filter Test Integer", Value);
          'Code':       Evaluate(FilterTest."Filter Test Code", Value);
          'Text':       Evaluate(FilterTest."Filter Test Text", Value);
          'Decimal':    Evaluate(FilterTest."Filter Test Decimal", Value);
          'Date':       Evaluate(FilterTest."Filter Test Date", Value);
          'Time':       Evaluate(FilterTest."Filter Test Time", Value);
          'DateTime':   Evaluate(FilterTest."Filter Test DateTime", Value);
          else
            exit(ValueMatchesFilter(Value, 'Text', FilterString));
        end;
        FilterTest.Insert(false);
        FilterTest.Reset;
        case Datatype of
          'Integer':    FilterTest.SetFilter("Filter Test Integer", FilterString);
          'BigInteger': FilterTest.SetFilter("Filter Test Integer", FilterString);
          'Code':       FilterTest.SetFilter("Filter Test Code", FilterString);
          'Text':       FilterTest.SetFilter("Filter Test Text", FilterString);
          'Decimal':    FilterTest.SetFilter("Filter Test Decimal", FilterString);
          'Date':       FilterTest.SetFilter("Filter Test Date", FilterString);
          'Time':       FilterTest.SetFilter("Filter Test Time", FilterString);
          'DateTime':   FilterTest.SetFilter("Filter Test DateTime", FilterString);
        end;
        exit(FilterTest.FindFirst);
    end;

    local procedure ParseDate(DateAsString: Text;FormatString: Text) Result: Date
    var
        DotNetDate: dotnet DateTime;
        CultureInfo: dotnet CultureInfo;
        DateTimeStyles: dotnet DateTimeStyles;
    begin
        if FormatString = '' then
          Evaluate(Result, DateAsString)
        else
          Result := Dt2Date(DotNetDate.ParseExact(DateAsString, FormatString, CultureInfo.InvariantCulture, DateTimeStyles.None));
    end;

    [TryFunction]
    local procedure MoveFile(Filename: Text;DestFolderName: Text)
    var
        SourceFilename: Text;
        SourceFolderName: Text;
        ClientFile: dotnet File;
    begin
        SourceFilename := Filename;
        while StrPos(SourceFilename, '\') > 0 do
          SourceFilename := CopyStr(SourceFilename, StrPos(SourceFilename, '\')+1);
        SourceFolderName := CopyStr(Filename, 1, StrLen(Filename)-StrLen(SourceFilename)-1);

        if DestFolderName = '' then
          exit;

        if DestFolderName[StrLen(DestFolderName)] <> '\' then
          DestFolderName += '\';

        ClientFile.Move(Filename, StrSubstNo('%1%2', DestFolderName, SourceFilename));
    end;

    [TryFunction]
    local procedure TryCloseDialog()
    begin
        InfoDlg.Close;
    end;

    [TryFunction]
    local procedure TryUpdateDialog(ControlId: Integer;Value: Variant)
    begin
        InfoDlg.Update(ControlId, Value);
    end;
}

