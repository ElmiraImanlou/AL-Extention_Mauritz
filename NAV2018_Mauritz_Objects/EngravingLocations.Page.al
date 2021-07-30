Page 50002 "Engraving Locations"
{
    Caption = 'Gravurorte';
    PageType = List;
    SourceTable = "Engraving Location";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
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

