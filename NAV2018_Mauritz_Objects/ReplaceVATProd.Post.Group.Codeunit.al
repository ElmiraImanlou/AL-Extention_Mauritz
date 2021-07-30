Codeunit 50700 "Replace VAT Prod. Post. Group"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        HeaderPostingIdDict: dotnet Dictionary_Of_T_U;


    procedure CopyVATPostingSetup(CopyTo: Record "VAT Posting Setup")
    var
        CopyFrom: Record "VAT Posting Setup";
        VATPct: Decimal;
    begin
        if Page.RunModal(0, CopyFrom) = Action::LookupOK then begin
          VATPct := CopyTo."VAT %";
          CopyTo.TransferFields(CopyFrom);
          CopyTo."VAT %" := VATPct;
          CopyTo.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Posting Date', false, false)]
    local procedure SalesHeader_OnAfterValidatePostingDate(var Rec: Record "Sales Header";var xRec: Record "Sales Header";CurrFieldNo: Integer)
    var
        VATProductPostingGroup: Record "VAT Product Posting Group";
        SalesLine: Record "Sales Line";
    begin
        if IsNull(HeaderPostingIdDict) then
          HeaderPostingIdDict := HeaderPostingIdDict.Dictionary();
        if HeaderPostingIdDict.ContainsKey(Format(Rec.RecordId)) then
          HeaderPostingIdDict.Remove(Format(Rec.RecordId));
        HeaderPostingIdDict.Add(Format(Rec.RecordId), Format(Rec."Posting Date"));

        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::"G/L Account", SalesLine.Type::"Charge (Item)");

        if SalesLine.FindSet(true, false) then repeat
          with VATProductPostingGroup do begin
            if Get(SalesLine."VAT Prod. Posting Group") then
              if ("Replace by Code" <> '') and ("Replace Start Date" <> 0D) then
                if ("Replace Start Date" <= Rec."Posting Date") and (("Replace End Date" = 0D) or ("Replace End Date" >= Rec."Posting Date")) then begin
                  SalesLine.SuspendStatusCheck(true);
                  SalesLine.Validate("VAT Prod. Posting Group", "Replace by Code");
                  SalesLine.Modify(true);
                end;

            SetRange("Replace by Code", SalesLine."VAT Prod. Posting Group");
            SetFilter("Replace Start Date", '..%1&>%2', xRec."Posting Date", Rec."Posting Date");
            SetFilter("Replace End Date", '%1|%2..', 0D, xRec."Posting Date");
            if FindFirst then
              if Code <> SalesLine."VAT Prod. Posting Group" then begin
                SalesLine.SuspendStatusCheck(true);
                SalesLine.Validate("VAT Prod. Posting Group", Code);
                SalesLine.Modify(true);
              end;

            SetRange("Replace by Code", SalesLine."VAT Prod. Posting Group");
            SetFilter("Replace Start Date", '<%1&<%2', xRec."Posting Date", Rec."Posting Date");
            SetFilter("Replace End Date", '>=%1&<%2', xRec."Posting Date", Rec."Posting Date");
            if FindFirst then
              if Code <> SalesLine."VAT Prod. Posting Group" then begin
                SalesLine.SuspendStatusCheck(true);
                SalesLine.Validate("VAT Prod. Posting Group", Code);
                SalesLine.Modify(true);
              end;
          end;
        until SalesLine.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Posting Date', false, false)]
    local procedure PurchHeader_OnAfterValidatePostingDate(var Rec: Record "Purchase Header";var xRec: Record "Purchase Header";CurrFieldNo: Integer)
    var
        VATProductPostingGroup: Record "VAT Product Posting Group";
        PurchLine: Record "Purchase Line";
    begin
        if IsNull(HeaderPostingIdDict) then
          HeaderPostingIdDict := HeaderPostingIdDict.Dictionary();
        if HeaderPostingIdDict.ContainsKey(Format(Rec.RecordId)) then
          HeaderPostingIdDict.Remove(Format(Rec.RecordId));
        HeaderPostingIdDict.Add(Format(Rec.RecordId), Format(Rec."Posting Date"));

        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."No.");
        PurchLine.SetRange(Type, PurchLine.Type::"G/L Account", PurchLine.Type::"Charge (Item)");
        if PurchLine.FindSet(true, false) then repeat
          with VATProductPostingGroup do begin
            if Get(PurchLine."VAT Prod. Posting Group") then
              if ("Replace by Code" <> '') and ("Replace Start Date" <> 0D) then
                if ("Replace Start Date" <= Rec."Posting Date") and (("Replace End Date" = 0D) or ("Replace End Date" >= Rec."Posting Date")) then begin
                  PurchLine.SuspendStatusCheck(true);
                  PurchLine.Validate("VAT Prod. Posting Group", "Replace by Code");
                  PurchLine.Modify(true);
                end;

            SetRange("Replace by Code", PurchLine."VAT Prod. Posting Group");
            SetFilter("Replace Start Date", '..%1&>%2', xRec."Posting Date", Rec."Posting Date");
            SetFilter("Replace End Date", '%1|%2..', 0D, xRec."Posting Date");
            if FindFirst then
              if Code <> PurchLine."VAT Prod. Posting Group" then begin
                PurchLine.SuspendStatusCheck(true);
                PurchLine.Validate("VAT Prod. Posting Group", Code);
                PurchLine.Modify(true);
              end;

            SetRange("Replace by Code", PurchLine."VAT Prod. Posting Group");
            SetFilter("Replace Start Date", '<%1&<%2', xRec."Posting Date", Rec."Posting Date");
            SetFilter("Replace End Date", '>=%1&<%2', xRec."Posting Date", Rec."Posting Date");
            if FindFirst then
              if Code <> PurchLine."VAT Prod. Posting Group" then begin
                PurchLine.SuspendStatusCheck(true);
                PurchLine.Validate("VAT Prod. Posting Group", Code);
                PurchLine.Modify(true);
              end;
          end;
        until PurchLine.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'VAT Prod. Posting Group', false, false)]
    local procedure SalesLine_OnAfterValidateVATProdPostingGroup(var Rec: Record "Sales Line";var xRec: Record "Sales Line";CurrFieldNo: Integer)
    var
        VATProductPostingGroup: Record "VAT Product Posting Group";
        SalesHeader: Record "Sales Header";
        HeaderPostingDate: Date;
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        HeaderPostingDate := GetHeaderPostingDate(SalesHeader.RecordId);

        with VATProductPostingGroup do begin
          if Get(Rec."VAT Prod. Posting Group") then
            if ("Replace by Code" <> '') and ("Replace Start Date" <> 0D) then
              if ("Replace Start Date" <= HeaderPostingDate) and (("Replace End Date" = 0D) or ("Replace End Date" >= HeaderPostingDate)) then
                Rec.Validate("VAT Prod. Posting Group", "Replace by Code");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'VAT Prod. Posting Group', false, false)]
    local procedure PurchLine_OnAfterValidateVATProdPostingGroup(var Rec: Record "Purchase Line";var xRec: Record "Purchase Line";CurrFieldNo: Integer)
    var
        VATProductPostingGroup: Record "VAT Product Posting Group";
        PurchHeader: Record "Purchase Header";
        HeaderPostingDate: Date;
    begin
        PurchHeader.Get(Rec."Document Type", Rec."Document No.");
        HeaderPostingDate := GetHeaderPostingDate(PurchHeader.RecordId);

        with VATProductPostingGroup do begin
          if Get(Rec."VAT Prod. Posting Group") then
            if ("Replace by Code" <> '') and ("Replace Start Date" <> 0D) then
              if ("Replace Start Date" <= HeaderPostingDate) and (("Replace End Date" = 0D) or ("Replace End Date" >= HeaderPostingDate)) then
                Rec.Validate("VAT Prod. Posting Group", "Replace by Code");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Posting Date', false, false)]
    local procedure GenJnlLine_OnAfterValidatePostingDate(var Rec: Record "Gen. Journal Line";var xRec: Record "Gen. Journal Line";CurrFieldNo: Integer)
    var
        VATProductPostingGroup: Record "VAT Product Posting Group";
    begin
        with VATProductPostingGroup do begin
          if Get(Rec."VAT Prod. Posting Group") then
            if ("Replace by Code" <> '') and ("Replace Start Date" <> 0D) then
              if ("Replace Start Date" <= Rec."Posting Date") and (("Replace End Date" = 0D) or ("Replace End Date" >= Rec."Posting Date")) then
                Rec.Validate("VAT Prod. Posting Group", "Replace by Code");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'VAT Prod. Posting Group', false, false)]
    local procedure GenJnlLine_OnAfterValidateVATProdPostingGroup(var Rec: Record "Gen. Journal Line";var xRec: Record "Gen. Journal Line";CurrFieldNo: Integer)
    var
        VATProductPostingGroup: Record "VAT Product Posting Group";
    begin
        with VATProductPostingGroup do begin
          if Get(Rec."VAT Prod. Posting Group") then
            if ("Replace by Code" <> '') and ("Replace Start Date" <> 0D) then
              if ("Replace Start Date" <= Rec."Posting Date") and (("Replace End Date" = 0D) or ("Replace End Date" >= Rec."Posting Date")) then
                Rec.Validate("VAT Prod. Posting Group", "Replace by Code");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnAfterOnRun', '', false, false)]
    local procedure OnAfterSalesQuoteToOrder(var SalesHeader: Record "Sales Header";var SalesOrderHeader: Record "Sales Header")
    begin
        if SalesOrderHeader."Posting Date" = 0D then
          SalesOrderHeader.Validate("Posting Date", WorkDate)
        else
          SalesOrderHeader.Validate("Posting Date");
        SalesOrderHeader.Modify(true);
    end;


    procedure GetHeaderPostingDate(HeaderRecordId: RecordID) PostingDate: Date
    var
        RecRef: RecordRef;
        "Field": Record "Field";
    begin
        if not IsNull(HeaderPostingIdDict) then
          if HeaderPostingIdDict.ContainsKey(Format(HeaderRecordId)) then begin
            Evaluate(PostingDate, HeaderPostingIdDict.Item(Format(HeaderRecordId)));
            exit;
          end;

        RecRef.Get(HeaderRecordId);
        Field.SetRange(TableNo, RecRef.Number);
        Field.SetRange(FieldName, 'Posting Date');
        if Field.FindFirst then
          exit(RecRef.Field(Field."No.").Value);

        exit(0D);
    end;
}

