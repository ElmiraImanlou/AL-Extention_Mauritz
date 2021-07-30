PageExtension 50042 pageextension50042 extends "Sales Quote Archive" 
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

