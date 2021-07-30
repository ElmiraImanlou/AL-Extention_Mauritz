Page 50020 "MailError Log"
{
    ApplicationArea = Basic;
    Caption = 'E-Mailrückläufer';
    PageType = List;
    SourceTable = "MailError Log";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Kontakte';
                field(listContactNo;"Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(listEMail;"EMail Address")
                {
                    ApplicationArea = Basic;
                }
                field(listContactName;"Contact Name")
                {
                    ApplicationArea = Basic;
                }
                field(listContactprivacyBlocked;"Contact Privacy Blocked")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                Editable = false;
                Enabled = false;
                grid(Control50010)
                {
                    GridLayout = Rows;
                    group("Empfänger")
                    {
                        Caption = 'Empfänger';
                        field("Contact No.";"Contact No.")
                        {
                            ApplicationArea = Basic;
                        }
                        field("EMail Address";"EMail Address")
                        {
                            ApplicationArea = Basic;
                        }
                        field("Contact Name";"Contact Name")
                        {
                            ApplicationArea = Basic;
                        }
                        field("Contact Privacy Blocked";"Contact Privacy Blocked")
                        {
                            ApplicationArea = Basic;
                        }
                    }
                    group(Meldung)
                    {
                        Caption = 'Meldung';
                        field(ErrorMessage;ErrorMessage)
                        {
                            ApplicationArea = Basic;
                            ColumnSpan = 4;
                            MultiLine = true;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportMailErrorFile)
            {
                ApplicationArea = Basic;
                Caption = 'E-Mail-Fehlerdatei importieren';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SetRange("File Import DateTime", ImportMailErrorFile);
                    CurrPage.Update(false);
                end;
            }
            action(ImportPostErrorFile)
            {
                ApplicationArea = Basic;
                Caption = 'Post-Fehlerdatei importieren';

                trigger OnAction()
                begin
                    SetRange("File Import DateTime", ImportPostErrorFile);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        InStr: InStream;
    begin
        Clear(ErrorMessage);
        CalcFields("Error Message");
        "Error Message".CreateInstream(InStr);
        InStr.Read(ErrorMessage);
    end;

    var
        ErrorMessage: Text;

    local procedure ImportMailErrorFile() ImportDatetime: DateTime
    var
        FileManagement: Codeunit "File Management";
        ServerFilename: Text;
        ClientFilename: Text;
        FileContent: Text;
        Regex: dotnet Regex;
        MatchCollection: dotnet MatchCollection;
        Match: dotnet Match;
        MailErrorMessage: Text;
        MailErrorMessageList: dotnet List_Of_T;
        FileStream: dotnet FileStream;
        FileMode: dotnet FileMode;
        FileAccess: dotnet FileAccess;
        StreamReader: dotnet StreamReader;
        REGEX_PATTERN: label '(?<email>[A-z0-9\.!#$%&''*+-/=?^_`{|}~]+@(?!pokalversand\.com)(?!kundenserver\.de)(?:[^<>: ,@"'']+))|(?:[Rr]eason:(?<reason>[^\r\n]+)|[Ee]xplanation:(?<explanation>[^\r\n]+))';
        EmailAddress: Text;
        Reason: Text;
        Explanation: Text;
        Contact: Record Contact;
        LogEntry: Record "MailError Log";
        OutStr: OutStream;
    begin
        ServerFilename := FileManagement.UploadFile('E-Mail-Fehlerdatei auswählen', ClientFilename);
        if ServerFilename = '' then
          exit;

        FileStream := FileStream.FileStream(ServerFilename, FileMode.Open, FileAccess.Read);
        StreamReader := StreamReader.StreamReader(FileStream);
        FileContent := StreamReader.ReadToEnd();
        Clear(StreamReader);
        Clear(FileStream);

        Evaluate(ImportDatetime, Format(CurrentDatetime, 0, '<Day,2>.<Month,2>.<Year4> <Hours24,2>:<Minutes,2>:<Seconds,2>'));

        MailErrorMessageList := MailErrorMessageList.List();
        MatchCollection := Regex.Matches(FileContent, '(?<=\r\n"(?:[^"]|"")*",")(?:[^"]|"")*(?=")');
        foreach Match in MatchCollection do begin
          MailErrorMessage := Match.Value;
          MailErrorMessageList.Add(MailErrorMessage);
        end;

        foreach MailErrorMessage in MailErrorMessageList do begin
          MatchCollection := Regex.Matches(MailErrorMessage, REGEX_PATTERN);
          Clear(EmailAddress);
          Clear(Reason);
          Clear(Explanation);
          foreach Match in MatchCollection do begin
            case true of
              Match.Groups.Item('email').Value <> '':
                if EmailAddress = '' then
                  EmailAddress := Match.Value;
              Match.Groups.Item('reason').Value <> '':
                Reason := Match.Value;
              Match.Groups.Item('explanation').Value <> '':
                Explanation := Match.Value;
            end;
          end;

          if EmailAddress <> '' then begin
            Clear(Contact);
            Contact.SetRange("E-Mail", EmailAddress);
            if Contact.FindFirst then begin
              if not (Contact."Territory Code" in ['I', 'K']) then
                Contact."Privacy Blocked" := true
              else
                Contact."E-Mail" := '';
              Contact.Modify(true);
            end;
            LogEntry.Init;
            LogEntry."Contact No." := Contact."No.";
            LogEntry."EMail Address" := EmailAddress;
            LogEntry."File Import DateTime" := ImportDatetime;
            LogEntry.Insert(true);
            LogEntry.CalcFields("Error Message");
            LogEntry."Error Message".CreateOutstream(OutStr);
            if Explanation <> '' then begin
              Reason[StrLen(Reason)] := 10;
              Reason += Explanation;
            end;
            OutStr.Write(Reason);
            LogEntry.Modify(true);
          end;
        end;
    end;

    local procedure ImportPostErrorFile() ImportDatetime: DateTime
    var
        ColumnNumbers: dotnet Dictionary_Of_T_U;
        FileManagement: Codeunit "File Management";
        ServerFilename: Text;
        ClientFilename: Text;
        ExcelBuffer: Record "Excel Buffer";
        rowCount: Integer;
        colCount: Integer;
        i: Integer;
        Contact: Record Contact;
        LogEntry: Record "MailError Log";
        Name1: Text;
        Name2: Text;
        Name3: Text;
        Address: Text;
        AddressNo: Text;
        PostCode: Text;
        City: Text;
    begin
        ServerFilename := FileManagement.UploadFile('Post-Fehlerdatei auswählen', ClientFilename);
        if ServerFilename = '' then
          exit;

        ExcelBuffer.LockTable;
        ExcelBuffer.DeleteAll;
        ExcelBuffer.OpenBook(ServerFilename, 'Premiumadress');
        ExcelBuffer.ReadSheet();

        Evaluate(ImportDatetime, Format(CurrentDatetime, 0, '<Day,2>.<Month,2>.<Year4> <Hours24,2>:<Minutes,2>:<Seconds,2>'));

        ColumnNumbers := ColumnNumbers.Dictionary();
        ExcelBuffer.SetRange("Row No.", 1);
        if ExcelBuffer.FindSet then repeat
          if ExcelBuffer."Cell Value as Text" <> '' then
            ColumnNumbers.Add(ExcelBuffer."Cell Value as Text", ExcelBuffer."Column No.");
        until ExcelBuffer.Next = 0;

        ExcelBuffer.Reset;
        ExcelBuffer.FindLast;
        rowCount := ExcelBuffer."Row No.";

        for i:=2 to rowCount do begin
          Contact.Reset;

          if ColumnNumbers.ContainsKey('Kd_Na1') then Name1 := GetCellValueAsFilter(ExcelBuffer, i, ColumnNumbers.Item('Kd_Na1'));
          if ColumnNumbers.ContainsKey('Kd_Na2') then Name2 := GetCellValueAsFilter(ExcelBuffer, i, ColumnNumbers.Item('Kd_Na2'));
          if ColumnNumbers.ContainsKey('Kd_Na3') then Name3 := GetCellValueAsFilter(ExcelBuffer, i, ColumnNumbers.Item('Kd_Na3'));
          if ColumnNumbers.ContainsKey('Kd_Str') then Address := GetCellValueAsFilter(ExcelBuffer, i, ColumnNumbers.Item('Kd_Str'));
          if ColumnNumbers.ContainsKey('Kd_HNr') then AddressNo := GetCellValueAsFilter(ExcelBuffer, i, ColumnNumbers.Item('Kd_HNr'));
          if ColumnNumbers.ContainsKey('Kd_PLZ') then PostCode := GetCellValueAsFilter(ExcelBuffer, i, ColumnNumbers.Item('Kd_PLZ'));
          if ColumnNumbers.ContainsKey('Kd_Ort') then City := GetCellValueAsFilter(ExcelBuffer, i, ColumnNumbers.Item('Kd_Ort'));

          if Name1 <> '' then Contact.SetFilter(Name, StrSubstNo('@%1*', Name1));
          if Name2 <> '' then Contact.SetFilter("Name 2", StrSubstNo('@%1*', Name2));
          // IF Name3 <> '' THEN Contact.SETFILTER("Name 3", STRSUBSTNO('@%1', Name3));
          if Address <> '' then begin
            if AddressNo <> '' then
              Contact.SetFilter(Address, StrSubstNo('@%1*%2', Address, ConvertStr(AddressNo, ' ', '*')))
            else
              Contact.SetFilter(Address, StrSubstNo('@%1', Address));
          end;
          Contact.SetFilter("Post Code", PostCode);
          Contact.SetFilter(City, StrSubstNo('%1*', City));

          if Contact.Count = 1 then begin
            Contact.FindFirst;
            Contact."Privacy Blocked" := true;
            Contact.Modify(true);

            LogEntry.Init;
            LogEntry."Contact No." := Contact."No.";
            LogEntry."EMail Address" := Contact."E-Mail";
            LogEntry."File Import DateTime" := ImportDatetime;
            LogEntry.Insert(true);
          end;
        end;
    end;

    local procedure GetCellValueAsFilter(var ExcelBuffer: Record "Excel Buffer";rowNo: Integer;colNo: Integer) AsFilter: Text
    var
        Regex: dotnet Regex;
    begin
        if not ExcelBuffer.Get(rowNo, colNo) then
          exit('');

        AsFilter := ExcelBuffer."Cell Value as Text";
        if AsFilter = '' then
          exit;

        AsFilter := Regex.Replace(AsFilter, '[sS]tr\.', 'straße');
        AsFilter := Regex.Replace(AsFilter, '[<>()\.=\|]', '?');
        AsFilter := Regex.Replace(AsFilter, '(.*(?=straße))straße((?<=straße).*)', '$1str*$2');
        AsFilter := DelChr(AsFilter, '<>', ' ');
    end;
}

