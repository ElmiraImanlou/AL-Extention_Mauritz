PageExtension 50005 pageextension50005 extends "Item Card" 
{
    layout
    {
        modify("Item Category Code")
        {
            Caption = 'Item Category Code';
        }
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            field("Attached Item No.";"Attached Item No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {


        //Unsupported feature: Code Modification on "CopyItem(Action 1150000).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CopyItem.ItemDef(Rec);
            CopyItem.RUNMODAL;
            IF CopyItem.ItemReturn(ReturnItem) THEN
              IF CONFIRM(Text11500,TRUE) THEN
                Rec := ReturnItem;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..4
                // Rec := ReturnItem;
                PAGE.RUN(30, ReturnItem);
            */
        //end;
    }
}

