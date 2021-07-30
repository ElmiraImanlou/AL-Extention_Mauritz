Codeunit 50005 "Import Name 3"
{

    trigger OnRun()
    var
        CSVFile: File;
        CSVText: Text;
        CustNo: Code[20];
        Name3: Text;
        StopIdx: Integer;
        Customer: Record Customer;
        Contact: Record Contact;
    begin
        CSVFile.TextMode(true);
        CSVFile.Open('C:\tmp\Kunden_Name 3.csv', Textencoding::Windows);
        while CSVFile.Read(CSVText) > 0 do begin
          StopIdx := StrPos(CSVText, ';');
          if StopIdx > 0 then begin
            CustNo := CopyStr(CSVText, 1, StopIdx-1);
            Name3 := CopyStr(CSVText, StopIdx+1);
            if Customer.Get(CustNo) then begin
              Customer."Name 3" := Name3;
              Customer.Modify(false);
            end;

            if Contact.Get(CustNo) then begin
              Contact."Name 3" := Name3;
              Contact.Modify(false);
            end;
          end;
        end;
    end;
}

