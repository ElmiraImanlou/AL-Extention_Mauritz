Page 80001 "Export/import Card"
{
    PageType = Card;
    SourceTable = "Export/Import Header";

    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field("Code"; Code)
                {
                    ApplicationArea = Basic;
                }
                field(Direction; Direction)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if Direction <> xRec.Direction then
                            UpdateControls(true);
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(Type; Type)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if Type <> xRec.Type then
                            UpdateControls(true);
                    end;
                }
                field(Encoding; Encoding)
                {
                    ApplicationArea = Basic;
                }
                field("Table No."; "Table No.")
                {
                    ApplicationArea = Basic;
                }
                field("Record Separator"; "Record Separator")
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    var
                        Answer: Integer;
                    begin
                        Answer := StrMenu('beliebiger Zeilenwechsel,CRLF,LFCR,CR,LF');
                        case Answer of
                            1:
                                "Record Separator" := '\n\r|\r\n|\n|\r';
                            2:
                                "Record Separator" := '\r\n';
                            3:
                                "Record Separator" := '\n\r';
                            4:
                                "Record Separator" := '\r';
                            5:
                                "Record Separator" := '\n';
                        end;
                    end;
                }
                field("Field Separator"; "Field Separator")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Export)
            {
                Visible = DIRECTION_EXPORT;
                field("Export File Name"; "Export File Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = '%Y: Jahr (4-stellig)\%M: Monat (2-stellig)\%d: Tag (2-stellig)';
                }
            }
            group(Import)
            {
                Visible = DIRECTION_IMPORT;
                field("Post Processing Object Type"; "Post Processing Object Type")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if "Post Processing Object Type" <> xRec."Post Processing Object Type" then
                            UpdateControls(true);
                    end;
                }
                field("Post Processing Object ID"; "Post Processing Object ID")
                {
                    ApplicationArea = Basic;
                }
                field("Skip First Lines"; "Skip First Lines")
                {
                    ApplicationArea = Basic;
                }
                field("Import File Filter"; "Import File Filter")
                {
                    ApplicationArea = Basic;
                    ColumnSpan = 2;
                }
                field("Move File On Success"; "Move File On Success")
                {
                    ApplicationArea = Basic;
                }
                field("Move File On Error"; "Move File On Error")
                {
                    ApplicationArea = Basic;
                }
                field(OnExistingRecord; OnExistingRecord)
                {
                    ApplicationArea = Basic;
                }
            }
            part(ImportLines; "Import Lines Subpage")
            {
                Caption = 'Zeilen';
                SubPageLink = Code = field(Code);
                Visible = DIRECTION_IMPORT;
            }
            part(ExportLines; "Export Lines Subpage")
            {
                Caption = 'Zeilen';
                SubPageLink = Code = field(Code);
                Visible = DIRECTION_EXPORT;
            }
            part(ImportPreview; "Import Buffer Preview")
            {
                Caption = 'Vorschau';
                Visible = DIRECTION_IMPORT;
            }
            group(Vorschau)
            {
                Caption = 'Vorschau';
                Visible = DIRECTION_EXPORT;
                grid(Control50002)
                {
                    GridLayout = Rows;
                    Visible = DIRECTION_EXPORT;
                    group(Control50001)
                    {
                        field(ExportPreview; ExportPreview)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Vorschau';
                            ColumnSpan = 2;
                            MultiLine = true;
                            RowSpan = 3;
                            ShowCaption = false;
                            Visible = DIRECTION_EXPORT;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
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
            action(LoadPreview)
            {
                ApplicationArea = Basic;
                Caption = 'Vorschau';
                Image = PreviewChecks;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ExpImpMgmt: Codeunit "Export/Import Management";
                begin
                    ExportPreview := ExpImpMgmt.Preview(Rec);
                    CurrPage.Update(false);
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
                    ExpImp: Record "Export/Import Header";
                begin
                    ExpImp.SetRange(Code, Code);
                    SetupXMLport.SetTableview(ExpImp);
                    SetupXMLport.Run;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls(false);
    end;

    trigger OnOpenPage()
    begin
        UpdateControls(false);
    end;

    var
        DIRECTION_EXPORT: Boolean;
        DIRECTION_IMPORT: Boolean;
        EXPORT_HINTS: label '%Y: Jahr (4-stellig)\%M: Monat (2-stellig)\%d: Tag (2-stellig)';
        ExportPreview: Text;

    local procedure UpdateControls(SaveRecord: Boolean)
    begin
        DIRECTION_EXPORT := Direction = Direction::Export;
        DIRECTION_IMPORT := Direction = Direction::Import;
        case Direction of
            Direction::Import:
                begin
                    CurrPage.ImportLines.Page.SetFileFormat(Type);
                    CurrPage.ImportLines.Page.SetDirectImport("Post Processing Object Type" = "post processing object type"::" ");
                    CurrPage.ImportPreview.Page.SetHeader(Rec);
                end;
            Direction::Export:
                begin
                    CurrPage.ExportLines.Page.SetFileFormat(Type);
                end;
        end;
        CurrPage.Update(SaveRecord);
    end;
}

