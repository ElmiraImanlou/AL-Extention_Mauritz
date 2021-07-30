Page 80003 "Export Lines Subpage"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Export Line";

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

                    trigger OnValidate()
                    begin
                        UpdateColumnAccess;
                    end;
                }

            }
            group(Source)
            {
                Caption = 'Quelle';
                group("Field")
                {
                    Caption = 'Feld';
                    Enabled = TYPE_FIELD;
                    field("Source Table No."; "Source Table No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Source Table Name"; "Source Table Name")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Source Field No."; "Source Field No.")
                    {
                        ApplicationArea = Basic;

                        trigger OnValidate()
                        begin
                            CalcFields("Source Field Name");
                            SourceFieldName := "Source Field Name";
                        end;
                    }
                    field(SourceFieldName; SourceFieldName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Feldname';
                        Editable = true;

                        trigger OnValidate()
                        var
                            "Field": Record "Field";
                        begin
                            Field.SetRange(TableNo, "Source Table No.");
                            Field.SetFilter("Field Caption", StrSubstNo('@%1*', SourceFieldName));
                            if not Field.FindFirst then
                                Field.SetFilter("Field Caption", StrSubstNo('@*%1*', SourceFieldName));
                            if Field.FindFirst then
                                "Source Field No." := Field."No.";

                            CalcFields("Source Field Name");
                            SourceFieldName := "Source Field Name";
                        end;
                    }
                }
                field("Source Field Filter"; "Source Field Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Do not export"; "Do not export")
                {
                    ApplicationArea = Basic;
                }
                group(FixValue)
                {
                    Caption = 'Fester Wert';
                    Enabled = TYPE_FIXVALUE or TYPE_FUNCTION;
                }
            }
            group(Destination)
            {
                Caption = 'Ziel';
                group(CSV)
                {
                    Caption = 'CSV';
                    Visible = TYPE_CSV;
                    field("Field Start Delimiter"; "Field Start Delimiter")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Field End Delimiter"; "Field End Delimiter")
                    {
                        ApplicationArea = Basic;
                    }
                }
                group(FixLength)
                {
                    Caption = 'Feste Länge';
                    Visible = TYPE_FIXLENGTH;
                    field(Length; Length)
                    {
                        ApplicationArea = Basic;
                    }
                    field("Fill Character"; "Fill Character")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Fill Before/After"; "Fill Before/After")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateColumnAccess;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CalcFields("Source Table No.");
        UpdateColumnAccess;
    end;

    var
        [InDataSet]
        TYPE_FIELD: Boolean;
        [InDataSet]
        TYPE_FIXVALUE: Boolean;
        TYPE_FUNCTION: Boolean;
        TYPE_CSV: Boolean;
        TYPE_FIXLENGTH: Boolean;
        SourceFieldName: Text;


    procedure SetFileFormat(ExportType: Option)
    var
        Header: Record "Export/Import Header";
    begin
        TYPE_CSV := ExportType = Header.Type::VarText;
        TYPE_FIXLENGTH := ExportType = Header.Type::FixText;
    end;

    local procedure UpdateColumnAccess()
    begin
        TYPE_FIELD := "Source Type" = "source type"::Field;
        TYPE_FIXVALUE := "Source Type" = "source type"::FixText;
        TYPE_FUNCTION := "Source Type" = "source type"::"Function";

        CalcFields("Source Field Name");
        SourceFieldName := "Source Field Name";
    end;
}

