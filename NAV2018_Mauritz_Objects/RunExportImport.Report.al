Report 80000 "Run Export / Import"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Run Export  Import.rdlc';
    Caption = 'Export / Import ausführen';

    dataset
    {
        dataitem(Header;"Export/Import Header")
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(ComanyLogo;CompanyInfo.Picture)
            {
            }
            column(Header_Code;Code)
            {
            }
            column(Header_Direction;Direction)
            {
            }
            column(Header_Description;Description)
            {
            }
            column(Header_TableNo;"Table No.")
            {
            }
            column(Header_ExportFileName;"Export File Name")
            {
            }
            column(Header_StartDateTime;StartDateTime)
            {
            }
            dataitem(LogEntry;"Export/Import Log Entry")
            {
                DataItemLink = Code=field(Code);
                DataItemTableView = sorting(Code,"Start Datetime","Entry No.") order(ascending);
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(LogEntry_Class;Format(Class, 0, '<Number>'))
                {
                }
                column(LogEntry_EntryNo;"Entry No.")
                {
                }
                column(LogEntry_Type;Format(Type, 0, '<Number>'))
                {
                }
                column(LogEntry_TypeText;Type)
                {
                }
                column(LogEntry_Message;Message)
                {
                }

                trigger OnPreDataItem()
                begin
                    SetFilter("Start Datetime", '%1..', StartDateTime);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                StartDateTime := CurrentDatetime;
                Proceed;
            end;
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

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        StartDateTime: DateTime;
}

