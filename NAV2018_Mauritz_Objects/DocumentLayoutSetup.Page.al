Page 50000 "Document Layout Setup"
{
    PageType = Card;
    SourceTable = "Document Layout Setup";

    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic;
                }
                field("Report Name";"Report Name")
                {
                    ApplicationArea = Basic;
                }
                field("Font Type";"Font Type")
                {
                    ApplicationArea = Basic;
                }
                field("Default Font Size";"Default Font Size")
                {
                    ApplicationArea = Basic;
                }
                field("Info Box Font Size";"Info Box Font Size")
                {
                    ApplicationArea = Basic;
                }
                field("Lines Font Size";"Lines Font Size")
                {
                    ApplicationArea = Basic;
                }
                field("Footer Font Size";"Footer Font Size")
                {
                    ApplicationArea = Basic;
                }
                field("Title Font Size";"Title Font Size")
                {
                    ApplicationArea = Basic;
                }
                field("Show Amount Sum Per VAT";"Show Amount Sum Per VAT")
                {
                    ApplicationArea = Basic;
                }
                field("Show Currency Per Line";"Show Currency Per Line")
                {
                    ApplicationArea = Basic;
                }
                field("Column Captions Bold";"Column Captions Bold")
                {
                    ApplicationArea = Basic;
                }
                field("Copy Text";"Copy Text")
                {
                    ApplicationArea = Basic;
                }
                field("Print In Background";"Print In Background")
                {
                    ApplicationArea = Basic;
                }
            }
            group(InfoBox)
            {
                Caption = 'InfoBox';
                field("InfoBox 1 Caption";"InfoBox 1 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 2 Caption";"InfoBox 2 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 3 Caption";"InfoBox 3 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 4 Caption";"InfoBox 4 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 5 Caption";"InfoBox 5 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 6 Caption";"InfoBox 6 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 7 Caption";"InfoBox 7 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 8 Caption";"InfoBox 8 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 1 Source";"InfoBox 1 Source")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 2 Source";"InfoBox 2 Source")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 3 Source";"InfoBox 3 Source")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 4 Source";"InfoBox 4 Source")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 5 Source";"InfoBox 5 Source")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 6 Source";"InfoBox 6 Source")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 7 Source";"InfoBox 7 Source")
                {
                    ApplicationArea = Basic;
                }
                field("InfoBox 8 Source";"InfoBox 8 Source")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Info vor Positionen")
            {
                Caption = 'Belegdaten vor Positionen';
                field("PrePos 1 Caption";"PrePos 1 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 2 Caption";"PrePos 2 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 3 Caption";"PrePos 3 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 4 Caption";"PrePos 4 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 5 Caption";"PrePos 5 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 6 Caption";"PrePos 6 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 1 Source";"PrePos 1 Source")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 2 Source";"PrePos 2 Source")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 3 Source";"PrePos 3 Source")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 4 Source";"PrePos 4 Source")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 5 Source";"PrePos 5 Source")
                {
                    ApplicationArea = Basic;
                }
                field("PrePos 6 Source";"PrePos 6 Source")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Info nach Positionen")
            {
                Caption = 'Belegdaten nach Positionen';
                field("PostPos 1 Caption";"PostPos 1 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("PostPos 2 Caption";"PostPos 2 Caption")
                {
                    ApplicationArea = Basic;
                }
                field("PostPos 1 Source";"PostPos 1 Source")
                {
                    ApplicationArea = Basic;
                }
                field("PostPos 2 Source";"PostPos 2 Source")
                {
                    ApplicationArea = Basic;
                }
            }
            group(DocFooter3Cols)
            {
                Caption = 'Belegfuß';
                field("Footer Columns";"Footer Columns")
                {
                    ApplicationArea = Basic;
                }
                grid(Control60103)
                {
                    GridLayout = Rows;
                    group(Control60100)
                    {
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Rows;
                        field(FooterHTML1;FooterCol[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Spalte 1 (HTML)';
                            ColumnSpan = 2;
                            MultiLine = true;

                            trigger OnValidate()
                            var
                                OutStr: OutStream;
                            begin
                                CalcFields("Footer Column 1 HTML");
                                "Footer Column 1 HTML".CreateOutstream(OutStr);
                                OutStr.Write(FooterCol[1]);
                            end;
                        }
                        field("Footer Column 1 Image";"Footer Column 1 Image")
                        {
                            ApplicationArea = Basic;
                        }
                    }
                    group(Control60104)
                    {
                        Visible = "Footer Columns">=2;
                        field(FooterHTML2;FooterCol[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Spalte 2 (HTML)';
                            ColumnSpan = 2;
                            MultiLine = true;

                            trigger OnValidate()
                            var
                                OutStr: OutStream;
                            begin
                                CalcFields("Footer Column 2 HTML");
                                "Footer Column 2 HTML".CreateOutstream(OutStr);
                                OutStr.Write(FooterCol[2]);
                            end;
                        }
                        field("Footer Column 2 Image";"Footer Column 2 Image")
                        {
                            ApplicationArea = Basic;
                        }
                    }
                    group(Control60101)
                    {
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Rows;
                        Visible = "Footer Columns">=3;
                        field(FooterHTML3;FooterCol[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Spalte 3 (HTML)';
                            ColumnSpan = 2;
                            MultiLine = true;

                            trigger OnValidate()
                            var
                                OutStr: OutStream;
                            begin
                                CalcFields("Footer Column 3 HTML");
                                "Footer Column 3 HTML".CreateOutstream(OutStr);
                                OutStr.Write(FooterCol[3]);
                            end;
                        }
                        field("Footer Column 3 Image";"Footer Column 3 Image")
                        {
                            ApplicationArea = Basic;
                        }
                    }
                    group(Control60107)
                    {
                        Visible = "Footer Columns">=4;
                        field(FooterHTML4;FooterCol[4])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Spalte 4 (HTML)';
                            ColumnSpan = 2;
                            MultiLine = true;

                            trigger OnValidate()
                            var
                                OutStr: OutStream;
                            begin
                                CalcFields("Footer Column 4 HTML");
                                "Footer Column 4 HTML".CreateOutstream(OutStr);
                                OutStr.Write(FooterCol[4]);
                            end;
                        }
                        field("Footer Column 4 Image";"Footer Column 4 Image")
                        {
                            ApplicationArea = Basic;
                        }
                    }
                    group(Control60102)
                    {
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Rows;
                        Visible = "Footer Columns">=5;
                        field(FooterHTML5;FooterCol[5])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Spalte 5 (HTML)';
                            ColumnSpan = 2;
                            MultiLine = true;

                            trigger OnValidate()
                            var
                                OutStr: OutStream;
                            begin
                                CalcFields("Footer Column 5 HTML");
                                "Footer Column 5 HTML".CreateOutstream(OutStr);
                                OutStr.Write(FooterCol[5]);
                            end;
                        }
                        field("Footer Column 5 Image";"Footer Column 5 Image")
                        {
                            ApplicationArea = Basic;
                        }
                    }
                    group(Control60110)
                    {
                        Visible = "Footer Columns"=6;
                        field(FooterHTML6;FooterCol[6])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Spalte 6 (HTML)';
                            ColumnSpan = 2;
                            MultiLine = true;

                            trigger OnValidate()
                            var
                                OutStr: OutStream;
                            begin
                                CalcFields("Footer Column 6 HTML");
                                "Footer Column 6 HTML".CreateOutstream(OutStr);
                                OutStr.Write(FooterCol[6]);
                            end;
                        }
                        field("Footer Column 6 Image";"Footer Column 6 Image")
                        {
                            ApplicationArea = Basic;
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
            action(SaveAsXML)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Message(GetLayoutPropertiesAsXML);
                end;
            }
            action(Copy)
            {
                ApplicationArea = Basic;
                Caption = 'Kopieren von';
                Image = Copy;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Source: Record "Document Layout Setup";
                begin
                    if Page.RunModal(50001, Source) = Action::LookupOK then begin
                      "Footer Columns" := Source."Footer Columns";
                      "Font Type" := Source."Font Type";
                      "Default Font Size" := Source."Default Font Size";
                      "Lines Font Size" := Source."Lines Font Size";
                      "Footer Font Size" := Source."Footer Font Size";
                      "Show Amount Sum Per VAT" := Source."Show Amount Sum Per VAT";
                      "Show Currency Per Line" := Source."Show Currency Per Line";
                      "Column Captions Bold" := Source."Column Captions Bold";
                      "Info Box Font Size" := Source."Info Box Font Size";
                      "Title Font Size" := Source."Title Font Size";
                      "InfoBox 1 Caption" := Source."InfoBox 1 Caption";
                      "InfoBox 2 Caption" := Source."InfoBox 2 Caption";
                      "InfoBox 3 Caption" := Source."InfoBox 3 Caption";
                      "InfoBox 4 Caption" := Source."InfoBox 4 Caption";
                      "InfoBox 5 Caption" := Source."InfoBox 5 Caption";
                      "InfoBox 6 Caption" := Source."InfoBox 6 Caption";
                      "InfoBox 7 Caption" := Source."InfoBox 7 Caption";
                      "InfoBox 8 Caption" := Source."InfoBox 8 Caption";
                      "InfoBox 1 Source" := Source."InfoBox 1 Source";
                      "InfoBox 2 Source" := Source."InfoBox 2 Source";
                      "InfoBox 3 Source" := Source."InfoBox 3 Source";
                      "InfoBox 4 Source" := Source."InfoBox 4 Source";
                      "InfoBox 5 Source" := Source."InfoBox 5 Source";
                      "InfoBox 6 Source" := Source."InfoBox 6 Source";
                      "InfoBox 7 Source" := Source."InfoBox 7 Source";
                      "InfoBox 8 Source" := Source."InfoBox 8 Source";
                      "PrePos 1 Caption" := Source."PrePos 1 Caption";
                      "PrePos 2 Caption" := Source."PrePos 2 Caption";
                      "PrePos 3 Caption" := Source."PrePos 3 Caption";
                      "PrePos 4 Caption" := Source."PrePos 4 Caption";
                      "PrePos 5 Caption" := Source."PrePos 5 Caption";
                      "PrePos 6 Caption" := Source."PrePos 6 Caption";
                      "PrePos 1 Source" := Source."PrePos 1 Source";
                      "PrePos 2 Source" := Source."PrePos 2 Source";
                      "PrePos 3 Source" := Source."PrePos 3 Source";
                      "PrePos 4 Source" := Source."PrePos 4 Source";
                      "PrePos 5 Source" := Source."PrePos 5 Source";
                      "PrePos 6 Source" := Source."PrePos 6 Source";
                      "PostPos 1 Caption" := Source."PostPos 1 Caption";
                      "PostPos 2 Caption" := Source."PostPos 2 Caption";
                      "PostPos 1 Source" := Source."PostPos 1 Source";
                      "PostPos 2 Source" := Source."PostPos 2 Source";

                      Source.CalcFields("Footer Column 1 HTML");
                      "Footer Column 1 HTML" := Source."Footer Column 1 HTML";
                      Source.CalcFields("Footer Column 2 HTML");
                      "Footer Column 2 HTML" := Source."Footer Column 2 HTML";
                      Source.CalcFields("Footer Column 3 HTML");
                      "Footer Column 3 HTML" := Source."Footer Column 3 HTML";
                      Source.CalcFields("Footer Column 4 HTML");
                      "Footer Column 4 HTML" := Source."Footer Column 4 HTML";
                      Source.CalcFields("Footer Column 5 HTML");
                      "Footer Column 5 HTML" := Source."Footer Column 5 HTML";
                      Source.CalcFields("Footer Column 6 HTML");
                      "Footer Column 6 HTML" := Source."Footer Column 6 HTML";

                      Source.CalcFields("Footer Column 1 Image");
                      "Footer Column 1 Image" := Source."Footer Column 1 Image";
                      Source.CalcFields("Footer Column 2 Image");
                      "Footer Column 2 Image" := Source."Footer Column 2 Image";
                      Source.CalcFields("Footer Column 3 Image");
                      "Footer Column 3 Image" := Source."Footer Column 3 Image";
                      Source.CalcFields("Footer Column 4 Image");
                      "Footer Column 4 Image" := Source."Footer Column 4 Image";
                      Source.CalcFields("Footer Column 5 Image");
                      "Footer Column 5 Image" := Source."Footer Column 5 Image";
                      Source.CalcFields("Footer Column 6 Image");
                      "Footer Column 6 Image" := Source."Footer Column 6 Image";

                      Modify(false);
                      CurrPage.Update(false);
                    end;
                end;
            }
            action(PrintJobs)
            {
                ApplicationArea = Basic;
                Caption = 'Druckaufträge';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Print Jobs";
                RunPageLink = "Report ID"=field("Report ID");
                RunPageView = sorting(Finished,"User ID")
                              order(ascending);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LoadFooterTexts;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Template: Record "Document Layout Setup";
    begin
    end;

    var
        FooterCol: array [6] of Text;

    local procedure LoadFooterTexts()
    var
        InStr: InStream;
    begin
        CalcFields("Footer Column 1 HTML");
        if "Footer Column 1 HTML".Hasvalue then begin
          "Footer Column 1 HTML".CreateInstream(InStr);
          InStr.Read(FooterCol[1]);
          Clear(InStr);
        end;

        CalcFields("Footer Column 2 HTML");
        if "Footer Column 2 HTML".Hasvalue then begin
          "Footer Column 2 HTML".CreateInstream(InStr);
          InStr.Read(FooterCol[2]);
          Clear(InStr);
        end;

        CalcFields("Footer Column 3 HTML");
        if "Footer Column 3 HTML".Hasvalue then begin
          "Footer Column 3 HTML".CreateInstream(InStr);
          InStr.Read(FooterCol[3]);
          Clear(InStr);
        end;

        CalcFields("Footer Column 4 HTML");
        if "Footer Column 4 HTML".Hasvalue then begin
          "Footer Column 4 HTML".CreateInstream(InStr);
          InStr.Read(FooterCol[4]);
          Clear(InStr);
        end;

        CalcFields("Footer Column 5 HTML");
        if "Footer Column 5 HTML".Hasvalue then begin
          "Footer Column 5 HTML".CreateInstream(InStr);
          InStr.Read(FooterCol[5]);
          Clear(InStr);
        end;

        CalcFields("Footer Column 6 HTML");
        if "Footer Column 6 HTML".Hasvalue then begin
          "Footer Column 6 HTML".CreateInstream(InStr);
          InStr.Read(FooterCol[6]);
          Clear(InStr);
        end;
    end;
}

