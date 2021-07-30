Table 80002 "Export Line"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "Export/Import Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Zeilennr.';
        }
        field(3; "Source Type"; Option)
        {
            Caption = 'Quelle';
            InitValue = "Field";
            OptionCaption = ' ,Feld,Fester Text,Funktion';
            OptionMembers = " ","Field",FixText,"Function",RelatedInfo;
        }
        field(10; "Source Table No."; Integer)
        {
            CalcFormula = lookup("Export/Import Header"."Table No." where(Code = field(Code)));
            Caption = 'Tabellennr.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Object.ID where(Type = const(Table));
        }
        field(11; "Source Field No."; Integer)
        {
            Caption = 'Feldnr.';
            TableRelation = if ("Source Type" = const(Field)) Field."No." where(TableNo = field("Source Table No."));

            trigger OnLookup()
            var
                "Field": Record "Field";
            begin
                Field.SetRange(TableNo, "Source Table No.");
                if Page.RunModal(Page::"Fields Lookup", Field) = Action::LookupOK then //"Field List"
                    Validate("Source Field No.", Field."No.");
            end;
        }
        field(12; "Source Value"; Text[250])
        {
            Caption = 'Wert';
        }
        field(13; "Source Field Filter"; Text[250])
        {
            Caption = 'Filter';
        }
        field(20; "Field Start Delimiter"; Text[10])
        {
            Caption = 'Startbegrenzer';
        }
        field(21; "Field End Delimiter"; Text[10])
        {
            Caption = 'Endbegrenzer';
        }
        field(22; Length; Integer)
        {
            Caption = 'Länge';
        }
        field(23; "Fill Character"; Text[1])
        {
            Caption = 'Füllzeichen';
        }
        field(24; "Fill Before/After"; Option)
        {
            Caption = 'Auffüllen';
            OptionCaption = 'Vor Wert,Nach Wert';
            OptionMembers = Before,After;
        }
        field(25; "Format Pattern"; Text[100])
        {
            Caption = 'Formatierung';
        }
        field(26; "Do not export"; Boolean)
        {
            Caption = 'Nicht exportieren';

            trigger OnValidate()
            var
                USE_FILTER: label 'Die Einstellung %1 ist nur sinnvoll in Verbindung mit einem Filter.';
            begin
                if "Do not export" and ("Source Field Filter" = '') then
                    Message(USE_FILTER, FieldCaption("Do not export"));
            end;
        }
        field(1010; "Source Table Name"; Text[50])
        {
            CalcFormula = lookup(Object.Name where(Type = const(Table),
                                                    ID = field("Source Table No.")));
            Caption = 'Tabellenname';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1011; "Source Field Name"; Text[50])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Source Table No."),
                                                              "No." = field("Source Field No.")));
            Caption = 'Feldname';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

