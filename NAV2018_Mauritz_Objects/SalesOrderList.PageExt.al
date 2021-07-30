PageExtension 50046 pageextension50046 extends "Sales Order List" 
{
    layout
    {
        modify("Shipment Date")
        {
            Caption = 'Shipment Date';
        }

        //Unsupported feature: Property Deletion (Visible) on ""Requested Delivery Date"(Control 1102601027)".

        addafter("Amount Including VAT")
        {
            field("Engraving Location";"Engraving Location")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

