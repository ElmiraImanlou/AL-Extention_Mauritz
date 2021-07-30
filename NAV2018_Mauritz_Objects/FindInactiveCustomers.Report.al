Report 50010 "Find Inactive Customers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Find Inactive Customers.rdlc';

    dataset
    {
    }

    requestpage
    {
        SourceTable = Customer;
        SourceTableTemporary = true;

        layout
        {
            area(content)
            {
                field(ReferenceDate;ReferenceDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'letzte Aktivität vor';

                    trigger OnValidate()
                    begin
                        FindInactiveCustomers(ReferenceDate, Rec);
                    end;
                }
                repeater(Control50002)
                {
                    field("No.";"No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(Name;Name)
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ReferenceDate: Date;

    local procedure FindInactiveCustomers(ToDate: Date;var InactiveCust: Record Customer temporary)
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ProgressDialog: Dialog;
        CountCustAll: Integer;
        CountCustDone: Integer;
    begin
        InactiveCust.Reset;
        InactiveCust.DeleteAll;
        CustLedgerEntry.SetCurrentkey("Posting Date");

        if Customer.FindSet(false) then
          repeat
            CustLedgerEntry.SetRange("Customer No.", Customer."No.");
            if not CustLedgerEntry.FindLast xor (CustLedgerEntry."Posting Date" <= ToDate) then begin
              InactiveCust.Copy(Customer);
              InactiveCust.Insert;
            end;
          until Customer.Next = 0;
    end;
}

