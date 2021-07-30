TableExtension 50022 tableextension50022 extends "Customer Template" 
{
    fields
    {
        field(50000;"VAT Reg. No. mandatory";Boolean)
        {
            Caption = 'Ust-ID-Nr. erforderlich';
            DataClassification = ToBeClassified;
        }
        field(50001;"Reminder Terms Code";Code[10])
        {
            Caption = 'Reminder Terms Code';
            DataClassification = ToBeClassified;
            TableRelation = "Reminder Terms";
        }
    }
}

