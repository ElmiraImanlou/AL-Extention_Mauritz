Table 50000 "Document Layout Setup"
{
    LookupPageID = "Document Layout Setup";

    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Usage';
        }
        field(2; "Report Name"; Text[50])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Report ID")));
            Caption = 'Berichtsname';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Footer Columns"; Integer)
        {
            Caption = 'Anzahl Spalten in Belegfuß';
            InitValue = 1;
            MaxValue = 6;
            MinValue = 1;
        }
        field(11; "Footer Column 1 HTML"; Blob)
        {
            Caption = 'Belegfuß Spalte 1 (HTML)';
            SubType = Memo;
        }
        field(12; "Footer Column 2 HTML"; Blob)
        {
            Caption = 'Belegfuß Spalte 2 (HTML)';
            SubType = Memo;
        }
        field(13; "Footer Column 3 HTML"; Blob)
        {
            Caption = 'Belegfuß Spalte 3 (HTML)';
            SubType = Memo;
        }
        field(14; "Footer Column 4 HTML"; Blob)
        {
            Caption = 'Belegfuß Spalte 4 (HTML)';
            SubType = Memo;
        }
        field(15; "Footer Column 5 HTML"; Blob)
        {
            Caption = 'Belegfuß Spalte 5 (HTML)';
            SubType = Memo;
        }
        field(16; "Footer Column 6 HTML"; Blob)
        {
            Caption = 'Belegfuß Spalte 6 (HTML)';
            SubType = Memo;
        }
        field(21; "Footer Column 1 Image"; Blob)
        {
            Caption = 'Belegfuß Spalte 1 Bild';
            SubType = Bitmap;
        }
        field(22; "Footer Column 2 Image"; Blob)
        {
            Caption = 'Belegfuß Spalte 2 Bild';
            SubType = Bitmap;
        }
        field(23; "Footer Column 3 Image"; Blob)
        {
            Caption = 'Belegfuß Spalte 3 Bild';
            SubType = Bitmap;
        }
        field(24; "Footer Column 4 Image"; Blob)
        {
            Caption = 'Belegfuß Spalte 4 Bild';
            SubType = Bitmap;
        }
        field(25; "Footer Column 5 Image"; Blob)
        {
            Caption = 'Belegfuß Spalte 5 Bild';
            SubType = Bitmap;
        }
        field(26; "Footer Column 6 Image"; Blob)
        {
            Caption = 'Belegfuß Spalte 6 Bild';
            SubType = Bitmap;
        }
        field(30; "Font Type"; Text[30])
        {
            Caption = 'Schriftart';
        }
        field(31; "Default Font Size"; Integer)
        {
            Caption = 'Standard-Schriftgröße (pt)';
        }
        field(32; "Lines Font Size"; Integer)
        {
            Caption = 'Zeilen Schriftgröße (pt)';
        }
        field(33; "Footer Font Size"; Integer)
        {
            Caption = 'Belegfuß Schriftgröße (pt)';
        }
        field(34; "Show Amount Sum Per VAT"; Boolean)
        {
            Caption = 'Netto/Brutto pro MwSt-Satz ausgeben';
        }
        field(35; "Show Currency Per Line"; Boolean)
        {
            Caption = 'Währung in Zeilen ausgeben';
        }
        field(36; "Column Captions Bold"; Boolean)
        {
            Caption = 'Spaltenüberschriften fett';
        }
        field(37; "Info Box Font Size"; Integer)
        {
            Caption = 'Beleg-InfoBox Schriftgröße (pt)';
        }
        field(38; "Title Font Size"; Integer)
        {
            Caption = 'Beleg-Titel Schriftgröße (pt)';
        }
        field(39; "Copy Text"; Text[200])
        {
            Caption = 'Kopientext';
        }
        field(41; "InfoBox 1 Caption"; Text[30])
        {
            Caption = 'Infobox Zeile 1 (Bezeichnung)';
        }
        field(42; "InfoBox 2 Caption"; Text[30])
        {
            Caption = 'Infobox Zeile 2 (Bezeichnung)';
        }
        field(43; "InfoBox 3 Caption"; Text[30])
        {
            Caption = 'Infobox Zeile 3 (Bezeichnung)';
        }
        field(44; "InfoBox 4 Caption"; Text[30])
        {
            Caption = 'Infobox Zeile 4 (Bezeichnung)';
        }
        field(45; "InfoBox 5 Caption"; Text[30])
        {
            Caption = 'Infobox Zeile 5 (Bezeichnung)';
        }
        field(46; "InfoBox 6 Caption"; Text[30])
        {
            Caption = 'Infobox Zeile 6 (Bezeichnung)';
        }
        field(47; "InfoBox 7 Caption"; Text[30])
        {
            Caption = 'Infobox Zeile 7 (Bezeichnung)';
        }
        field(48; "InfoBox 8 Caption"; Text[30])
        {
            Caption = 'Infobox Zeile 8 (Bezeichnung)';
        }
        field(51; "InfoBox 1 Source"; Integer)
        {
            Caption = 'InfoBox Zeile 1 (Herkunftsfeld)';
        }
        field(52; "InfoBox 2 Source"; Integer)
        {
            Caption = 'InfoBox Zeile 2 (Herkunftsfeld)';
        }
        field(53; "InfoBox 3 Source"; Integer)
        {
            Caption = 'InfoBox Zeile 3 (Herkunftsfeld)';
        }
        field(54; "InfoBox 4 Source"; Integer)
        {
            Caption = 'InfoBox Zeile 4 (Herkunftsfeld)';
        }
        field(55; "InfoBox 5 Source"; Integer)
        {
            Caption = 'InfoBox Zeile 5 (Herkunftsfeld)';
        }
        field(56; "InfoBox 6 Source"; Integer)
        {
            Caption = 'InfoBox Zeile 6 (Herkunftsfeld)';
        }
        field(57; "InfoBox 7 Source"; Integer)
        {
            Caption = 'InfoBox Zeile 7 (Herkunftsfeld)';
        }
        field(58; "InfoBox 8 Source"; Integer)
        {
            Caption = 'InfoBox Zeile 8 (Herkunftsfeld)';
        }
        field(71; "PrePos 1 Caption"; Text[30])
        {
            Caption = 'Info vor Positionen 1 (Bezeichnung)';
        }
        field(72; "PrePos 2 Caption"; Text[30])
        {
            Caption = 'Info vor Positionen 2 (Bezeichnung)';
        }
        field(73; "PrePos 3 Caption"; Text[30])
        {
            Caption = 'Info vor Positionen 3 (Bezeichnung)';
        }
        field(74; "PrePos 4 Caption"; Text[30])
        {
            Caption = 'Info vor Positionen 4 (Bezeichnung)';
        }
        field(75; "PrePos 5 Caption"; Text[30])
        {
            Caption = 'Info vor Positionen 5 (Bezeichnung)';
        }
        field(76; "PrePos 6 Caption"; Text[30])
        {
            Caption = 'Info vor Positionen 6 (Bezeichnung)';
        }
        field(81; "PrePos 1 Source"; Integer)
        {
            Caption = 'Info vor Positionen 1 (Herkunftsfeld)';
        }
        field(82; "PrePos 2 Source"; Integer)
        {
            Caption = 'Info vor Positionen 2 (Herkunftsfeld)';
        }
        field(83; "PrePos 3 Source"; Integer)
        {
            Caption = 'Info vor Positionen 3 (Herkunftsfeld)';
        }
        field(84; "PrePos 4 Source"; Integer)
        {
            Caption = 'Info vor Positionen 4 (Herkunftsfeld)';
        }
        field(85; "PrePos 5 Source"; Integer)
        {
            Caption = 'Info vor Positionen 5 (Herkunftsfeld)';
        }
        field(86; "PrePos 6 Source"; Integer)
        {
            Caption = 'Info vor Positionen 6 (Herkunftsfeld)';
        }
        field(91; "PostPos 1 Caption"; Text[30])
        {
            Caption = 'Info nach Positionen 1 (Bezeichnung)';
        }
        field(92; "PostPos 2 Caption"; Text[30])
        {
            Caption = 'Info nach Positionen 2 (Bezeichnung)';
        }
        field(101; "PostPos 1 Source"; Integer)
        {
            Caption = 'Info nach Positionen 1 (Herkunftsfeld)';
        }
        field(102; "PostPos 2 Source"; Integer)
        {
            Caption = 'Info nach Positionen 2 (Herkunftsfeld)';
        }
        field(200; "Print In Background"; Boolean)
        {
            Caption = 'Im Hintergrund drucken';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Report ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetLayoutPropertiesAsXML() Xml: Text
    var
        XMLDocument: dotnet XmlDocument;
        XMLRootElement: dotnet XmlElement;
        XMLElement: dotnet XmlElement;
        InStr: InStream;
    begin
        XMLDocument := XMLDocument.XmlDocument;
        XMLRootElement := XMLDocument.CreateElement(DelChr(TableName, '=', ' '));
        XMLDocument.AppendChild(XMLRootElement);

        AddXMLSimpleElement(XMLDocument, FieldName("Footer Columns"), "Footer Columns");

        CalcFields("Footer Column 1 HTML");
        "Footer Column 1 HTML".CreateInstream(InStr);
        AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 1 HTML"), InStr, false);
        CalcFields("Footer Column 1 Image");
        "Footer Column 1 Image".CreateInstream(InStr);
        AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 1 Image"), InStr, true);

        if "Footer Columns" >= 2 then begin
            CalcFields("Footer Column 2 HTML");
            "Footer Column 2 HTML".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 2 HTML"), InStr, false);
            CalcFields("Footer Column 2 Image");
            "Footer Column 2 Image".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 2 Image"), InStr, true);
        end;

        if "Footer Columns" >= 3 then begin
            CalcFields("Footer Column 3 HTML");
            "Footer Column 3 HTML".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 3 HTML"), InStr, false);
            CalcFields("Footer Column 3 Image");
            "Footer Column 3 Image".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 3 Image"), InStr, true);
        end;

        if "Footer Columns" >= 4 then begin
            CalcFields("Footer Column 4 HTML");
            "Footer Column 4 HTML".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 4 HTML"), InStr, false);
            CalcFields("Footer Column 4 Image");
            "Footer Column 4 Image".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 4 Image"), InStr, true);
        end;

        if "Footer Columns" >= 5 then begin
            CalcFields("Footer Column 5 HTML");
            "Footer Column 5 HTML".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 5 HTML"), InStr, false);
            CalcFields("Footer Column 5 Image");
            "Footer Column 5 Image".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 5 Image"), InStr, true);
        end;

        if "Footer Columns" = 6 then begin
            CalcFields("Footer Column 6 HTML");
            "Footer Column 6 HTML".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 6 HTML"), InStr, false);
            CalcFields("Footer Column 6 Image");
            "Footer Column 6 Image".CreateInstream(InStr);
            AddXMLCDATAElement(XMLDocument, FieldName("Footer Column 6 Image"), InStr, true);
        end;

        AddXMLSimpleElement(XMLDocument, FieldName("Font Type"), "Font Type");
        AddXMLSimpleElement(XMLDocument, FieldName("Default Font Size"), "Default Font Size");
        AddXMLSimpleElement(XMLDocument, FieldName("Info Box Font Size"), "Info Box Font Size");
        AddXMLSimpleElement(XMLDocument, FieldName("Lines Font Size"), "Lines Font Size");
        AddXMLSimpleElement(XMLDocument, FieldName("Footer Font Size"), "Footer Font Size");
        AddXMLSimpleElement(XMLDocument, FieldName("Title Font Size"), "Title Font Size");
        AddXMLSimpleElement(XMLDocument, FieldName("Show Amount Sum Per VAT"), Format("Show Amount Sum Per VAT", 0, '<Number>'));
        AddXMLSimpleElement(XMLDocument, FieldName("Show Currency Per Line"), Format("Show Currency Per Line", 0, '<Number>'));
        AddXMLSimpleElement(XMLDocument, FieldName("Column Captions Bold"), Format("Column Captions Bold", 0, '<Number>'));

        Xml := XMLDocument.OuterXml;

        Clear(XMLElement);
        Clear(XMLRootElement);
        Clear(XMLDocument);
    end;

    local procedure AddXMLSimpleElement(var XMLDoc: dotnet XmlDocument; ElementName: Text; ElementValue: Variant)
    var
        XMLElement: dotnet XmlElement;
    begin
        XMLElement := XMLDoc.CreateElement(DelChr(ElementName, '=', ' '));
        XMLElement.AppendChild(XMLDoc.CreateTextNode(Format(ElementValue)));

        XMLDoc.SelectSingleNode(StrSubstNo('//%1', DelChr(TableName, '=', ' '))).AppendChild(XMLElement);

        Clear(XMLElement);
    end;

    local procedure AddXMLCDATAElement(var XMLDoc: dotnet XmlDocument; ElementName: Text; ElementValueStream: InStream; IsBinary: Boolean)
    var
        XMLElement: dotnet XmlElement;
        ElementValue: Text;
        ImageMIMEType: Text;
    begin
        if ElementValueStream.eos then
            exit;

        XMLElement := XMLDoc.CreateElement(DelChr(ElementName, '=', ' '));

        if IsBinary then begin
            if Base64Encode(ElementValueStream, ElementValue, ImageMIMEType) then begin
                XMLElement.AppendChild(XMLDoc.CreateCDataSection(ElementValue));
                XMLElement.SetAttribute('MimeType', '', ImageMIMEType);
            end;
        end else begin
            ElementValueStream.Read(ElementValue);
            XMLElement.AppendChild(XMLDoc.CreateCDataSection(ElementValue));
        end;

        XMLDoc.SelectSingleNode(StrSubstNo('//%1', DelChr(TableName, '=', ' '))).AppendChild(XMLElement);

        Clear(XMLElement);
    end;

    [TryFunction]
    local procedure Base64Encode(InStr: InStream; var Base64EncodedImage: Text; var ImageMIMEType: Text)
    var
        Image: dotnet Image;
        fmt: dotnet ImageFormat;
        ms: dotnet MemoryStream;
        ByteArray: dotnet Array;
        Convert: dotnet Convert;
    begin
        Image := Image.FromStream(InStr);
        fmt := Image.RawFormat;

        case fmt.Guid of
            fmt.Bmp.Guid:
                ImageMIMEType := 'image/bmp';
            fmt.Jpeg.Guid:
                ImageMIMEType := 'image/jpeg';
            fmt.Gif.Guid:
                ImageMIMEType := 'image/gif';
            fmt.Png.Guid:
                ImageMIMEType := 'image/png';
        end;

        ms := ms.MemoryStream();
        Image.Save(ms, fmt);
        ByteArray := ms.ToArray();
        Base64EncodedImage := Convert.ToBase64String(ByteArray);

        Clear(Image);
        Clear(fmt);
        Clear(ByteArray);
        Clear(Convert);
    end;


    procedure SetInfoBox(HeaderRecordVariant: Variant; var InfoBoxCaptions: array[8] of Text; var InfoBoxValues: array[8] of Text)
    var
        SetupRecRef: RecordRef;
        HeaderRecRef: RecordRef;
        RelatedRecRef: RecordRef;
        RelatedFieldRef: FieldRef;
        i: Integer;
        SourceFieldNo: Integer;
        "Field": Record "Field";
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        Location: Record Location;
        SalesPersonPurchaser: Record "Salesperson/Purchaser";
    begin
        if HeaderRecordVariant.IsRecord then
            HeaderRecRef.GetTable(HeaderRecordVariant);

        if HeaderRecordVariant.IsRecordId then
            HeaderRecRef.Get(HeaderRecordVariant);

        if HeaderRecordVariant.IsRecordRef then
            HeaderRecRef := HeaderRecordVariant;

        SetupRecRef.GetTable(Rec);
        for i := 1 to 8 do begin
            InfoBoxCaptions[i] := Format(SetupRecRef.Field(40 + i).Value);
            Evaluate(SourceFieldNo, Format(SetupRecRef.Field(50 + i).Value));
            case SourceFieldNo of
                23:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if PaymentTerms.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            InfoBoxValues[i] := PaymentTerms.Description
                        else
                            InfoBoxValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                27:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if ShipmentMethod.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            InfoBoxValues[i] := ShipmentMethod.Description
                        else
                            InfoBoxValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                28:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if Location.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            InfoBoxValues[i] := Location.Name
                        else
                            InfoBoxValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                43:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if SalesPersonPurchaser.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            InfoBoxValues[i] := SalesPersonPurchaser.Name
                        else
                            InfoBoxValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                else
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then begin
                        InfoBoxValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                        if Field.RelationTableNo <> 0 then begin
                            RelatedRecRef.Open(Field.RelationTableNo);
                            Field.Reset;
                            Field.Get(RelatedRecRef.Number, RelatedRecRef.KeyIndex(1).FieldIndex(1).Number);
                            RelatedFieldRef := RelatedRecRef.Field(Field."No.");
                            RelatedFieldRef.SetRange(HeaderRecRef.Field(SourceFieldNo).Value);
                            if RelatedRecRef.FindFirst then begin
                                Field.Reset;
                                Field.SetRange(TableNo, RelatedRecRef.Number);
                                Field.SetRange(FieldName, 'Description');
                                if Field.FindFirst then
                                    InfoBoxValues[i] := RelatedRecRef.Field(Field."No.").Value;
                            end;
                            RelatedRecRef.Close;
                        end;
                    end else
                        InfoBoxValues[i] := GetSpecialValue(SourceFieldNo);
            end;
        end;
    end;


    procedure SetPrePosInfo(HeaderRecordVariant: Variant; var PrePosCaptions: array[6] of Text; var PrePosValues: array[6] of Text)
    var
        SetupRecRef: RecordRef;
        HeaderRecRef: RecordRef;
        RelatedRecRef: RecordRef;
        FieldRef: FieldRef;
        RelatedFieldRef: FieldRef;
        i: Integer;
        SourceFieldNo: Integer;
        "Field": Record "Field";
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        Location: Record Location;
        SalesPersonPurchaser: Record "Salesperson/Purchaser";
        TempBlob: Record TempBlob;
        InStr: InStream;
        User: Record User;
    begin
        if HeaderRecordVariant.IsRecord then
            HeaderRecRef.GetTable(HeaderRecordVariant);

        if HeaderRecordVariant.IsRecordId then
            HeaderRecRef.Get(HeaderRecordVariant);

        if HeaderRecordVariant.IsRecordRef then
            HeaderRecRef := HeaderRecordVariant;

        SetupRecRef.GetTable(Rec);
        for i := 1 to 6 do begin
            PrePosCaptions[i] := Format(SetupRecRef.Field(70 + i).Value);
            Evaluate(SourceFieldNo, Format(SetupRecRef.Field(80 + i).Value));
            case SourceFieldNo of
                23:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if PaymentTerms.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            PrePosValues[i] := PaymentTerms.Description
                        else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                27:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if ShipmentMethod.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            PrePosValues[i] := ShipmentMethod.Description
                        else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                28:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if Location.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            PrePosValues[i] := Location.Name
                        else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                43:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if SalesPersonPurchaser.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            PrePosValues[i] := SalesPersonPurchaser.Name
                        else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                else
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then begin
                        if Field.Type = Field.Type::Blob then begin
                            FieldRef := HeaderRecRef.Field(SourceFieldNo);
                            FieldRef.CalcField;
                            TempBlob.Blob := FieldRef.Value;
                            TempBlob.Blob.CreateInstream(InStr, Textencoding::Windows);
                            InStr.Read(PrePosValues[i]);
                        end else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                        if Field.RelationTableNo <> 0 then begin
                            RelatedRecRef.Open(Field.RelationTableNo);
                            Field.Reset;
                            Field.Get(RelatedRecRef.Number, RelatedRecRef.KeyIndex(1).FieldIndex(1).Number);
                            RelatedFieldRef := RelatedRecRef.Field(Field."No.");
                            RelatedFieldRef.SetRange(HeaderRecRef.Field(SourceFieldNo).Value);
                            if RelatedRecRef.FindFirst then begin
                                Field.Reset;
                                Field.SetRange(TableNo, RelatedRecRef.Number);
                                Field.SetRange(FieldName, 'Description');
                                if Field.FindFirst then
                                    PrePosValues[i] := RelatedRecRef.Field(Field."No.").Value;
                            end;
                            RelatedRecRef.Close;
                        end;
                    end else
                        PrePosValues[i] := GetSpecialValue(SourceFieldNo);
            end;

        end;
    end;


    procedure SetPostPosInfo(HeaderRecordVariant: Variant; var PrePosCaptions: array[2] of Text; var PrePosValues: array[2] of Text)
    var
        SetupRecRef: RecordRef;
        HeaderRecRef: RecordRef;
        FieldRef: FieldRef;
        RelatedRecRef: RecordRef;
        RelatedFieldRef: FieldRef;
        i: Integer;
        SourceFieldNo: Integer;
        "Field": Record "Field";
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        Location: Record Location;
        SalesPersonPurchaser: Record "Salesperson/Purchaser";
        TempBlob: Record TempBlob;
        InStr: InStream;
    begin
        if HeaderRecordVariant.IsRecord then
            HeaderRecRef.GetTable(HeaderRecordVariant);

        if HeaderRecordVariant.IsRecordId then
            HeaderRecRef.Get(HeaderRecordVariant);

        if HeaderRecordVariant.IsRecordRef then
            HeaderRecRef := HeaderRecordVariant;

        SetupRecRef.GetTable(Rec);
        for i := 1 to 2 do begin
            PrePosCaptions[i] := Format(SetupRecRef.Field(90 + i).Value);
            Evaluate(SourceFieldNo, Format(SetupRecRef.Field(100 + i).Value));
            case SourceFieldNo of
                23:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if PaymentTerms.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            PrePosValues[i] := PaymentTerms.Description
                        else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                27:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if ShipmentMethod.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            PrePosValues[i] := ShipmentMethod.Description
                        else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                28:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if Location.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            PrePosValues[i] := Location.Name
                        else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                43:
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then
                        if SalesPersonPurchaser.Get(Format(HeaderRecRef.Field(SourceFieldNo).Value)) then
                            PrePosValues[i] := SalesPersonPurchaser.Name
                        else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                else
                    if Field.Get(HeaderRecRef.Number, SourceFieldNo) then begin
                        if Field.Type = Field.Type::Blob then begin
                            FieldRef := HeaderRecRef.Field(SourceFieldNo);
                            FieldRef.CalcField;
                            TempBlob.Blob := FieldRef.Value;
                            TempBlob.Blob.CreateInstream(InStr, Textencoding::Windows);
                            InStr.Read(PrePosValues[i]);
                        end else
                            PrePosValues[i] := Format(HeaderRecRef.Field(SourceFieldNo).Value);

                        if Field.RelationTableNo <> 0 then begin
                            RelatedRecRef.Open(Field.RelationTableNo);
                            Field.Reset;
                            Field.Get(RelatedRecRef.Number, RelatedRecRef.KeyIndex(1).FieldIndex(1).Number);
                            RelatedFieldRef := RelatedRecRef.Field(Field."No.");
                            RelatedFieldRef.SetRange(HeaderRecRef.Field(SourceFieldNo).Value);
                            if RelatedRecRef.FindFirst then begin
                                Field.Reset;
                                Field.SetRange(TableNo, RelatedRecRef.Number);
                                Field.SetRange(FieldName, 'Description');
                                if Field.FindFirst then
                                    PrePosValues[i] := RelatedRecRef.Field(Field."No.").Value;
                            end;
                            RelatedRecRef.Close;
                        end;
                    end else
                        PrePosValues[i] := GetSpecialValue(SourceFieldNo);
            end;

        end;
    end;

    local procedure GetSpecialValue(Number: Integer) Value: Text
    var
        User: Record User;
    begin
        case Number of
            -1:
                if User.Get(UserSecurityId) then
                    exit(User."Full Name");
        end;
    end;
}

