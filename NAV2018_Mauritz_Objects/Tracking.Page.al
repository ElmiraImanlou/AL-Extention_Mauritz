Page 50014 Tracking
{
    ApplicationArea = Basic;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Parcel";
    SourceTableView = sorting("Parcel Order Date")
                      order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = Status;
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = ShowWarning;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = ShowWarning;
                }
                field("Tracking No.";"Tracking No.")
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = ShowWarning;
                }
                field(Express;Express)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = ShowWarning;
                }
                field("Parcel Order Date";"Parcel Order Date")
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = ShowWarning;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = ShowWarning;
                }
                field("Status Date";"Status Date")
                {
                    ApplicationArea = Basic;
                }
                field("Delivered Date";"Delivered Date")
                {
                    ApplicationArea = Basic;
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                }
                field(Info;Info)
                {
                    ApplicationArea = Basic;
                }
                field(ShipToAddress;ShipToAddress)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lief. an Adresse';
                    Editable = false;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer Name 2";"Sell-to Customer Name 2")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Name 2";"Ship-to Name 2")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Tracking)
            {
                ApplicationArea = All;
                Caption = 'Alle offenen Sendungen verfolgen';
                Image = Track;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Codeunit "Parcel Management";
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Regex: dotnet Regex;
    begin
        case "Document Type" of
          "document type"::SalesOrder:
            begin
              SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."document type"::Order);
              SalesHeaderArchive.SetRange("No.", "Document No.");
              case true of
                SalesHeader.Get(SalesHeader."document type"::Order, "Document No."):
                  with SalesHeader do
                    if "Ship-to Address" <> '' then
                      ShipToAddress := StrSubstNo('%1 %2 - %3 %4 - %5 %6', "Ship-to Name", "Ship-to Name 2", "Ship-to Address", "Ship-to Address 2", "Ship-to Post Code", "Ship-to City")
                    else
                      ShipToAddress := StrSubstNo('%1 %2 - %3 %4 - %5 %6', "Sell-to Customer Name", "Sell-to Customer Name 2", "Sell-to Address", "Sell-to Address 2", "Sell-to Post Code", "Sell-to City");
                SalesHeaderArchive.FindLast:
                  with SalesHeaderArchive do
                    if "Ship-to Address" <> '' then
                      ShipToAddress := StrSubstNo('%1 %2 - %3 %4 - %5 %6', "Ship-to Name", "Ship-to Name 2", "Ship-to Address", "Ship-to Address 2", "Ship-to Post Code", "Ship-to City")
                    else
                      ShipToAddress := StrSubstNo('%1 %2 - %3 %4 - %5 %6', "Sell-to Customer Name", "Sell-to Customer Name 2", "Sell-to Address", "Sell-to Address 2", "Sell-to Post Code", "Sell-to City");
              end;
            end;
          "document type"::SalesReturnOrder:
            if SalesHeader.Get(SalesHeader."document type"::"Return Order", "Document No.") then
              with SalesHeader do
                if "Ship-to Address" = '' then
                  ShipToAddress := StrSubstNo('%1 %2 - %3 %4 - %5 %6', "Ship-to Name", "Ship-to Name 2", "Ship-to Address", "Ship-to Address 2", "Ship-to Post Code", "Ship-to City")
                else
                  ShipToAddress := StrSubstNo('%1 %2 - %3 %4 - %5 %6', "Sell-to Customer Name", "Sell-to Customer Name 2", "Sell-to Address", "Sell-to Address 2", "Sell-to Post Code", "Sell-to City");
          "document type"::PostedSalesShipment:
            if SalesShipmentHeader.Get("Document No.") then
              with SalesShipmentHeader do
                if "Ship-to Address" = '' then
                  ShipToAddress := StrSubstNo('%1 %2 - %3 %4 - %5 %6', "Ship-to Name", "Ship-to Name 2", "Ship-to Address", "Ship-to Address 2", "Ship-to Post Code", "Ship-to City")
                else
                  ShipToAddress := StrSubstNo('%1 %2 - %3 %4 - %5 %6', "Sell-to Customer Name", "Sell-to Customer Name 2", "Sell-to Address", "Sell-to Address 2", "Sell-to Post Code", "Sell-to City");
        end;

        ShipToAddress := Regex.Replace(ShipToAddress, '[ \t][ \t]+', ' ');

        ShowWarning := GetShowWarning;
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesShipmentHeader: Record "Sales Shipment Header";
        [InDataSet]
        ShipToAddress: Text;
        [InDataSet]
        ShowWarning: Boolean;

    local procedure GetShowWarning() Warning: Boolean
    begin
        if Status = Status::DELIVERED then
          exit(false);

        exit((WorkDate - "Parcel Order Date") >= 3);
    end;
}

