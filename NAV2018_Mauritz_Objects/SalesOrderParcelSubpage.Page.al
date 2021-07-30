Page 50012 "Sales Order Parcel Subpage"
{
    Caption = 'Zeilen';
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Sales Line";
    SourceTableView = sorting("Document Type","Document No.","Line No.")
                      order(ascending)
                      where(Type=const(Item));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Qty. to Ship";"Qty. to Ship")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

