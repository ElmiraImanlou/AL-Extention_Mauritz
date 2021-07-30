Table 60000 "ERIC Setup"
{

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"PFX File";Blob)
        {
            Caption = 'Zertifikatsdatei';
            DataClassification = ToBeClassified;
        }
        field(3;"PFX Pin";Blob)
        {
            Caption = 'Zertifikat Kennwort';
            DataClassification = ToBeClassified;
        }
        field(4;"VAT Declaration No. Series";Code[20])
        {
            Caption = 'Nummernserie UStVA';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5;"VIES Declaration No. Series";Code[20])
        {
            Caption = 'Nummernserie ZM';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6;"VAT Declaration XSL";Blob)
        {
            Caption = 'UStVA-XSL-Stylesheet';
            DataClassification = ToBeClassified;
        }
        field(7;"VIES Declaration XSL";Blob)
        {
            Caption = 'ZM-XSL-Stylesheet';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

