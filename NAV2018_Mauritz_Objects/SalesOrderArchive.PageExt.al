PageExtension 50041 pageextension50041 extends "Sales Order Archive" 
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

