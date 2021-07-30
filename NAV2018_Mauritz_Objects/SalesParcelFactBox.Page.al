Page 50010 "Sales Parcel FactBox"
{
    Caption = 'Pakete';
    PageType = ListPart;
    SourceTable = "Sales Parcel";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                }
                field("Tracking No.";"Tracking No.")
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

