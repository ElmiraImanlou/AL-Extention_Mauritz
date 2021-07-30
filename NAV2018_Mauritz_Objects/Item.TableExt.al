TableExtension 50004 tableextension50004 extends Item 
{
    fields
    {
        field(50000;"Attached Item No.";Code[20])
        {
            Caption = 'Zugehöriger Artikel';
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnRename".

    //trigger (Variable: TransferLine)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesLine.RenameNo(SalesLine.Type::Item,xRec."No.","No.");
        PurchaseLine.RenameNo(PurchaseLine.Type::Item,xRec."No.","No.");

        ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);
        ItemAttributeValueMapping.RenameItemAttributeValueMapping(xRec."No.","No.");
        SetLastDateTimeModified;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        SalesLine.RenameNo(SalesLine.Type::Item,xRec."No.","No.");
        PurchaseLine.RenameNo(PurchaseLine.Type::Item,xRec."No.","No.");
        TransferLine.RenameNo(xRec."No.","No.");
        #3..6
        */
    //end;


    //Unsupported feature: Code Modification on "CalcUnitPriceExclVAT(PROCEDURE 41)".

    //procedure CalcUnitPriceExclVAT();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        GetGLSetup;
        IF 1 + CalcVAT = 0 THEN
          EXIT(0);
        EXIT(ROUND("Unit Price" / (1 + CalcVAT),GLSetup."Unit-Amount Rounding Precision"));
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF "VAT Prod. Posting Group" = '' THEN
          EXIT(0);
        #1..4
        */
    //end;

    var
        TransferLine: Record "Transfer Line";
}

