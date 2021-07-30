Codeunit 50008 "ECKERT-DATEV"
{
    TableNo = "Import Buffer";

    trigger OnRun()
    var
        CountColumns: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
        DimCode: Code[20];
        LastRecordNo: Integer;
    begin
        if not FindFirst then
          exit;

        SetRange("Record No.", "Record No.");
        CountColumns := Count;

        if GenJnlLine.FindLast then;
        NextLineNo := GenJnlLine."Line No." + 10000;

        Reset;
        FindSet(false);
        repeat
          GenJnlLine.Init;
          GenJnlLine."Journal Template Name" := DelChr(GetValueByID(10), '<>', '"');
          GenJnlLine."Journal Batch Name" := DelChr(GetValueByID(11), '<>', '"');
        //  EVALUATE(GenJnlLine.Amount, GetValueByID(1));
          GenJnlLine."Line No." := NextLineNo;
          GenJnlLine."Document No." := DelChr(GetValueByID(13), '<>', '"');
          GenJnlLine."External Document No." := DelChr(GetValueByID(14), '<>', '"');
          GenJnlLine."Account No." := DelChr(GetValueByID(3), '<>', '"');
          GenJnlLine."Bal. Account No." := DelChr(GetValueByID(4), '<>', '"');
          Evaluate(GenJnlLine."Posting Date", StrSubstNo('%1%2', DelChr(GetValueByID(5), '<>', '"'), DelChr(GetValueByID(6), '<>', '"')));
          GenJnlLine.Validate("Posting Date");
          GenJnlLine.Description := CopyStr(DelChr(GetValueByID(7), '<>', '"'), 1, MaxStrLen(GenJnlLine.Description));
          Evaluate(DimCode, DelChr(GetValueByID(8), '<>', '"'));
          if DimCode <> '' then
            GenJnlLine.ValidateShortcutDimCode(1, DimCode);
          GenJnlLine."Shortcut Dimension 1 Code" := DimCode;
          Evaluate(DimCode, DelChr(GetValueByID(9), '<>', '"'));
          if DimCode <> '' then
            GenJnlLine.ValidateShortcutDimCode(2, DimCode);

          case DelChr(GetValueByID(2), '<>', '"') of
            'S':
              begin
                Evaluate(GenJnlLine."Debit Amount", DelChr(GetValueByID(1), '<>', '"'));
                GenJnlLine.Validate("Debit Amount");
              end;
            'H':
              begin
                Evaluate(GenJnlLine."Credit Amount", DelChr(GetValueByID(1), '<>', '"'));
                GenJnlLine.Validate("Credit Amount");
              end;
          end;

          if LastRecordNo <> "Record No." then begin
            if GenJnlLine.Insert then
              NextLineNo += 10000;
            Clear(GenJnlLine);
            LastRecordNo := "Record No.";
          end;

        until Next(CountColumns) = 0;
    end;
}

