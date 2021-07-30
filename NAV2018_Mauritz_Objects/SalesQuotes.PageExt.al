PageExtension 50043 pageextension50043 extends "Sales Quotes" 
{
    layout
    {
        addafter(Status)
        {
            field("Engraving Location";"Engraving Location")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

