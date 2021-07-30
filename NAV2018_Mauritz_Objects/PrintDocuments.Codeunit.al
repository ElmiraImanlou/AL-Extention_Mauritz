Codeunit 50003 "Print Documents"
{
    TableNo = User;

    trigger OnRun()
    var
        PrintJob: Record "Print Job";
        PrinterSelection: Record "Printer Selection";
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        if Rec."User Name" = '' then
          Rec.Get(UserSecurityId);

        PrintJob.SetRange("User ID", Rec."User Name");
        PrintJob.SetRange(Finished, false);
        while PrintJob.FindFirst do begin
            PrinterSelection.SetFilter("User ID", '%1|%2', PrintJob."User ID", '');
            PrinterSelection.SetRange("Report ID", PrintJob."Report ID");
            if not PrinterSelection.FindLast then begin
              PrinterSelection.SetRange("Report ID", 0);
              if PrinterSelection.FindLast then;
            end;

            RecRef.Get(PrintJob."Record ID");
            if RecRef.Number in [36, 38] then begin
              FldRef := RecRef.Field(1);
              FldRef.SetRange(RecRef.Field(1));
            end;

            FldRef := RecRef.Field(3);
            FldRef.SetRange(RecRef.Field(3));

            case PrintJob.Type of
              PrintJob.Type::Original:
                Report.Print(PrintJob."Report ID", '', PrinterSelection."Printer Name", RecRef);
              PrintJob.Type::Copy:
                if PrinterSelection."Copy Printer Name" = '' then
                  Report.Print(PrintJob."Report ID", '', PrinterSelection."Printer Name", RecRef)
                else
                  Report.Print(PrintJob."Report ID", '', PrinterSelection."Copy Printer Name", RecRef);
            end;

            PrintJob.Finished := true;
            PrintJob.Modify(true);
        end;
    end;
}

