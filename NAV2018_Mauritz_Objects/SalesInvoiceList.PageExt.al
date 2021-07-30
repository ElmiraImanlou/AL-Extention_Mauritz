PageExtension 50044 pageextension50044 extends "Sales Invoice List" 
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

