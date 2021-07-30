Table 80006 Standort
{

    fields
    {
        field(1;"Artikel-Nr.";Code[20])
        {
        }
        field(2;Standort;Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Artikel-Nr.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

