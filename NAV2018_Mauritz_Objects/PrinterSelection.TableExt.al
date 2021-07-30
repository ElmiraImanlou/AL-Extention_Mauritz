TableExtension 50008 tableextension50008 extends "Printer Selection" 
{
    fields
    {
        field(50000;"Copy Printer Name";Text[250])
        {
            Caption = 'Drucker für Kopien';
            DataClassification = ToBeClassified;
            TableRelation = Printer;
        }
    }
}

