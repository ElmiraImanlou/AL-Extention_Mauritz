PageExtension 50032 pageextension50032 extends "Sales & Receivables Setup" 
{
    layout
    {
        addafter("Ignore Updated Addresses")
        {
            field("Default Payment Terms Code";"Default Payment Terms Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

