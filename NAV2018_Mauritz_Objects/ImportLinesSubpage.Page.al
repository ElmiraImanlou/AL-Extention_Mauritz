Page 80002 "Import Lines Subpage"
{
    AutoSplitKey = true;
    Caption = 'Zeilen';
    PageType = ListPart;
    SourceTable = "Import Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }

                field("Source Type"; "Source Type")
                {
                    ApplicationArea = Basic;
                }

                field("Source Field Name"; "Source Field Name")
                {
                    ApplicationArea = Basic;
                }

                field("Source Value"; "Source Value")
                {
                    ApplicationArea = Basic;
                }
                field("Source Number Series"; "Source Number Series")
                {
                    ApplicationArea = Basic;
                    Editable = "Source Type" = "Source Type"::NumberSeries;
                }
            }
            group(FixLength)
            {
                Caption = 'Feste Länge';
                Visible = TYPE_FIXLENGTH;
                field("Source Position"; "Source Position")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Source Length"; "Source Length")
                {
                    ApplicationArea = Basic;
                }
            }
            group(CSV)
            {
                Caption = 'CSV';
                Visible = TYPE_CSV;
                field("Source Field No."; "Source Field No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(DirectImport)
            {
                Caption = 'Zieltabelle';
                Visible = IS_DIRECTIMPORT;
                field("Destination Field No."; "Destination Field No.")
                {
                    ApplicationArea = Basic;
                    ColumnSpan = 2;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                    begin
                        CalcFields("Destination Table No.");
                        Field.SetRange(TableNo, "Destination Table No.");

                        if Page.RunModal(Page::"Fields Lookup", Field) = Action::LookupOK then //"Field List"
                            Validate("Destination Field No.", Field."No.");
                    end;

                    trigger OnValidate()
                    begin
                        CalcFields("Destination Field Name");
                        DestinationFieldName := "Destination Field Name";
                        CurrPage.Update(false);
                    end;
                }
                field(DestinationFieldName; DestinationFieldName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Feldname';
                    ShowCaption = false;

                    trigger OnValidate()
                    var
                        "Field": Record "Field";
                    begin
                        Field.SetRange(TableNo, "Destination Table No.");
                        Field.SetFilter("Field Caption", StrSubstNo('@%1*', DestinationFieldName));
                        if not Field.FindFirst then
                            Field.SetFilter("Field Caption", StrSubstNo('@*%1*', DestinationFieldName));
                        if Field.FindFirst then
                            "Destination Field No." := Field."No.";

                        CalcFields("Destination Field Name");
                        DestinationFieldName := "Destination Field Name";
                    end;
                }
            }

            group(Erweitert)
            {
                Caption = 'Erweitert';
                Visible = ShowExtendedOptions;
                field("Source Filter"; "Source Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Source Field Format String"; "Source Field Format String")
                {
                    ApplicationArea = Basic;
                }
                field("Validate Field"; "Validate Field")
                {
                    ApplicationArea = Basic;
                }
                field("Source Field Start Delimiter"; "Source Field Start Delimiter")
                {
                    ApplicationArea = Basic;
                }
                field("Source Field End Delimiter"; "Source Field End Delimiter")
                {
                    ApplicationArea = Basic;
                }
                field("Remove Chars Before"; "Remove Chars Before")
                {
                    ApplicationArea = Basic;
                }
                field("Remove Chars After"; "Remove Chars After")
                {
                    ApplicationArea = Basic;
                }
                field("Regex Pattern"; "Regex Pattern")
                {
                    ApplicationArea = Basic;
                }
                field("Regex Replacement"; "Regex Replacement")
                {
                    ApplicationArea = Basic;
                }
                field("Destination Formatting"; "Destination Formatting")
                {
                    ApplicationArea = Basic;
                    ToolTip = '[AUFFÜLLEN;]MUSTER[;AUFFÜLLEN]';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowExtended)
            {
                ApplicationArea = Basic;
                Caption = 'Erw. Einstellungen anzeigen/ausblenden';
                Image = ExtendedDataEntry;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowExtendedOptions := not ShowExtendedOptions;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields("Destination Field Name");
        DestinationFieldName := "Destination Field Name";
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Destination Table No.");
        CalcFields("Destination Field Name");
        DestinationFieldName := "Destination Field Name";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if BelowxRec then
            if (xRec."Source Type" = xRec."source type"::Field) and (xRec."Source Position" <> 0) and (xRec."Source Length" <> 0) then
                "Source Position" := xRec."Source Position" + xRec."Source Length";

        CalcFields("Destination Table No.");
    end;

    var
        Header: Record "Export/Import Header";
        TYPE_CSV: Boolean;
        TYPE_FIXLENGTH: Boolean;
        IS_DIRECTIMPORT: Boolean;
        DestinationFieldName: Text[50];
        ShowExtendedOptions: Boolean;

    local procedure SetHeader(ImportHeader: Record "Export/Import Header")
    begin
        Header := ImportHeader;
    end;


    procedure SetFileFormat(FileFormat: Option)
    var
        Header: Record "Export/Import Header";
    begin
        TYPE_FIXLENGTH := FileFormat = Header.Type::FixText;
        TYPE_CSV := FileFormat = Header.Type::VarText;
    end;


    procedure SetDirectImport(DirectImport: Boolean)
    begin
        IS_DIRECTIMPORT := DirectImport;
    end;
}

