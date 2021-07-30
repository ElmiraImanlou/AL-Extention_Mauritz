Table 50020 "MailError Log"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'lfd. Nr.';
            DataClassification = ToBeClassified;
        }
        field(2;"Contact No.";Code[20])
        {
            Caption = 'Kontaktnr.';
            DataClassification = ToBeClassified;
            TableRelation = Contact;
        }
        field(3;"EMail Address";Text[200])
        {
            Caption = 'E-Mailadresse';
            DataClassification = ToBeClassified;
        }
        field(4;"Error Message";Blob)
        {
            Caption = 'Fehlermeldung';
            DataClassification = ToBeClassified;
        }
        field(5;"File Import DateTime";DateTime)
        {
            Caption = 'Datei Importzeit';
            DataClassification = ToBeClassified;
        }
        field(100;"Contact Name";Text[50])
        {
            CalcFormula = lookup(Contact.Name where ("No."=field("Contact No.")));
            Caption = 'Kontaktname';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Contact Privacy Blocked";Boolean)
        {
            CalcFormula = lookup(Contact."Privacy Blocked" where ("No."=field("Contact No.")));
            Caption = 'Kontakt Datenschutzsperre';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        LogEntry: Record "MailError Log";
    begin
        if LogEntry.FindLast then
          "Entry No." := LogEntry."Entry No." + 1
        else
          "Entry No." := 1;
    end;
}

