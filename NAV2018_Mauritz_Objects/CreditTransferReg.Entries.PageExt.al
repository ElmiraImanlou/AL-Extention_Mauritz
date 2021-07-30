PageExtension 50035 pageextension50035 extends "Credit Transfer Reg. Entries" 
{
    actions
    {
        addfirst(processing)
        {
            action(PrintJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Journal ausdrucken';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
        }
    }
}

