Codeunit 50010 "Parcel Management"
{
    SingleInstance = true;

    trigger OnRun()
    var
        SalesParcel: Record "Sales Parcel";
    begin
        SalesParcel.SetRange("Delivered Date", 0D);
        SalesParcel.SetFilter("Tracking No.", '<>%1', '');
        if SalesParcel.FindSet then
          repeat
            SalesParcel.Info := '';
            if not GetTrackingData(SalesParcel) then
              SalesParcel.Info := CopyStr(GetLastErrorText, 1, MaxStrLen(SalesParcel.Info));
            SalesParcel.Modify;
          until SalesParcel.Next = 0;
    end;

    var
        AuthToken: Text;
        DELIS_ID: label '14000282';
        PASSWORD: label 'mauritz';
        NS_SOAPENV: label 'http://schemas.xmlsoap.org/soap/envelope/';
        NS_DPD_LOGINSERVICE: label 'http://dpd.com/common/service/types/LoginService/2.0';
        NS_DPD_AUTHSERVICE: label 'http://dpd.com/common/service/types/Authentication/2.0';
        NS_DPD_SHIPMENTSERVICE: label 'http://dpd.com/common/service/types/ShipmentService/3.2';
        Depot: Text;
        Debug: Text;
        XMLRequestDoc: dotnet XmlDocument;
        XMLResponseDoc: dotnet XmlDocument;
        XMLNamespaceMgmr: dotnet XmlNamespaceManager;
        NS_DPD_TRACKING: label 'http://dpd.com/common/service/types/ParcelLifeCycleService/2.0';
        Regex: dotnet Regex;


    procedure CreateAndPrintParcel(SalesHeader: Record "Sales Header";var SalesParcel: Record "Sales Parcel")
    var
        PDFBase64: Text;
        OutStr: OutStream;
        FileManagement: Codeunit "File Management";
        XMLRequestServerFilename: Text;
        XMLRequestClientFilename: Text;
    begin
        Login(false);

        CreateStoreOrderRequest(XMLRequestDoc, SalesHeader, SalesParcel);
        SalesParcel.CalcFields("XML Request");
        SalesParcel."XML Request".CreateOutstream(OutStr);
        OutStr.Write(XMLRequestDoc.OuterXml);
        SalesParcel.Modify;

        // XMLRequestDoc.Save('C:\tmp\request.xml');
        // IF NOT SubmitRequest('https://public-ws-stage.dpd.com/services/ShipmentService/V3_2/storeOrders') THEN
        if not SubmitRequest('https://public-ws.dpd.com/services/ShipmentService/V3_2/storeOrders') then begin
          if Confirm('Fehler bei der Übertragung.\ Übertragene Daten speichern?') then begin
            XMLRequestServerFilename := FileManagement.ServerTempFileName('xml');
            XMLRequestDoc.Save(XMLRequestServerFilename);
            XMLRequestClientFilename := FileManagement.ClientTempFileName('xml');
            FileManagement.DownloadToFile(XMLRequestServerFilename, XMLRequestClientFilename);
            Hyperlink(XMLRequestClientFilename);
          end;
          Error('');
        end;

        if not IsNull(XMLResponseDoc.SelectSingleNode('//parcellabelsPDF')) then begin
          PDFBase64 := XMLResponseDoc.SelectSingleNode('//parcellabelsPDF').InnerText;
          SalesParcel.Printed := PrintViaSpire(PDFBase64);
          if not SalesParcel.Printed then
            SalesParcel.Printed := PrintLabel(PDFBase64);

          SalesParcel.CalcFields(PDFBase64);
          SalesParcel.PDFBase64.CreateOutstream(OutStr);
          OutStr.Write(PDFBase64);
        end else begin
          Debug := XMLResponseDoc.OuterXml;
          Message(Debug);
        end;

        if not IsNull(XMLResponseDoc.SelectSingleNode('//parcelLabelNumber')) then
          SalesParcel."Tracking No." := XMLResponseDoc.SelectSingleNode('//parcelLabelNumber').InnerText;
        SalesParcel."Parcel Order Date" := Today;

        SalesParcel.CalcFields("XML Response");
        SalesParcel."XML Response".CreateOutstream(OutStr);
        OutStr.Write(XMLResponseDoc.OuterXml);

        SalesParcel.Modify;
    end;

    [TryFunction]
    local procedure PrintViaSpire(PDFBase64: Text)
    var
        [RunOnClient]
        PDFDocument: dotnet PdfDocument;
        Convert: dotnet Convert;
        PDFTempFilename: Text;
        [RunOnClient]
        PDFTempFile: dotnet File;
        FileManagement: Codeunit "File Management";
    begin
        PDFTempFilename := FileManagement.ClientTempFileName('pdf');
        PDFTempFile.WriteAllBytes(PDFTempFilename, Convert.FromBase64String(PDFBase64));

        PDFDocument := PDFDocument.PdfDocument();
        PDFDocument.LoadFromFile(PDFTempFilename);
        PDFDocument.Print();
    end;


    procedure RePrintParcel(SalesParcel: Record "Sales Parcel")
    var
        PDFBase64: Text;
        InStr: InStream;
        Convert: dotnet Convert;
        PDFTempFilename: Text;
        PDFTempFile: dotnet File;
        FileManagement: Codeunit "File Management";
        ClientFileName: Text;
    begin
        SalesParcel.CalcFields(PDFBase64);
        SalesParcel.PDFBase64.CreateInstream(InStr);
        InStr.Read(PDFBase64);

        PDFTempFilename := FileManagement.ServerTempFileName('pdf');
        PDFTempFile.WriteAllBytes(PDFTempFilename, Convert.FromBase64String(PDFBase64));
        ClientFileName := StrSubstNo('Auftrag %1 - Paket %2.pdf', SalesParcel."Document No.", SalesParcel."Entry No.");
        Download(PDFTempFilename, 'Label öffnen', '', '', ClientFileName);
    end;

    [TryFunction]

    procedure GetTrackingData(var SalesParcel: Record "Sales Parcel")
    var
        XMLStatusNodeList: dotnet XmlNodeList;
        StatusDateText: Text;
    begin
        Login(false);
        CreateTrackingRequest(XMLRequestDoc, SalesParcel);
        // IF NOT SubmitRequest('https://public-ws-stage.dpd.com/services/ParcelLifeCycleService/V2_0/getTrackingData') THEN
        if not SubmitRequest('https://public-ws.dpd.com/services/ParcelLifeCycleService/V2_0/getTrackingData') then
          Error('Fehler bei der Übertragung.');

        if not IsNull(XMLResponseDoc.SelectSingleNode('//statusInfo[./isCurrentStatus="true"]/status')) then begin
          Evaluate(SalesParcel.Status, XMLResponseDoc.SelectSingleNode('//statusInfo[./isCurrentStatus="true"]/status').InnerText);

          if not IsNull(XMLResponseDoc.SelectSingleNode('//statusInfo[./isCurrentStatus="true"]/date/content')) then
            StatusDateText := XMLResponseDoc.SelectSingleNode('//statusInfo[./isCurrentStatus="true"]/date/content').InnerText;
          if not ParseDateTime(StatusDateText, SalesParcel."Status Date") then
            SalesParcel."Status Date" := CurrentDatetime;
          if SalesParcel.Status = SalesParcel.Status::DELIVERED then
            SalesParcel."Delivered Date" := Dt2Date(SalesParcel."Status Date");
        end;
    end;

    local procedure Login(ForceLogin: Boolean)
    var
        XMLAuthTokenElement: dotnet XmlElement;
    begin
        if (AuthToken <> '') and not ForceLogin then
          exit;

        CreateAuthRequest(XMLRequestDoc);
        // SubmitRequest('https://public-ws-stage.dpd.com/services/LoginService/V2_0/getAuth');
        SubmitRequest('https://public-ws.dpd.com/services/LoginService/V2_0/getAuth');

        XMLAuthTokenElement := XMLResponseDoc.SelectSingleNode('//authToken');
        if not IsNull(XMLAuthTokenElement) then
          AuthToken := XMLAuthTokenElement.InnerText
        else
          Error('Login-Fehler');

        Depot := XMLResponseDoc.SelectSingleNode('//depot').InnerText;
    end;

    local procedure CreateAuthRequest(var XMLDoc: dotnet XmlDocument)
    var
        XMLDocElement: dotnet XmlElement;
        XMLBody: dotnet XmlElement;
        XMLMessage: dotnet XmlElement;
    begin
        if not IsNull(XMLDoc) then
          Clear(XMLDoc);
        XMLDoc := XMLDoc.XmlDocument();

        XMLDocElement := XMLDoc.CreateElement('soapenv', 'Envelope', NS_SOAPENV);
        XMLDocElement.SetAttribute('xmlns:soapenv', NS_SOAPENV);
        XMLDocElement.SetAttribute('xmlns:ns', NS_DPD_LOGINSERVICE);
        XMLDoc.AppendChild(XMLDocElement);

        XMLDocElement.AppendChild(XMLDoc.CreateElement('soapenv', 'Header', NS_SOAPENV));
        XMLBody := XMLDoc.CreateElement('soapenv', 'Body', NS_SOAPENV);
        XMLDocElement.AppendChild(XMLBody);

        XMLMessage := XMLDoc.CreateElement('ns', 'getAuth', NS_DPD_LOGINSERVICE);
        XMLBody.AppendChild(XMLMessage);

        AddSimpleXMLElement(XMLDoc, XMLMessage, 'delisId', DELIS_ID);
        AddSimpleXMLElement(XMLDoc, XMLMessage, 'password', PASSWORD);
        AddSimpleXMLElement(XMLDoc, XMLMessage, 'messageLanguage', 'de_DE');
    end;

    local procedure CreateStoreOrderRequest(var XMLDoc: dotnet XmlDocument;SalesHeader: Record "Sales Header";SalesParcel: Record "Sales Parcel")
    var
        CompanyInfo: Record "Company Information";
        Location: Record Location;
        XMLDocElement: dotnet XmlElement;
        XMLHeader: dotnet XmlElement;
        XMLAuth: dotnet XmlElement;
        XMLBody: dotnet XmlElement;
        XMLMessage: dotnet XmlElement;
        XMLPrintOptions: dotnet XmlElement;
        XMLOrder: dotnet XmlElement;
        XMLGeneralShipmentData: dotnet XmlElement;
        XMLSender: dotnet XmlElement;
        XMLRecipient: dotnet XmlElement;
        XMLParcel: dotnet XmlElement;
        XMLProduct: dotnet XmlElement;
        XMLNotification: dotnet XmlElement;
        XMLCOD: dotnet XmlElement;
        Weight: Integer;
        RecipientAddress: array [6] of Text;
        SenderAddress: array [6] of Text;
    begin
        if not IsNull(XMLDoc) then
          Clear(XMLDoc);
        XMLDoc := XMLDoc.XmlDocument();

        XMLDocElement := XMLDoc.CreateElement('soapenv', 'Envelope', NS_SOAPENV);
        XMLDocElement.SetAttribute('xmlns:soapenv', NS_SOAPENV);
        XMLDocElement.SetAttribute('xmlns:ns', NS_DPD_AUTHSERVICE);
        XMLDocElement.SetAttribute('xmlns:ns1', NS_DPD_SHIPMENTSERVICE);
        XMLDoc.AppendChild(XMLDocElement);

        // Create and append header
        AddComplexXMLElement(XMLDoc, XMLDocElement, XMLHeader, 'soapenv', 'Header', NS_SOAPENV);
        AddComplexXMLElement(XMLDoc, XMLHeader, XMLAuth, 'ns', 'authentication', NS_DPD_AUTHSERVICE);

        AddSimpleXMLElement(XMLDoc, XMLAuth, 'delisId', DELIS_ID);
        AddSimpleXMLElement(XMLDoc, XMLAuth, 'authToken', AuthToken);
        AddSimpleXMLElement(XMLDoc, XMLAuth, 'messageLanguage', 'de_DE');

        // Create and append body
        AddComplexXMLElement(XMLDoc, XMLDocElement, XMLBody, 'soapenv', 'Body', NS_SOAPENV);
        AddComplexXMLElement(XMLDoc, XMLBody, XMLMessage, 'ns1', 'storeOrders', NS_DPD_SHIPMENTSERVICE);

        AddComplexXMLElement(XMLDoc, XMLMessage, XMLPrintOptions, '', 'printOptions', '');
        AddSimpleXMLElement(XMLDoc, XMLPrintOptions, 'printerLanguage', 'PDF');
        AddSimpleXMLElement(XMLDoc, XMLPrintOptions, 'paperFormat', 'A6');

        AddComplexXMLElement(XMLDoc, XMLMessage, XMLOrder, '', 'order', '');
        AddComplexXMLElement(XMLDoc, XMLOrder, XMLGeneralShipmentData, '', 'generalShipmentData', '');
        AddSimpleXMLElement(XMLDoc, XMLGeneralShipmentData, 'sendingDepot', Depot);
        if SalesParcel.Express then
          AddSimpleXMLElement(XMLDoc, XMLGeneralShipmentData, 'product', 'E18') //IE2
        else
          AddSimpleXMLElement(XMLDoc, XMLGeneralShipmentData, 'product', 'CL');

        // Sender
        AddComplexXMLElement(XMLDoc, XMLGeneralShipmentData, XMLSender, '', 'sender', '');
        Location.Get(SalesParcel."Location Code");
        SetSenderAddress(Location, SenderAddress);
        AddSimpleXMLElement(XMLDoc, XMLSender, 'name1', SenderAddress[1]);
        if SenderAddress[2] <> '' then
          AddSimpleXMLElement(XMLDoc, XMLSender, 'name2', SenderAddress[2]);
        AddSimpleXMLElement(XMLDoc, XMLSender, 'street', SenderAddress[3]);
        AddSimpleXMLElement(XMLDoc, XMLSender, 'country', SenderAddress[6]);
        AddSimpleXMLElement(XMLDoc, XMLSender, 'zipCode', SenderAddress[4]);
        AddSimpleXMLElement(XMLDoc, XMLSender, 'city', SenderAddress[5]);

        // Recipient
        AddComplexXMLElement(XMLDoc, XMLGeneralShipmentData, XMLRecipient, '', 'recipient', '');
        SetRecipientAddress(SalesHeader, RecipientAddress);

        AddSimpleXMLElement(XMLDoc, XMLRecipient, 'name1', RecipientAddress[1]);
        if RecipientAddress[2] <> '' then
          AddSimpleXMLElement(XMLDoc, XMLRecipient, 'name2', RecipientAddress[2]);
        AddSimpleXMLElement(XMLDoc, XMLRecipient, 'street', RecipientAddress[3]);
        AddSimpleXMLElement(XMLDoc, XMLRecipient, 'country', RecipientAddress[6]);
        AddSimpleXMLElement(XMLDoc, XMLRecipient, 'zipCode', RecipientAddress[4]);
        AddSimpleXMLElement(XMLDoc, XMLRecipient, 'city', RecipientAddress[5]);
        AddSimpleXMLElement(XMLDoc, XMLRecipient, 'email', SalesHeader."Shipping Avis to Email");

        // Parcels
        AddComplexXMLElement(XMLDoc, XMLOrder, XMLParcel, '', 'parcels', '');
        Weight := ROUND( SalesParcel.Weight * 1000, 1);
        AddSimpleXMLElement(XMLDoc, XMLParcel, 'weight', Weight);
        // AddSimpleXMLElement(XMLDoc, XMLParcel, 'customerReferenceNumber1', STRSUBSTNO('Auftrag: %1', SalesHeader."No."));
        // IF SalesHeader."Your Reference" <> '' THEN
        //  AddSimpleXMLElement(XMLDoc, XMLParcel, 'customerReferenceNumber2', STRSUBSTNO('Referenz: %1', SalesHeader."Your Reference"));
        if SalesParcel."COD Amount" <> 0 then begin
          AddComplexXMLElement(XMLDoc, XMLParcel, XMLCOD, '', 'cod', '');
          AddSimpleXMLElement(XMLDoc, XMLCOD, 'amount', Format(ROUND(SalesParcel."COD Amount" * 100, 1), 0, '<Integer>'));
          if SalesParcel."COD Currency" = '' then
            AddSimpleXMLElement(XMLDoc, XMLCOD, 'currency', 'EUR')
          else
            AddSimpleXMLElement(XMLDoc, XMLCOD, 'currency', SalesParcel."COD Currency");
          AddSimpleXMLElement(XMLDoc, XMLCOD, 'inkasso', 0);
        end;

        // productAndServiceData
        AddComplexXMLElement(XMLDoc, XMLOrder, XMLProduct, '', 'productAndServiceData', '');
        AddSimpleXMLElement(XMLDoc, XMLProduct, 'orderType', 'consignment');

        if (not SalesParcel.Express) and (SalesHeader."Shipping Avis to Email" <> '') then begin
          AddComplexXMLElement(XMLDoc, XMLProduct, XMLNotification, '', 'predict', '');
          AddSimpleXMLElement(XMLDoc, XMLNotification, 'channel', 1);
          AddSimpleXMLElement(XMLDoc, XMLNotification, 'value', SalesHeader."Shipping Avis to Email");
          if SalesHeader."Language Code" = '' then
          SalesHeader."Language Code" := 'DE';
          AddSimpleXMLElement(XMLDoc, XMLNotification, 'language', SalesHeader."Language Code");
        end;
    end;

    local procedure CreateTrackingRequest(var XMLDoc: dotnet XmlDocument;SalesParcel: Record "Sales Parcel")
    var
        XMLDocElement: dotnet XmlElement;
        XMLHeader: dotnet XmlElement;
        XMLAuth: dotnet XmlElement;
        XMLBody: dotnet XmlElement;
        XMLMessage: dotnet XmlElement;
    begin
        if not IsNull(XMLDoc) then
          Clear(XMLDoc);
        XMLDoc := XMLDoc.XmlDocument();

        XMLDocElement := XMLDoc.CreateElement('soapenv', 'Envelope', NS_SOAPENV);
        XMLDocElement.SetAttribute('xmlns:soapenv', NS_SOAPENV);
        XMLDocElement.SetAttribute('xmlns:ns', NS_DPD_AUTHSERVICE);
        XMLDocElement.SetAttribute('xmlns:ns1', NS_DPD_TRACKING);
        XMLDoc.AppendChild(XMLDocElement);

        // Create and append header
        AddComplexXMLElement(XMLDoc, XMLDocElement, XMLHeader, 'soapenv', 'Header', NS_SOAPENV);
        AddComplexXMLElement(XMLDoc, XMLHeader, XMLAuth, 'ns', 'authentication', NS_DPD_AUTHSERVICE);

        AddSimpleXMLElement(XMLDoc, XMLAuth, 'delisId', DELIS_ID);
        AddSimpleXMLElement(XMLDoc, XMLAuth, 'authToken', AuthToken);
        AddSimpleXMLElement(XMLDoc, XMLAuth, 'messageLanguage', 'de_DE');

        // Create and append body
        AddComplexXMLElement(XMLDoc, XMLDocElement, XMLBody, 'soapenv', 'Body', NS_SOAPENV);
        AddComplexXMLElement(XMLDoc, XMLBody, XMLMessage, 'ns1', 'getTrackingData', NS_DPD_TRACKING);

        AddSimpleXMLElement(XMLDoc, XMLMessage, 'parcelLabelNumber', SalesParcel."Tracking No.");
    end;

    local procedure AddSimpleXMLElement(var XMLDoc: dotnet XmlDocument;var XMLParentElement: dotnet XmlElement;ElementName: Text;ElementValue: Variant)
    var
        XMLChildElement: dotnet XmlElement;
    begin
        XMLChildElement := XMLDoc.CreateElement(ElementName);
        if Format(ElementValue) <> '' then
          case true of
            ElementValue.Isinteger:
              XMLChildElement.AppendChild(XMLDoc.CreateTextNode(Format(ElementValue, 0, '<Integer>')));
            ElementValue.IsDecimal:
              XMLChildElement.AppendChild(XMLDoc.CreateTextNode(Format(ElementValue, 0, '<Integer><Decimals,3><Comma,.>')));
            else
              XMLChildElement.AppendChild(XMLDoc.CreateTextNode(Format(ElementValue)));
          end;

        XMLParentElement.AppendChild(XMLChildElement);

        Clear(XMLChildElement);
    end;

    local procedure AddComplexXMLElement(var XMLDoc: dotnet XmlDocument;var XMLParentElement: dotnet XmlElement;var XMLElem: dotnet XmlElement;NamepacePrefix: Text;ElementName: Text;NamespaceURL: Text)
    begin
        if NamepacePrefix = '' then
          XMLElem := XMLDoc.CreateElement(ElementName)
        else
          XMLElem := XMLDoc.CreateElement(NamepacePrefix, ElementName, NamespaceURL);

        XMLParentElement.AppendChild(XMLElem);
    end;

    [TryFunction]
    local procedure SubmitRequest(WebServiceURL: Text)
    var
        InStr: InStream;
        OutStr: OutStream;
        HttpWebRequest: dotnet HttpWebRequest;
        HttpWebResponse: dotnet HttpWebResponse;
        HttpStatusCode: dotnet HttpStatusCode;
        ResponseHeaders: dotnet NameValueCollection;
        WebServReqHelper: Codeunit "Web Request Helper";
        TempBlob: Record TempBlob;
        SourceRecRef: RecordRef;
        SourceRecordID: RecordID;
        ServicePointManager: dotnet ServicePointManager;
        SecurityProtocolType: dotnet SecurityProtocolType;
        SystemTextUTF8Encoding: dotnet UTF8Encoding;
        Bytes: dotnet Array;
        RequestStream: dotnet Stream;
        ResponseStreamReader: dotnet StreamReader;
        ResponseText: Text;
        MessageToSend: Text;
    begin
        HttpWebRequest := HttpWebRequest.Create(WebServiceURL);
        HttpWebRequest.KeepAlive := false;

        HttpWebRequest.ContentType := 'text/xml';
        HttpWebRequest.Method := 'POST';
        SystemTextUTF8Encoding := SystemTextUTF8Encoding.UTF8Encoding();
        Bytes := SystemTextUTF8Encoding.GetBytes(XMLRequestDoc.OuterXml);
        HttpWebRequest.ContentLength := Bytes.Length;
        RequestStream := HttpWebRequest.GetRequestStream();
        RequestStream.Write(Bytes, 0, Bytes.Length);
        RequestStream.Close;

        HttpWebResponse := HttpWebRequest.GetResponse();
        ResponseStreamReader := ResponseStreamReader.StreamReader(HttpWebResponse.GetResponseStream(), SystemTextUTF8Encoding.GetEncoding('utf-8'));
        ResponseText := ResponseStreamReader.ReadToEnd();

        if not IsNull(XMLResponseDoc) then
          Clear(XMLResponseDoc);

        XMLResponseDoc := XMLResponseDoc.XmlDocument();
        XMLResponseDoc.LoadXml(ResponseText);
    end;

    local procedure GetNamespaceManager(var XMLDoc: dotnet XmlDocument)
    var
        XMLNodeList: dotnet XmlNodeList;
        XMLNode: dotnet XmlNode;
    begin
        XMLNamespaceMgmr := XMLNamespaceMgmr.XmlNamespaceManager(XMLDoc.NameTable);
        XMLNodeList := XMLDoc.SelectNodes('/*/namespace::*');
        if not IsNull(XMLNodeList) then
          foreach XMLNode in XMLNodeList do begin
            if not (XMLNode.LocalName in ['xml', 'xmlns']) then
              XMLNamespaceMgmr.AddNamespace(XMLNode.LocalName, XMLNode.NamespaceURI);
          end;
    end;

    [TryFunction]
    local procedure PrintLabel(PDFBase64: Text)
    var
        Convert: dotnet Convert;
        PDFTempFilename: Text;
        [RunOnClient]
        PDFTempFile: dotnet File;
        FileManagement: Codeunit "File Management";
        [RunOnClient]
        ProcessStartInfo: dotnet ProcessStartInfo;
        [RunOnClient]
        ProcessWindowStyle: dotnet ProcessWindowStyle;
        [RunOnClient]
        Process: dotnet Process;
    begin
        PDFTempFilename := FileManagement.ClientTempFileName('pdf');
        PDFTempFile.WriteAllBytes(PDFTempFilename, Convert.FromBase64String(PDFBase64));

        ProcessStartInfo := ProcessStartInfo.ProcessStartInfo();
        ProcessStartInfo.Verb := 'print';
        ProcessStartInfo.FileName := PDFTempFilename;
        ProcessStartInfo.CreateNoWindow := true;
        ProcessStartInfo.WindowStyle := ProcessWindowStyle.Hidden;

        Process := Process.Process();
        Process.StartInfo := ProcessStartInfo;
        Process.Start;

        Process.WaitForInputIdle;
        Sleep(10000);
        if not Process.CloseMainWindow then
          Process.Kill;
    end;

    local procedure SetRecipientAddress(SalesHeader: Record "Sales Header";var RecipientAddress: array [7] of Text)
    var
        Regex: dotnet Regex;
        i: Integer;
    begin
        if SalesHeader."Ship-to Name" = '' then begin
          RecipientAddress[1] := SalesHeader."Sell-to Customer Name";
          RecipientAddress[2] := SalesHeader."Sell-to Customer Name 2";
          RecipientAddress[3] := StrSubstNo('%1 %2', SalesHeader."Sell-to Address", SalesHeader."Sell-to Address 2");
          RecipientAddress[4] := SalesHeader."Sell-to Post Code";
          RecipientAddress[5] := SalesHeader."Sell-to City";
          RecipientAddress[6] := SalesHeader."Sell-to Country/Region Code";
        end else begin
          RecipientAddress[1] := SalesHeader."Ship-to Name";
          RecipientAddress[2] := SalesHeader."Ship-to Name 2";
          RecipientAddress[3] := StrSubstNo('%1 %2', SalesHeader."Ship-to Address", SalesHeader."Ship-to Address 2");
          RecipientAddress[4] := SalesHeader."Ship-to Post Code";
          RecipientAddress[5] := SalesHeader."Ship-to City";
          RecipientAddress[6] := SalesHeader."Ship-to Country/Region Code";
        end;

        if RecipientAddress[6] = '' then
          RecipientAddress[6] := 'DE';

        for i := 1 to 5 do begin
          RecipientAddress[i] := Regex.Replace(RecipientAddress[i], 'ß', 'ss');
          RecipientAddress[i] := Regex.Replace(RecipientAddress[i], 'ä', 'ae');
          RecipientAddress[i] := Regex.Replace(RecipientAddress[i], 'ö', 'oe');
          RecipientAddress[i] := Regex.Replace(RecipientAddress[i], 'ü', 'ue');
          RecipientAddress[i] := Regex.Replace(RecipientAddress[i], 'Ä', 'Ae');
          RecipientAddress[i] := Regex.Replace(RecipientAddress[i], 'Ö', 'Oe');
          RecipientAddress[i] := Regex.Replace(RecipientAddress[i], 'Ü', 'Ue');
          RecipientAddress[i] := DelChr(RecipientAddress[i], '<>', ' ');
        end;

        for i := 1 to 2 do
          if StrLen(RecipientAddress[i]) > 35 then
            Error('Der Name in der Lieferadresse darf nicht länger als 35 Zeichen sein.\ Bitte ändern Sie:\ \%1 (%2 Zeichen)', RecipientAddress[i], StrLen(RecipientAddress[i]));
    end;

    local procedure SetSenderAddress(Location: Record Location;var SenderAddress: array [6] of Text)
    var
        Regex: dotnet Regex;
        i: Integer;
    begin
        SenderAddress[1] := Location.Name;
        SenderAddress[2] := Location."Name 2";
        SenderAddress[3] := StrSubstNo('%1 %2', Location.Address, Location."Address 2");
        SenderAddress[4] := Location."Post Code";
        SenderAddress[5] := Location.City;
        SenderAddress[6] := Location."Country/Region Code";

        if SenderAddress[6] = '' then
          SenderAddress[6] := 'DE';

        for i := 1 to 5 do begin
          SenderAddress[i] := Regex.Replace(SenderAddress[i], 'ß', 'ss');
          SenderAddress[i] := Regex.Replace(SenderAddress[i], 'ä', 'ae');
          SenderAddress[i] := Regex.Replace(SenderAddress[i], 'ö', 'oe');
          SenderAddress[i] := Regex.Replace(SenderAddress[i], 'ü', 'ue');
          SenderAddress[i] := Regex.Replace(SenderAddress[i], 'Ä', 'AE');
          SenderAddress[i] := Regex.Replace(SenderAddress[i], 'Ö', 'OE');
          SenderAddress[i] := Regex.Replace(SenderAddress[i], 'Ü', 'UE');
        end;
    end;

    [TryFunction]
    local procedure ParseDateTime(Input: Text;var Output: DateTime)
    var
        Match: dotnet Match;
        day: Integer;
        month: Integer;
        year: Integer;
        hour: Integer;
        minute: Integer;
        newDate: Date;
        newTime: Time;
    begin
        Match := Regex.Match(Input, '(?<day>0[1-9]|[12]\d|3[01])\/(?<month>0[1-9]|1[0-2])\/(?<year>\d{4}), (?<hours>[01]\d|2[0-3]):(?<minutes>[0-5]\d)');

        Evaluate(day, Format(Match.Groups.Item('day').Value));
        Evaluate(month, Format(Match.Groups.Item('month').Value));
        Evaluate(year, Format(Match.Groups.Item('year').Value));
        Evaluate(hour, Format(Match.Groups.Item('hours').Value));
        Evaluate(minute, Format(Match.Groups.Item('minutes').Value));

        newDate := Dmy2date(day, month, year);
        Evaluate(newTime, StrSubstNo('%1:%2:00', hour, minute));

        Output := CreateDatetime(newDate, newTime);
    end;

    trigger Xmlresponsedoc::NodeInserting(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlresponsedoc::NodeInserted(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlresponsedoc::NodeRemoving(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlresponsedoc::NodeRemoved(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlresponsedoc::NodeChanging(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlresponsedoc::NodeChanged(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlrequestdoc::NodeInserting(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlrequestdoc::NodeInserted(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlrequestdoc::NodeRemoving(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlrequestdoc::NodeRemoved(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlrequestdoc::NodeChanging(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;

    trigger Xmlrequestdoc::NodeChanged(sender: Variant;e: dotnet XmlNodeChangedEventArgs)
    begin
    end;
}

