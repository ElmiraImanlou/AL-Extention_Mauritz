Report 50087 "Create XML-File VAT Adv.N.Aff."
{
    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // TAX  01.11.08   Balance and Taxes
    //                 - Object created
    // -----------------------------------------------------

    Caption = 'Create XML-File VAT Adv.Notif.';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales VAT Advance Notification"; "Sales VAT Advance Notification")
        {
            DataItemTableView = sorting("No.") order(ascending);
            column(ReportForNavId_2265; 2265)
            {
            }

            trigger OnAfterGetRecord()
            var
                PeriodSelection: Option "Before and Within Period","Within Period";
                Continued: Decimal;
                TotalLine1: Decimal;
                TotalLine2: Decimal;
                TotalLine3: Decimal;
                VATNo: Text[30];
                PosTaxOffice: Integer;
                NumberTaxOffice: Integer;
                PosArea: Integer;
                NumberArea: Integer;
                PosDistinction: Integer;
                NumberDistinction: Integer;
            begin
                if "XML-File Creation Date" <> 0D then
                    Error(Text1140006, TableCaption);
                TestField("Contact for Tax Office");
                Window.Update(1, Text1140000);
                VATStmtName.SetRange(Affiliation, true);
                VATStmtName.FindFirst;
                CheckDate("Starting Date");
                VATNo := CheckVATNo(PosTaxOffice, NumberTaxOffice, PosArea, NumberArea, PosDistinction, NumberDistinction);
                if "Incl. VAT Entries (Period)" = "incl. vat entries (period)"::"Before and Within Period" then
                    PeriodSelection := Periodselection::"Before and Within Period"
                else
                    PeriodSelection := Periodselection::"Within Period";
                SetCalcParameters("Starting Date", CalcEndDate("Starting Date"),
                  "Incl. VAT Entries (Closing)", PeriodSelection,
                  "Amounts in Add. Rep. Currency");
                CalcTaxFiguresAff(VATStmtName, TaxAmount, TaxBase, TaxUnrealizedAmount, TaxUnrealizedBase,
                  Continued, TotalLine1, TotalLine2, TotalLine3, CompanyTemp);
                Window.Update(1, Text1140001);

                CheckTaxPairs;

                CreateXMLSubDoc;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Commit;
                case SubsequentAction of
                    Subsequentaction::"create and show":
                        Export;
                    Subsequentaction::"create and transmit":
                        Codeunit.Run(Codeunit::Codeunit11001, "Sales VAT Advance Notification");
                    Subsequentaction::"Only create":
                        Message(Text1140005, TableCaption);
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('#1########');

                FillCompanyTemp;
            end;
        }
    }

    requestpage
    {
        Caption = 'Create XML-File VAT Adv.N.Aff.';

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(XMLFile; SubsequentAction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'XML-File';
                        OptionCaption = 'Create,Create and show,Create and transmit';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text1140000: label 'Calculating Tax Amounts';
        Text1140001: label 'Creating Sales VAT Adv. Notif.';
        Text1140002: label 'The XML Document has not been not created.';
        Text1140003: label 'The %1 must consist of 4 digits.';
        Text1140004: label 'Key figure %1 must not be negative.';
        Text1140005: label 'The XML-File for the %1 has been created successfully.';
        Text1140006: label 'The XML-File for the %1 already exists.';
        Text1140024: label 'The length of the field %1 of table %2 exceeds the maximum length of %3 allowed. The text will be truncated from\\%4 to\%5.\\Do you want to continue?';
        Text1140025: label 'Please make sure that as well category %1 and %2 are defined in %3 %4.';
        VATStmtName: Record "VAT Statement Name";
        CompanyInfo: Record "Company Information";
        Country: Record "Country/Region";
        ElectronicVATDeclSetup: Record "Electronic VAT Decl. Setup";
        ApplicationMgt: Codeunit ApplicationManagement;
        XMLDOMMgt: Codeunit "XML DOM Management";
        Window: Dialog;
        SubsequentAction: Option "Only create","create and show","create and transmit";
        TaxAmount: array[100] of Decimal;
        TaxBase: array[100] of Decimal;
        TaxUnrealizedAmount: array[100] of Decimal;
        TaxUnrealizedBase: array[100] of Decimal;
        xmlNameSpace: Text[250];
        DatenLieferantTransferHeader: Text[256];
        DatenLieferantNutzdatenHeader: Text[256];
        Version: Text[250];
        DateText: Text[30];
        ElsterVATNo: Text[30];
        ContactForTaxOffice: Text[30];
        AdditionalInformation: Text[250];
        ManufacturerID: Code[10];
        UseAuthentication: Boolean;
        Company: Record Company;
        CompanyTemp: Record Company temporary;
        OPplusAnalysisSetup: Record UnknownRecord5157882;
        OPplusAnalysisSetup2: Record UnknownRecord5157882;

    local procedure CreateXMLSubDoc()
    var
        XMLSubDoc: dotnet XmlDocument;
        XMLNodeCurr: dotnet XmlNode;
    begin
        PrepareXMLDoc;

        if IsNull(XMLSubDoc) then
            XMLSubDoc := XMLSubDoc.XmlDocument;

        XMLSubDoc.LoadXml('<?xml version="1.0" encoding="UTF-8"?>' +
          '<Elster xmlns="' + xmlNameSpace + '"></Elster>');

        if IsNull(XMLSubDoc) then
            Error(Text1140002);
        XMLNodeCurr := XMLSubDoc.DocumentElement;

        AddTransferHeader(XMLNodeCurr);
        AddUseDataHeader(XMLNodeCurr);
        AddUseData(XMLNodeCurr);

        UpdateSalesVATAdvNotif(XMLSubDoc);
        Clear(XMLSubDoc);
    end;

    local procedure AddAddressText(Type: Integer; TextToAdd: Text[80])
    begin
        case Type of
            1:
                begin                     // TransferHeader
                    if StrLen(DatenLieferantTransferHeader) + StrLen(TextToAdd) >= 253 then
                        exit;
                    DatenLieferantTransferHeader :=
                      CopyStr(DatenLieferantTransferHeader + TextToAdd, 1, MaxStrLen(DatenLieferantTransferHeader));
                end;
            2:
                begin                     // NutzdatenHeader
                    if StrLen(DatenLieferantNutzdatenHeader) + StrLen(TextToAdd) >= 253 then
                        exit;
                    DatenLieferantNutzdatenHeader :=
                      CopyStr(DatenLieferantNutzdatenHeader + TextToAdd, 1, MaxStrLen(DatenLieferantNutzdatenHeader));
                end;
        end;
    end;

    local procedure UpdateSalesVATAdvNotif(XMLSubDoc: dotnet XmlDocument)
    var
        XMLSubDocOutStream: OutStream;
    begin
        with "Sales VAT Advance Notification" do begin
            "XML Submission Document".CreateOutstream(XMLSubDocOutStream);
            XMLSubDoc.Save(XMLSubDocOutStream);
            CalcFields("XML Submission Document");
            if "XML Submission Document".Hasvalue then begin
                "XML-File Creation Date" := Today;
                "Statement Template Name" := VATStmtName."Statement Template Name";
                "Statement Name" := VATStmtName.Name;
                Modify;
            end;
        end;
    end;

    local procedure PrepareXMLDoc()
    begin
        CompanyInfo.Get;
        CompanyInfo.TestField("VAT Representative");
        if CompanyInfo."Country/Region Code" <> '' then
            Country.Get(CompanyInfo."Country/Region Code");

        UseAuthentication := false;
        if ElectronicVATDeclSetup.Get then
            UseAuthentication := ElectronicVATDeclSetup."Use Authentication";
        ContactForTaxOffice := "Sales VAT Advance Notification"."Contact for Tax Office";
        AdditionalInformation := "Sales VAT Advance Notification"."Additional Information";

        CheckAddressData(5, CompanyInfo."VAT Representative", 45);
        CheckAddressData(6, ContactForTaxOffice, 30);
        if CompanyInfo.Address <> '' then
            CheckAddressData(1, CompanyInfo.Address, 30)
        else
            CheckAddressData(2, CompanyInfo."Address 2", 30);
        CheckAddressData(3, CompanyInfo."Post Code", 12);
        CheckAddressData(4, CompanyInfo.City, 30);
        CheckAddressData(7, AdditionalInformation, 250);

        if UseAuthentication then
            AddAddressText(1, 'ElsterOnline-Portal: ' + CompanyInfo."VAT Representative" + '; ')
        else
            AddAddressText(1, CompanyInfo."VAT Representative" + '; ');
        AddAddressText(1, CompanyInfo.Address + '; ');
        AddAddressText(1, '; ');
        AddAddressText(1, '; ');
        AddAddressText(1, CompanyInfo."Address 2" + '; ');
        AddAddressText(1, CompanyInfo."Post Code" + '; ');
        AddAddressText(1, CompanyInfo.City + '; ');
        AddAddressText(1, Country.Name + '; ');
        AddAddressText(1, CompanyInfo."Phone No." + '; ');
        AddAddressText(1, CompanyInfo."E-Mail");

        AddAddressText(2, ContactForTaxOffice + '; ');
        AddAddressText(2, CompanyInfo.Address + '; ');
        AddAddressText(2, '; ');
        AddAddressText(2, '; ');
        AddAddressText(2, CompanyInfo."Address 2" + '; ');
        AddAddressText(2, CompanyInfo."Post Code" + '; ');
        AddAddressText(2, CompanyInfo.City + '; ');
        AddAddressText(2, Country.Name + '; ');
        AddAddressText(2, "Sales VAT Advance Notification"."Contact Phone No." + '; ');
        AddAddressText(2, "Sales VAT Advance Notification"."Contact E-Mail");

        // xmlNameSpace := 'http://www.elster.de/2002/XMLSchema';
        xmlNameSpace := 'http://www.elster.de/elsterxml/schema/v11';

        Version := 'Navision ' + ApplicationMgt.ApplicationVersion + ' Build # ' + ApplicationMgt.ApplicationBuild;

        if "Sales VAT Advance Notification".Period = "Sales VAT Advance Notification".Period::Month then
            DateText := Format("Sales VAT Advance Notification"."Starting Date", 0, '<month,2>')
        else
            DateText := '4' + Format(((Date2dmy("Sales VAT Advance Notification"."Starting Date", 2) + 2) / 3));

        if StrLen(CompanyInfo."Tax Office Number") <> 4 then
            Error(Text1140003, CompanyInfo.FieldCaption("Tax Office Number"));
        ElsterVATNo := DelChr(CompanyInfo."Registration No.");
        ElsterVATNo := DelChr(ElsterVATNo, '=', '/');
        ElsterVATNo := CompanyInfo."Tax Office Number" + '0' + CopyStr(ElsterVATNo, StrLen(ElsterVATNo) - 7);
        ManufacturerID := '20784';
    end;

    local procedure AddTransferHeader(var XMLNodeCurr: dotnet XmlNode)
    var
        XMLNewNode: dotnet XmlNode;
    begin
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'TransferHeader', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;

        XMLNodeCurr := XMLNewNode;

        if XMLDOMMgt.AddAttribute(XMLNodeCurr, 'version', '11') > 0 then
            exit;

        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Verfahren', 'ElsterAnmeldung', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'DatenArt', 'UStVA', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if UseAuthentication then begin
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Vorgang', 'send-Auth', xmlNameSpace, XMLNewNode) > 0 then
                exit;
        end else begin
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Vorgang', 'send-NoSig', xmlNameSpace, XMLNewNode) > 0 then
                exit;
        end;
        if "Sales VAT Advance Notification".Testversion then
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Testmerker', '700000004', xmlNameSpace, XMLNewNode) > 0 then
                exit;
        // END ELSE
        //  IF XMLDOMMgt.AddElement(XMLNodeCurr,'Testmerker','000000000',xmlNameSpace,XMLNewNode) > 0 THEN
        //    EXIT;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'HerstellerID', ManufacturerID, xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'DatenLieferant', DatenLieferantTransferHeader, xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Datei', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Verschluesselung', 'CMSEncryptedData', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Kompression', 'GZIP', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'TransportSchluessel', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        if XMLDOMMgt.AddElement(XMLNodeCurr, 'VersionClient', 'MS Dynamics NAV', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if "Sales VAT Advance Notification"."Additional Information" <> '' then begin
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Zusatz', '', xmlNameSpace, XMLNewNode) > 0 then
                exit;
            if XMLDOMMgt.AddElement(
               XMLNewNode, 'Info', AdditionalInformation, xmlNameSpace, XMLNewNode) > 0
            then
                exit;
        end;

        XMLNodeCurr := XMLNodeCurr.ParentNode;
    end;

    local procedure AddUseDataHeader(var XMLNodeCurr: dotnet XmlNode)
    var
        XMLNewNode: dotnet XmlNode;
    begin
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'DatenTeil', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Nutzdatenblock', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'NutzdatenHeader', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        if XMLDOMMgt.AddAttribute(XMLNodeCurr, 'version', '11') > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'NutzdatenTicket', "Sales VAT Advance Notification"."No.", xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Empfaenger', CompanyInfo."Tax Office Number", xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddAttribute(XMLNewNode, 'id', 'F') > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Hersteller', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'ProduktName', 'Microsoft Business Solutions-Navision', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'ProduktVersion', ApplicationMgt.ApplicationVersion, xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'DatenLieferant', DatenLieferantNutzdatenHeader, xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if "Sales VAT Advance Notification"."Additional Information" <> '' then begin
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Zusatz', '', xmlNameSpace, XMLNewNode) > 0 then
                exit;
            if XMLDOMMgt.AddElement(
               XMLNewNode, 'Info', AdditionalInformation, xmlNameSpace, XMLNewNode) > 0
            then
                exit;
        end;
        XMLNodeCurr := XMLNodeCurr.ParentNode;
    end;

    local procedure AddUseData(var XMLNodeCurr: dotnet XmlNode)
    var
        XMLNewNode: dotnet XmlNode;
        i: Integer;
        AmtToUse: Decimal;
        TaxAmtText: Text[30];
        NotificationVersion: Text[2];
    begin
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Nutzdaten', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        xmlNameSpace := 'http://finkonsens.de/elster/elsteranmeldung/ustva/v2021';
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Anmeldungssteuern', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Erstellungsdatum', Format(Today, 0, '<year4><month,2><day,2>'), xmlNameSpace, XMLNewNode) >
           0
        then
            exit;
        // IF XMLDOMMgt.AddAttribute(XMLNodeCurr,'art','UStVA') > 0 THEN
        //  EXIT;
        if ("Sales VAT Advance Notification"."Starting Date" >= 20110701D) and
           ("Sales VAT Advance Notification"."Starting Date" <= 20111231D)
        then
            NotificationVersion := '02'
        else
            NotificationVersion := '01';
        // IF XMLDOMMgt.AddAttribute(XMLNodeCurr,'version',
        //     FORMAT(DATE2DMY("Sales VAT Advance Notification"."Starting Date",3)) + NotificationVersion) > 0
        if XMLDOMMgt.AddAttribute(XMLNodeCurr, 'version',
             Format(Date2dmy("Sales VAT Advance Notification"."Starting Date", 3))) > 0
        then
            exit;

        if XMLDOMMgt.AddElement(XMLNodeCurr, 'DatenLieferant', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Name', ContactForTaxOffice, xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if CompanyInfo.Address <> '' then begin
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Strasse', CompanyInfo.Address, xmlNameSpace, XMLNewNode) > 0 then
                exit;
        end else begin
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Strasse', CompanyInfo."Address 2", xmlNameSpace, XMLNewNode) > 0 then
                exit;
        end;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'PLZ', CompanyInfo."Post Code", xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Ort', CompanyInfo.City, xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Steuerfall', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Umsatzsteuervoranmeldung', '', xmlNameSpace, XMLNewNode) > 0 then
            exit;
        XMLNodeCurr := XMLNewNode;
        if XMLDOMMgt.AddElement(
           XMLNodeCurr, 'Jahr', Format(Date2dmy("Sales VAT Advance Notification"."Starting Date", 3)), xmlNameSpace, XMLNewNode) > 0
        then
            exit;

        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Zeitraum', DateText, xmlNameSpace, XMLNewNode) > 0 then
            exit;

        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Steuernummer', ElsterVATNo, xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if XMLDOMMgt.AddElement(XMLNodeCurr, 'Kz09', ManufacturerID, xmlNameSpace, XMLNewNode) > 0 then
            exit;
        if "Sales VAT Advance Notification"."Corrected Notification" then
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Kz10', '1', xmlNameSpace, XMLNewNode) > 0 then
                exit;
        if "Sales VAT Advance Notification"."Documents Submitted Separately" then
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Kz22', '1', xmlNameSpace, XMLNewNode) > 0 then
                exit;
        if "Sales VAT Advance Notification"."Cancel Order for Direct Debit" then
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Kz26', '1', xmlNameSpace, XMLNewNode) > 0 then
                exit;
        if "Sales VAT Advance Notification"."Offset Amount of Refund" then
            if XMLDOMMgt.AddElement(XMLNodeCurr, 'Kz29', '1', xmlNameSpace, XMLNewNode) > 0 then
                exit;
        if TaxAmount[39] < 0 then
            Error(Text1140004, Format(39));
        for i := 21 to 100 do begin
            TaxAmtText := '';
            case i of
                21, 35, 41, 42, 43, 44, 45, 46, 48, 49, 51, 52, 54, 55, 57, 60, 68, 73, 76, 77, 78, 81, 84, 86, 89, 91, 93, 94, 95, 97:
                    AmtToUse := TaxBase[i];
                else
                    AmtToUse := TaxAmount[i];
            end;
            if (AmtToUse <> 0) or
               (i = 83)
            then begin
                case i of
                    21, 35, 41, 42, 43, 44, 45, 46, 48, 49, 51, 52, 57, 60, 68, 73, 76, 77, 78, 81, 84, 86, 89, 91, 93, 94, 95, 97:
                        TaxAmtText := Format(AmtToUse, 0, '<Sign><Integer>');
                    36, 39, 47, 53, 54, 55, 58, 59, 61, 62, 63, 64, 65, 66, 67, 69, 74, 79, 80, 83, 85, 96, 98:
                        TaxAmtText := Format(AmtToUse, 0, '<precision,2:2><Sign><Integer><Decimals><comma,.>');
                end;
                if TaxAmtText <> '' then
                    if XMLDOMMgt.AddElement(XMLNodeCurr, 'Kz' + Format(i), TaxAmtText, xmlNameSpace, XMLNewNode) > 0 then
                        exit;
            end;
        end;
    end;

    local procedure CheckAddressData(FieldID: Integer; TextToCheck: Text[250]; MaxLength: Integer)
    var
        TruncatedText: Text[50];
    begin
        case FieldID of
            1:
                begin
                    CompanyInfo.Address := ConvertSpecialChars(CompanyInfo.Address, MaxStrLen(CompanyInfo.Address));
                    TextToCheck := CompanyInfo.Address;
                end;
            2:
                begin
                    CompanyInfo."Address 2" := ConvertSpecialChars(CompanyInfo."Address 2", MaxStrLen(CompanyInfo."Address 2"));
                    TextToCheck := CompanyInfo."Address 2";
                end;
            4:
                begin
                    CompanyInfo.City := ConvertSpecialChars(CompanyInfo.City, MaxStrLen(CompanyInfo.City));
                    TextToCheck := CompanyInfo.City;
                end;
            6:
                begin
                    ContactForTaxOffice := ConvertSpecialChars(ContactForTaxOffice, MaxStrLen(ContactForTaxOffice));
                    Clear(TextToCheck);
                end;
            7:
                begin
                    AdditionalInformation := ConvertSpecialChars(AdditionalInformation, MaxStrLen(AdditionalInformation));
                    TextToCheck := AdditionalInformation;
                end;
        end;
        Clear(TruncatedText);
        if StrLen(TextToCheck) > MaxLength then
            case FieldID of
                1:
                    begin
                        TruncatedText := PadStr(CompanyInfo.Address, MaxLength);
                        if not Confirm(Text1140024, true, CompanyInfo.FieldCaption(Address),
                             CompanyInfo.TableCaption, MaxLength,
                             CompanyInfo.Address,
                             TruncatedText)
                        then
                            Error('');

                        CompanyInfo.Address := TruncatedText;
                    end;
                2:
                    begin
                        TruncatedText := PadStr(CompanyInfo."Address 2", MaxLength);
                        if not Confirm(Text1140024, true, CompanyInfo.FieldCaption("Address 2"),
                             CompanyInfo.TableCaption, MaxLength,
                             CompanyInfo."Address 2",
                             TruncatedText)
                        then
                            Error('');

                        CompanyInfo."Address 2" := TruncatedText;
                    end;
                3:
                    begin
                        TruncatedText := PadStr(CompanyInfo."Post Code", MaxLength);
                        if not Confirm(Text1140024, true, CompanyInfo.FieldCaption("Post Code"),
                             CompanyInfo.TableCaption, MaxLength,
                             CompanyInfo."Post Code",
                             TruncatedText)
                        then
                            Error('');

                        CompanyInfo."Post Code" := TruncatedText;
                    end;
                4:
                    begin
                        TruncatedText := PadStr(CompanyInfo.City, MaxLength);
                        if not Confirm(Text1140024, true, CompanyInfo.FieldCaption(City),
                             CompanyInfo.TableCaption, MaxLength,
                             CompanyInfo.City,
                             TruncatedText)
                        then
                            Error('');

                        CompanyInfo.City := TruncatedText;
                    end;
            end;
    end;


    procedure CheckTaxPairs()
    var
        TaxError: Boolean;
        TaxPair: array[9, 2] of Integer;
        loop: Integer;
    begin
        Clear(TaxError);
        Clear(TaxPair);

        TaxPair[1] [1] := 35;
        TaxPair[1] [2] := 36;
        TaxPair[2] [1] := 76;
        TaxPair[2] [2] := 80;
        TaxPair[3] [1] := 95;
        TaxPair[3] [2] := 98;
        TaxPair[4] [1] := 94;
        TaxPair[4] [2] := 96;
        TaxPair[5] [1] := 52;
        TaxPair[5] [2] := 53;
        TaxPair[6] [1] := 73;
        TaxPair[6] [2] := 74;
        TaxPair[7] [1] := 84;
        TaxPair[7] [2] := 85;
        TaxPair[8] [1] := 46;
        TaxPair[8] [2] := 47;
        TaxPair[9] [1] := 78;
        TaxPair[9] [2] := 79;

        loop := 1;
        while (not TaxError) and (loop <= ArrayLen(TaxPair, 1)) do begin
            if not TaxError then
                if TaxBase[TaxPair[loop] [1]] <> 0 then
                    TaxError := TaxAmount[TaxPair[loop] [2]] = 0;
            loop += 1;
        end;
        if TaxError then
            Error(Text1140025, TaxPair[loop - 1] [1], TaxPair[loop - 1] [2], VATStmtName.TableCaption, VATStmtName.Name);
    end;

    local procedure ConvertSpecialChars(Text: Text[250]; MaxLen: Integer): Text[250]
    var
        SpecialCharPos: Integer;
        loop: Integer;
        SpecialChars: Text[20];
        ConvertedChars: Text[20];
    begin
        SpecialChars := 'ÄäÖöÜüß';
        ConvertedChars := 'AeaeOeoeUeuess';
        for loop := 1 to 7 do begin
            while StrPos(Text, CopyStr(SpecialChars, loop, 1)) <> 0 do begin
                SpecialCharPos := StrPos(Text, CopyStr(SpecialChars, loop, 1));
                if StrLen(Text) = MaxLen then
                    Text := PadStr(Text, MaxLen - 1);
                Text := DelStr(Text, SpecialCharPos, 1);
                Text := InsStr(Text, CopyStr(ConvertedChars, loop * 2 - 1, 2), SpecialCharPos);
            end;
        end;
        exit(Text);
    end;


    procedure FillCompanyTemp()
    begin
        OPplusAnalysisSetup.Get;
        if OPplusAnalysisSetup.Affiliation <> '' then begin
            if Company.FindSet(false) then
                repeat
                    OPplusAnalysisSetup2.ChangeCompany(Company.Name);
                    if OPplusAnalysisSetup2.Get then
                        if OPplusAnalysisSetup2.Affiliation = OPplusAnalysisSetup.Affiliation then begin
                            CompanyTemp := Company;
                            CompanyTemp.Insert;
                        end;
                until Company.Next = 0;
        end else begin
            Company.Get(COMPANYNAME);
            CompanyTemp := Company;
            CompanyTemp.Insert;
        end;
    end;
}

