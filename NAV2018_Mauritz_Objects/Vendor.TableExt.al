TableExtension 50003 tableextension50003 extends Vendor 
{

    //Unsupported feature: Property Insertion (DataPerCompany) on "Vendor(Table 23)".

    fields
    {
        field(50002;"Cont. Bus. Rel. Filter";Code[20])
        {
            Caption = 'Geschäftsbez.-Filter';
            FieldClass = FlowFilter;
            TableRelation = "Business Relation";
        }
        field(50003;"Contact No.";Code[20])
        {
            CalcFormula = lookup("Contact Business Relation"."Contact No." where ("No."=field("No."),
                                                                                  "Business Relation Code"=field("Cont. Bus. Rel. Filter")));
            Caption = 'Kantaktnr.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004;"Name 3";Text[50])
        {
            Caption = 'Name 3';
            DataClassification = ToBeClassified;
        }
    }
}

