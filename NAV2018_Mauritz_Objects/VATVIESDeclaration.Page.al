Page 60001 "VAT VIES Declaration"
{
    ApplicationArea = Basic;
    Caption = 'Zusammenfassende Meldung';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "VAT VIES Declaration";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                    ApplicationArea = Basic;
                    Editable = not "Transmission successfull";
                }
                field(Year; Year)
                {
                    ApplicationArea = Basic;
                    Editable = not "Transmission successfull";
                }
                field(Period; Period)
                {
                    ApplicationArea = Basic;
                    Editable = not "Transmission successfull";
                }
                field("From Date"; "From Date")
                {
                    ApplicationArea = Basic;
                    Editable = not "Transmission successfull";
                }
                field("To Date"; "To Date")
                {
                    ApplicationArea = Basic;
                    Editable = not "Transmission successfull";
                }
                field("VAT Posting Group Filter"; "VAT Posting Group Filter")
                {
                    ApplicationArea = Basic;
                    Editable = not "Transmission successfull";
                }
                field(Correction; Correction)
                {
                    ApplicationArea = Basic;
                    Editable = not "Transmission successfull";
                }
                field(Cancelation; Cancelation)
                {
                    ApplicationArea = Basic;
                    Editable = not "Transmission successfull";
                }
                field(Test; Test)
                {
                    ApplicationArea = Basic;
                }
                field("XML Document created"; "XML Document created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Transmission DateTime"; "Transmission DateTime")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Transmission successfull"; "Transmission successfull")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CreateXMLDocument)
            {
                ApplicationArea = Basic;
                Caption = 'Meldung erstellen';
                Enabled = not "XML Document created";
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLDoc: dotnet XmlDocument;
                    OutStr: OutStream;
                begin
                    if HalvotecERiCInterface.CreateZMDocument(XMLDoc, Rec) then begin
                        CalcFields("XML Document");
                        "XML Document".CreateOutstream(OutStr);
                        XMLDoc.Save(OutStr);
                        "XML Document created" := true;
                        Modify;
                    end;
                    CurrPage.Update(false);
                end;
            }
            action(ShowXMLDocument)
            {
                ApplicationArea = Basic;
                Caption = 'Meldung anzeigen';
                Enabled = "XML Document created";
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TransformXSL: Boolean;
                    Fallback: Boolean;
                    XMLDocInStr: InStream;
                    StylesheetInStr: InStream;
                    XMLDoc: dotnet XmlDocument;
                    XSLStylesheet: dotnet XslCompiledTransform;
                    XMLDocReader: dotnet XmlReader;
                    XMLDocWriter: dotnet XmlWriter;
                    StylesheetReader: dotnet XmlReader;
                    FileStream: dotnet FileStream;
                    FileMode: dotnet FileMode;
                    FileManagement: Codeunit "File Management";
                    ServerFilename: Text;
                    INVALID_XMLDOC: label 'Das %1 ist ungültig.\ \%2';
                    SHOW_DOCUMENT: label 'Dokument anzeigen';
                begin
                    if ERICSetup.Get then begin
                        ERICSetup.CalcFields("VIES Declaration XSL");
                        TransformXSL := ERICSetup."VIES Declaration XSL".Hasvalue;
                    end;

                    CalcFields("XML Document");
                    "XML Document".CreateInstream(XMLDocInStr);
                    XMLDocReader := XMLDocReader.Create(XMLDocInStr);

                    ServerFilename := FileManagement.ServerTempFileName('xml');

                    if TransformXSL then begin
                        ERICSetup."VIES Declaration XSL".CreateInstream(StylesheetInStr);
                        StylesheetReader := StylesheetReader.Create(StylesheetInStr);
                        Fallback := not LoadXSLStrylesheetFromXMLReader(XSLStylesheet, StylesheetReader);

                        if not Fallback then begin
                            FileStream := FileStream.FileStream(ServerFilename, FileMode.CreateNew);
                            XMLDocWriter := XMLDocWriter.Create(FileStream);
                            XSLStylesheet.Transform(XMLDocReader, XMLDocWriter);
                            FileStream.Close();
                        end else
                            Message(INVALID_XMLDOC, ERICSetup.FieldCaption("VIES Declaration XSL"), GetLastErrorText);
                    end else begin
                        XMLDoc := XMLDoc.XmlDocument();
                        Fallback := not LoadXMLDocFromXMLReader(XMLDoc, XMLDocReader);
                        if not Fallback then
                            XMLDoc.Save(ServerFilename)
                        else
                            Message(INVALID_XMLDOC, FieldCaption("XML Document"), GetLastErrorText);
                    end;

                    if Fallback then begin
                        "XML Document".CreateInstream(XMLDocInStr);
                        FileStream := FileStream.FileStream(ServerFilename, FileMode.CreateNew);
                        CopyStream(FileStream, XMLDocInStr);
                        FileStream.Close();
                    end;

                    if Fallback or not TransformXSL then
                        FileManagement.DownloadHandler(ServerFilename, SHOW_DOCUMENT, FileManagement.CreateClientTempSubDirectory(), '', StrSubstNo('%1.xml', Code))
                    else
                        FileManagement.DownloadHandler(ServerFilename, SHOW_DOCUMENT, FileManagement.CreateClientTempSubDirectory(), '', StrSubstNo('%1.html', Code));
                    //HYPERLINK(FileManagement.DownloadTempFile(ServerFilename));
                end;
            }
            action(TransmitXMLDocument)
            {
                ApplicationArea = Basic;
                Caption = 'Meldung übertragen';
                Enabled = "XML Document created";
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLDoc: dotnet XmlDocument;
                    OutStr: OutStream;
                begin
                    if HalvotecERiCInterface.TransmitZMDocument(Rec) then;
                    CurrPage.Update(true);
                end;
            }
            action(ShowResponse)
            {
                ApplicationArea = Basic;
                Caption = 'Rückmeldung anzeigen';
                Enabled = "Transmission successfull";
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    InStr: InStream;
                    OutStr: OutStream;
                    TempBlob: Record TempBlob;
                    TempBlob1: Codeunit "Temp Blob";
                begin
                    CalcFields("Transmission Response Document");
                    Rec."Transmission Response Document".CreateInstream(InStr);

                    TempBlob.Init;
                    TempBlob.Blob.CreateOutstream(OutStr);
                    CopyStream(OutStr, InStr);
                    FileManagement.BLOBExport(TempBlob1, StrSubstNo('%1.pdf', Code), true);

                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Code := GetNewCode;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        LastDeclaration: Record "VAT VIES Declaration";
    begin
        // Code := GetNewCode;
        if LastDeclaration.FindLast then begin
            Year := LastDeclaration.Year;
            Period := LastDeclaration.Period;
            "VAT Posting Group Filter" := LastDeclaration."VAT Posting Group Filter";

            case LastDeclaration.Period of
                1 .. 3, 21 .. 31:
                    Period := LastDeclaration.Period + 1;
                4:
                    begin
                        Year += 1;
                        Period := 1;
                    end;
                5:
                    Year += 1;
                11:
                    Period := 23;
                12:
                    Period := 26;
                13:
                    Period := 29;
                14:
                    Period := 32;
            end;

            Validate(Period);
        end;
    end;

    var
        HalvotecERiCInterface: Codeunit "Halvotec ERiC Interface";
        ERICSetup: Record "ERIC Setup";
        FileManagement: Codeunit "File Management";

    local procedure GetNewCode(): Code[20]
    var
        NoSeries: Record "No. Series";
        LastDeclaration: Record "VAT VIES Declaration";
        NOSMgmt: Codeunit NoSeriesManagement;
    begin
        if not ERICSetup.Get then
            exit;

        if NoSeries.Get(ERICSetup."VIES Declaration No. Series") then
            exit(NOSMgmt.GetNextNo(ERICSetup."VIES Declaration No. Series", WorkDate, true));

        if LastDeclaration.FindLast then
            exit(IncStr(LastDeclaration.Code));
    end;

    [TryFunction]
    local procedure LoadXMLDocFromXMLReader(var XMLDoc: dotnet XmlDocument; XMLReader: dotnet XmlReader)
    begin
        XMLDoc.Load(XMLReader);
    end;

    [TryFunction]
    local procedure LoadXSLStrylesheetFromXMLReader(var XSLStylesheet: dotnet XslCompiledTransform; XMLReader: dotnet XmlReader)
    begin
        if not IsNull(XSLStylesheet) then
            Clear(XSLStylesheet);
        XSLStylesheet := XSLStylesheet.XslCompiledTransform();
        XSLStylesheet.Load(XMLReader);
    end;
}

