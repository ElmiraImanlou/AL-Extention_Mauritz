TableExtension 50023 tableextension50023 extends "Sales Header Archive" 
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

