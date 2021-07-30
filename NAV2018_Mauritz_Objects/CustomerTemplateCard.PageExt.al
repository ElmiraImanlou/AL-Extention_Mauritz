PageExtension 50040 pageextension50040 extends "Customer Template Card" 
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("VAT Reg. No. mandatory";"VAT Reg. No. mandatory")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

