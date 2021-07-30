Report 50012 "Überweisungsjournal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Überweisungsjournal.rdlc';

    dataset
    {
        dataitem("Credit Transfer Register";"Credit Transfer Register")
        {
            column(ReportForNavId_50000; 50000)
            {
            }
            column(No_CreditTransferRegister;"Credit Transfer Register"."No.")
            {
            }
            column(CreatedDateTime_CreditTransferRegister;"Credit Transfer Register"."Created Date-Time")
            {
            }
            column(CreatedbyUser_CreditTransferRegister;"Credit Transfer Register"."Created by User")
            {
            }
            column(Status_CreditTransferRegister;"Credit Transfer Register".Status)
            {
            }
            column(NoofTransfers_CreditTransferRegister;"Credit Transfer Register"."No. of Transfers")
            {
            }
            column(FromBankAccountNo_CreditTransferRegister;"Credit Transfer Register"."From Bank Account No.")
            {
            }
            column(FromBankAccountName_CreditTransferRegister;"Credit Transfer Register"."From Bank Account Name")
            {
            }
            dataitem("Credit Transfer Entry";"Credit Transfer Entry")
            {
                DataItemLink = "Credit Transfer Register No."=field("No.");
                column(ReportForNavId_50008; 50008)
                {
                }
                column(EntryNo_CreditTransferEntry;"Credit Transfer Entry"."Entry No.")
                {
                }
                column(AccountType_CreditTransferEntry;"Credit Transfer Entry"."Account Type")
                {
                }
                column(AccountNo_CreditTransferEntry;"Credit Transfer Entry"."Account No.")
                {
                }
                column(AppliestoEntryNo_CreditTransferEntry;"Credit Transfer Entry"."Applies-to Entry No.")
                {
                }
                column(TransferDate_CreditTransferEntry;"Credit Transfer Entry"."Transfer Date")
                {
                }
                column(CurrencyCode_CreditTransferEntry;"Credit Transfer Entry"."Currency Code")
                {
                }
                column(TransferAmount_CreditTransferEntry;"Credit Transfer Entry"."Transfer Amount")
                {
                }
                column(Canceled_CreditTransferEntry;"Credit Transfer Entry".Canceled)
                {
                }
                column(RecipientBankAccNo_CreditTransferEntry;"Credit Transfer Entry"."Recipient Bank Acc. No.")
                {
                }
                column(MessagetoRecipient_CreditTransferEntry;"Credit Transfer Entry"."Message to Recipient")
                {
                }
                column(CreditorName_CreditTransferEntry;"Credit Transfer Entry".CreditorName)
                {
                }
                dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
                {
                    column(ReportForNavId_50019; 50019)
                    {
                    }
                    column(PostingDate_VendorLedgerEntry;"Vendor Ledger Entry"."Posting Date")
                    {
                    }
                    column(DocumentType_VendorLedgerEntry;"Vendor Ledger Entry"."Document Type")
                    {
                    }
                    column(DocumentNo_VendorLedgerEntry;"Vendor Ledger Entry"."Document No.")
                    {
                    }
                    column(Description_VendorLedgerEntry;"Vendor Ledger Entry".Description)
                    {
                    }
                    column(CurrencyCode_VendorLedgerEntry;"Vendor Ledger Entry"."Currency Code")
                    {
                    }
                    column(Amount_VendorLedgerEntry;"Vendor Ledger Entry".Amount)
                    {
                    }
                    column(RemainingAmount_VendorLedgerEntry;"Vendor Ledger Entry"."Remaining Amount")
                    {
                    }
                    column(OriginalAmtLCY_VendorLedgerEntry;"Vendor Ledger Entry"."Original Amt. (LCY)")
                    {
                    }
                    column(RemainingAmtLCY_VendorLedgerEntry;"Vendor Ledger Entry"."Remaining Amt. (LCY)")
                    {
                    }
                    column(DueDate_VendorLedgerEntry;"Vendor Ledger Entry"."Due Date")
                    {
                    }
                    column(DocumentDate_VendorLedgerEntry;"Vendor Ledger Entry"."Document Date")
                    {
                    }

                    trigger OnPreDataItem()
                    var
                        VendorLedgerEntry: Record "Vendor Ledger Entry";
                    begin
                        VendorLedgerEntry.Get("Credit Transfer Entry"."Applies-to Entry No.");
                        SetRange("Closed by Entry No.", VendorLedgerEntry."Closed by Entry No.");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                begin
                end;
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

    labels
    {
    }
}

