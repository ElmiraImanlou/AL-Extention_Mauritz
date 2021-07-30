Table 80001 "Import Line"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            TableRelation = "Export/Import Header";
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Zeilennr.';
        }
        field(3;"Destination Table No.";Integer)
        {
            CalcFormula = lookup("Export/Import Header"."Table No." where (Code=field(Code)));
            Caption = 'Zieltabelle';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Object.ID where (Type=const(Table));
        }
        field(4;"Destination Field No.";Integer)
        {
            Caption = 'Zielfeld';
            TableRelation = Field."No." where (TableNo=field("Destination Table No."));
        }
        field(5;"Validate Field";Boolean)
        {
            Caption = 'Feld validieren';
        }
        field(10;"Source Type";Option)
        {
            Caption = 'Quelle';
            OptionCaption = 'Feld,Fester Wert,Nummernserie,AutoIncrement';
            OptionMembers = "Field",FixValue,NumberSeries,AutoIncrement;
        }
        field(11;"Source Field No.";Integer)
        {
            Caption = 'Quellfeldnr.';
        }
        field(12;"Source Field Name";Text[50])
        {
            Caption = 'Quellfeldname';
        }
        field(13;"Source Field Start Delimiter";Text[10])
        {
            Caption = 'Startbegrenzer';
        }
        field(14;"Source Field End Delimiter";Text[10])
        {
            Caption = 'Endbegrenzer';
        }
        field(15;"Source Position";Integer)
        {
            Caption = 'Position';
        }
        field(16;"Source Length";Integer)
        {
            Caption = 'Länge';
        }
        field(17;"Source Value";Text[250])
        {
            Caption = 'Wert';
        }
        field(18;"Remove Chars Before";Text[30])
        {
            Caption = 'Füllzeichen am Anfang entfernen';
        }
        field(19;"Remove Chars After";Text[30])
        {
            Caption = 'Füllzeichen am Ende entfernen';
        }
        field(20;"Source Number Series";Code[20])
        {
            Caption = 'Nummernserie';
            TableRelation = "No. Series";
        }
        field(21;"Source Filter";Text[250])
        {
            Caption = 'Filter';
        }
        field(22;"Source Field Format String";Text[30])
        {
            Caption = 'Formatierung';
        }
        field(23;"Regex Pattern";Text[250])
        {
            Caption = 'Suchmuster (Reg. Ausdr.)';
        }
        field(24;"Regex Replacement";Text[250])
        {
            Caption = 'Ersetzung (Reg. Ausdr.)';
        }
        field(25;"Destination Formatting";Text[50])
        {
            Caption = 'Zielfeldformatierung';
        }
        field(1003;"Destination Table Name";Text[50])
        {
            CalcFormula = lookup(Object.Caption where (Type=const(Table),
                                                       ID=field("Destination Table No.")));
            Caption = 'Zieltabelle';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1004;"Destination Field Name";Text[50])
        {
            CalcFormula = lookup(Field."Field Caption" where (TableNo=field("Destination Table No."),
                                                              "No."=field("Destination Field No.")));
            Caption = 'Zielfeld';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Code","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

