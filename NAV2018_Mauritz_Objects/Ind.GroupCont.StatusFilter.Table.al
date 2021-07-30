Table 50004 "Ind. Group Cont. Status Filter"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Beschreibung';
            DataClassification = ToBeClassified;
        }
        field(3;"Industry Group Code";Code[20])
        {
            Caption = 'Branchencode';
            DataClassification = ToBeClassified;
            TableRelation = "Industry Group";
        }
        field(4;"Contact Status Filter";Text[30])
        {
            Caption = 'Kontaktstatusfilter';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code","Industry Group Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

