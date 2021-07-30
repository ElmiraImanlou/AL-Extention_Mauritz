Page 50001 "Document Layout Setup List"
{
    ApplicationArea = Basic;
    Caption = 'Berichtslayout Einrichtung Übersicht';
    CardPageID = "Document Layout Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Document Layout Setup";
    UsageCategory = Lists;

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
                field("Report Name";"Report Name")
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

