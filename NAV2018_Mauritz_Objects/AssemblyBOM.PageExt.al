PageExtension 50007 pageextension50007 extends "Assembly BOM" 
{
    layout
    {
        addfirst(Control1)
        {
            field("Parent Item No.";"Parent Item No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Resource Usage Type")
        {
            field("Shelf No.";"Shelf No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

