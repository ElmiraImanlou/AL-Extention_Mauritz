Table 80000 "Export/Import Header"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Direction; Option)
        {
            Caption = 'Richtung';
            OptionMembers = Import,Export;
        }
        field(3; Type; Option)
        {
            Caption = 'Art';
            OptionCaption = 'Feste Feldlänge,Variable Feldlänge (Trennzeichen)';
            OptionMembers = FixText,VarText,Complex;
        }
        field(4; Encoding; Option)
        {
            Caption = 'Encoding';
            OptionMembers = MSDos,UTF8,UTF16,Windows;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Beschreibung';
        }
        field(6; "Record Separator"; Text[50])
        {
            Caption = 'Trennzeichen (Datensatz)';
        }
        field(7; "Field Separator"; Text[50])
        {
            Caption = 'Trennzeichen (Feld)';
        }
        field(8; "Post Processing Object Type"; Option)
        {
            Caption = 'Nachverarbeitung Objektart';
            OptionCaption = ' ,Report,Codeunit';
            OptionMembers = " ","Report","Codeunit";
        }
        field(9; "Post Processing Object ID"; Integer)
        {
            Caption = 'Nachverarbeitung Objekt-ID';
            TableRelation = if ("Post Processing Object Type" = const(Report)) Object.ID where(Type = const(Report))
            else
            if ("Post Processing Object Type" = const(Codeunit)) Object.ID where(Type = const(Codeunit));
        }
        field(10; "Import File Filter"; Text[250])
        {
            Caption = 'Import Dateifilter';
        }
        field(11; "Table No."; Integer)
        {
            Caption = 'Tabellennr.';
            TableRelation = Object.ID where(Type = const(Table));
        }
        field(12; "Skip First Lines"; Integer)
        {
            Caption = 'Zeilen am Anfang überspringen';
        }
        field(13; "Move File On Success"; Text[250])
        {
            Caption = 'Datei(en) bei Erfolg in diesen Ordner verschieben';
        }
        field(14; "Move File On Error"; Text[250])
        {
            Caption = 'Datei(en) bei Fehler in diesen Ordner verschieben';
        }
        field(20; "Export File Name"; Text[250])
        {
            Caption = 'Export Dateiname';
        }
        field(21; OnExistingRecord; Option)
        {
            Caption = 'Bei existierendem Datensatz';
            OptionCaption = 'Abbrechen,Datensatz überschreiben,Datensatz nicht importieren';
            OptionMembers = "Break",Update,Skip;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ExportLines: Record "Export Line";
        ImportLines: Record "Import Line";
    begin
        case Direction of
            Direction::Export:
                begin
                    ExportLines.SetRange(Code, Code);
                    ExportLines.DeleteAll;
                end;
            Direction::Import:
                begin
                    ImportLines.SetRange(Code, Code);
                    ImportLines.DeleteAll;
                end;
        end;
    end;


    procedure Proceed()
    var
        ExportImportMgmt: Codeunit "Export/Import Management";
    begin
        ExportImportMgmt.Run(Rec);
    end;
}

