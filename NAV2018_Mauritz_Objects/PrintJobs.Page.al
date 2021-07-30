Page 50004 "Print Jobs"
{
    Caption = 'Druckaufträge';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Print Job";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic;
                }
                field("FORMAT(""Record ID"")";Format("Record ID"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Datensatz';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("No OF Copies";"No OF Copies")
                {
                    ApplicationArea = Basic;
                }
                field(Finished;Finished)
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

