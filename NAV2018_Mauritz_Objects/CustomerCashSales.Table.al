Table 50003 "Customer Cash Sales"
{

    fields
    {
        field(1;"Customer No.";Code[20])
        {
            Caption = 'Debitornr.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(2;"Posting Date";Date)
        {
            Caption = 'Buchungsdatum';
            DataClassification = ToBeClassified;
        }
        field(3;"Cash Amount";Decimal)
        {
            Caption = 'Barbetrag';
            DataClassification = ToBeClassified;
        }
        field(4;Description;Text[250])
        {
            Caption = 'Beschreibung';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Customer No.","Posting Date")
        {
            Clustered = true;
            SumIndexFields = "Cash Amount";
        }
    }

    fieldgroups
    {
    }
}

