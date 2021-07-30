PageExtension 50120 pageextension500120 extends "Sales VAT Adv. Notif. List"
{
    layout
    {
        addafter("XML-File Creation Date")
        {
            field("Transmission successful"; "Transmission successful")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

