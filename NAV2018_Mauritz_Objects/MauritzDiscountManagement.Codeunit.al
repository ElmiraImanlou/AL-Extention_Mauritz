Codeunit 50002 "Mauritz Discount Management"
{

    trigger OnRun()
    begin
        Page.Run(50011);
    end;

    [EventSubscriber(Objecttype::Page, 42, 'OnClosePageEvent', '', false, false)]
    local procedure SalesOrderCardOnClose(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        InvDiscAmount: Decimal;
        InvDiscPct: Decimal;
        VATAmt: Decimal;
    begin
        CalcSalesDocumentTotals(Rec, SalesLine, InvDiscAmount, InvDiscPct, VATAmt, true);
    end;

    [EventSubscriber(Objecttype::Page, 46, 'OnUpdateSalesInvoiceDiscount', '', false, false)]
    local procedure SalesOrderSubFormOnUpdateSalesInvoiceDiscount(var TotalSalesHeader: Record "Sales Header";var TotalSalesLine: Record "Sales Line";var InvDiscAmount: Decimal;var InvDiscPct: Decimal;var VATAmt: Decimal;UpdateLines: Boolean)
    begin
        CalcSalesDocumentTotals(TotalSalesHeader, TotalSalesLine, InvDiscAmount, InvDiscPct, VATAmt, UpdateLines);
    end;

    [EventSubscriber(Objecttype::Page, 47, 'OnUpdateSalesInvoiceDiscount', '', false, false)]
    local procedure SalesInvoiceSubFormOnUpdateSalesInvoiceDiscount(var TotalSalesHeader: Record "Sales Header";var TotalSalesLine: Record "Sales Line";var InvDiscAmount: Decimal;var InvDiscPct: Decimal;var VATAmt: Decimal;UpdateLines: Boolean)
    begin
        CalcSalesDocumentTotals(TotalSalesHeader, TotalSalesLine, InvDiscAmount, InvDiscPct, VATAmt, UpdateLines);
    end;

    [EventSubscriber(Objecttype::Page, 41, 'OnClosePageEvent', '', false, false)]
    local procedure SalesQuoteCardOnClose(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        InvDiscAmount: Decimal;
        InvDiscPct: Decimal;
        VATAmt: Decimal;
    begin
        CalcSalesDocumentTotals(Rec, SalesLine, InvDiscAmount, InvDiscPct, VATAmt, true);
    end;

    [EventSubscriber(Objecttype::Page, 95, 'OnUpdateSalesInvoiceDiscount', '', false, false)]
    local procedure SalesQuoteSubFormOnUpdateSalesInvoiceDiscount(var TotalSalesHeader: Record "Sales Header";var TotalSalesLine: Record "Sales Line";var InvDiscAmount: Decimal;var InvDiscPct: Decimal;var VATAmt: Decimal;UpdateLines: Boolean)
    begin
        CalcSalesDocumentTotals(TotalSalesHeader, TotalSalesLine, InvDiscAmount, InvDiscPct, VATAmt, UpdateLines);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure SalesLineOnAfterValidateLineDiscountPct(var Rec: Record "Sales Line";var xRec: Record "Sales Line";CurrFieldNo: Integer)
    begin
        if Rec."Line Discount %" <> 0 then
          Rec.Validate("Line Discount %", 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure SalesDocumentOnBeforePost(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        InvDiscAmount: Decimal;
        InvDiscPct: Decimal;
        VATAmt: Decimal;
    begin
        CalcSalesDocumentTotals(SalesHeader, SalesLine, InvDiscAmount, InvDiscPct, VATAmt, true);
    end;


    procedure CalcSalesDocumentTotals(TotalSalesHeader: Record "Sales Header";var TotalSalesLine: Record "Sales Line";var InvDiscAmount: Decimal;var InvDiscPct: Decimal;var VATAmt: Decimal;UpdateLines: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CustomerDiscountGroup: Record "Customer Discount Group";
        CustInvoiceDisc: Record "Cust. Invoice Disc.";
        TotalInvoiceAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalInvoiceAmountInclVAT: Decimal;
        TotalInvoiceAmountInclVATDiscountable: Decimal;
        VATFactor: Decimal;
    begin
        if not SalesHeader.Get(TotalSalesHeader."Document Type", TotalSalesHeader."No.") then
          exit;

        // Calc Discountable Invoice Amount (incl. VAT)
        CalcInvoiceAmounts(TotalSalesHeader, TotalInvoiceAmount, TotalInvoiceAmountInclVAT, TotalInvoiceAmountInclVATDiscountable);
        TotalSalesLine."Line Amount" := TotalInvoiceAmountInclVATDiscountable;

        // Get Invoice Discount Percent
        case SalesHeader."Invoice Discount Calculation" of
          SalesHeader."invoice discount calculation"::None:
            begin
              if SalesHeader."Document Type" in [SalesHeader."document type"::"Credit Memo", SalesHeader."document type"::"Return Order"] then
                InvDiscPct := CalcCurrentInvDiscPercent(TotalSalesHeader, TotalInvoiceAmountInclVATDiscountable)
              else
                InvDiscPct := FindBestDiscountPercent(TotalSalesHeader, TotalInvoiceAmountInclVATDiscountable);
              InvDiscAmount := TotalInvoiceAmountInclVATDiscountable * InvDiscPct / 100;
            end;
          SalesHeader."invoice discount calculation"::"%":
            begin
              InvDiscPct := SalesHeader."Invoice Discount Value";
              InvDiscAmount := TotalInvoiceAmountInclVATDiscountable * InvDiscPct / 100;
            end;
          SalesHeader."invoice discount calculation"::Amount:
            begin
              InvDiscAmount := SalesHeader."Invoice Discount Value";
              if TotalInvoiceAmountInclVATDiscountable <> 0 then
                InvDiscPct := InvDiscAmount / TotalInvoiceAmountInclVATDiscountable * 100
              else
                InvDiscPct := 0;
            end;
        end;

        Clear(TotalInvoiceAmount);
        Clear(TotalInvoiceAmountInclVAT);
        Clear(VATAmt);

        // Apply Invoice Discount to SalesLines
        if not (TotalSalesHeader."Document Type" in [TotalSalesHeader."document type"::"Credit Memo", TotalSalesHeader."document type"::"Return Order"]) then begin
          SalesLine.SetRange("Document Type", TotalSalesHeader."Document Type");
          SalesLine.SetRange("Document No.", TotalSalesHeader."No.");
          //SalesLine.SETRANGE("Allow Invoice Disc.", TRUE);
          if SalesLine.FindSet(true) then
            repeat
              VATFactor := (1 + SalesLine."VAT %" / 100);
              if SalesLine."Allow Invoice Disc." then
                SalesLine.Validate("Inv. Discount Amount", SalesLine."Line Amount" * InvDiscPct / 100);

              if SalesHeader."Prices Including VAT" then begin
                TotalInvoiceAmount += (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") / VATFactor;
                TotalInvoiceAmountInclVAT += SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
              end else begin
                TotalInvoiceAmount += SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
                TotalInvoiceAmountInclVAT += (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") * VATFactor;
              end;

              if UpdateLines then
                SalesLine.Modify;
            until SalesLine.Next = 0;
        end;

        TotalSalesLine.Amount := TotalInvoiceAmount;
        VATAmt := TotalInvoiceAmountInclVAT - TotalInvoiceAmount;
        TotalSalesLine."Amount Including VAT" := TotalInvoiceAmountInclVAT;
    end;


    procedure CalcTotalSalesAmount(SalesHeader: Record "Sales Header";IncludingVAT: Boolean;OnlyDicountAllowed: Boolean): Decimal
    var
        TotalSalesLine: Record "Sales Line";
    begin
        with TotalSalesLine do begin
          SetRange("Document Type",SalesHeader."Document Type");
          SetRange("Document No.",SalesHeader."No.");
          if OnlyDicountAllowed then
            SetRange("Allow Invoice Disc.",true);

          if IncludingVAT then begin
            CalcSums("Amount Including VAT");
            exit("Amount Including VAT");
          end else begin
            CalcSums("Line Amount");
            exit("Line Amount");
          end;
        end;
    end;

    local procedure CalcInvoiceAmounts(SalesHeader: Record "Sales Header";var TotalInvoiceAmount: Decimal;var TotalInvoiceAmountInclVAT: Decimal;var TotalInvoiceAmountInclVATDiscountable: Decimal)
    var
        SalesLine: Record "Sales Line";
        VATFactor: Decimal;
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet then
          repeat
            VATFactor := (1 + SalesLine."VAT %" / 100);

            if SalesHeader."Prices Including VAT" then begin
              TotalInvoiceAmount += SalesLine."Line Amount" / VATFactor;
              TotalInvoiceAmountInclVAT += SalesLine."Line Amount";
              if SalesLine."Allow Invoice Disc." then
                TotalInvoiceAmountInclVATDiscountable += SalesLine."Line Amount";
            end else begin
              TotalInvoiceAmount += SalesLine."Line Amount";
              TotalInvoiceAmountInclVAT += SalesLine."Line Amount" * VATFactor;
              if SalesLine."Allow Invoice Disc." then
                TotalInvoiceAmountInclVATDiscountable += SalesLine."Line Amount" * VATFactor;
            end;
          until SalesLine.Next = 0;
    end;

    local procedure FindBestDiscountPercent(TotalSalesHeader: Record "Sales Header";TotalInvoiceAmountInclVATDiscountable: Decimal) InvDiscPct: Decimal
    var
        CustomerDiscountGroup: Record "Customer Discount Group";
        CustInvoiceDisc: Record "Cust. Invoice Disc.";
    begin
        if CustomerDiscountGroup.Get(TotalSalesHeader."Customer Disc. Group") then
          InvDiscPct := CustomerDiscountGroup."Default Discount %";

        CustInvoiceDisc.SetRange("Minimum Amount", 0, TotalInvoiceAmountInclVATDiscountable);
        CustInvoiceDisc.SetFilter("Discount %", '>%1', InvDiscPct);
        CustInvoiceDisc.SetCurrentkey("Discount %");
        if CustInvoiceDisc.FindLast then
          InvDiscPct := CustInvoiceDisc."Discount %";
    end;

    local procedure CalcCurrentInvDiscPercent(TotalSalesHeader: Record "Sales Header";TotalInvoiceAmountInclVATDiscountable: Decimal) CurrDiscountPct: Decimal
    var
        SalesLine: Record "Sales Line";
        TotalInvoiceDiscountAmount: Decimal;
        VATFactor: Decimal;
    begin
        SalesLine.SetRange("Document Type", TotalSalesHeader."Document Type");
        SalesLine.SetRange("Document No.", TotalSalesHeader."No.");
        if SalesLine.FindSet then
          repeat
            VATFactor := (1 + SalesLine."VAT %" / 100);
            TotalInvoiceDiscountAmount += (SalesLine."Inv. Discount Amount" * VATFactor);
          until SalesLine.Next = 0;

        if TotalInvoiceAmountInclVATDiscountable <> 0 then
          CurrDiscountPct := TotalInvoiceDiscountAmount / TotalInvoiceAmountInclVATDiscountable * 100
        else
          CurrDiscountPct := 0;
    end;


    procedure ApplyFixInvoiceDiscountPercent(TotalSalesHeader: Record "Sales Header";Value: Decimal)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        InvDiscAmount: Decimal;
        InvDiscPct: Decimal;
        VATAmt: Decimal;
    begin
        with SalesHeader do begin
          Get(TotalSalesHeader."Document Type", TotalSalesHeader."No.");
          "Invoice Discount Calculation" := "invoice discount calculation"::"%";
          "Invoice Discount Value" := Value;
          Modify(true);
        end;
        CalcSalesDocumentTotals(TotalSalesHeader, SalesLine, InvDiscAmount, InvDiscPct, VATAmt, true);
    end;


    procedure ApplyFixInvoiceDiscountAmount(TotalSalesHeader: Record "Sales Header";Value: Decimal)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        InvDiscAmount: Decimal;
        InvDiscPct: Decimal;
        VATAmt: Decimal;
    begin
        with SalesHeader do begin
          Get(TotalSalesHeader."Document Type", TotalSalesHeader."No.");
          "Invoice Discount Calculation" := "invoice discount calculation"::Amount;
          "Invoice Discount Value" := Value;
          Modify(true);
        end;
        CalcSalesDocumentTotals(TotalSalesHeader, SalesLine, InvDiscAmount, InvDiscPct, VATAmt, true);
    end;


    procedure ApplyAutoInvoiceDiscount(TotalSalesHeader: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        InvDiscAmount: Decimal;
        InvDiscPct: Decimal;
        VATAmt: Decimal;
    begin
        with SalesHeader do begin
          Get(TotalSalesHeader."Document Type", TotalSalesHeader."No.");
          "Invoice Discount Calculation" := "invoice discount calculation"::None;
          Clear("Invoice Discount Value");
          Modify(true);
        end;
        CalcSalesDocumentTotals(TotalSalesHeader, SalesLine, InvDiscAmount, InvDiscPct, VATAmt, true);
    end;
}

