PageExtension 50002 pageextension50002 extends "Customer Card"
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on ""IC Partner Code"(Control 154)".


        //Unsupported feature: Property Insertion (Visible) on ""Responsibility Center"(Control 64)".


        //Unsupported feature: Property Insertion (Visible) on ""Service Zone Code"(Control 93)".


        //Unsupported feature: Property Insertion (Visible) on ""Document Sending Profile"(Control 23)".


        //Unsupported feature: Property Insertion (Visible) on ""CustSalesLCY - CustProfit - AdjmtCostLCY"(Control 72)".


        //Unsupported feature: Property Insertion (Visible) on "AdjCustProfit(Control 71)".


        //Unsupported feature: Property Insertion (Visible) on "AdjProfitPct(Control 69)".


        //Unsupported feature: Property Insertion (Visible) on "GLN(Control 61)".


        //Unsupported feature: Property Insertion (Visible) on "Shipping(Control 1906801201)".


        //Unsupported feature: Property Insertion (GroupType) on "Shipping(Control 1906801201)".


        //Unsupported feature: Property Insertion (Visible) on ""Location Code"(Control 95)".


        //Unsupported feature: Property Insertion (Visible) on ""Combine Shipments"(Control 32)".


        //Unsupported feature: Property Insertion (Visible) on "Reserve(Control 158)".


        //Unsupported feature: Property Insertion (Visible) on ""Shipping Advice"(Control 123)".


        //Unsupported feature: Property Insertion (Visible) on ""Shipment Method"(Control 145)".


        //Unsupported feature: Property Insertion (Visible) on ""Shipment Method Code"(Control 30)".


        //Unsupported feature: Property Insertion (Visible) on ""Shipping Agent Code"(Control 101)".


        //Unsupported feature: Property Insertion (Visible) on ""Shipping Agent Service Code"(Control 131)".


        //Unsupported feature: Property Insertion (Visible) on ""Shipping Time"(Control 119)".


        //Unsupported feature: Property Insertion (Visible) on ""Base Calendar Code"(Control 141)".


        //Unsupported feature: Property Insertion (Visible) on ""Customized Calendar"(Control 146)".

        // modify("Customer Disc. Group")
        // {
        //     Visible = false;
        // }
        addafter("No.")
        {
            field("Industry Group Code"; "Industry Group Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Name)
        {
            // field("Name 2";"Name 2")
            // {
            //     ApplicationArea = Basic;
            // }
            field("Name 3"; "Name 3")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(TotalSales2)
        {
            // field("Customer Disc. Group";"Customer Disc. Group")
            // {
            //     ApplicationArea = Basic;
            // }
        }
        addafter("Disable Search by Name")
        {
            field("Contact No."; "Contact No.")
            {
                ApplicationArea = Basic;
                Caption = 'Kontaktnummer';
            }
        }
        addafter("Fax No.")
        {
            field("Mobile Phone No."; "Mobile Phone No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(PriceAndLineDisc)
        {
            part(Control50008; "Customer Cash Sales Part")
            {
                SubPageLink = "Customer No." = field("No.");
            }
        }
    }
    actions
    {
        // modify("Ledger E&ntries")
        // {
        //     Visible = false;
        // }
        // addafter(OPplus)
        // {
        //     action("Ledger E&ntries")
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Ledger E&ntries';
        //         Image = CustomerLedger;
        //         Promoted = true;
        //         PromotedCategory = Process;
        //         PromotedIsBig = true;
        //         RunObject = Page "Customer Ledger Entries";
        //         RunPageLink = "Customer No."=field("No.");
        //         RunPageMode = View;
        //         RunPageView = sorting("Customer No.")
        //                       order(descending);
        //         ShortCutKey = 'Ctrl+F7';
        //         ToolTip = 'View the history of transactions that have been posted for the selected record.';
        //     }
        // }
        addafter(CustomerReportSelections)
        {
            action("Print Cover &Sheet")
            {
                ApplicationArea = All;
                Caption = 'Print Cover &Sheet';
                Image = PrintCover;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                ToolTip = 'View cover sheets to send to your contact.';

                trigger OnAction()
                var
                    Cont: Record Contact;
                begin
                    CalcFields("Contact No.");
                    Cont.Get("Contact No.");
                    Cont.SetRecfilter;
                    Report.Run(5085, true, false, Cont);
                end;
            }
            action(EditMemo)
            {
                ApplicationArea = Basic;
                Caption = 'Notizen bearbeiten';
                Image = Notes;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Customer Memo";
                RunPageLink = "No." = field("No.");
            }
        }
    }
}

