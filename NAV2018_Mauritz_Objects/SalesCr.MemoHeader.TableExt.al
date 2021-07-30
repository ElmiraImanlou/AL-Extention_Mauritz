TableExtension 50012 tableextension50012 extends "Sales Cr.Memo Header" 
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

