Codeunit 60000 "Halvotec ERiC Interface"
{

    trigger OnRun()
    var
        USTVACode: Code[20];
    begin
    end;

    var
        ERiCConnector: dotnet ERiCConnector;
        FileManagement: Codeunit "File Management";
        FileMode: dotnet FileMode;
        ELSTER_NS: label 'http://www.elster.de/elsterxml/schema/v11';

    [TryFunction]

    procedure TransmitVATAdvNotification(var VATAdvNotification: Record "Sales VAT Advance Notification")
    var
        Certificate: Record "ERIC Setup";
        TransmissionLogEntry: Record "Transmission Log Entry";
        TempBlob: Record TempBlob;
        TempBlob1: Codeunit "Temp Blob";
        DataFilename: Text;
        CertificateFilename: Text;
        CertificatePin: Text;
        NotificationYear: Text;
        ResultPDFFilename: Text;
        InStr: InStream;
        OutStr: OutStream;
        LogEntryNo: Integer;
        LogPath: Text;
        ErrorMsg: Text;
        ErrorCode: Text;
        Filename: Text;
    begin
        VATAdvNotification.TestField("XML Submission Document");
        VATAdvNotification.TestField("Transmission successful", false);

        Certificate.Get;

        DataFilename := SaveVATDocumentToFile(VATAdvNotification);
        CertificateFilename := SaveCertificateToFile(Certificate);
        CertificatePin := GetCertificatePin(Certificate);
        NotificationYear := Format(VATAdvNotification."Starting Date", 0, '<Year4>');
        ResultPDFFilename := FileManagement.ServerTempFileName('pdf');

        if not IsNull(ERiCConnector) then begin
            ERiCConnector.Close();
            Clear(ERiCConnector);
        end;
        LogPath := FileManagement.ServerCreateTempSubDirectory();
        ERiCConnector := ERiCConnector.ERiCConnector(ResultPDFFilename, LogPath);
        ErrorCode := ERiCConnector.ErrorCode();
        if not (ErrorCode in ['', '0', 'ERIC_OK']) then begin
            ErrorMsg := StrSubstNo('%1\ %2', ERiCConnector.ShortError(), ERiCConnector.LongError());
            Message(StrSubstNo('%1 \ %2', ERiCConnector.ShortError, ERiCConnector.LongError));
            Clear(ERiCConnector);
            Error('');
        end;

        if TransmissionLogEntry.FindLast then
            LogEntryNo := TransmissionLogEntry."Entry No." + 1
        else
            LogEntryNo := 1;

        TransmissionLogEntry.Init;
        TransmissionLogEntry."Entry No." := LogEntryNo;
        TransmissionLogEntry."Sales VAT Adv. Notif. No." := VATAdvNotification."No.";
        TransmissionLogEntry."Transmission Date" := Today;
        TransmissionLogEntry."User ID" := UserId;
        TransmissionLogEntry.Insert(true);

        TransmissionLogEntry."Transmission successful" := SubmitVATAdvNotification(DataFilename, CertificateFilename, CertificatePin, NotificationYear);
        // TransmissionLogEntry."XML Response Document".CREATEOUTSTREAM(OutStr);
        // IF SaveResponse(OutStr) THEN;
        TransmissionLogEntry.Modify;

        if TransmissionLogEntry."Transmission successful" then begin
            Message('Übertragung abgeschlossen');
            TempBlob.Init;
            if TempBlob.FindLast then
                TempBlob."Primary Key" += 1;
            TempBlob.Insert(true);
            FileManagement.BLOBImportFromServerFile(TempBlob1, ResultPDFFilename);
            TempBlob.Modify(true);

            TempBlob.CalcFields(Blob);
            TransmissionLogEntry.CalcFields("Transmission Result PDF");

            TempBlob.Blob.CreateInstream(InStr);
            TransmissionLogEntry."Transmission Result PDF".CreateOutstream(OutStr);
            CopyStream(OutStr, InStr);
            TransmissionLogEntry.Modify(true);
            TempBlob.Delete;
            ERiCConnector.Close();
            Clear(ERiCConnector);
        end else begin
            ErrorCode := ERiCConnector.ErrorCode;
            ErrorMsg := StrSubstNo('%1\ %2', ERiCConnector.ShortError, ERiCConnector.LongError);
            ErrorMsg := StrSubstNo('Fehler bei der Übertragung.\ \%1\ \%2\ \Log-Datei öffnen?', ErrorMsg, ERiCConnector.ServerResponse);
            ERiCConnector.Close();
            Clear(ERiCConnector);
            if Confirm(ErrorMsg, true) then begin
                Filename := 'eric.log';
                Download(StrSubstNo('%1\eric.log', LogPath), '', '', '', Filename);
            end;
        end;

        Commit;
    end;

    [TryFunction]
    local procedure SubmitVATAdvNotification(DataFilename: Text; CertificateFilename: Text; CertificatePin: Text; NotificationYear: Text)
    begin
        if not ERiCConnector.SendUSTVA(DataFilename, CertificateFilename, CertificatePin, NotificationYear) then
            Error('Fehler bei der Übertragung.');
    end;


    procedure TransmitZMDocument(var VATVIESDeclaration: Record "VAT VIES Declaration") Ok: Boolean
    var
        ERICSetup: Record "ERIC Setup";
        DataFilename: Text;
        ResultPDFFilename: Text;
        CertificateFilename: Text;
        CertificatePin: Text;
        OutStr: OutStream;
        FileStream: dotnet FileStream;
        LogPath: Text;
        ErrorMsg: Text;
        ErrorCode: Text;
        Filename: Text;
    begin
        VATVIESDeclaration.TestField("XML Document");
        VATVIESDeclaration.TestField("Transmission successfull", false);

        ERICSetup.Get;

        DataFilename := SaveVATDocumentToFile(VATVIESDeclaration);
        CertificateFilename := SaveCertificateToFile(ERICSetup);
        CertificatePin := GetCertificatePin(ERICSetup);
        ResultPDFFilename := FileManagement.ServerTempFileName('pdf');

        if not IsNull(ERiCConnector) then begin
            ERiCConnector.Close();
            Clear(ERiCConnector);
        end;
        LogPath := FileManagement.ServerCreateTempSubDirectory();
        ERiCConnector := ERiCConnector.ERiCConnector(ResultPDFFilename, LogPath);
        ErrorCode := ERiCConnector.ErrorCode();
        if not (ErrorCode in ['', '0', 'ERIC_OK']) then begin
            ErrorMsg := StrSubstNo('%1\ %2', ERiCConnector.ShortError(), ERiCConnector.LongError());
            Message(StrSubstNo('%1 \ %2', ERiCConnector.ShortError, ERiCConnector.LongError));
            Clear(ERiCConnector);
            Error('');
        end;

        VATVIESDeclaration."Transmission successfull" := ERiCConnector.SendZM(DataFilename, CertificateFilename, CertificatePin);

        if VATVIESDeclaration."Transmission successfull" then begin
            Message('Übertragung abgeschlossen');
            VATVIESDeclaration.CalcFields("Transmission Response Document");
            VATVIESDeclaration."Transmission Response Document".CreateOutstream(OutStr);
            FileStream := FileStream.FileStream(ResultPDFFilename, FileMode.Open);
            CopyStream(OutStr, FileStream);
            ERiCConnector.Close();
            Clear(ERiCConnector);
            //  VATVIESDeclaration.MODIFY(FALSE);
        end else begin
            ErrorCode := ERiCConnector.ErrorCode;
            ErrorMsg := StrSubstNo('%1\ %2', ERiCConnector.ShortError, ERiCConnector.LongError);
            ErrorMsg := StrSubstNo('Fehler bei der Übertragung.\ \%1\ \%2\ \Log-Datei öffnen?', ErrorMsg, ERiCConnector.ServerResponse);
            ERiCConnector.Close();
            Clear(ERiCConnector);
            if Confirm(ErrorMsg, true) then begin
                Filename := 'eric.log';
                Download(StrSubstNo('%1\eric.log', LogPath), '', '', '', Filename);
            end;
        end;

        exit(VATVIESDeclaration."Transmission successfull");
    end;

    [TryFunction]

    procedure CreateZMDocument(XMLDoc: dotnet XmlDocument; VATVIESDeclaration: Record "VAT VIES Declaration")
    var
        XMLDocumentElement: dotnet XmlElement;
        XMLElement: array[10] of dotnet XmlElement;
        CompanyInfo: Record "Company Information";
        INVALID_DATEFILTER: label 'Der ausgewählte Zeitraum (%1 - %2) ist ungültig.';
    begin
        if not IsNull(XMLDoc) then
            Clear(XMLDoc);

        if CalcDate('<-CY>', VATVIESDeclaration."From Date") <> CalcDate('<-CY>', VATVIESDeclaration."To Date") then
            Error(INVALID_DATEFILTER, VATVIESDeclaration."From Date", VATVIESDeclaration."To Date");

        XMLDoc := XMLDoc.XmlDocument();
        XMLDoc.LoadXml('<?xml version="1.0" encoding="UTF-8"?><Elster xmlns="http://www.elster.de/elsterxml/schema/v11" />');
        XMLElement[1] := XMLDoc.DocumentElement;
        AppendXMLElement(XMLElement[1], 'TransferHeader', XMLElement[2], '');
        XMLElement[2].SetAttribute('version', '11');
        AppendXMLElement(XMLElement[2], 'Verfahren', XMLElement[3], 'ElsterExtern');
        AppendXMLElement(XMLElement[2], 'DatenArt', XMLElement[3], 'ZMDO');
        AppendXMLElement(XMLElement[2], 'Vorgang', XMLElement[3], 'send-Auth');
        if VATVIESDeclaration.Test then
            AppendXMLElement(XMLElement[2], 'Testmerker', XMLElement[3], '700000004');
        AppendXMLElement(XMLElement[2], 'HerstellerID', XMLElement[3], '20784');
        CompanyInfo.Get;
        with CompanyInfo do AppendXMLElement(XMLElement[2], 'DatenLieferant', XMLElement[3], StrSubstNo('%1; %2; %3 %4', Name, Address, "Post Code", City));
        AppendXMLElement(XMLElement[2], 'Datei', XMLElement[3], '');
        AppendXMLElement(XMLElement[3], 'Verschluesselung', XMLElement[4], 'CMSEncryptedData');
        AppendXMLElement(XMLElement[3], 'Kompression', XMLElement[4], 'GZIP');
        AppendXMLElement(XMLElement[3], 'TransportSchluessel', XMLElement[4], '');

        AppendXMLElement(XMLElement[2], 'VersionClient', XMLElement[3], 'MS Dynamics NAV');

        AppendXMLElement(XMLElement[1], 'DatenTeil', XMLElement[2], '');
        AppendXMLElement(XMLElement[2], 'Nutzdatenblock', XMLElement[3], '');
        AppendXMLElement(XMLElement[3], 'NutzdatenHeader', XMLElement[4], '');
        XMLElement[4].SetAttribute('version', '11');
        AppendXMLElement(XMLElement[4], 'NutzdatenTicket', XMLElement[5], 'ZM');
        AppendXMLElement(XMLElement[4], 'Empfaenger', XMLElement[5], 'BF');
        XMLElement[5].SetAttribute('id', 'L');
        AppendXMLElement(XMLElement[3], 'Nutzdaten', XMLElement[4], '');
        AppendXMLElement(XMLElement[4], 'zm', XMLElement[5], '');
        XMLElement[5].SetAttribute('version', '000004');
        AppendXMLElement(XMLElement[5], 'unternehmer', XMLElement[6], '');
        AppendXMLElement(XMLElement[6], 'knri', XMLElement[7], CompanyInfo."VAT Registration No.");
        AppendXMLElement(XMLElement[6], 'zulassNr', XMLElement[7], '');
        AppendXMLElement(XMLElement[7], 'zulnr1', XMLElement[8], 'N');
        AppendXMLElement(XMLElement[7], 'zulnr2', XMLElement[8], '1111111');
        AppendXMLElement(XMLElement[6], 'anschrift', XMLElement[7], '');
        AppendXMLElement(XMLElement[7], 'name', XMLElement[8], CopyStr(CompanyInfo.Name, 1, 30));
        AppendXMLElement(XMLElement[7], 'strasse', XMLElement[8], CopyStr(CompanyInfo.Address, 1, 30));
        AppendXMLElement(XMLElement[7], 'plz', XMLElement[8], CompanyInfo."Post Code");
        AppendXMLElement(XMLElement[7], 'ort', XMLElement[8], CopyStr(CompanyInfo.City, 1, 30));
        AppendXMLElement(XMLElement[7], 'staat', XMLElement[8], CompanyInfo."Country/Region Code");
        AppendXMLElement(XMLElement[6], 'zm-zeilen', XMLElement[7], '');
        XMLElement[7].SetAttribute('waehrung', '1');
        if VATVIESDeclaration.Correction then
            XMLElement[7].SetAttribute('meldeart', '11')
        else
            XMLElement[7].SetAttribute('meldeart', '10');
        AppendXMLElement(XMLElement[7], 'anzeige', XMLElement[8], 'false');
        if VATVIESDeclaration.Cancelation then
            AppendXMLElement(XMLElement[7], 'widerruf', XMLElement[8], 'true')
        else
            AppendXMLElement(XMLElement[7], 'widerruf', XMLElement[8], 'false');
        AppendXMLElement(XMLElement[7], 'mzr', XMLElement[8], '');
        AppendXMLElement(XMLElement[8], 'quart', XMLElement[9], GetPeriodExpression(VATVIESDeclaration."From Date", VATVIESDeclaration."To Date"));
        AppendXMLElement(XMLElement[8], 'jahr', XMLElement[9], Format(VATVIESDeclaration."From Date", 0, '<Year4>'));
        CreateZMData(VATVIESDeclaration."VAT Posting Group Filter", VATVIESDeclaration."From Date", VATVIESDeclaration."To Date", XMLElement[7]);
    end;

    local procedure CreateZMData(VATBusPostGrpFilter: Text; FromDate: Date; ToDate: Date; var ZMDataXML: dotnet XmlElement)
    var
        VATEntry: Record "VAT Entry";
        XMLDoc: dotnet XmlDocument;
        ZMEntryXML: dotnet XmlElement;
        ASK_SHOW_EMPTY_VATREGNO: label 'Nicht alle %1 enthalten eine %2. Die Verarbeitung wird abgebrochen.\ Sollen die betreffenden Posten angezeigt werden?';
        ZMEntryKnreXML: dotnet XmlElement;
        ZMEntryBetragXML: dotnet XmlElement;
        SalesType: Option D,L,S;
        Amount: Decimal;
        XPath: Text;
        AmountText: Text;
    begin
        VATEntry.SetRange("Posting Date", FromDate, ToDate);
        VATEntry.SetRange(Type, VATEntry.Type::Sale);
        if VATBusPostGrpFilter <> '' then
            VATEntry.SetFilter("VAT Bus. Posting Group", VATBusPostGrpFilter);
        if VATEntry.FindSet then
            repeat
                if VATEntry."VAT Registration No." = '' then begin
                    if Confirm(ASK_SHOW_EMPTY_VATREGNO, true, VATEntry.TableCaption, VATEntry.FieldCaption("VAT Registration No.")) then begin
                        VATEntry.SetRange("VAT Registration No.", '');
                        Page.Run(0, VATEntry);
                    end;
                    Error('');
                end;

                case true of
                    VATEntry."EU 3-Party Trade":
                        SalesType := Salestype::D;
                    VATEntry."EU Service":
                        SalesType := Salestype::S;
                    else
                        SalesType := Salestype::L;
                end;

                VATEntry."VAT Registration No." := DelChr(VATEntry."VAT Registration No.", '=', ' -.');
                XPath := StrSubstNo('./zeile[@umsatzart="%1"][./knre="%2"]', Format(SalesType), VATEntry."VAT Registration No.");
                if IsNull(ZMDataXML.SelectSingleNode(XPath)) then begin
                    XMLDoc := ZMDataXML.OwnerDocument;
                    ZMEntryXML := XMLDoc.CreateElement('zeile');
                    ZMEntryXML.SetAttribute('umsatzart', Format(SalesType));
                    ZMEntryKnreXML := XMLDoc.CreateElement('knre');
                    ZMEntryKnreXML.AppendChild(XMLDoc.CreateTextNode(VATEntry."VAT Registration No."));
                    ZMEntryBetragXML := XMLDoc.CreateElement('betrag');
                    ZMEntryBetragXML.InnerText := Format(VATEntry.Base);
                    ZMEntryXML.AppendChild(ZMEntryKnreXML);
                    ZMEntryXML.AppendChild(ZMEntryBetragXML);
                    ZMDataXML.AppendChild(ZMEntryXML);
                end else begin
                    ZMEntryXML := ZMDataXML.SelectSingleNode(XPath);
                    AmountText := ZMEntryXML.OuterXml;
                    ZMEntryBetragXML := ZMEntryXML.SelectSingleNode('./betrag');
                    AmountText := ZMEntryBetragXML.InnerText;
                    Evaluate(Amount, AmountText);
                    Amount += VATEntry.Base;
                    ZMEntryBetragXML.InnerText := Format(Amount, 9);
                end;

            until VATEntry.Next = 0;

        foreach ZMEntryBetragXML in ZMDataXML.SelectNodes('./zeile/betrag') do begin
            AmountText := ZMEntryBetragXML.InnerText;
            Evaluate(Amount, AmountText);
            ZMEntryBetragXML.InnerText := DelChr(Format(ROUND(Amount, 1)), '=', ' -.,');
            if ZMEntryBetragXML.InnerText = '0' then
                ZMEntryBetragXML.ParentNode.ParentNode.RemoveChild(ZMEntryBetragXML.ParentNode);
        end;
    end;

    local procedure SaveCertificateToFile(var Certificate: Record "ERIC Setup") Filename: Text
    var
        InStr: InStream;
        OutStr: OutStream;
        TempBlob: Record TempBlob temporary;
        FileManagement: Codeunit "File Management";
    begin
        Certificate.CalcFields("PFX File");
        Certificate."PFX File".CreateInstream(InStr);

        TempBlob.DeleteAll;
        TempBlob.Init;
        TempBlob.Insert;
        TempBlob.CalcFields(Blob);
        TempBlob.Blob.CreateOutstream(OutStr);

        CopyStream(OutStr, InStr);

        TempBlob.Modify;
        Filename := FileManagement.ServerTempFileName('pfx');
        FileManagement.BLOBExportToServerFile(TempBlob1, Filename);
    end;

    local procedure GetCertificatePin(var Certificate: Record "ERIC Setup") Pin: Text
    var
        InStr: InStream;
        EncryptionManagement: Codeunit "Encryption Management";
    begin
        Certificate.CalcFields("PFX Pin");
        Certificate."PFX Pin".CreateInstream(InStr);
        InStr.Read(Pin);
        if EncryptionManagement.IsEncryptionEnabled then
            Pin := EncryptionManagement.Decrypt(Pin);
    end;

    local procedure SaveVATDocumentToFile(VATDocumentRecord: Variant) Filename: Text
    var
        RecRef: RecordRef;
        VATAdvNotification: Record "Sales VAT Advance Notification";
        VATVIESDeclaration: Record "VAT VIES Declaration";
        InStr: InStream;
        OutStr: OutStream;
        TempBlob: Record TempBlob temporary;
        FileManagement: Codeunit "File Management";
    begin
        RecRef.GetTable(VATDocumentRecord);
        case RecRef.Number of
            Database::"Sales VAT Advance Notification":
                begin
                    VATAdvNotification.Get(RecRef.Field(1));
                    VATAdvNotification.CalcFields("XML Submission Document");
                    VATAdvNotification."XML Submission Document".CreateInstream(InStr);
                end;
            Database::"VAT VIES Declaration":
                begin
                    VATVIESDeclaration.Get(RecRef.Field(1));
                    VATVIESDeclaration.CalcFields("XML Document");
                    VATVIESDeclaration."XML Document".CreateInstream(InStr);
                end;
        end;

        TempBlob.DeleteAll;
        TempBlob.Init;
        TempBlob.Insert;
        TempBlob.CalcFields(Blob);
        TempBlob.Blob.CreateOutstream(OutStr);

        CopyStream(OutStr, InStr);

        TempBlob.Modify;
        Filename := FileManagement.ServerTempFileName('xml');
        FileManagement.BLOBExportToServerFile(TempBlob1, Filename);
    end;

    [TryFunction]
    local procedure SaveResponse(var OutStr: OutStream)
    begin
        OutStr.Write(ERiCConnector.ServerResponse);
    end;

    local procedure AppendXMLElement(var ParentXMLElement: dotnet XmlElement; Name: Text; var XMLElement: dotnet XmlElement; Value: Text)
    begin
        XMLElement := ParentXMLElement.OwnerDocument.CreateElement(Name, ELSTER_NS);
        if Value <> '' then
            XMLElement.InnerText := XMLEscapeText(Value);
        ParentXMLElement.AppendChild(XMLElement);
    end;

    local procedure XMLEscapeText(TextToEscape: Text) escapedText: Text
    begin
        escapedText := ConvertStr(TextToEscape, 'ÄÖÜäöüß', 'AOUaous');
    end;

    local procedure GetPeriodExpression(FromDate: Date; ToDate: Date) PeriodExpression: Text
    begin
        if CalcDate('<-CM>', ToDate) = CalcDate('<-CM>', FromDate) then
            exit(Format(20 + Date2dmy(FromDate, 2)));

        if (Date2dmy(FromDate, 2) in [1, 4, 7, 10]) and (Date2dmy(ToDate, 2) in [2, 5, 8, 11]) then
            exit(Format(11 + (Date2dmy(FromDate, 2) DIV 3)));

        if ToDate <= CalcDate('<CQ>', FromDate) then
            exit(Format(Date2dmy(CalcDate('<CQ>', FromDate), 2) DIV 3));

        exit('5');
    end;
}

