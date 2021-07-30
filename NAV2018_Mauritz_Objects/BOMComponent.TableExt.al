TableExtension 50009 tableextension50009 extends "BOM Component" 
{
    fields
    {
        field(50000;"Shelf No.";Code[10])
        {
            CalcFormula = lookup(Item."Shelf No." where ("No."=field("No.")));
            Caption = 'Shelf No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

