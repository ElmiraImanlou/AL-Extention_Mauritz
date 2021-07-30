Codeunit 50006 Dummy
{

    trigger OnRun()
    var
        GeneralPostingSetup: Record "General Posting Setup";
        Company: Record Company;
    begin
        if Company.FindSet then
          repeat
            GeneralPostingSetup.ChangeCompany(Company.Name);
            if GeneralPostingSetup.Get('INLAND', 'HANDEL') then begin
              GeneralPostingSetup."Gen. Prod. Posting Group" := '';
              GeneralPostingSetup.Insert(false);
            end;
          until Company.Next = 0;

        exit;
        if SalesInvoiceHeader.FindSet then
          repeat
            if PaymentTerms.Get(SalesInvoiceHeader."Payment Terms Code") then begin
              DiscDate := SalesInvoiceHeader."Pmt. Discount Date";
              DueDate := SalesInvoiceHeader."Due Date";

              if DiscDate <> 0D then
                SalesInvoiceHeader."Pmt. Discount Date" := CalcDate(PaymentTerms."Discount Date Calculation", SalesInvoiceHeader."Document Date");
              SalesInvoiceHeader."Due Date" := CalcDate(PaymentTerms."Due Date Calculation", SalesInvoiceHeader."Document Date");

              if (SalesInvoiceHeader."Pmt. Discount Date" <> DiscDate) or (SalesInvoiceHeader."Due Date" <> DueDate) then begin
                SalesInvoiceHeader.Modify(false);
                CountModifiedInv += 1;
              end;

              if CustLedgerEntry.Get(SalesInvoiceHeader."Cust. Ledger Entry No.") then begin
                DiscDate := CustLedgerEntry."Pmt. Discount Date";
                DueDate := CustLedgerEntry."Due Date";
                CustLedgerEntry."Pmt. Discount Date" := SalesInvoiceHeader."Pmt. Discount Date";
                CustLedgerEntry."Due Date" := SalesInvoiceHeader."Due Date";
                if (CustLedgerEntry."Pmt. Discount Date" <> DiscDate) or (CustLedgerEntry."Due Date" <> DueDate) then begin
                  CustLedgerEntry.Modify(false);
                  CountModifiedEntr += 1;
                end;
              end;
            end;
          until SalesInvoiceHeader.Next = 0;

        Message('%1 Rechnungen geändert.\ %2 Deb.-posten geändert.', CountModifiedInv, CountModifiedEntr);
    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PaymentTerms: Record "Payment Terms";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DiscDate: Date;
        DueDate: Date;
        CountModifiedInv: Integer;
        CountModifiedEntr: Integer;
}

