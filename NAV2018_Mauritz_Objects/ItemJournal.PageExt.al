PageExtension 50010 pageextension50010 extends "Item Journal" 
{
    actions
    {
        addafter("&Save as Standard Journal")
        {
            action("Artikel in Buchblatt laden")
            {
                ApplicationArea = Basic;
                Caption = 'Artikel in Buchblatt laden';
                Image = ItemLines;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateItemJnlLines: Report "Create Item Jnl Lines";
                begin
                    CreateItemJnlLines.SetJournal(Rec);
                    CreateItemJnlLines.RunModal;
                    CurrPage.Update;
                end;
            }
        }
    }
}

