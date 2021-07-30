Codeunit 50000 "Custom Event Handlers"
{
    SingleInstance = true;

    trigger OnRun()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Customer: Record Customer;
        Contact: Record Contact;
    begin
        // IF ItemLedgerEntry.FINDSET THEN
        //  REPEAT
        //    ItemLedgerEntryOnAfterInsert(ItemLedgerEntry, TRUE);
        //  UNTIL ItemLedgerEntry.NEXT = 0;

        // Customer.SETRANGE("Date Filter", 20190109D, WORKDATE);
        // Customer.SETFILTER("Territory Code", '%1|%2', 'I', '');
        // Customer.SETFILTER("Total Sales (LCY)", '<>%1', 0);
        //
        // IF Customer.FINDSET(TRUE, TRUE) THEN
        //  REPEAT
        //    Customer.CALCFIELDS("Total Sales (LCY)");
        //    Customer."Territory Code" := 'K';
        //    Customer.MODIFY(TRUE);
        //  UNTIL Customer.NEXT = 0;
        //
        // EXIT;
        // Customer.RESET;

        if Customer.FindSet(false) then
          repeat
            CustomerOnAfterModify(Customer, Customer, true);
          until Customer.Next = 0;

        exit;
        if Contact.FindSet(false) then
          repeat
            ContactOnAfterModify(Contact, Contact, true);
          until Customer.Next = 0;
    end;

    var
        NoSeriesUpdateRunning: Boolean;
        isSendingEmail: Boolean;

    [EventSubscriber(Objecttype::Page, 46, 'OnNewRecordEvent', '', false, false)]
    local procedure SalesOrderLineOnNewRecord(var Rec: Record "Sales Line";BelowxRec: Boolean;var xRec: Record "Sales Line")
    begin
        Rec.Type := Rec.Type::Item;
    end;

    [EventSubscriber(Objecttype::Page, 95, 'OnNewRecordEvent', '', false, false)]
    local procedure SalesQuoteLineOnNewRecord(var Rec: Record "Sales Line";BelowxRec: Boolean;var xRec: Record "Sales Line")
    begin
        Rec.Type := Rec.Type::Item;
    end;

    [EventSubscriber(Objecttype::Page, 47, 'OnNewRecordEvent', '', false, false)]
    local procedure SalesInvoiceLineOnNewRecord(var Rec: Record "Sales Line";BelowxRec: Boolean;var xRec: Record "Sales Line")
    begin
        Rec.Type := Rec.Type::Item;
    end;

    [EventSubscriber(Objecttype::Page, 96, 'OnNewRecordEvent', '', false, false)]
    local procedure SalesCrMemoLineOnNewRecord(var Rec: Record "Sales Line";BelowxRec: Boolean;var xRec: Record "Sales Line")
    begin
        Rec.Type := Rec.Type::Item;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', false, false)]
    local procedure CustomerOnBeforeInsert(var Rec: Record Customer;RunTrigger: Boolean)
    begin
        Rec."Prices Including VAT" := true;
        Rec."Created at" := Today;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeModifyEvent', '', false, false)]
    local procedure CustomerOnBeforeModify(var Rec: Record Customer;var xRec: Record Customer;RunTrigger: Boolean)
    var
        Contact: Record Contact;
        ContactIndustryGroup: Record "Contact Industry Group";
        SET_INDUSTRY_GROUP_CODE: label 'The Customer has no industry group code. Please select an industry group code!';
    begin
        if Rec."Industry Group Code" <> '' then
          exit;

        Rec.CalcFields("Contact No.");
        ContactIndustryGroup.SetRange("Contact No.", Rec."Contact No.");
        case ContactIndustryGroup.Count of
          0: ;
          1:
            if ContactIndustryGroup.FindFirst then
              Rec."Industry Group Code" := ContactIndustryGroup."Industry Group Code";
          else
            if Confirm(SET_INDUSTRY_GROUP_CODE, true) then
              if Page.RunModal(0, ContactIndustryGroup) = Action::LookupOK then
                Rec."Industry Group Code" := ContactIndustryGroup."Industry Group Code";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterModifyEvent', '', false, false)]
    local procedure CustomerOnAfterModify(var Rec: Record Customer;var xRec: Record Customer;RunTrigger: Boolean)
    var
        Contact: Record Contact;
        DoModify: Boolean;
    begin
        if not RunTrigger then
          exit;

        Rec.CalcFields("Contact No.");
        if Contact.Get(Rec."Contact No.") then begin
          DoModify := (Contact."Industry Group Code" <> Rec."Industry Group Code");
          DoModify := DoModify or ((Rec."Territory Code" <> '') and (Contact."Territory Code" <> Rec."Territory Code"));

          if DoModify then begin
            Contact."Industry Group Code" := Rec."Industry Group Code";
            Contact."Territory Code" := Rec."Territory Code";
            Contact.Modify(false);
          end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterModifyEvent', '', false, false)]
    local procedure ContactOnAfterModify(var Rec: Record Contact;var xRec: Record Contact;RunTrigger: Boolean)
    var
        Customer: Record Customer;
        ContactBusinessRelation: Record "Contact Business Relation";
        DoModify: Boolean;
    begin
        if not RunTrigger then
          exit;

        ContactBusinessRelation.SetRange("Contact No.", Rec."No.");
        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."link to table"::Customer);
        if ContactBusinessRelation.FindSet(false) then
          repeat
            if Customer.Get(ContactBusinessRelation."No.") then begin
              DoModify := (Customer."Industry Group Code" <> Rec."Industry Group Code");
              DoModify := DoModify or ((Rec."Territory Code" <> '') and (Customer."Territory Code" <> Rec."Territory Code"));

              if DoModify then begin
                Customer."Industry Group Code" := Rec."Industry Group Code";
                Customer."Territory Code" := Rec."Territory Code";
                Customer.Modify(false);
              end;
            end;
          until ContactBusinessRelation.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeInsertEvent', '', false, false)]
    local procedure ItemOnBeforeInsert(var Rec: Record Item;RunTrigger: Boolean)
    begin
        Rec."Price Includes VAT" := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        PmtTerms: Record "Payment Terms";
    begin
        if not (SalesHeader."Document Type" in [SalesHeader."document type"::"Credit Memo", SalesHeader."document type"::"Return Order"]) then
          SalesHeader.TestField("Payment Terms Code");

        SalesHeader."Posting Date" := WorkDate;
        SalesHeader."Document Date" := WorkDate;

        if PmtTerms.Get(SalesHeader."Payment Terms Code") then begin
          if SalesHeader."Document Type" <> SalesHeader."document type"::"Credit Memo" then
            SalesHeader."Pmt. Discount Date" := CalcDate(PmtTerms."Discount Date Calculation", SalesHeader."Document Date");
          SalesHeader."Due Date" := CalcDate(PmtTerms."Due Date Calculation", SalesHeader."Document Date");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure SalesHeaderOnAfterInsert(var Rec: Record "Sales Header";RunTrigger: Boolean)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get;

        if Rec."Payment Terms Code" = '' then begin
          Rec."Payment Terms Code" := SalesReceivablesSetup."Default Payment Terms Code";
          Rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure ItemLedgerEntryOnAfterInsert(var Rec: Record "Item Ledger Entry";RunTrigger: Boolean)
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        with Rec do begin
          case "Document Type" of
            "document type"::"Sales Shipment":
              if SalesShipmentHeader.Get("Document No.") then
                "Cust./Vend. Name" := SalesShipmentHeader."Ship-to Name";
            "document type"::"Sales Invoice":
              if SalesInvoiceHeader.Get("Document No.") then
                "Cust./Vend. Name" := SalesInvoiceHeader."Bill-to Name";
            "document type"::"Sales Return Receipt": ;

            "document type"::"Sales Credit Memo":
              if SalesCrMemoHeader.Get("Document No.") then
                "Cust./Vend. Name" := SalesCrMemoHeader."Bill-to Name";
            "document type"::"Purchase Receipt":
              if PurchRcptHeader.Get("Document No.") then
                "Cust./Vend. Name" := PurchRcptHeader."Buy-from Vendor Name";
            "document type"::"Purchase Invoice":
              if PurchInvHeader.Get("Document No.") then
                "Cust./Vend. Name" := PurchInvHeader."Pay-to Name";
            "document type"::"Purchase Return Shipment": ;

            "document type"::"Purchase Credit Memo":
              if PurchCrMemoHdr.Get("Document No.") then
                "Cust./Vend. Name" := PurchCrMemoHdr."Pay-to Name";
            "document type"::"Transfer Shipment": ;
            "document type"::"Transfer Receipt": ;
            "document type"::"Service Shipment": ;
            "document type"::"Service Invoice": ;
            "document type"::"Service Credit Memo": ;
            "document type"::"Posted Assembly": ;
          end;

          Modify(false);
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Contact Business Relation", 'OnAfterInsertEvent', '', false, false)]
    local procedure ContBusRelOnAfterInsert(var Rec: Record "Contact Business Relation";RunTrigger: Boolean)
    var
        Contact: Record Contact;
    begin
        if Rec."Link to Table" = Rec."link to table"::Customer then
          if Contact.Get(Rec."Contact No.") then begin
            Contact."Territory Code" := 'K';
            Contact.Modify(false);
          end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header";SalesHeader: Record "Sales Header")
    begin
        if SalesInvHeader."Shipment Date" = 0D then
          SalesInvHeader."Shipment Date" := WorkDate;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeCustomerInsert', '', false, false)]
    local procedure ContactOnBeforeCustomerInsert(var Sender: Record Contact;var Cust: Record Customer;CustomerTemplate: Code[10])
    var
        CustTemplate: Record "Customer Template";
        VATREGNO_MANDATORY: label 'Die Debitorvorlage %1 kann nicht verwendet werden, wenn %2 nicht angegeben ist.';
    begin
        if CustTemplate.Get(CustomerTemplate) then
          if CustTemplate."VAT Reg. No. mandatory" then
            if Sender."VAT Registration No." = '' then
              Error(VATREGNO_MANDATORY, CustomerTemplate, Sender.FieldCaption("VAT Registration No."));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure SalesHeaderOnBeforeValidateSellToCust(var Rec: Record "Sales Header";var xRec: Record "Sales Header";CurrFieldNo: Integer)
    var
        Customer: Record Customer;
        IssuedReminderHeader: Record "Issued Reminder Header";
        CUSTOMER_HAS_REMINDERS: label 'Der Debitor hat offene Mahnungen ab Mahnstufe 2 mit einem Gesamtwert von %1 ░ zzgl. Gebühren.';
        CUSTOMER_HAS_REMINDER: label 'Der Debitor hat eine offene Mahnung ab Mahnstufe 2 über %1 ░ zzgl. Gebühren.';
        PaymentTerms: Record "Payment Terms";
        TotalReminderAmount: Decimal;
        CUSTOMER_PAYMENT: label 'Der Debitor hat die Zahlungsform %1.';
    begin
        if Customer.Get(Rec."Sell-to Customer No.") then begin
          Rec."Shipping Avis to Email" := Customer."E-Mail";

          // look for issued reminder (level >= 2)
          IssuedReminderHeader.SetRange("Customer No.", Rec."Sell-to Customer No.");
          IssuedReminderHeader.SetFilter("Reminder Level", '>=%1', 2);
          IssuedReminderHeader.SetFilter("Remaining Amount", '<>%1', 0);

          case true of
            IssuedReminderHeader.FindSet:
              begin
                repeat
                  if IssuedReminderHeader."Reminder Level" = 2 then begin
                    IssuedReminderHeader.CalcFields("Remaining Amount");
                    TotalReminderAmount += IssuedReminderHeader."Remaining Amount";
                  end;
                until IssuedReminderHeader.Next = 0;
                if IssuedReminderHeader.Count > 1 then
                  Message(CUSTOMER_HAS_REMINDERS, TotalReminderAmount)
                else
                  Message(CUSTOMER_HAS_REMINDER, TotalReminderAmount);
              end;
            Customer."Payment Terms Code" in ['VK']:
              if PaymentTerms.Get(Customer."Payment Terms Code") then
              Message(CUSTOMER_PAYMENT, PaymentTerms.Description);
          end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure SalesLineOnAfterValidateNo(var Rec: Record "Sales Line";var xRec: Record "Sales Line";CurrFieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
    begin
        if Rec.Type <> Rec.Type::Item then
          exit;

        if not Item.Get(Rec."No.") then
          exit;

        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if not SalesHeader."Prices Including VAT" then
          exit;

        GLSetup.Get;
        if Item."Price Includes VAT" then
          Rec.Validate("Unit Price", Item."Unit Price")
        else
          if 1 + CalcVAT(Item) <> 0 then
            Rec.Validate("Unit Price", ROUND(Item."Unit Price" / (1 + CalcVAT(Item)),GLSetup."Unit-Amount Rounding Precision"));

        // Rec.MODIFY(FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";SalesShptHdrNo: Code[20];RetRcpHdrNo: Code[20];SalesInvHdrNo: Code[20];SalesCrMemoHdrNo: Code[20])
    var
        SalesParcel: Record "Sales Parcel";
    begin
        // CASE SalesHeader."Document Type" OF
        //  SalesHeader."Document Type"::Order:
        //    SalesParcel.SETRANGE("Document Type", SalesParcel."Document Type"::SalesOrder);
        //  SalesHeader."Document Type"::"Return Order":
        //    SalesParcel.SETRANGE("Document Type", SalesParcel."Document Type"::SalesReturnOrder);
        // END;
        // SalesParcel.SETRANGE("Document No.", SalesHeader."No.");
        // IF SalesParcel.FINDSET(TRUE, TRUE) THEN
        //  REPEAT
        //    IF SalesInvHdrNo <> '' THEN BEGIN
        //      SalesParcel."Document Type" := SalesParcel."Document Type"::PostedSalesInvoice;
        //      SalesParcel."Document No." := SalesInvHdrNo;
        //      SalesParcel.INSERT(TRUE);
        //    END;
        //  UNTIL SalesParcel.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesCrMemo(var Rec: Record "Sales Header";RunTrigger: Boolean)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if Rec."Document Type" <> Rec."document type"::"Credit Memo" then
          exit;

        if Rec."Applies-to Doc. Type" <> Rec."applies-to doc. type"::Invoice then
          exit;

        if not SalesInvoiceHeader.Get(Rec."Applies-to Doc. No.") then
          exit;

        Rec."Payment Terms Code" := SalesInvoiceHeader."Payment Terms Code";
        Rec.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure SalesHeaderOnAfterValidateSellToCustNo(var Rec: Record "Sales Header";var xRec: Record "Sales Header";CurrFieldNo: Integer)
    var
        SalesLine: Record "Sales Line";
        SHOW_CUSTOMERS_SALES: label 'Für den Debitor\ \%1 (%2)\ \existieren bereits %3 Verkaufszeilen.\Möchten Sie diese ansehen?';
        Customer: Record Customer;
    begin
        SalesLine.SetRange("Document Type", SalesLine."document type"::Quote, SalesLine."document type"::Invoice);
        SalesLine.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
        SalesLine.SetRange("Qty. Shipped (Base)", 0);
        if not SalesLine.IsEmpty then
          if Confirm(SHOW_CUSTOMERS_SALES, true, Rec."Sell-to Customer Name", Rec."Sell-to Customer No.", SalesLine.Count) then
            Page.Run(Page::"Sales Lines", SalesLine);

        if Customer.Get(Rec."Sell-to Customer No.") then begin
          Customer.CalcFields(Memo);
          if Customer.Memo.Hasvalue then
            Page.Run(50015, Customer);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeCustomerInsert', '', false, false)]
    local procedure CustomerOnCreateFromContact(var Sender: Record Contact;var Cust: Record Customer;CustomerTemplate: Code[10])
    begin
        Cust."Mobile Phone No." := Sender."Mobile Phone No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure SalesLineOnAfterInsert(var Rec: Record "Sales Line";RunTrigger: Boolean)
    begin
        if RunTrigger and (Rec."No." <> '') then
          AddAttachedItem(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure SalesLineOnAfterModify(var Rec: Record "Sales Line";var xRec: Record "Sales Line";RunTrigger: Boolean)
    begin
        if RunTrigger and ((Rec.Type <> xRec.Type) or (Rec."No." <> xRec."No.") ) then
          AddAttachedItem(Rec);
    end;

    local procedure AddAttachedItem(var Rec: Record "Sales Line")
    var
        Item: Record Item;
        AttachedItem: Record Item;
        SalesLine: Record "Sales Line";
        ADD_LINE_ATTACHED_ITEM: label 'Zu dem gewählten Artikel gehört auch der Artikel %1.\ \Soll eine Zeile mit dem Artikel %1 hinzugefügt werden?';
        NewLineNo: Integer;
    begin
        if Rec."Document Type" = Rec."document type"::"Credit Memo" then
          exit;

        if Rec.Type <> Rec.Type::Item then
          exit;

        if not Item.Get(Rec."No.") then
          exit;

        if Item."Attached Item No." = '' then
          exit;

        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        if SalesLine.FindLast then
          NewLineNo := SalesLine."Line No." + 10000
        else
          NewLineNo := 20000;

        SalesLine.SetRange("Attached to Line No.", Rec."Line No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", Item."Attached Item No.");
        if not SalesLine.IsEmpty then
          exit;

        AttachedItem.Get(Item."Attached Item No.");

        if Confirm(ADD_LINE_ATTACHED_ITEM, true, AttachedItem.Description) then begin
          SalesLine.Reset;
          SalesLine := Rec;
          SalesLine."Line No." := NewLineNo;
          SalesLine.Validate("No.", Item."Attached Item No.");
          SalesLine.Validate("Attached to Line No.", Rec."Line No.");
          SalesLine.Validate(Quantity, Rec.Quantity);
          SalesLine.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeInsertEvent', '', false, false)]
    local procedure ContactOnBeforeInsert(var Rec: Record Contact;RunTrigger: Boolean)
    begin
        Rec."Created at" := Today;
        Rec."Territory Code" := 'I';
        Rec."Salesperson Code" := '0';
    end;

    [EventSubscriber(Objecttype::Page, 36, 'OnNewRecordEvent', '', false, false)]
    local procedure AssemlyBOMOnNewLine(var Rec: Record "BOM Component";BelowxRec: Boolean;var xRec: Record "BOM Component")
    begin
        Rec.Type := Rec.Type::Item;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnBeforeSendEmailToCust', '', false, false)]
    local procedure OnBeforeSendEmailToCust(ReportUsage: Integer;RecordVariant: Variant;DocNo: Code[20];DocName: Text[150];ShowDialog: Boolean;CustNo: Code[20];var Handled: Boolean)
    begin
        isSendingEmail := true
    end;


    procedure resetSendingEmail()
    begin
        isSendingEmail := false
    end;


    procedure SendingEmail(): Boolean
    begin
        exit(isSendingEmail)
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure SalesHeader_OnBeforeInsert(var Rec: Record "Sales Header";RunTrigger: Boolean)
    begin
        if Rec."Document Date" = 0D then
          Rec.Validate("Document Date", WorkDate);

        if Rec."Posting Date" = 0D then
          Rec.Validate("Posting Date", WorkDate);
    end;

    [EventSubscriber(Objecttype::Page, 42, 'OnOpenPageEvent', '', false, false)]
    local procedure SalesOrder_OnOpenPage(var Rec: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Sell-to Customer No.") then begin
          Customer.CalcFields(Memo);
          if Customer.Memo.Hasvalue then
            Page.Run(50015, Customer);
        end;
    end;

    local procedure "+++ NoSeries Synchronization +++"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"No. Series", 'OnAfterInsertEvent', '', false, false)]
    local procedure NoSeriesOnAfterInsert(var Rec: Record "No. Series";RunTrigger: Boolean)
    begin
        if NoSeriesUpdateRunning then
          exit;

        if not Rec."Synchronize between companies" then
          exit;

        NoSeriesOnAfterModify(Rec, Rec, RunTrigger);
    end;

    [EventSubscriber(ObjectType::Table, Database::"No. Series", 'OnAfterModifyEvent', '', false, false)]
    local procedure NoSeriesOnAfterModify(var Rec: Record "No. Series";var xRec: Record "No. Series";RunTrigger: Boolean)
    var
        NoSeriesLine: Record "No. Series Line";
        Company: Record Company;
    begin
        if NoSeriesUpdateRunning then
          exit;

        NoSeriesUpdateRunning := true;

        if xRec."Synchronize between companies" <> Rec."Synchronize between companies" then
          UpdateNoSeries(Rec.Code);

        if Rec."Synchronize between companies" then begin
          Company.SetFilter(Name, '<>%1', COMPANYNAME);
          if Company.FindSet then
            repeat
              NoSeriesLine.ChangeCompany(Company.Name);
              NoSeriesLine.SetRange("Series Code", Rec.Code);
              NoSeriesLine.DeleteAll(false);
            until Company.Next = 0;

          NoSeriesLine.ChangeCompany(COMPANYNAME);
          NoSeriesLine.SetRange("Series Code", Rec.Code);
          if NoSeriesLine.FindSet then
            repeat
              UpdateNoSeriesLine(NoSeriesLine."Series Code", NoSeriesLine."Line No.");
            until NoSeriesLine.Next = 0;
        end;

        NoSeriesUpdateRunning := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"No. Series", 'OnAfterDeleteEvent', '', false, false)]
    local procedure NoSeriesOnAfterDelete(var Rec: Record "No. Series";RunTrigger: Boolean)
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        Company: Record Company;
    begin
        if NoSeriesUpdateRunning then
          exit;

        if not Rec."Synchronize between companies" then
          exit;

        NoSeriesLine.SetRange("Series Code", Rec.Code);
        NoSeriesLine.DeleteAll(true);

        NoSeriesUpdateRunning := true;

        Company.SetFilter(Name, '<>%1', COMPANYNAME);
        if Company.FindSet then
          repeat
            NoSeries.ChangeCompany(Company.Name);
            if NoSeries.Get(Rec.Code) then
              NoSeries.Delete;
          until Company.Next = 0;

        NoSeriesUpdateRunning := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"No. Series Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure NoSeriesLineOnAfterInsert(var Rec: Record "No. Series Line";RunTrigger: Boolean)
    begin
        if NoSeriesUpdateRunning then
          exit;

        NoSeriesLineOnAfterModify(Rec, Rec, true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"No. Series Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure NoSeriesLineOnAfterModify(var Rec: Record "No. Series Line";var xRec: Record "No. Series Line";RunTrigger: Boolean)
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Get(Rec."Series Code");
        if not NoSeries."Synchronize between companies" then
          exit;

        if NoSeriesUpdateRunning then
          exit;

        NoSeriesUpdateRunning := true;

        // UpdateNoSeries(Rec."Series Code");
        UpdateNoSeriesLine(Rec."Series Code", Rec."Line No.");

        NoSeriesUpdateRunning := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"No. Series Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure NoSeriesLineOnAfterDelete(var Rec: Record "No. Series Line";RunTrigger: Boolean)
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        Company: Record Company;
    begin
        if NoSeriesUpdateRunning then
          exit;

        NoSeries.Get(Rec."Series Code");
        if not NoSeries."Synchronize between companies" then
          exit;

        Company.SetFilter(Name, '<>%1', COMPANYNAME);
        if Company.FindSet then
          repeat
            NoSeriesLine.ChangeCompany(Company.Name);
            if NoSeriesLine.Get(Rec."Series Code", Rec."Line No.") then
              NoSeriesLine.Delete;
          until Company.Next = 0;
    end;

    local procedure UpdateNoSeries(SeriesCode: Code[20])
    var
        ThisCompNoSeries: Record "No. Series";
        NoSeries: Record "No. Series";
        Company: Record Company;
    begin
        ThisCompNoSeries.Get(SeriesCode);

        Company.SetFilter(Name, '<>%1', COMPANYNAME);
        if Company.FindSet then
          repeat
            NoSeries.ChangeCompany(Company.Name);
            NoSeries.TransferFields(ThisCompNoSeries);
            if not NoSeries.Insert then
              NoSeries.Modify;
          until Company.Next = 0;
    end;

    local procedure UpdateNoSeriesLine(SeriesCode: Code[20];SeriesLineNo: Integer)
    var
        ThisCompNoSeriesLine: Record "No. Series Line";
        NoSeriesLine: Record "No. Series Line";
        Company: Record Company;
    begin
        ThisCompNoSeriesLine.Get(SeriesCode, SeriesLineNo);

        Company.SetFilter(Name, '<>%1', COMPANYNAME);
        if Company.FindSet then
          repeat
            NoSeriesLine.ChangeCompany(Company.Name);
            NoSeriesLine.TransferFields(ThisCompNoSeriesLine);
            if not NoSeriesLine.Insert then
              NoSeriesLine.Modify;
          until Company.Next = 0;
    end;

    local procedure "+++ Name3 +++"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure SalesHeaderOnValidateSellToCustomerNo(var Rec: Record "Sales Header";var xRec: Record "Sales Header";CurrFieldNo: Integer)
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Sell-to Customer No.") then
          Rec."Sell-to Contact" := Customer."Name 3"
        else
          Clear(Rec."Sell-to Contact");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Bill-to Customer No.', false, false)]
    local procedure SalesHeaderOnValidateBillToCustomerNo(var Rec: Record "Sales Header";var xRec: Record "Sales Header";CurrFieldNo: Integer)
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Bill-to Customer No.") then
          Rec."Bill-to Contact" := Customer."Name 3"
        else
          Clear(Rec."Bill-to Contact");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Ship-to Code', false, false)]
    local procedure SalesHeaderOnValidateShipToCode(var Rec: Record "Sales Header";var xRec: Record "Sales Header";CurrFieldNo: Integer)
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        if ShiptoAddress.Get(Rec."Ship-to Code") then
          Rec."Ship-to Contact" := ShiptoAddress."Name 3"
        else
          Clear(Rec."Ship-to Contact");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure PurchHeaderOnValidateBuyFromVendorNo(var Rec: Record "Purchase Header";var xRec: Record "Purchase Header";CurrFieldNo: Integer)
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(Rec."Buy-from Vendor No.") then
          Rec."Buy-from Contact" := Vendor."Name 3"
        else
          Clear(Rec."Buy-from Contact");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Pay-to Vendor No.', false, false)]
    local procedure PurchHeaderOnValidatePayToVendorNo(var Rec: Record "Purchase Header";var xRec: Record "Purchase Header";CurrFieldNo: Integer)
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(Rec."Pay-to Vendor No.") then
          Rec."Pay-to Contact" := Vendor."Name 3"
        else
          Clear(Rec."Pay-to Contact");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Ship-to Code', false, false)]
    local procedure PurchHeaderOnValidateShipToCode(var Rec: Record "Purchase Header";var xRec: Record "Purchase Header";CurrFieldNo: Integer)
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        if ShiptoAddress.Get(Rec."Ship-to Code") then
          Rec."Ship-to Contact" := ShiptoAddress."Name 3"
        else
          Clear(Rec."Ship-to Contact");
    end;

    local procedure CalcVAT(Item: Record Item): Decimal
    var
        VATPostingSetup: Record "VAT Posting Setup";
        Text006: label 'Prices including VAT cannot be calculated when %1 is %2.';
    begin
        with Item do begin
          if "Price Includes VAT" then begin
            VATPostingSetup.Get("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
            case VATPostingSetup."VAT Calculation Type" of
              VATPostingSetup."vat calculation type"::"Reverse Charge VAT":
                VATPostingSetup."VAT %" := 0;
              VATPostingSetup."vat calculation type"::"Sales Tax":
                Error(
                  Text006,
                  VATPostingSetup.FieldCaption("VAT Calculation Type"),
                  VATPostingSetup."VAT Calculation Type");
            end;
          end else
            Clear(VATPostingSetup);

          exit(VATPostingSetup."VAT %" / 100);
        end;
    end;
}

