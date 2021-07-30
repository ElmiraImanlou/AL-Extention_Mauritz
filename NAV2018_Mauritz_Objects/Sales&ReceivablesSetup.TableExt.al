TableExtension 50016 tableextension50016 extends "Sales & Receivables Setup"
{
    fields
    {
        // modify("Archive Quotes and Orders")
        // {
        //     Caption = 'Archive Quotes and Orders';
        // }
        field(50000; "Default Payment Terms Code"; Code[20])
        {
            Caption = 'Vorgabe Zahlungsbedingungscode';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";
        }
    }
}

