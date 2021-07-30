Page 50013 "Sales Order Parcels Subpage"
{
    Caption = 'Pakete';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Sales Parcel";

    layout
    {
        area(content)
        {
            group("Anzahl Pakete")
            {
                Caption = 'Anzahl Pakete';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                field(NumberOfParcels; NumberOfParcels)
                {
                    ApplicationArea = Basic;
                    Caption = 'Anzahl Pakete';
                }
            }
            group(Details)
            {
                Caption = 'Details';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                Visible = false;
                field(ParcelWeight; ParcelWeight)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gewicht (kg)';
                    Visible = false;
                }
                field(LocationCode; LocationCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerort';
                    TableRelation = Location;
                    Visible = false;
                }
            }
            group(Services)
            {
                Caption = 'Services';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                field(doExpress; doExpress)
                {
                    ApplicationArea = Basic;
                    Caption = 'Expressversand';
                }
                field(CODAmount; CODAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nachnahme-Betrag (░)';
                }
                field(CODCurrency; CODCurrency)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nachnahme-Währung';
                    TableRelation = Currency;
                    Visible = false;
                }
            }
            repeater(Group)
            {
                Editable = false;
                Enabled = false;
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Weight; Weight)
                {
                    ApplicationArea = Basic;
                }
                field(Express; Express)
                {
                    ApplicationArea = Basic;
                }
                field("Parcel Order Date"; "Parcel Order Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Tracking No."; "Tracking No.")
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;
                    Editable = false;
                }
                field(Printed; Printed)
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Status Date"; "Status Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Delivered Date"; "Delivered Date")
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
            action(CreateAndPrintLabel)
            {
                ApplicationArea = Basic;
                Caption = 'Label erzeugen/drucken';
                Image = Shipment;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesParcel: Record "Sales Parcel";
                    SalesHeader: Record "Sales Header";
                    SalesHeaderArchive: Record "Sales Header Archive";
                    Location: Record Location;
                    ParcelManagement: Codeunit "Parcel Management";
                    i: Integer;
                    NextEntryNo: Integer;
                begin
                    if ((ParcelWeight <> 0) or (CODAmount <> 0)) and (NumberOfParcels <> 1) then
                        Error('Anzahl Pakete muss 1 sein, wenn Gewicht oder Nachnahmebetrag angegeben wird.');

                    SalesParcel.SetRange("Document Type", "Document Type");
                    SalesParcel.SetRange("Document No.", "Document No.");
                    if SalesParcel.FindLast then
                        NextEntryNo := SalesParcel."Entry No." + 1
                    else
                        NextEntryNo := 1;

                    for i := 1 to NumberOfParcels do begin
                        SalesParcel.Init;
                        SalesParcel."Document Type" := "Document Type";
                        SalesParcel."Document No." := "Document No.";
                        SalesParcel."Entry No." := NextEntryNo;
                        SalesParcel.Express := doExpress;
                        SalesParcel."Location Code" := LocationCode;
                        SalesParcel.Weight := ParcelWeight;
                        if CODAmount <> 0 then begin
                            SalesParcel."COD Amount" := CODAmount;
                            SalesParcel."COD Currency" := CODCurrency;
                        end;

                        SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."document type"::Order);
                        SalesHeaderArchive.SetRange("No.", "Document No.");
                        case true of
                            SalesHeader.Get(SalesHeader."document type"::Order, "Document No."):
                                begin
                                    SalesParcel."Sell-to Customer Name" := SalesHeader."Sell-to Customer Name";
                                    SalesParcel."Sell-to Customer Name 2" := SalesHeader."Sell-to Customer Name 2";
                                    SalesParcel."Sell-to Post Code" := SalesHeader."Sell-to Post Code";
                                    SalesParcel."Ship-to Name" := SalesHeader."Ship-to Name";
                                    SalesParcel."Ship-to Name 2" := SalesHeader."Ship-to Name 2";
                                    SalesParcel."Ship-to Post Code" := SalesHeader."Ship-to Post Code";
                                    SalesParcel."Ship-to Country/Region Code" := SalesHeader."Ship-to Country/Region Code";
                                end;
                            SalesHeaderArchive.FindLast:
                                begin
                                    SalesParcel."Sell-to Customer Name" := SalesHeaderArchive."Sell-to Customer Name";
                                    SalesParcel."Sell-to Customer Name 2" := SalesHeaderArchive."Sell-to Customer Name 2";
                                    SalesParcel."Sell-to Post Code" := SalesHeaderArchive."Sell-to Post Code";
                                    SalesParcel."Ship-to Name" := SalesHeaderArchive."Ship-to Name";
                                    SalesParcel."Ship-to Name 2" := SalesHeaderArchive."Ship-to Name 2";
                                    SalesParcel."Ship-to Post Code" := SalesHeaderArchive."Ship-to Post Code";
                                    SalesParcel."Ship-to Country/Region Code" := SalesHeaderArchive."Ship-to Country/Region Code";
                                    SalesHeader.Init;
                                    SalesHeader.TransferFields(SalesHeaderArchive);
                                    SalesHeader."Ship-to Name" := SalesHeaderRef.Field(SalesHeader.FieldNo("Ship-to Name")).Value;
                                    SalesHeader."Ship-to Name 2" := SalesHeaderRef.Field(SalesHeader.FieldNo("Ship-to Name 2")).Value;
                                    SalesHeader."Ship-to Contact" := SalesHeaderRef.Field(SalesHeader.FieldNo("Ship-to Contact")).Value;
                                    SalesHeader."Ship-to Address" := SalesHeaderRef.Field(SalesHeader.FieldNo("Ship-to Address")).Value;
                                    SalesHeader."Ship-to Address 2" := SalesHeaderRef.Field(SalesHeader.FieldNo("Ship-to Address 2")).Value;
                                    SalesHeader."Ship-to Post Code" := SalesHeaderRef.Field(SalesHeader.FieldNo("Ship-to Post Code")).Value;
                                    SalesHeader."Ship-to City" := SalesHeaderRef.Field(SalesHeader.FieldNo("Ship-to City")).Value;
                                    SalesHeader."Ship-to Country/Region Code" := SalesHeaderRef.Field(SalesHeader.FieldNo("Ship-to Country/Region Code")).Value;
                                end;
                        end;

                        if SalesParcel."Ship-to Name" = '' then begin
                            SalesParcel."Ship-to Name" := SalesParcel."Sell-to Customer Name";
                            SalesParcel."Ship-to Name 2" := SalesParcel."Sell-to Customer Name 2";
                            SalesParcel."Ship-to Post Code" := SalesParcel."Sell-to Post Code";
                        end;

                        if SalesParcel.Insert then begin
                            NextEntryNo += 1;
                            ParcelManagement.CreateAndPrintParcel(SalesHeader, SalesParcel);
                        end;
                    end;

                    CurrPage.Update(false);
                end;
            }
            action(ShowPDF)
            {
                ApplicationArea = Basic;
                Caption = 'Label anzeigen (PDF)';

                trigger OnAction()
                var
                    ParcelManagement: Codeunit "Parcel Management";
                begin
                    ParcelManagement.RePrintParcel(Rec);
                end;
            }
            action(Tracking)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    ParcelManagement: Codeunit "Parcel Management";
                begin
                    ParcelManagement.GetTrackingData(Rec);
                end;
            }
            action(ShowDebuggingOptions)
            {
                ApplicationArea = Basic;
                Caption = 'Debug';
                Image = ErrorLog;
                Promoted = true;
                PromotedCategory = Process;
                Visible = not ShowDebuggingOptions;

                trigger OnAction()
                begin
                    ShowDebuggingOptions := true;
                    CurrPage.Update(false);
                end;
            }
            action(ExportXMLRequest)
            {
                ApplicationArea = Basic;
                Caption = 'XMLRequest exportieren';
                Image = Export;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                Visible = ShowDebuggingOptions;

                trigger OnAction()
                var
                    TempBlob: Record TempBlob;
                    TempBlob1: Codeunit "Temp Blob";
                    InStr: InStream;
                    OutStr: OutStream;
                    FileManagement: Codeunit "File Management";
                begin
                    CalcFields("XML Request");
                    if "XML Request".Hasvalue then begin
                        "XML Request".CreateInstream(InStr);
                        TempBlob.Init;
                        TempBlob.Blob.CreateOutstream(OutStr);
                        CopyStream(OutStr, InStr);
                        FileManagement.BLOBExport(TempBlob1, StrSubstNo('%1_request.xml', "Tracking No."), true);
                    end;
                end;
            }
            action(ExportXMLResponse)
            {
                ApplicationArea = Basic;
                Caption = 'XMLResponse exportieren';
                Image = Export;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                Visible = ShowDebuggingOptions;

                trigger OnAction()
                var
                    TempBlob: Record TempBlob;
                    TempBlob1: Codeunit "Temp Blob";
                    InStr: InStream;
                    OutStr: OutStream;
                    FileManagement: Codeunit "File Management";
                begin
                    CalcFields("XML Response");
                    if "XML Response".Hasvalue then begin
                        "XML Response".CreateInstream(InStr);
                        TempBlob.Init;
                        TempBlob.Blob.CreateOutstream(OutStr);
                        CopyStream(OutStr, InStr);
                        FileManagement.BLOBExport(TempBlob1, StrSubstNo('%1_response.xml', "Tracking No."), true);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetDefaults;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        LastSalesParcel: Record "Sales Parcel";
        Location: Record Location;
    begin
        SetDefaults;
    end;

    trigger OnOpenPage()
    var
        Location: Record Location;
    begin
        if Location.Count = 1 then
            if Location.FindFirst then
                LocationCode := Location.Code;

        SetDefaults;
    end;

    var
        doExpress: Boolean;
        CODAmount: Decimal;
        CODCurrency: Code[10];
        NumberOfParcels: Integer;
        LocationCode: Code[10];
        ParcelWeight: Decimal;
        ShowDebuggingOptions: Boolean;
        SalesHeaderRef: RecordRef;


    procedure SetHeaderId(HeaderRef: RecordRef)
    begin
        SalesHeaderRef := HeaderRef;
    end;

    local procedure SetDefaults()
    begin
        NumberOfParcels := 1;
        doExpress := false;
        CODAmount := 0;
        Weight := 0;
    end;
}

