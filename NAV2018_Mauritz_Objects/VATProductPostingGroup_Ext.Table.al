tableextension 60324 "VAT Product Posting Group_Ext" extends "VAT Product Posting Group"
{
    Caption = 'VAT Product Posting Group_Ext';
    fields
    {
        field(50700; "Replace Start Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(50701; "Replace End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50702; "Replace by Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }
}