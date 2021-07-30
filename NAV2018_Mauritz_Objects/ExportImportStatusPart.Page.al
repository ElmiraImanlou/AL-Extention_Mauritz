Page 80005 "Export / Import Status Part"
{
    Caption = 'Protokoll';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Export/Import Log Entry";
    SourceTableView = sorting(Code,"Start Datetime",Class,"Entry No.")
                      order(descending)
                      where(Class=const(ExportImport),
                            Type=const(Result));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Start Datetime";"Start Datetime")
                {
                    ApplicationArea = Basic;
                }
                field(Message;Message)
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    var
                        LogEntry: Record "Export/Import Log Entry";
                    begin
                        LogEntry.SetRange(Code, Code);
                        LogEntry.SetRange("Start Datetime", "Start Datetime");
                        Page.Run(Page::"Export / Import Log List", LogEntry);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ClearLog)
            {
                ApplicationArea = Basic;
                Caption = 'Protokoll leeren';
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LogEntry: Record "Export/Import Log Entry";
                begin
                    FilterGroup(4);
                    LogEntry.SetFilter(Code, GetFilter(Code));
                    LogEntry.DeleteAll;
                    FilterGroup(0);

                    CurrPage.Update(false);
                end;
            }
        }
    }
}

