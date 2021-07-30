Page 80006 "Export / Import Log List"
{
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Export/Import Log Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Indent;
                IndentationControls = Message;
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(Message;Message)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Indent := Class;
    end;

    var
        [InDataSet]
        Indent: Integer;
}

