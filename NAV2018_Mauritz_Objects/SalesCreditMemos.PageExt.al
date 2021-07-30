PageExtension 50045 pageextension50045 extends "Sales Credit Memos" 
{
    layout
    {
        addafter(Amount)
        {
            field("Engraving Location";"Engraving Location")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

