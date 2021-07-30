Page 50007 "Customer Cash Sales Part"
{
    Caption = 'Barverkäufe';
    PageType = ListPart;
    SourceTable = "Customer Cash Sales";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cash Amount";"Cash Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Total)
            {
                field(TotalAmount;TotalAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gesamtbetrag';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UpdateTotals;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        UpdateTotals;
    end;

    var
        TotalAmount: Decimal;

    local procedure UpdateTotals()
    var
        CustomerCashSales: Record "Customer Cash Sales";
    begin
        CustomerCashSales.CopyFilters(Rec);
        CustomerCashSales.CalcSums("Cash Amount");
        TotalAmount := CustomerCashSales."Cash Amount";
    end;
}

