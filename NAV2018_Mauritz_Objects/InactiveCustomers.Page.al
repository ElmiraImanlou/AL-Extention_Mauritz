Page 50005 "Inactive Customers"
{
    Caption = 'Inaktive Debitoren';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = Customer;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Sales)
            {
                Caption = 'Umsatz';
                field(SalesMaxAmount;SalesMaxAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'nicht mehr als (░)';
                }
                field(SalesSinceDate;SalesSinceDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'seit';

                    trigger OnValidate()
                    begin
                        SetRange("Date Filter", SalesSinceDate, WorkDate);
                    end;
                }
            }
            group(Entries)
            {
                Caption = 'Posten';
                field(EntriesLastPostingDateBefore;EntriesLastPostingDateBefore)
                {
                    ApplicationArea = Basic;
                    Caption = 'letzter Posten vor';

                    trigger OnValidate()
                    begin
                        FindInactiveEnabled := (EntriesLastPostingDateBefore <> 0D) or (NoEntriesRefDate <> 0D);
                    end;
                }
                field(NoEntriesRefDate;NoEntriesRefDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'keine Posten und geändert vor';

                    trigger OnValidate()
                    begin
                        FindInactiveEnabled := (EntriesLastPostingDateBefore <> 0D) or (NoEntriesRefDate <> 0D);
                    end;
                }
            }
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Name 2";"Name 2")
                {
                    ApplicationArea = Basic;
                }
                field("Name 3";"Name 3")
                {
                    ApplicationArea = Basic;
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field("Net Change (LCY)";"Net Change (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Sales (LCY)";"Sales (LCY)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(FindLowSalesCustomers)
            {
                ApplicationArea = Basic;
                Caption = 'Debitoren mit niedrigem Umsatz finden';
                Enabled = SalesMaxAmount <> 0;
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FindLowSalesCustomers(SalesSinceDate, SalesMaxAmount, Rec);
                end;
            }
            action(FindInactiveCustomers)
            {
                ApplicationArea = Basic;
                Caption = 'Inaktive Debitoren suchen';
                Enabled = FindInactiveEnabled;
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FindInactiveCustomers(EntriesLastPostingDateBefore, NoEntriesRefDate, Rec)
                end;
            }
            action(SetInactive)
            {
                ApplicationArea = Basic;
                Caption = 'Kontakte als inaktiv markieren';
                Image = ContactReference;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    InactiveCust: Record Customer;
                    Contact: Record Contact;
                begin
                    CurrPage.SetSelectionFilter(InactiveCust);
                    if InactiveCust.FindSet then
                      repeat
                        InactiveCust.CalcFields("Contact No.");
                        if Contact.Get(InactiveCust."Contact No.") then begin
                          Contact."Territory Code" := 'i';
                          Contact.Modify(false);
                        end;
                      until InactiveCust.Next = 0;
                end;
            }
            action(SetDeletable)
            {
                ApplicationArea = Basic;
                Caption = 'Kontakte als "zu löschen" markieren';
                Image = ContactReference;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    InactiveCust: Record Customer;
                    Contact: Record Contact;
                begin
                    CurrPage.SetSelectionFilter(InactiveCust);
                    if InactiveCust.FindSet then
                      repeat
                        InactiveCust.CalcFields("Contact No.");
                        if Contact.Get(InactiveCust."Contact No.") and (Contact."Territory Code" = 'I') then begin
                          Contact."Territory Code" := 'L';
                          Contact."Privacy Blocked" := true;
                          Contact.Modify(false);
                        end;
                      until InactiveCust.Next = 0;
                end;
            }
            action(Entries)
            {
                ApplicationArea = Basic;
                Caption = 'Posten';
                Image = Entries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgerEntry.SetRange("Customer No.", Rec."No.");
                    CustLedgerEntry.SetRange("Posting Date", SalesSinceDate, 99991231D);
                    Page.Run(0, CustLedgerEntry);
                end;
            }
        }
    }

    var
        EntriesLastPostingDateBefore: Date;
        NoEntriesRefDate: Date;
        SalesSinceDate: Date;
        SalesMaxAmount: Decimal;
        FindInactiveEnabled: Boolean;

    local procedure FindInactiveCustomers(ToDate1: Date;ToDate2: Date;var InactiveCust: Record Customer temporary)
    var
        Contact: Record Contact;
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ProgressDialog: Dialog;
        CountCustAll: Integer;
        CountCustDone: Integer;
    begin
        InactiveCust.Reset;
        InactiveCust.DeleteAll;
        CustLedgerEntry.SetCurrentkey("Posting Date");

        Customer.SetFilter("Contact No.", '<>%1', '');
        if Customer.FindSet(false) then
          repeat
            Customer.CalcFields("Contact No.");
            Contact.Get(Customer."Contact No.");
            CustLedgerEntry.SetRange("Customer No.", Customer."No.");
            if not (Contact."Territory Code" in ['I', 'S']) then
              if (CustLedgerEntry.FindLast and (CustLedgerEntry."Posting Date" < ToDate1)) xor
                 (Customer."Last Date Modified" < ToDate2)
              then begin
                InactiveCust.Copy(Customer);
                InactiveCust.Insert;
              end;

          until Customer.Next = 0;
    end;

    local procedure FindLowSalesCustomers(FromDate: Date;MaxAmount: Decimal;var InactiveCust: Record Customer temporary)
    var
        Contact: Record Contact;
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ProgressDialog: Dialog;
        CountCustAll: Integer;
        CountCustDone: Integer;
        CustomerSales: Decimal;
    begin
        InactiveCust.Reset;
        InactiveCust.DeleteAll;

        Customer.SetFilter("Contact No.", '<>%1', '');
        if Customer.FindSet(false) then
          repeat
            CustomerSales := 0;
            Customer.CalcFields("Contact No.");
            Contact.Get(Customer."Contact No.");
            CustLedgerEntry.SetRange("Customer No.", Customer."No.");
            CustLedgerEntry.SetRange("Posting Date", FromDate, 99991231D);
            CustLedgerEntry.SetFilter("Sales (LCY)", '<>%1', 0);
            if CustLedgerEntry.FindSet then
              repeat
                CustLedgerEntry.CalcFields("Amount (LCY)");
                CustomerSales += CustLedgerEntry."Amount (LCY)";
              until (CustLedgerEntry.Next = 0) or (CustomerSales > MaxAmount);

            if CustomerSales <= MaxAmount then begin
              InactiveCust.Copy(Customer);
              InactiveCust.Insert;
            end;
          until Customer.Next = 0;
    end;
}

