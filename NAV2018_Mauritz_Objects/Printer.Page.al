Page 50006 Printer
{
    PageType = List;
    SourceTable = Printer;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID;ID)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Driver;Driver)
                {
                    ApplicationArea = Basic;
                }
                field(Device;Device)
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

