PageExtension 50003 pageextension50003 extends "Customer List"
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on ""Responsibility Center"(Control 40)".


        //Unsupported feature: Property Insertion (Visible) on ""Location Code"(Control 43)".


        //Unsupported feature: Property Deletion (Visible) on ""Post Code"(Control 54)".

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
            field(Address; Address)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Location Code")
        {
            field(City; City)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Shipping Agent Code")
        {
            field("E-Mail"; "E-Mail")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Sales (LCY)")
        {
            field("Contact No."; "Contact No.")
            {
                ApplicationArea = Basic;
            }
            field("Total Sales (LCY)"; "Total Sales (LCY)")
            {
                ApplicationArea = Basic;
            }
            field("Cash Sales Amount"; "Cash Sales Amount")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        modify(CustomerLedgerEntries)
        {
            ApplicationArea = All;

            //Unsupported feature: Property Insertion (Promoted) on "CustomerLedgerEntries(Action 22)".


            //Unsupported feature: Property Insertion (PromotedIsBig) on "CustomerLedgerEntries(Action 22)".


            //Unsupported feature: Property Insertion (PromotedCategory) on "CustomerLedgerEntries(Action 22)".

        }
        addafter(ApprovalEntries)
        {
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
        addafter("Item &Tracking Entries")
        {
            action("Inaktive Debitoren")
            {
                ApplicationArea = Basic;
                Caption = 'Inaktive Debitoren';
                Image = CustomerList;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = Page "Inactive Customers";
            }
        }
    }


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    CALCFIELDS("Contact No.");
    */
    //end;
}

