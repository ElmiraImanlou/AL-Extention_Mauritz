Report 50009 ExportBuchungen
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            RequestFilterFields = "Posting Date","Document Type";
            column(ReportForNavId_50000; 50000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Amount = LastVATAmount then
                  CurrReport.Skip;

                Clear(LineContent);
                if Amount > 0 then
                  LineContent := '+'
                else
                  LineContent := '-';

                LineContent += FillLeft('', 10, '0');
                LineContent += 'a';

                if "Document Type" = "document type"::"Credit Memo" then
                  LineContent += '1'
                else
                  LineContent += '0';
                LineContent += Steuerschluessel("G/L Entry");
                LineContent += FillLeft("Bal. Account No.", 9, '0');
                LineContent += 'b';

                LineContent += FillRight(CopyStr("Document No.", 1, 12), 12, ' ');
                LineContent += 'c';

                LineContent += FillLeft('', 12, ' ');
                LineContent += 'd';

                LineContent += Format("Document Date", 0, '<Day,2><Month,2>');
                LineContent += 'e';

                LineContent += FillLeft("G/L Account No.", 9, '0');
                LineContent += 'f';

                LineContent += FillRight(CopyStr("G/L Entry"."Global Dimension 1 Code", 1, 8), 8, ' ');
                LineContent += 'g';

                LineContent += FillLeft('', 8, ' ');
                LineContent += 'h';

                // Skonto
                LineContent += '000000';
                LineContent += Char('1E');

                LineContent += FillRight(Description, 30, ' ');
                LineContent += Char('1C');
                LineContent += Char('BA');

                LineContent += FillLeft('', 2, ' ');
                LineContent += FillLeft('', 13, ' ');
                LineContent += Char('1C');

                LineContent += 'j';

                LineContent += FillLeft(Format(VATPostingSetup."VAT %" * 100, 0, '<Integer>'), 4, '0');
                if Amount > 0 then
                  LineContent += '+'
                else
                  LineContent += '-';
                LineContent += FillLeft(Format((Amount + "VAT Amount") * 100, 0, '<Integer>'), 10, '0');
                // Skonto
                LineContent += '000000';

                LineContent += '2';
                LineContent += Char('20');
                LineContent += FillLeft('', 20, ' ');
                LineContent += FillLeft('', 20, ' ');
                LineContent += '0000000000';
                LineContent += 'y';
                LineContent += Char('20');
                LineContent += Char('D') + Char('A');

                FileContent += LineContent;

                LastVATAmount := "VAT Amount";
            end;

            trigger OnPostDataItem()
            var
                FileManagement: Codeunit "File Management";
                Filepath: Text;
                ClientFileName: Text;
            begin
                FileContent += Char('1A');

                Filepath := FileManagement.ServerTempFileName('txt');
                WriteToFile(Filepath, FileContent);
                ClientFileName := StrSubstNo('Buchungen (%1).txt', GetFilter("Posting Date"));
                Download(Filepath, '', '', '', ClientFileName);
            end;

            trigger OnPreDataItem()
            begin
                FileContent := 'Agenda FIBU32 BUCHUNGEN NEU';
                FileContent += ' ';
                FileContent += '5';
                FileContent += FillLeft('', 60, ' ');
                FileContent += 'ANFANG';
                FileContent += FillLeft('', 160, ' ');
                FileContent += Char('D')+ Char('A');

                SetRange("Gen. Posting Type", "gen. posting type"::Purchase, "gen. posting type"::Sale);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        FileContent: Text;
        LineContent: Text;
        LastVATAmount: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";

    [TryFunction]
    local procedure WriteToFile(Filepath: Text;Content: Text)
    var
        FileStream: dotnet FileStream;
        FileMode: dotnet FileMode;
        FileAccess: dotnet FileAccess;
        StreamWriter: dotnet StreamWriter;
        Encoding: dotnet Encoding;
    begin
        FileStream := FileStream.FileStream(Filepath, FileMode.CreateNew, FileAccess.ReadWrite);
        StreamWriter := StreamWriter.StreamWriter(FileStream, Encoding.Ascii);

        StreamWriter.Write(Content);
        StreamWriter.Close;
        FileStream.Close;

        Clear(StreamWriter);
        Clear(FileStream);
    end;

    local procedure Steuerschluessel(Rec: Record "G/L Entry"): Text
    begin
        Clear(VATPostingSetup);
        if not VATPostingSetup.Get(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") then
          exit('0');

        if Rec."Gen. Posting Type" = Rec."gen. posting type"::Sale then begin
          if VATPostingSetup."VAT %" = 0 then
            exit('1');
          if VATPostingSetup."VAT %" = 7 then
            exit('2');
          if VATPostingSetup."VAT %" = 19 then
            exit('3');
        end;

        if Rec."Gen. Posting Type" = Rec."gen. posting type"::Purchase then begin
          if VATPostingSetup."VAT %" = 7 then
            exit('8');
          if VATPostingSetup."VAT %" = 19 then
            exit('9');
        end;

        exit('0')
    end;

    local procedure Char(HexCode: Code[2]) Char: Text[1]
    var
        HexChars: Text;
    begin
        case StrLen(HexCode) of
          0: Char[1] := 0;
          1: Char[1] := StrPos('0123456789ABCDEF', HexCode) - 1;
          2: Char[1] := (StrPos('0123456789ABCDEF', Format(HexCode[1])) - 1) * 16 + StrPos('0123456789ABCDEF', Format(HexCode[2])) - 1;
        end;
    end;

    local procedure FillLeft(Input: Text;Length: Integer;FillChar: Text) Output: Text
    begin
        Output := CopyStr(Input, 1, Length);

        if FillChar = '' then
          exit;

        while StrLen(Output) < Length do
          Output := StrSubstNo('%1%2', FillChar, Output);
    end;

    local procedure FillRight(Input: Text;Length: Integer;FillChar: Text) Output: Text
    begin
        Output := CopyStr(Input, 1, Length);

        if FillChar = '' then
          exit;

        while StrLen(Output) < Length do
          Output := StrSubstNo('%1%2', Output, FillChar);
    end;
}

