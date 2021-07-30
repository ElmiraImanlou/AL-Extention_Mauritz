Report 50003 Shipment
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Shipment.rdlc';
    Caption = 'Shipment';
    // EnableExternalAssemblies = ;
    // PDFFontEmbedding = ;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(OuterCopyLoop; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_50001; 50001)
            {
            }
            column(DocLayoutXML; DocLayoutXML)
            {
            }
            column(Report_OuterLoop; Number)
            {
            }
            column(Report_UseStationery; Format(REQ_UseStationery, 0, '<Number>'))
            {
            }
            column(REPORT_LOGO_PADDING; GetLogoPadding)
            {
            }
            column(Company_Name; CompanyInfo.Name)
            {
            }
            column(Company_Address; CompanyInfo.Address)
            {
            }
            column(Company_City; CompanyInfo.City)
            {
            }
            column(Company_PostCode; CompanyInfo."Post Code")
            {
            }
            column(Company_Picture; CompanyInfo.Picture)
            {
            }
            column(Company_Phone; CompanyInfo."Phone No.")
            {
            }
            column(Company_Fax; CompanyInfo."Fax No.")
            {
            }
            column(Company_EMail; CompanyInfo."E-Mail")
            {
            }
            column(Company_Homepage; CompanyInfo."Home Page")
            {
            }
            column(Company_VATRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(Company_RegistrationNo; CompanyInfo."Registration No.")
            {
            }
            column(Company_LetterWindowAddress; CompanyLetterWindowAddress)
            {
            }
            dataitem(Header; "Sales Shipment Header")
            {
                DataItemTableView = sorting("No.") order(ascending);
                RequestFilterFields = "No.", "Bill-to Customer No.", "Posting Date";
                column(ReportForNavId_50000; 50000)
                {
                }
                column(Header_DocumentNo; Header."No.")
                {
                }
                column(Header_OrderNo; Header."No.")
                {
                }
                column(Header_PricesIncludingVAT; Header."Prices Including VAT")
                {
                }
                column(Header_DocumentDate; WorkDate)
                {
                }
                column(Header_DestinationAddress; DestinationAddress)
                {
                }
                column(Header_PaymentAddress; PaymentAddress)
                {
                }
                column(Header_ShipmentAddress; ShipmentAddress)
                {
                }
                column(Header_YourReference; Header."Your Reference")
                {
                }
                column(Header_Currency; Header."Currency Code")
                {
                }
                column(Header_ShowDiscount; ShowDiscount(Header))
                {
                }
                column(PersonInCharge_Name; PersonInCharge.Name)
                {
                }
                column(PersonInCharge_EMail; PersonInCharge."E-Mail")
                {
                }
                column(PersonInCharge_PhoneNo; PersonInCharge."Phone No.")
                {
                }
                column(PersonInCharge_JobTitle; PersonInCharge."Job Title")
                {
                }
                column(PaymentTerms_Description; PaymentTerms.Description)
                {
                }
                column(ShipmentMethod_Description; ShipmentMethod.Description)
                {
                }
                column(Header_BroadGunParameter; BroadGunParameter)
                {
                }
                column(VATText; VATText)
                {
                }
                column(PrePosInfo_1; PrePosInfo[1])
                {
                }
                column(PrePosInfo_2; PrePosInfo[2])
                {
                }
                column(PrePosInfo_3; PrePosInfo[3])
                {
                }
                column(PrePosInfo_4; PrePosInfo[4])
                {
                }
                column(PrePosInfo_5; PrePosInfo[5])
                {
                }
                column(PrePosInfo_6; PrePosInfo[6])
                {
                }
                column(PrePosInfoCaption_1; PrePosInfoCaption[1])
                {
                }
                column(PrePosInfoCaption_2; PrePosInfoCaption[2])
                {
                }
                column(PrePosInfoCaption_3; PrePosInfoCaption[3])
                {
                }
                column(PrePosInfoCaption_4; PrePosInfoCaption[4])
                {
                }
                column(PrePosInfoCaption_5; PrePosInfoCaption[5])
                {
                }
                column(PrePosInfoCaption_6; PrePosInfoCaption[6])
                {
                }
                column(InfoBoxText_1; InfoBoxText[1])
                {
                }
                column(InfoBoxText_2; InfoBoxText[2])
                {
                }
                column(InfoBoxText_3; InfoBoxText[3])
                {
                }
                column(InfoBoxText_4; InfoBoxText[4])
                {
                }
                column(InfoBoxText_5; InfoBoxText[5])
                {
                }
                column(InfoBoxText_6; InfoBoxText[6])
                {
                }
                column(InfoBoxText_7; InfoBoxText[7])
                {
                }
                column(InfoBoxText_8; InfoBoxText[8])
                {
                }
                column(InfoBoxCaption_1; InfoBoxCaption[1])
                {
                }
                column(InfoBoxCaption_2; InfoBoxCaption[2])
                {
                }
                column(InfoBoxCaption_3; InfoBoxCaption[3])
                {
                }
                column(InfoBoxCaption_4; InfoBoxCaption[4])
                {
                }
                column(InfoBoxCaption_5; InfoBoxCaption[5])
                {
                }
                column(InfoBoxCaption_6; InfoBoxCaption[6])
                {
                }
                column(InfoBoxCaption_7; InfoBoxCaption[7])
                {
                }
                column(InfoBoxCaption_8; InfoBoxCaption[8])
                {
                }
                dataitem(InnerCopyLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) order(ascending);
                    column(ReportForNavId_50002; 50002)
                    {
                    }
                    column(Report_InnerLoop; Number)
                    {
                    }
                    column(CAPTION_PAGE; CAPTION_PAGE)
                    {
                    }
                    column(CAPTION_PAGE_OF; CAPTION_PAGE_OF)
                    {
                    }
                    column(CAPTION_DOCUMENT_NO; GetCurrReportCaption)
                    {
                    }
                    column(CAPTION_DOCUMENT_DATE; CAPTION_DOCUMENT_DATE)
                    {
                    }
                    column(CAPTION_DOCUMENT_FROM; CAPTION_DOCUMENT_FROM)
                    {
                    }
                    column(CAPTION_PHONENO; CAPTION_PHONENO)
                    {
                    }
                    column(CAPTION_FAXNO; CAPTION_FAXNO)
                    {
                    }
                    column(CAPTION_EMAIL; CAPTION_EMAIL)
                    {
                    }
                    column(CAPTION_YOURREFERENCE; CAPTION_YOURREFERENCE)
                    {
                    }
                    column(CAPTION_LINE_NO; CAPTION_LINE_NO)
                    {
                    }
                    column(CAPTION_LINE_DESCR; CAPTION_LINE_DESCR)
                    {
                    }
                    column(CAPTION_LINE_QANTITY; CAPTION_LINE_QANTITY)
                    {
                    }
                    column(CAPTION_LINE_UNITPRICE; CAPTION_LINE_UNITPRICE)
                    {
                    }
                    column(CAPTION_LINE_DISCOUNT; CAPTION_LINE_DISCOUNT)
                    {
                    }
                    column(CAPTION_LINE_AMOUNT; CAPTION_LINE_AMOUNT)
                    {
                    }
                    column(CAPTION_PERSONINCHARGE; CAPTION_PERSONINCHARGE)
                    {
                    }
                    column(CAPTION_CUSTOMER_NO; CAPTION_CUSTOMER_NO)
                    {
                    }
                    column(CAPTION_CUSTOMER_REFERENCE; CAPTION_CUSTOMER_REFERENCE)
                    {
                    }
                    column(CAPTION_TOTAL_NET; CAPTION_TOTAL_NET)
                    {
                    }
                    column(CAPTION_TOTAL_VAT; CAPTION_TOTAL_VAT)
                    {
                    }
                    column(CAPTION_TOTAL; CAPTION_TOTAL)
                    {
                    }
                    column(CAPTION_PAYMENTTERMS; CAPTION_PAYMENTTERMS)
                    {
                    }
                    column(CAPTION_SHIPMENTMETHOD; CAPTION_SHIPMENTMETHOD)
                    {
                    }
                    column(CAPTION_ORDERNO; CAPTION_ORDERNO)
                    {
                    }
                    column(CAPTION_CARRYFORWARD; CAPTION_CARRYFORWARD)
                    {
                    }
                    column(CAPTION_PLUS; CAPTION_PLUS)
                    {
                    }
                    column(CAPTION_VAT; CAPTION_VAT)
                    {
                    }
                    dataitem(Lines; "Sales Shipment Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = Header;
                        DataItemTableView = sorting("Document No.", "Line No.") order(ascending);
                        column(ReportForNavId_50003; 50003)
                        {
                        }
                        column(Lines_LineNo; Lines."Line No.")
                        {
                        }
                        column(Lines_Type; Format(Lines.Type, 0, '<Number>'))
                        {
                        }
                        column(Lines_ItemCategoryCode; Lines."Item Category Code")
                        {
                        }
                        column(Lines_No; Lines."No.")
                        {
                        }
                        column(Lines_VariantCode; Lines."Variant Code")
                        {
                        }
                        column(Lines_Description; GetLineDescription(Lines))
                        {
                        }
                        column(Lines_Description2; '')
                        {
                        }
                        column(Lines_UnitofMeasure; Lines."Unit of Measure")
                        {
                        }
                        column(Lines_Quantity; Lines.Quantity)
                        {
                        }
                        column(Lines_GrossWeight; Lines."Gross Weight")
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            VATPostingSetup: Record "VAT Posting Setup";
                            VATClause: Record "VAT Clause";
                        begin
                            if (Type = Type::" ") and ("Attached to Line No." <> 0) then
                                CurrReport.Skip;

                            if VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                                if VATClause.Get(VATPostingSetup."VAT Clause Code") then
                                    if not TempVATClause.Get(VATPostingSetup."VAT Clause Code") then begin
                                        TempVATClause.Copy(VATClause);
                                        TempVATClause.Insert;

                                        if VATText <> '' then begin
                                            VATText[StrLen(VATText) + 1] := 10;
                                            VATText[StrLen(VATText) + 1] := 10;
                                        end;

                                        VATText += VATClause.Description + VATClause."Description 2";
                                    end;
                        end;

                        trigger OnPostDataItem()
                        begin
                            Clear(DocLayoutXML);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if REQ_SkipZeroLines then
                                SetFilter(Lines.Quantity, '<>%1', 0);
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        if REQ_CopySortOrder = Req_copysortorder::InnerLoop then
                            SetRange(Number, 0, REQ_NumberOfCopies)
                        else
                            SetRange(Number, 0);
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    Language: Record "Windows Language";
                    ThisRecRef: RecordRef;
                    AddressArray: array[8] of Text[50];
                    i: Integer;
                begin
                    "Order Date" := WorkDate;

                    if Language.Get("Language Code") then
                        CurrReport.Language(Language."Language ID")
                    else
                        CurrReport.Language(GlobalLanguage);

                    ThisRecRef.GetTable(Header);
                    if ThisRecRef.Number in [36, 38, 110, 112, 114, 120, 122, 124] then begin
                        Clear(PersonInCharge);
                        if PersonInCharge.Get(ThisRecRef.Field(43)) then;

                        Clear(PaymentTerms);
                        if PaymentTerms.Get(ThisRecRef.Field(23)) then
                            PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");

                        Clear(ShipmentMethod);
                        if ShipmentMethod.Get(ThisRecRef.Field(27)) then
                            ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                    end;

                    // Adresses
                    FormatAddress(AddressArray, Header, 0);
                    if (AddressArray[1] = AddressArray[2]) then
                        Clear(AddressArray[1]);
                    Clear(DestinationAddress);
                    for i := 1 to 8 do
                        if AddressArray[i] <> '' then begin
                            if DestinationAddress <> '' then
                                DestinationAddress[StrLen(DestinationAddress) + 1] := 10;
                            DestinationAddress += AddressArray[i];
                        end;

                    FormatAddress(AddressArray, Header, 1);
                    if (AddressArray[1] = AddressArray[2]) then
                        Clear(AddressArray[1]);
                    Clear(PaymentAddress);
                    for i := 1 to 8 do
                        if AddressArray[i] <> '' then begin
                            if PaymentAddress <> '' then
                                PaymentAddress[StrLen(PaymentAddress) + 1] := 10;
                            PaymentAddress += AddressArray[i];
                        end;

                    FormatAddress(AddressArray, Header, 2);
                    if (AddressArray[1] = AddressArray[2]) then
                        Clear(AddressArray[1]);
                    Clear(ShipmentAddress);
                    for i := 1 to 8 do
                        if AddressArray[i] <> '' then begin
                            if ShipmentAddress <> '' then
                                ShipmentAddress[StrLen(ShipmentAddress) + 1] := 10;
                            ShipmentAddress += AddressArray[i];
                        end;

                    if "Currency Code" = '' then
                        "Currency Code" := GLSetup."LCY Code";
                    if "Currency Code" = 'EUR' then
                        "Currency Code" := '░';

                    TempVATClause.Reset;
                    TempVATClause.DeleteAll;

                    DocLayoutSetup.SetInfoBox(Header, InfoBoxCaption, InfoBoxText);
                    DocLayoutSetup.SetPrePosInfo(Header, PrePosInfoCaption, PrePosInfo);

                    if not CurrReport.Preview then
                        Codeunit.Run(Codeunit::"Sales Shpt.-Printed", Header)
                end;
            }

            trigger OnPreDataItem()
            begin
                if REQ_CopySortOrder = Req_copysortorder::OuterLoop then
                    SetRange(Number, 0, REQ_NumberOfCopies)
                else
                    SetRange(Number, 0);
            end;
        }
    }

    requestpage
    {
        Caption = 'Verkaufsrechnung';
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(REQ_UseStationery; REQ_UseStationery)
                {
                    ApplicationArea = Basic;
                    Caption = 'Briefpapier (Logo usw. nicht drucken)';
                }
                field(REQ_SkipZeroLines; REQ_SkipZeroLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Zeilen ohne Menge weglassen';
                }
                group(Copies)
                {
                    Caption = 'Kopien';
                    field(NumberOfCopies; REQ_NumberOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Anzahl Kopien';
                    }
                    field(CopySortOrder; REQ_CopySortOrder)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sortierung';
                        OptionCaption = ' ,123 123,11 22 33';
                        Visible = SHOW_CopySortOrder;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(Setup)
                {
                    ApplicationArea = Basic;
                    Image = Setup;
                    InFooterBar = true;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if not DocLayoutSetup.Get(GetCurrReportNumber) then
                            if DocLayoutSetup.Get(0) then begin
                                DocLayoutSetup."Report ID" := GetCurrReportNumber;
                                DocLayoutSetup.Insert;
                            end else begin
                                DocLayoutSetup.Init;
                                DocLayoutSetup."Report ID" := GetCurrReportNumber;
                                DocLayoutSetup.Insert;
                            end;

                        Page.RunModal(0, DocLayoutSetup);
                    end;
                }
            }
        }

        trigger OnOpenPage()
        begin
            SHOW_CopySortOrder := Header.GetFilter("No.") = '';
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        InStr: InStream;
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        DocLayoutSetup.SetFilter("Report ID", '%1|%2', 0, GetCurrReportNumber);
        if DocLayoutSetup.FindLast() then
            DocLayoutXML := DocLayoutSetup.GetLayoutPropertiesAsXML();

        CompanyLetterWindowAddress := StrSubstNo('%1 - %2 - %3 %4', CompanyInfo.Name, CompanyInfo.Address, CompanyInfo."Post Code", CompanyInfo.City);
        GLSetup.Get;

        if not CurrReport.UseRequestPage() then
            REQ_UseStationery := false;
    end;

    var
        DocLayoutSetup: Record "Document Layout Setup";
        DocLayoutXML: Text;
        CompanyInfo: Record "Company Information";
        PersonInCharge: Record "Salesperson/Purchaser";
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        GLSetup: Record "General Ledger Setup";
        SelltoCountry: Record "Country/Region";
        BilltoCountry: Record "Country/Region";
        ShipToCountry: Record "Country/Region";
        TempVATClause: Record "VAT Clause" temporary;
        [InDataSet]
        SHOW_CopySortOrder: Boolean;
        REQ_NumberOfCopies: Integer;
        REQ_CopySortOrder: Option " ",OuterLoop,InnerLoop;
        REQ_UseStationery: Boolean;
        REQ_SkipZeroLines: Boolean;
        DestinationAddress: Text;
        CAPTION_PAGE: label 'Page ';
        CAPTION_PAGE_OF: label 'of';
        CAPTION_CARRYFORWARD: label 'Amount brought forward';
        CAPTION_DOCUMENT_NO: label 'Invoice';
        CAPTION_DOCUMENT_DATE: label 'Date';
        CAPTION_DOCUMENT_FROM: label 'by';
        CAPTION_PERSONINCHARGE: label 'Person in Charge';
        CAPTION_CUSTOMER_NO: label 'Customer No.';
        CAPTION_CUSTOMER_REFERENCE: label 'Your Reference';
        CAPTION_PLUS: label 'plus';
        CAPTION_VAT: label 'VAT';
        CAPTION_TOTAL_VAT: label 'VAT Amount';
        CAPTION_TOTAL_NET: label 'Total excl. VAT';
        CAPTION_TOTAL: label 'Total Amount';
        PaymentAddress: Text;
        CAPTION_ORDERNO: label 'Order No.';
        ShipmentAddress: Text;
        CAPTION_PHONENO: label 'Tel.';
        CAPTION_FAXNO: label 'Fax';
        CAPTION_EMAIL: label 'E-Mail';
        CAPTION_YOURREFERENCE: label 'Your Reference';
        CAPTION_PAYMENTTERMS: label 'Payment Terms';
        CAPTION_SHIPMENTMETHOD: label 'Shipment Method';
        CAPTION_LINE_TYPE: label 'Type';
        CAPTION_LINE_NO: label 'No.';
        CAPTION_LINE_DESCR: label 'Description';
        CAPTION_LINE_QANTITY: label 'Quantity';
        CAPTION_LINE_UNITPRICE: label 'Unit Price';
        CAPTION_LINE_DISCOUNT: label 'Discount';
        CAPTION_LINE_AMOUNT: label 'Total';
        CompanyLetterWindowAddress: Text;
        BroadGunParameter: Text;
        FooterText: Text;
        VATText: Text;
        PrePosInfo: array[6] of Text;
        PrePosInfoCaption: array[6] of Text;
        InfoBoxText: array[8] of Text;
        InfoBoxCaption: array[8] of Text;
        CopyPrint: Boolean;

    local procedure GetLogoPadding() LogoPadding: Decimal
    var
        SalesSetup: Record "Sales & Receivables Setup";
        InStr: InStream;
        Logo: dotnet Image;
        LogoXtoYRatio: Decimal;
    begin
        CompanyInfo.CalcFields(Picture);
        if not CompanyInfo.Picture.Hasvalue then
            exit(10);

        CompanyInfo.Picture.CreateInstream(InStr);
        Logo := Logo.FromStream(InStr);

        LogoXtoYRatio := Logo.Width / Logo.Height;

        Logo.Dispose();
        Clear(Logo);

        with SalesSetup do begin
            Get;
            if (LogoXtoYRatio >= 6) then
                if "Logo Position on Documents" <> "logo position on documents"::"No Logo" then
                    exit(0);

            case "Logo Position on Documents" of
                "logo position on documents"::"No Logo":
                    begin
                        Clear(CompanyInfo.Picture);
                        exit(0);
                    end;
                "logo position on documents"::Left:
                    exit(0);
                "logo position on documents"::Center:
                    exit(ROUND((170 - (30 * LogoXtoYRatio)) / 2, 1));
                "logo position on documents"::Right:
                    exit(ROUND(170 - (30 * LogoXtoYRatio), 1));
            end;
        end;
    end;

    local procedure GetFooterLogoPadding() LogoPadding: Decimal
    var
        SalesSetup: Record "Sales & Receivables Setup";
        InStr: InStream;
        Logo: dotnet Image;
        LogoXtoYRatio: Decimal;
    begin
        exit(10);
        // IF NOT Company."Footer Image".HASVALUE THEN
        //  EXIT(0);
        //
        // Company."Footer Image".CREATEINSTREAM(InStr);
        // Logo := Logo.FromStream(InStr);
        //
        // LogoXtoYRatio := Logo.Width / Logo.Height;
        //
        // Logo.Dispose();
        // CLEAR(Logo);
        //
        // WITH SalesSetup DO BEGIN
        //  GET;
        //  IF (LogoXtoYRatio >= 6) THEN
        //    IF "Logo Position on Documents" <> "Logo Position on Documents"::"No Logo" THEN
        //      EXIT(0);
        //
        //  CASE "Logo Position on Documents" OF
        //    "Logo Position on Documents"::"No Logo":
        //      BEGIN
        //        CLEAR(Company.Picture);
        //        EXIT(0);
        //      END;
        //    "Logo Position on Documents"::Left:
        //      EXIT(0);
        //    "Logo Position on Documents"::Center:
        //      EXIT((170 - (30 * LogoXtoYRatio)) / 2);
        //    "Logo Position on Documents"::Right:
        //      EXIT(170 - (30 * LogoXtoYRatio));
        //  END;
        // END;
    end;

    local procedure FormatAddress(var AddressArray: array[8] of Text; Header: Variant; Type: Option SellOrBuy,BillOrPay,Ship)
    var
        RecRef: RecordRef;
        FormatAddress: Codeunit "Format Address";
    begin
        RecRef.GetTable(Header);

        case RecRef.Number of
            36:
                case Type of
                    0:
                        FormatAddress.SalesHeaderSellTo(AddressArray, Header);
                    1:
                        FormatAddress.SalesHeaderBillTo(AddressArray, Header);
                    2:
                        FormatAddress.SalesHeaderShipTo(AddressArray, AddressArray, Header);
                end;
            38:
                case Type of
                    0:
                        FormatAddress.PurchHeaderBuyFrom(AddressArray, Header);
                    1:
                        FormatAddress.PurchHeaderPayTo(AddressArray, Header);
                    2:
                        FormatAddress.PurchHeaderShipTo(AddressArray, Header);
                end;
            110:
                case Type of
                    0:
                        FormatAddress.SalesShptSellTo(AddressArray, Header);
                    1:
                        FormatAddress.SalesShptBillTo(AddressArray, AddressArray, Header);
                    2:
                        FormatAddress.SalesShptShipTo(AddressArray, Header);
                end;
            112:
                case Type of
                    0:
                        FormatAddress.SalesInvSellTo(AddressArray, Header);
                    1:
                        FormatAddress.SalesInvBillTo(AddressArray, Header);
                    2:
                        FormatAddress.SalesInvShipTo(AddressArray, AddressArray, Header);
                end;
            114:
                case Type of
                    0:
                        FormatAddress.SalesCrMemoSellTo(AddressArray, Header);
                    1:
                        FormatAddress.SalesCrMemoBillTo(AddressArray, Header);
                    2:
                        FormatAddress.SalesCrMemoShipTo(AddressArray, AddressArray, Header);
                end;
            120:
                case Type of
                    0:
                        FormatAddress.PurchShptBuyFrom(AddressArray, Header);
                    1:
                        FormatAddress.PurchShptPayTo(AddressArray, Header);
                    2:
                        FormatAddress.PurchShptShipTo(AddressArray, Header);
                end;
            122:
                case Type of
                    0:
                        FormatAddress.PurchInvBuyFrom(AddressArray, Header);
                    1:
                        FormatAddress.PurchInvPayTo(AddressArray, Header);
                    2:
                        FormatAddress.PurchInvShipTo(AddressArray, Header);
                end;
            124:
                case Type of
                    0:
                        FormatAddress.PurchCrMemoBuyFrom(AddressArray, Header);
                    1:
                        FormatAddress.PurchCrMemoPayTo(AddressArray, Header);
                    2:
                        FormatAddress.PurchCrMemoShipTo(AddressArray, Header);
                end;
        end;

        RecRef.Close;
    end;

    local procedure ShowDiscount(Header: Variant) ShowDisc: Boolean
    var
        RecRefHeader: RecordRef;
        RecRefLine: RecordRef;
        FieldRefHeader: FieldRef;
        FieldRefLine: FieldRef;
    begin
        RecRefHeader.GetTable(Header);
        RecRefLine.Open(RecRefHeader.Number + 1);

        if RecRefHeader.Number in [36, 38] then begin
            FieldRefLine := RecRefLine.Field(1);
            FieldRefLine.SetRange(RecRefHeader.Field(1));
        end;

        if RecRefHeader.Number in [36, 38, 110, 112, 114, 120, 122, 124] then begin
            FieldRefLine := RecRefLine.Field(3);
            FieldRefLine.SetRange(RecRefHeader.Field(3));

            FieldRefLine := RecRefLine.Field(27);
            FieldRefLine.SetFilter('<>%1', 0);
            ShowDisc := not RecRefLine.IsEmpty;
        end;

        if RecRefHeader.Number in [36, 38, 112, 114, 122, 124] then begin
            FieldRefLine := RecRefLine.Field(28);
            FieldRefLine.SetFilter('<>%1', 0);
            ShowDisc := ShowDisc or (not RecRefLine.IsEmpty);
        end;

        RecRefHeader.Close;
        RecRefLine.Close;
    end;

    local procedure GetCurrReportCaption() ObjectCaption: Text
    var
        "Object": Record "Object";
        CurrReportID: Integer;
    begin
        Evaluate(CurrReportID, CopyStr(CurrReport.ObjectId(false), 8));
        Object.Get(Objecttype::Report, '', CurrReportID);
        Object.CalcFields(Caption);
        exit(Object.Caption);
    end;

    local procedure GetCurrReportNumber() ObjectNumber: Integer
    begin
        Evaluate(ObjectNumber, CopyStr(CurrReport.ObjectId(false), 8));
    end;

    local procedure GetLineDescription(Line: Variant) Description: Text
    var
        ThisLineRef: RecordRef;
        ThisLineFieldRef: FieldRef;
        AttachedLineRef: RecordRef;
        AttachedLineFieldRef: FieldRef;
        Description1: Text;
        Description2: Text;
        LineBreak: Text[2];
    begin
        if Line.IsRecordRef then
            ThisLineRef := Line;

        if Line.IsRecord then
            ThisLineRef.GetTable(Line);

        if Line.IsRecordId then
            ThisLineRef.Get(Line);

        LineBreak[1] := 10;

        Description1 := DelChr(Format(ThisLineRef.Field(11).Value), '<>', ' ');
        Description2 := DelChr(Format(ThisLineRef.Field(12).Value), '<>', ' ');
        if Description2 <> '' then
            Description := StrSubstNo('%1 %2', Description1, Description2)
        else
            Description := Description1;

        AttachedLineRef.Open(ThisLineRef.Number);

        if ThisLineRef.Number in [37, 39] then begin
            ThisLineFieldRef := ThisLineRef.Field(1);
            AttachedLineFieldRef := AttachedLineRef.Field(1);
            AttachedLineFieldRef.SetRange(ThisLineFieldRef.Value);
        end;

        ThisLineFieldRef := ThisLineRef.Field(3);
        AttachedLineFieldRef := AttachedLineRef.Field(3);
        AttachedLineFieldRef.SetRange(ThisLineFieldRef.Value);

        ThisLineFieldRef := ThisLineRef.Field(4);
        AttachedLineFieldRef := AttachedLineRef.Field(80);
        AttachedLineFieldRef.SetRange(ThisLineFieldRef.Value);

        AttachedLineFieldRef := AttachedLineRef.Field(5);
        AttachedLineFieldRef.SetRange(0);

        if AttachedLineRef.FindSet then
            repeat
                Description1 := DelChr(Format(AttachedLineRef.Field(11).Value), '<>', ' ');
                Description2 := DelChr(Format(AttachedLineRef.Field(12).Value), '<>', ' ');
                case true of
                    (Description1 = '') and (Description2 = ''):
                        Description := StrSubstNo('%1%2%2', Description, LineBreak);
                    Description2 = '':
                        Description := StrSubstNo('%1 %2', Description, Description1);
                    else
                        Description := StrSubstNo('%1 %2 %3', Description, Description1, Description2);
                end;
            until AttachedLineRef.Next = 0;
    end;


    procedure SetCopyDoc(NoOfCopies: Integer; Loop: Option " ",OuterLoop,InnerLoop)
    begin
        CopyPrint := true;
        REQ_NumberOfCopies := NoOfCopies - 1;
        REQ_CopySortOrder := Loop;
        if REQ_CopySortOrder = Req_copysortorder::" " then
            REQ_CopySortOrder := Req_copysortorder::InnerLoop;
    end;

    local procedure PrintCopies() PrintedCopies: Integer
    var
        ThisReport: Report Shipment;
        PrinterSelection: Record "Printer Selection";
        RecRef: RecordRef;
    begin
        if REQ_NumberOfCopies = 0 then
            exit(0);
        if CopyPrint then
            exit(0);

        PrinterSelection.SetFilter("User ID", '%1|%2', UserId, '');
        PrinterSelection.SetRange("Report ID", GetCurrReportNumber);
        if not PrinterSelection.FindLast then begin
            PrinterSelection.SetRange("Report ID", 0);
            if PrinterSelection.FindLast then;
        end;

        if PrinterSelection."Copy Printer Name" in [PrinterSelection."Printer Name", ''] then
            exit(0);

        PrintedCopies := REQ_NumberOfCopies;
        ThisReport.SetTableview(Header);
        ThisReport.SetCopyDoc(PrintedCopies, REQ_CopySortOrder);
        ThisReport.UseRequestPage(false);
        RecRef.GetTable(Header);
        ThisReport.Print('', PrinterSelection."Copy Printer Name", RecRef);
        // ThisReport.RUN;
    end;
}

