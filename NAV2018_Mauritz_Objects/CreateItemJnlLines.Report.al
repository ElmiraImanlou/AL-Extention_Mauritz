Report 50008 "Create Item Jnl Lines"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item;Item)
        {
            column(ReportForNavId_50000; 50000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ItemJournalLine.Copy(TemplateJnlLine);
                ItemJournalLine."Line No." := NextLineNo;
                ItemJournalLine.Validate("Item No.", "No.");
                ItemJournalLine.Insert(true);
                NextLineNo += 10000;
            end;

            trigger OnPreDataItem()
            begin
                ItemJournalLine.SetRange("Journal Template Name", TemplateJnlLine."Journal Template Name");
                ItemJournalLine.SetRange("Journal Batch Name", TemplateJnlLine."Journal Batch Name");
                if ItemJournalLine.FindLast then
                  NextLineNo := ItemJournalLine."Line No." + 10000
                else
                  NextLineNo := 10000;

                if Item.GetFilter("Location Filter") <> '' then
                  Location.SetFilter(Code, Item.GetFilter("Location Filter"));
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("TemplateJnlLine.""Journal Template Name""";TemplateJnlLine."Journal Template Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Buch.-Blattvorlagenname';
                    TableRelation = "Item Journal Template";
                }
                field("TemplateJnlLine.""Journal Batch Name""";TemplateJnlLine."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Buch.-Blattname';
                    TableRelation = "Item Journal Batch".Name;
                }
                field("TemplateJnlLine.""Posting Date""";TemplateJnlLine."Posting Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Buchungsdatum';
                }
                field("TemplateJnlLine.""Entry Type""";TemplateJnlLine."Entry Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Postenart';
                }
                field("TemplateJnlLine.""Document No.""";TemplateJnlLine."Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Belegnr.';
                }
                field("TemplateJnlLine.Description";TemplateJnlLine.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beschreibung';
                }
                field("TemplateJnlLine.""Location Code""";TemplateJnlLine."Location Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerortcode';
                    TableRelation = Location;
                }
                field("TemplateJnlLine.Quantity";TemplateJnlLine.Quantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        TemplateJnlLine: Record "Item Journal Line" temporary;
        ItemJournalLine: Record "Item Journal Line";
        Location: Record Location;
        NextLineNo: Integer;


    procedure SetJournal(JnlLine: Record "Item Journal Line")
    begin
        TemplateJnlLine."Journal Template Name" := JnlLine."Journal Template Name";
        TemplateJnlLine."Journal Batch Name" := JnlLine."Journal Batch Name";
    end;
}

