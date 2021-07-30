Page 50011 "Sales Order Parcel Card"
{
    ApplicationArea = Basic;
    Caption = 'Versand';
    PageType = Card;
    SourceTable = "Sales Header";
    SourceTableView = sorting("Document Type","No.")
                      order(ascending)
                      where("Document Type"=const(Order));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(OrderNo;OrderNo)
            {
                ApplicationArea = Basic;
                Caption = 'Auftragsnr.';

                trigger OnValidate()
                var
                    SalesOrder: Record "Sales Header";
                    SalesOrderArchive: Record "Sales Header Archive";
                    TempSalesOrder: Record "Sales Header" temporary;
                    Parcel: Page "Sales Order Parcel Card";
                begin
                    if not SalesOrder.Get(SalesOrder."document type"::Order, OrderNo) then begin
                      SalesOrderArchive.SetRange("Document Type", SalesOrderArchive."document type"::Order);
                      SalesOrderArchive.SetRange("No.", OrderNo);
                      if SalesOrderArchive.FindLast then begin
                        TempSalesOrder.TransferFields(SalesOrderArchive);
                        TempSalesOrder.Insert(false);
                        Page.RunModal(50011, TempSalesOrder);
                      end else
                        SalesOrder.Get(SalesOrder."document type"::Order, OrderNo);
                    end else begin
                      SetRange("No.", OrderNo);
                      CurrPage.Update(false);
                    end;
                end;
            }
            group("Order")
            {
                Caption = 'Auftrag';
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Your Reference";"Your Reference")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(BillToAddress;BillToAddress)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rechnungsanschrift';
                    Editable = false;
                    Enabled = false;
                    MultiLine = true;
                }
                part(Control50020;"Sales Order Parcel Subpage")
                {
                    Caption = 'Zeilen';
                    SubPageLink = "Document Type"=field("Document Type"),
                                  "Document No."=field("No.");
                    Visible = ShowLines;
                }
            }
            group(Parcel)
            {
                Caption = 'Lieferung';
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(ShipToAddress;ShipToAddress)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lieferanschrift';
                    Editable = false;
                    MultiLine = true;
                    Visible = not ShowEditShippingAddress;

                    trigger OnAssistEdit()
                    begin
                        ShowEditShippingAddress := not ShowEditShippingAddress;
                        ShipToAddress := GetShipToAddress;
                        CurrPage.Update(true);
                    end;
                }
                group(EditShippingAddress)
                {
                    Caption = 'Bearbeiten';
                    Visible = ShowEditShippingAddress;
                    field("Ship-to Name";"Ship-to Name")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Ship-to Name 2";"Ship-to Name 2")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Ship-to Address";"Ship-to Address")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Ship-to Address 2";"Ship-to Address 2")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Ship-to Post Code";"Ship-to Post Code")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Ship-to City";"Ship-to City")
                    {
                        ApplicationArea = Basic;
                    }
                }
                field("Shipping Avis to Email";"Shipping Avis to Email")
                {
                    ApplicationArea = Basic;
                }
                part(parcels;"Sales Order Parcels Subpage")
                {
                    Caption = 'Pakete';
                    ShowFilter = false;
                    SubPageLink = "Document Type"=const(SalesOrder),
                                  "Document No."=field("No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShipAndPost)
            {
                ApplicationArea = Basic;
                Caption = 'Liefern und Fakturieren';
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                begin
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter("Qty. to Ship", '<>%1', 0);
                    if SalesLine.IsEmpty then begin
                      Rec.SendToPosting(Codeunit::"Sales-Post (Yes/No)");
                      exit;
                    end;

                    if not Confirm(POST_COMPLETE, true) then
                      exit;

                    SalesLine.SetRange("Qty. to Ship");
                    if SalesLine.FindSet(true) then
                      repeat
                        SalesLine."Qty. to Ship" := SalesLine.Quantity;
                        SalesLine.Modify(true);
                      until SalesLine.Next = 0;

                    Rec.SendToPosting(Codeunit::"Sales-Post (Yes/No)");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        CurrPage.parcels.Page.SetHeaderId(RecRef);
    end;

    trigger OnAfterGetRecord()
    begin
        ShipToAddress := GetShipToAddress;
    end;

    trigger OnOpenPage()
    var
        RecRef: RecordRef;
    begin
        ShowLines := not IsTemporary;
    end;

    var
        OrderNo: Code[20];
        POST_COMPLETE: label 'Es wurde keine Liefermengen angegeben?\ \Komplett liefern/fakturieren?';
        ShowEditShippingAddress: Boolean;
        ShipToAddress: Text;
        ShowLines: Boolean;

    local procedure BillToAddress() Result: Text
    begin
        Result := "Bill-to Name";
        if "Bill-to Name 2" <> '' then begin
          Result[StrLen(Result)+1] += 10;
          Result += "Bill-to Name 2";
        end;

        Result[StrLen(Result)+1] += 10;

        Result += "Bill-to Address";
        Result += "Bill-to Address 2";
        Result[StrLen(Result)+1] += 10;

        Result += "Bill-to Post Code" + ' ' + "Bill-to City";
    end;

    local procedure GetShipToAddress() Result: Text
    begin
        if "Ship-to Name" = '' then
          exit;

        Result := "Ship-to Name";
        if "Ship-to Name 2" <> '' then begin
          Result[StrLen(Result)+1] += 10;
          Result += "Ship-to Name 2";
        end;
        Result[StrLen(Result)+1] += 10;

        Result += "Ship-to Address";
        Result += "Ship-to Address 2";
        Result[StrLen(Result)+1] += 10;

        if "Ship-to Country/Region Code" <> '' then
          Result += "Ship-to Country/Region Code" + '-';

        Result += "Ship-to Post Code" + ' ' + "Ship-to City";
    end;
}

