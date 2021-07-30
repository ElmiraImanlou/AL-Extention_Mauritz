TableExtension 50011 tableextension50011 extends "Sales Invoice Header" 
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

