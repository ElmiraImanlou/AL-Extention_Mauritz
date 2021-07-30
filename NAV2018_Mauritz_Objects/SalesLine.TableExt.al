TableExtension 50007 tableextension50007 extends "Sales Line" 
{
    fields
    {

        //Unsupported feature: Property Insertion (ValidateTableRelation) on ""Document No."(Field 3)".


        //Unsupported feature: Code Modification on "Description(Field 11).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF Type = Type::" " THEN
              EXIT;

            CASE Type OF
              Type::Item:
                BEGIN
                  IF (STRLEN(Description) <= MAXSTRLEN(Item."No.")) AND ("No." <> '') THEN
                    DescriptionIsNo := Item.GET(Description)
            #9..59
                 ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote,"Document Type"::"Credit Memo"]
              THEN
                ERROR(STRSUBSTNO(CannotFindDescErr,Type,Description));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5
                // HLV::BEGIN
                IF FALSE THEN
                // HLV::END
            #6..62
            */
        //end;
        field(50000;"Customer Name";Text[50])
        {
            CalcFormula = lookup(Customer.Name where ("No."=field("Sell-to Customer No.")));
            Caption = 'Debitorname';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

