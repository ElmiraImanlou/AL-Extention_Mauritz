PageExtension 50013 pageextension50013 extends "Sales Invoice"
{
    layout
    {

        //Unsupported feature: Property Modification (Level) on ""Bill-to Name"(Control 14)".


        //Unsupported feature: Property Modification (Level) on ""Bill-to Address"(Control 18)".


        //Unsupported feature: Property Modification (Level) on ""Bill-to Address 2"(Control 20)".


        //Unsupported feature: Property Modification (Level) on ""Bill-to Post Code"(Control 85)".


        //Unsupported feature: Property Modification (Level) on ""Bill-to City"(Control 22)".


        //Unsupported feature: Property Modification (Level) on ""Bill-to Contact No."(Control 86)".


        //Unsupported feature: Property Modification (Level) on ""Bill-to Contact"(Control 24)".


        //Unsupported feature: Property Modification (Name) on ""Bill-to Contact"(Control 24)".


        //Unsupported feature: Property Insertion (Visible) on ""Bill-to Contact"(Control 24)".

        modify(BillToOptions)
        {
            Visible = false;
        }
        modify(Control205)
        {
            Visible = false;
        }

        //Unsupported feature: Code Modification on ""Bill-to Name"(Control 14).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF GETFILTER("Bill-to Customer No.") = xRec."Bill-to Customer No." THEN
          IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
            SETRANGE("Bill-to Customer No.");

        IF ApplicationAreaSetup.IsFoundationEnabled THEN
          SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

        CurrPage.UPDATE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        // HLVNAV::BEGIN
        // IF GETFILTER("Bill-to Customer No.") = xRec."Bill-to Customer No." THEN
        //  IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
        //    SETRANGE("Bill-to Customer No.");
        //
        // IF ApplicationAreaSetup.IsFoundationEnabled THEN
        //  SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);
        //
        // CurrPage.UPDATE;
        // HLVNAV::END
        */
        //end;

        //Unsupported feature: Property Deletion (Enabled) on ""Bill-to Address"(Control 18)".


        //Unsupported feature: Property Deletion (Editable) on ""Bill-to Address"(Control 18)".


        //Unsupported feature: Property Deletion (Enabled) on ""Bill-to Address 2"(Control 20)".


        //Unsupported feature: Property Deletion (Editable) on ""Bill-to Address 2"(Control 20)".


        //Unsupported feature: Property Deletion (Enabled) on ""Bill-to Post Code"(Control 85)".


        //Unsupported feature: Property Deletion (Editable) on ""Bill-to Post Code"(Control 85)".


        //Unsupported feature: Property Deletion (Enabled) on ""Bill-to City"(Control 22)".


        //Unsupported feature: Property Deletion (Editable) on ""Bill-to City"(Control 22)".

        addafter("Sell-to Contact")
        {
            field("Customer Disc. Group"; "Customer Disc. Group")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Assigned User ID")
        {
            field("Engraving Location"; "Engraving Location")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Bill-to Name")
        {
            field("Bill-to Name 2"; "Bill-to Name 2")
            {
                ApplicationArea = Basic;
                Caption = 'Bill-to Name 2';
            }
            // field("Bill-to Contact";"Bill-to Contact")
            // {
            //     ApplicationArea = Basic;
            //     Caption = 'Bill-to Contact';
            // }
        }
    }
}

