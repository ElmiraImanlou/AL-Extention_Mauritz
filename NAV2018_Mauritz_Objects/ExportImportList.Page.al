Page 80000 "Export/Import List"
{
    ApplicationArea = Basic;
    Caption = 'Export / Import Übersicht';
    CardPageID = "Export/import Card";
    PageType = List;
    SourceTable = "Export/Import Header";
    UsageCategory = Lists;

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
                field(Direction;Direction)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000009;"Export / Import Status Part")
            {
                SubPageLink = Code=field(Code);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000006)
            {
                action(RunExportImport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Starten';
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Proceed;
                    end;
                }
                action(ExportImportSetup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Einrichtung laden/speichern';
                    Image = Setup;
                    Promoted = true;

                    trigger OnAction()
                    var
                        SetupXMLport: XmlPort "Export/Import Setup";
                    begin
                        SetupXMLport.SetTableview(Rec);
                        SetupXMLport.Run;
                    end;
                }
            }
        }
    }
}

