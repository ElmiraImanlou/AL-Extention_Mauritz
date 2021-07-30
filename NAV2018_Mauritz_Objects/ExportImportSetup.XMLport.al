XmlPort 80000 "Export/Import Setup"
{

    schema
    {
        textelement(ExportImportSetupList)
        {
            tableelement("Export/Import Header";"Export/Import Header")
            {
                RequestFilterFields = Code,Type;
                XmlName = 'ExportImportSetup';
                SourceTableView = sorting(Code) order(ascending);
                fieldelement(Code;"Export/Import Header".Code)
                {
                }
                fieldelement(Direction;"Export/Import Header".Direction)
                {
                }
                fieldelement(Type;"Export/Import Header".Type)
                {
                }
                fieldelement(Encoding;"Export/Import Header".Encoding)
                {
                }
                fieldelement(Description;"Export/Import Header".Description)
                {
                }
                fieldelement(RecordSeparator;"Export/Import Header"."Record Separator")
                {
                }
                fieldelement(FieldSeparator;"Export/Import Header"."Field Separator")
                {
                }
                fieldelement(ImportObjectType;"Export/Import Header"."Post Processing Object Type")
                {
                }
                fieldelement(ImportObjectID;"Export/Import Header"."Post Processing Object ID")
                {
                }
                fieldelement(ImportFileFilter;"Export/Import Header"."Import File Filter")
                {
                }
                fieldelement(TableNo;"Export/Import Header"."Table No.")
                {
                }
                fieldelement(CaptionInFirstLine;"Export/Import Header"."Skip First Lines")
                {
                    MinOccurs = Zero;
                }
                fieldelement(MoveFileOnSuccess;"Export/Import Header"."Move File On Success")
                {
                    MinOccurs = Zero;
                }
                fieldelement(MoveFileOnError;"Export/Import Header"."Move File On Error")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ExportFileName;"Export/Import Header"."Export File Name")
                {
                }
                tableelement("Import Line";"Import Line")
                {
                    LinkTable = "Export/Import Header";
                    MinOccurs = Zero;
                    XmlName = 'ImportLine';
                    SourceTableView = sorting(Code,"Line No.") order(ascending);
                    fieldelement(Code;"Import Line".Code)
                    {
                    }
                    fieldelement(LineNo;"Import Line"."Line No.")
                    {
                    }
                    fieldelement(DestinationTableNo;"Import Line"."Destination Table No.")
                    {
                    }
                    fieldelement(DestinationFieldNo;"Import Line"."Destination Field No.")
                    {
                    }
                    fieldelement(Validate;"Import Line"."Validate Field")
                    {
                    }
                    fieldelement(SourceType;"Import Line"."Source Type")
                    {
                    }
                    fieldelement(SourceFieldNo;"Import Line"."Source Field No.")
                    {
                    }
                    fieldelement(SourceFieldName;"Import Line"."Source Field Name")
                    {
                    }
                    fieldelement(SourceStartDelimiter;"Import Line"."Source Field Start Delimiter")
                    {
                    }
                    fieldelement(SourceEndDelimiter;"Import Line"."Source Field End Delimiter")
                    {
                    }
                    fieldelement(SourcePosition;"Import Line"."Source Position")
                    {
                    }
                    fieldelement(SourceLength;"Import Line"."Source Length")
                    {
                    }
                    fieldelement(SourceValue;"Import Line"."Source Value")
                    {
                    }
                    fieldelement(RemovenCharsBefore;"Import Line"."Remove Chars Before")
                    {
                    }
                    fieldelement(RemoveCharsAfter;"Import Line"."Remove Chars After")
                    {
                    }
                    fieldelement(SourceNumSeries;"Import Line"."Source Number Series")
                    {
                    }
                    fieldelement(SourceFilter;"Import Line"."Source Filter")
                    {
                    }
                    fieldelement(SourceFieldFormatting;"Import Line"."Source Field Format String")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(RegexPattern;"Import Line"."Regex Pattern")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(RegexReplacement;"Import Line"."Regex Replacement")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(DestFormatting;"Import Line"."Destination Formatting")
                    {
                        MinOccurs = Zero;
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Import Line".SetRange(Code, "Export/Import Header".Code);
                    end;
                }
                tableelement("Export Line";"Export Line")
                {
                    LinkTable = "Export/Import Header";
                    MinOccurs = Zero;
                    XmlName = 'ExportLine';
                    SourceTableView = sorting(Code,"Line No.") order(ascending);
                    fieldelement(Code;"Export Line".Code)
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(LineNo;"Export Line"."Line No.")
                    {
                    }
                    fieldelement(SourceType;"Export Line"."Source Type")
                    {
                    }
                    fieldelement(SourceTableNo;"Export Line"."Source Table No.")
                    {
                    }
                    fieldelement(SourceFieldNo;"Export Line"."Source Field No.")
                    {
                    }
                    fieldelement(SourceValue;"Export Line"."Source Value")
                    {
                    }
                    fieldelement(SourceFieldFilter;"Export Line"."Source Field Filter")
                    {
                    }
                    fieldelement(StartDelimiter;"Export Line"."Field Start Delimiter")
                    {
                    }
                    fieldelement(EndDelimiter;"Export Line"."Field End Delimiter")
                    {
                    }
                    fieldelement(Length;"Export Line".Length)
                    {
                    }
                    fieldelement(FillCharacter;"Export Line"."Fill Character")
                    {
                    }
                    fieldelement(FillPosition;"Export Line"."Fill Before/After")
                    {
                    }
                    fieldelement(FormatPattern;"Export Line"."Format Pattern")
                    {
                    }
                    fieldelement(DoNotExport;"Export Line"."Do not export")
                    {
                        MinOccurs = Zero;
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Export Line".SetRange(Code, "Export/Import Header".Code);
                    end;

                    trigger OnAfterInitRecord()
                    begin
                        "Export Line".Code := "Export/Import Header".Code;
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

