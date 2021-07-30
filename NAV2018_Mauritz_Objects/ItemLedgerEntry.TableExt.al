TableExtension 50005 tableextension50005 extends "Item Ledger Entry" 
{

    //Unsupported feature: Property Insertion (Permissions) on ""Item Ledger Entry"(Table 32)".

    fields
    {
        field(50000;"Cust./Vend. Name";Text[50])
        {
            Caption = 'Debitor-/Kreditorname';
            DataClassification = ToBeClassified;
        }
    }

    procedure ClearTrackingFilter()
    begin
        SetRange("Serial No.");
        SetRange("Lot No.");
    end;
}

