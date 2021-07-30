Table 80003 "Import Buffer"
{

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;"Record No.";Integer)
        {
        }
        field(3;"Value No.";Integer)
        {
        }
        field(4;"Source Line No.";Integer)
        {
        }
        field(5;Value;Text[250])
        {
        }
        field(6;"Value (BLOB)";Blob)
        {
        }
        field(10;"Filter Test Code";Code[250])
        {
        }
        field(11;"Filter Test Text";Text[250])
        {
        }
        field(12;"Filter Test Integer";BigInteger)
        {
        }
        field(13;"Filter Test Decimal";Decimal)
        {
        }
        field(14;"Filter Test Date";Date)
        {
        }
        field(15;"Filter Test Time";Time)
        {
        }
        field(16;"Filter Test DateTime";DateTime)
        {
        }
    }

    keys
    {
        key(Key1;"Code","Record No.","Value No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure InitBuffer(newCode: Code[20])
    begin
        Reset;
        DeleteAll;
        Code := newCode;
    end;


    procedure SetNewRecord()
    begin
        "Record No." += 1;
        Clear("Value No.");
    end;


    procedure StoreValue(SourceLine: Record "Import Line";newValue: Text)
    var
        PrevLine: Record "Import Line";
        OutStr: OutStream;
        Regex: dotnet Regex;
        ArgArray: dotnet Array;
        PadStringBefore: Text;
        PadStringAfter: Text;
        Pattern: Text;
        PatternLength: Integer;
        oldValue: Text;
    begin
        "Source Line No." := SourceLine."Line No.";

        PrevLine.SetRange(Code, Code);
        PrevLine.SetRange("Line No.", 0, SourceLine."Line No."-1);
        PrevLine.SetRange("Source Type", SourceLine."source type"::Field);
        PrevLine.SetRange("Destination Field No.", SourceLine."Destination Field No.");
        if (SourceLine."Source Type" = SourceLine."source type"::Field) and
           (SourceLine."Destination Field No." <> 0) and
           PrevLine.FindFirst
        then begin
          SetRange(Code, SourceLine.Code);
          SetRange("Source Line No.", PrevLine."Line No.");
          if FindLast then;
        end else begin
          "Value No." += 1;
          Clear(Value);
          Clear("Value (BLOB)");
          Insert;
        end;

        if SourceLine."Source Field Start Delimiter" <> '' then
          newValue := DelChr(newValue, '<', SourceLine."Source Field Start Delimiter");
        if SourceLine."Source Field End Delimiter" <> '' then
          newValue := DelChr(newValue, '>', SourceLine."Source Field End Delimiter");

        if SourceLine."Remove Chars Before" <> '' then
          newValue := DelChr(newValue, '<', SourceLine."Remove Chars Before");
        if SourceLine."Remove Chars After" <> '' then
          newValue := DelChr(newValue, '>', SourceLine."Remove Chars After");

        if (SourceLine."Regex Pattern" <> '') then
          newValue := Regex.Replace(newValue, SourceLine."Regex Pattern", SourceLine."Regex Replacement");

        if SourceLine."Destination Formatting" <> '' then begin
          ArgArray := Regex.Split(SourceLine."Destination Formatting", ';');
          if ArgArray.Length > 1 then
            PadStringBefore := ArgArray.GetValue(0);
          if ArgArray.Length > 2 then
            PadStringAfter := ArgArray.GetValue(ArgArray.Length-1);

          Pattern := SourceLine."Destination Formatting";
          if PadStringBefore <> '' then
            Pattern := CopyStr(Pattern, StrLen(PadStringBefore)+2);
          if PadStringAfter <> '' then
            Pattern := CopyStr(Pattern, 1, StrLen(Pattern)-StrLen(PadStringAfter)-1);
          if (StrPos(PadStringBefore, '#') > 0) and (StrPos(Pattern, '#') = 0) and (PadStringAfter = '') then begin
            PadStringAfter := Pattern;
            Pattern := PadStringBefore;
            Clear(PadStringBefore);
          end;

          oldValue := newValue;
          Clear(newValue);

          PatternLength := StrLen(Pattern) - StrLen(DelChr(Pattern, '=', '#'));
          if PadStringBefore <> '' then
            while StrLen(oldValue) < PatternLength do
              oldValue := StrSubstNo('%1%2', PadStringBefore, oldValue);
          if PadStringAfter <> '' then
            while StrLen(oldValue) < PatternLength do
              oldValue := StrSubstNo('%1%2', oldValue, PadStringAfter);

          if Pattern <> '' then repeat
            if Pattern[1] in ['#', oldValue[1]] then begin
              newValue := StrSubstNo('%1%2', newValue, oldValue[1]);
              oldValue := CopyStr(oldValue, 2);
              Pattern := CopyStr(Pattern, 2);
            end else begin
              newValue := StrSubstNo('%1%2', newValue, Pattern[1]);
              Pattern := CopyStr(Pattern, 2);
            end;
          until (Pattern = '') or (oldValue = '');
        end;

        if StrLen(newValue) > MaxStrLen(Value) then begin
          "Value (BLOB)".CreateOutstream(OutStr);
          OutStr.Write(newValue);
        end else
          Value += newValue;

        Modify;
        Commit;

        Reset;
        FindLast;
    end;


    procedure StoreBuffer(var Buffer: Record "Import Buffer" temporary)
    var
        LastExistingRecordNo: Integer;
        CurrRecordCount: Integer;
        RecordIdx: array [2] of Integer;
        i: Integer;
    begin
        if FindLast then
          LastExistingRecordNo := "Record No." + 1
        else
          LastExistingRecordNo := 1;

        Buffer.Reset;
        if Buffer.FindFirst then
          RecordIdx[1] := Buffer."Record No.";
        if Buffer.FindLast then
          RecordIdx[2] := Buffer."Record No.";

        for i := RecordIdx[1] to RecordIdx[2] do begin
          Buffer.SetRange("Record No.", i);
          if Buffer.FindSet then
            repeat
              TransferFields(Buffer);
              "Record No." := LastExistingRecordNo + CurrRecordCount;
              Insert;
            until Buffer.Next = 0;
          CurrRecordCount += 1;
        end;
    end;


    procedure DeleteRecord()
    begin
        SetRange("Record No.", "Record No.");
        DeleteAll;
        SetRange("Record No.");
        Clear("Value No.");
    end;


    procedure GetValueByID(ValueNo: Integer) Value: Text
    var
        SelectBuffer: Record "Import Buffer";
        ImportSetupLine: Record "Import Line";
    begin
        SelectBuffer.CopyFilters(Rec);
        if SelectBuffer.GetFilter(Code) = '' then
          SelectBuffer.SetRange(Code, Code);
        if SelectBuffer.GetFilter("Record No.") = '' then
          SelectBuffer.SetRange("Record No.", "Record No.");

        SelectBuffer.SetRange("Value No.", ValueNo);
        if SelectBuffer.FindFirst then
          exit(SelectBuffer.Value);
    end;
}

