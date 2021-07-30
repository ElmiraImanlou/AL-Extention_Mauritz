Report 50013 Kontaktetiketten
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Kontaktetiketten.rdlc';
    Caption = 'Contact - Labels';

    dataset
    {
        dataitem(Contact;Contact)
        {
            RequestFilterFields = "No.",Name,Type,"Salesperson Code","Post Code","Territory Code","Country/Region Code";
            column(ReportForNavId_6698; 6698)
            {
            }
            column(ContAddr_1__1_;ContAddr[1])
            {
            }
            column(ContAddr_1__2_;ContAddr[2])
            {
            }
            column(ContAddr_1__3_;ContAddr[3])
            {
            }
            column(ContAddr_1__4_;ContAddr[4])
            {
            }
            column(ContAddr_1__5_;ContAddr[5])
            {
            }
            column(ContAddr_1__6_;ContAddr[6])
            {
            }
            column(ContAddr_1__7_;ContAddr[7])
            {
            }
            column(ContAddr_1__8_;ContAddr[8])
            {
            }

            trigger OnAfterGetRecord()
            var
                FilterContact: Record Contact;
            begin
                if FilterCode <> '' then begin
                  if not Rec.Get(FilterCode, Contact."Industry Group Code") then
                    CurrReport.Skip;

                  FilterContact.SetRange("No.", Contact."No.");
                  FilterContact.SetFilter("Territory Code", Rec."Contact Status Filter");
                  if not FilterContact.FindFirst then
                    CurrReport.Skip;
                end;

                FormatAddr.ContactAddr(ContAddr,Contact);
            end;
        }
    }

    requestpage
    {
        DeleteAllowed = false;
        InsertAllowed = false;
        ModifyAllowed = false;
        SaveValues = true;
        SourceTable = "Ind. Group Cont. Status Filter";

        layout
        {
            area(content)
            {
                group(Filtergruppe)
                {
                    Caption = 'Filtergruppe';
                    field(FilterCode;FilterCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Code';

                        trigger OnValidate()
                        begin
                            SetRange(Code, FilterCode);
                        end;
                    }
                }
                group(Details)
                {
                    Caption = 'Details';
                    Enabled = false;
                    repeater(Control50001)
                    {
                        field("Code";Code)
                        {
                            ApplicationArea = Basic;
                        }
                        field(Description;Description)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field("Industry Group Code";"Industry Group Code")
                        {
                            ApplicationArea = Basic;
                            TableRelation = "Industry Group";
                        }
                        field("Contact Status Filter";"Contact Status Filter")
                        {
                            ApplicationArea = Basic;
                        }
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(EditDetails)
                {
                    ApplicationArea = Basic;
                    Caption = 'Details bearbeiten';
                    Image = Edit;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        "Filter": Record "Ind. Group Cont. Status Filter";
                    begin
                        if FilterCode <> '' then
                          Filter.SetRange(Code, FilterCode);

                        Page.RunModal(50009, Filter);
                    end;
                }
            }
        }

        trigger OnNewRecord(BelowxRec: Boolean)
        begin
            if FilterCode <> '' then
              Code := FilterCode;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Commit;
    end;

    var
        FormatAddr: Codeunit "Format Address";
        LabelFormat: Option "36 x 70 mm (3 columns)","37 x 70 mm (3 columns)","36 x 105 mm (2 columns)","37 x 105 mm (2 columns)";
        ContAddr: array [8] of Text[50];
        FilterCode: Code[20];
        [InDataSet]
        SHOWFilter: Boolean;
}

