PageExtension 50001 pageextension50001 extends "General Ledger Entries" 
{
    layout
    {

        //Unsupported feature: Property Deletion (Visible) on ""Debit Amount"(Control 17)".


        //Unsupported feature: Property Deletion (Visible) on ""Credit Amount"(Control 19)".

        addafter("External Document No.")
        {
            field("Transaction No.";"Transaction No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter("Value Entries")
        {
            action("AGENDA Export")
            {
                ApplicationArea = Basic;
                Caption = 'AGENDA Export';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report ExportBuchungenXLS3;
            }
        }
    }
}

