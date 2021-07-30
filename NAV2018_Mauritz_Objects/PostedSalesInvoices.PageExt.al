PageExtension 50024 pageextension50024 extends "Posted Sales Invoices"
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on "Amount(Control 13)".

        modify("Document Date")
        {
            Visible = false;
        }
        addafter("Remaining Amount")
        {
            field("Invoice Discount Amount"; "Invoice Discount Amount")
            {
                ApplicationArea = Basic;
            }
            field("Customer Disc. Group"; "Customer Disc. Group")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("<Document Exchange Status>")
        {
            field("Order No."; "Order No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        modify(Print)
        {
            ApplicationArea = All;

            //Unsupported feature: Property Modification (PromotedCategory) on "Print(Action 20)".

            ShortCutKey = 'Ctrl+P';

            //Unsupported feature: Property Insertion (Promoted) on "Print(Action 20)".


            //Unsupported feature: Property Insertion (PromotedIsBig) on "Print(Action 20)".

        }
        modify(Email)
        {
            ApplicationArea = All;

            //Unsupported feature: Property Modification (PromotedCategory) on "Email(Action 3)".


            //Unsupported feature: Property Insertion (Promoted) on "Email(Action 3)".


            //Unsupported feature: Property Insertion (PromotedIsBig) on "Email(Action 3)".

        }
    }
}

