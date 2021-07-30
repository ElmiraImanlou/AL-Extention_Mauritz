PageExtension 50016 pageextension50016 extends "Sales Invoice Subform"
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on ""Unit of Measure Code"(Control 34)".


        //Unsupported feature: Property Insertion (Visible) on ""Line Discount %"(Control 16)".


        //Unsupported feature: Property Insertion (Visible) on ""Qty. to Assign"(Control 36)".

        modify("TotalSalesLine.""Line Amount""")
        {
            Caption = 'Subtotal Excl. VAT';
        }

        //Unsupported feature: Code Modification on "Type(Control 2).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        NoOnAfterValidate;
        UpdateEditableOnRow;
        UpdateTypeText;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3
        DeltaUpdateTotals;
        */
        //end;


        //Unsupported feature: Code Modification on "FilteredTypeField(Control 77).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF TempOptionLookupBuffer.AutoCompleteOption(TypeAsText,TempOptionLookupBuffer."Lookup Type"::Sales) THEN
          VALIDATE(Type,TempOptionLookupBuffer.ID);
        TempOptionLookupBuffer.ValidateOption(TypeAsText);
        UpdateEditableOnRow;
        UpdateTypeText;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..5
        DeltaUpdateTotals;
        */
        //end;


        //Unsupported feature: Code Modification on ""No."(Control 4).OnValidate".

        //trigger "(Control 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        NoOnAfterValidate;
        UpdateEditableOnRow;
        ShowShortcutDimCode(ShortcutDimCode);
        UpdateTypeText;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..4
        DeltaUpdateTotals;
        */
        //end;


        //Unsupported feature: Code Modification on "Description(Control 6).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        UpdateEditableOnRow;

        IF "No." = xRec."No." THEN
          EXIT;

        NoOnAfterValidate;
        ShowShortcutDimCode(ShortcutDimCode);
        UpdateTypeText;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..8
        DeltaUpdateTotals;
        */
        //end;


        //Unsupported feature: Code Modification on "Quantity(Control 8).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ValidateAutoReserve;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        ValidateAutoReserve;
        DeltaUpdateTotals;
        */
        //end;


        //Unsupported feature: Code Modification on ""Unit of Measure Code"(Control 34).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ValidateAutoReserve;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        ValidateAutoReserve;
        DeltaUpdateTotals;
        */
        //end;


        //Unsupported feature: Code Insertion on ""Unit Price"(Control 12)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        DeltaUpdateTotals;
        */
        //end;


        //Unsupported feature: Code Insertion on ""Line Discount %"(Control 16)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        DeltaUpdateTotals;
        */
        //end;


        //Unsupported feature: Code Insertion on ""Line Amount"(Control 64)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        DeltaUpdateTotals;
        */
        //end;


        //Unsupported feature: Code Insertion on ""Line Discount Amount"(Control 40)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        DeltaUpdateTotals;
        */
        //end;

        //Unsupported feature: Property Deletion (CaptionClass) on ""TotalSalesLine.""Line Amount"""(Control 7)".



        //Unsupported feature: Code Modification on ""Invoice Discount Amount"(Control 31).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ValidateInvoiceDiscountAmount;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        DocumentTotals.SalesDocTotalsNotUpToDate;
        ValidateInvoiceDiscountAmount;
        */
        //end;


        //Unsupported feature: Code Modification on ""Invoice Disc. Pct."(Control 29).OnValidate".

        //trigger  Pct()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
        InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
        ValidateInvoiceDiscountAmount;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        DocumentTotals.SalesDocTotalsNotUpToDate;
        #1..3
        */
        //end;
    }


    //Unsupported feature: Code Modification on "OnDeleteRecord".

    //trigger OnDeleteRecord(): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
      COMMIT;
      IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
        EXIT(FALSE);
      ReserveSalesLine.DeleteLine(Rec);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
    DocumentTotals.SalesDocTotalsNotUpToDate;
    */
    //end;


    //Unsupported feature: Code Insertion on "OnFindRecord".

    //trigger OnFindRecord()
    //Parameters and return type have not been exported.
    //begin
    /*
    DocumentTotals.SalesCheckAndClearTotals(Rec,xRec,TotalSalesLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
    EXIT(FIND(Which));
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModifyRecord".

    //trigger OnModifyRecord(): Boolean
    //begin
    /*
    DocumentTotals.SalesCheckIfDocumentChanged(Rec,xRec);
    */
    //end;


    //Unsupported feature: Code Modification on "ApproveCalcInvDisc(PROCEDURE 1)".

    //procedure ApproveCalcInvDisc();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    DocumentTotals.SalesDocTotalsNotUpToDate;
    */
    //end;


    //Unsupported feature: Code Modification on "ValidateInvoiceDiscountAmount(PROCEDURE 22)".

    //procedure ValidateInvoiceDiscountAmount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesHeader.GET("Document Type","Document No.");
    SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
    CurrPage.UPDATE(FALSE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SalesHeader.GET("Document Type","Document No.");
    SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
    DocumentTotals.SalesDocTotalsNotUpToDate;
    CurrPage.UPDATE(FALSE);
    */
    //end;


    //Unsupported feature: Code Modification on "CalcInvDisc(PROCEDURE 8)".

    //procedure CalcInvDisc();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesCalcDiscount.CalculateInvoiceDiscountOnLine(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SalesCalcDiscount.CalculateInvoiceDiscountOnLine(Rec);
    DocumentTotals.SalesDocTotalsNotUpToDate;
    */
    //end;


    //Unsupported feature: Code Modification on "ExplodeBOM(PROCEDURE 3)".

    //procedure ExplodeBOM();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
    DocumentTotals.SalesDocTotalsNotUpToDate;
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateEditableOnRow(PROCEDURE 11)".

    //procedure UpdateEditableOnRow();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsCommentLine := NOT HasTypeToFillMandatoryFields;
    IF NOT IsCommentLine THEN
      UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
    ELSE
      UnitofMeasureCodeIsChangeable := FALSE;

    CurrPageIsEditable := CurrPage.EDITABLE;
    InvDiscAmountEditable := CurrPageIsEditable AND NOT SalesSetup."Calc. Inv. Discount";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IsCommentLine := NOT HasTypeToFillMandatoryFields;
    UnitofMeasureCodeIsChangeable := NOT IsCommentLine;
    #6..8
    */
    //end;


    //Unsupported feature: Code Modification on "CalculateTotals(PROCEDURE 6)".

    //procedure CalculateTotals();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader,TotalSalesLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    DocumentTotals.SalesCheckIfDocumentChanged(Rec,xRec);
    // HLVNAV::BEGIN
    // DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader,TotalSalesLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
    // DocumentTotals.RefreshSalesLine(Rec);
    OnUpdateSalesInvoiceDiscount(TotalSalesHeader, TotalSalesLine, InvoiceDiscountAmount, InvoiceDiscountPct, VATAmount, FALSE);
    // HLVNAV::END
    */
    //end;

    local procedure DeltaUpdateTotals()
    begin
        DocumentTotals.SalesDeltaUpdateTotals(Rec, xRec, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
    end;

    local procedure "+++ HALVOTEC NAV +++"()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateSalesInvoiceDiscount(var TotalSalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var InvDiscAmount: Decimal; var InvDiscPct: Decimal; var VATAmt: Decimal; UpdateLines: Boolean)
    begin
    end;
}

