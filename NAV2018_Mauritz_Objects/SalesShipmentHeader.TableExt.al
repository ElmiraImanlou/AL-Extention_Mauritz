TableExtension 50010 tableextension50010 extends "Sales Shipment Header" 
{
    fields
    {
        field(50002;"Engraving Location";Code[20])
        {
            Caption = 'Gravurort';
            DataClassification = ToBeClassified;
            Description = 'MAURITZ';
            TableRelation = "Engraving Location";
        }
    }
}

