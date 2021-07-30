XmlPort 50000 "SEPA CT pain.001.002.03"
{
    Caption = 'SEPA CT pain.001.002.03';
    DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.001.002.03';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    Namespaces = xsi='http://www.w3.org/2001/XMLSchema-instance';
    UseDefaultNamespace = true;

    schema
    {
        tableelement("Gen. Journal Line";"Gen. Journal Line")
        {
            XmlName = 'Document';
            UseTemporary = true;
            tableelement(companyinformation;"Company Information")
            {
                XmlName = 'CstmrCdtTrfInitn';
                textelement(GrpHdr)
                {
                    textelement(messageid)
                    {
                        XmlName = 'MsgId';
                    }
                    textelement(createddatetime)
                    {
                        XmlName = 'CreDtTm';
                    }
                    textelement(nooftransfers)
                    {
                        XmlName = 'NbOfTxs';
                    }
                    textelement(controlsum)
                    {
                        XmlName = 'CtrlSum';
                    }
                    textelement(InitgPty)
                    {
                        fieldelement(Nm;CompanyInformation.Name)
                        {
                        }
                        textelement(initgptyid)
                        {
                            XmlName = 'Id';
                            textelement(initgptyorgid)
                            {
                                XmlName = 'OrgId';
                                textelement(initgptyothrinitgpty)
                                {
                                    XmlName = 'Othr';
                                    fieldelement(Id;CompanyInformation."VAT Registration No.")
                                    {
                                    }
                                }
                            }

                            trigger OnBeforePassVariable()
                            begin
                                currXMLport.Skip;
                            end;
                        }
                    }
                }
                tableelement(paymentexportdatagroup;"Payment Export Data")
                {
                    XmlName = 'PmtInf';
                    UseTemporary = true;
                    fieldelement(PmtInfId;PaymentExportDataGroup."Payment Information ID")
                    {
                    }
                    fieldelement(PmtMtd;PaymentExportDataGroup."SEPA Payment Method Text")
                    {
                    }
                    fieldelement(BtchBookg;PaymentExportDataGroup."SEPA Batch Booking")
                    {
                    }
                    fieldelement(NbOfTxs;PaymentExportDataGroup."Line No.")
                    {
                    }
                    fieldelement(CtrlSum;PaymentExportDataGroup.Amount)
                    {
                    }
                    textelement(PmtTpInf)
                    {
                        fieldelement(InstrPrty;PaymentExportDataGroup."SEPA Instruction Priority Text")
                        {
                        }
                        textelement(SvcLvl)
                        {
                            textelement(Cd)
                            {
                            }

                            trigger OnBeforePassVariable()
                            begin
                                Cd := 'SEPA';
                            end;
                        }
                    }
                    fieldelement(ReqdExctnDt;PaymentExportDataGroup."Transfer Date")
                    {
                    }
                    textelement(Dbtr)
                    {
                        fieldelement(Nm;CompanyInformation.Name)
                        {
                        }
                        textelement(dbtrid)
                        {
                            XmlName = 'Id';
                            textelement(dbtrorgid)
                            {
                                XmlName = 'OrgId';
                                fieldelement(BICOrBEI;PaymentExportDataGroup."Sender Bank BIC")
                                {
                                }
                            }

                            trigger OnBeforePassVariable()
                            begin
                                if PaymentExportDataGroup."Sender Bank BIC" = '' then
                                  currXMLport.Skip;
                            end;
                        }
                    }
                    textelement(DbtrAcct)
                    {
                        textelement(dbtracctid)
                        {
                            XmlName = 'Id';
                            fieldelement(Iban;PaymentExportDataGroup."Sender Bank Account No.")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }
                    }
                    textelement(DbtrAgt)
                    {
                        textelement(dbtragtfininstnid)
                        {
                            XmlName = 'FinInstnId';
                            fieldelement(BIC;PaymentExportDataGroup."Sender Bank BIC")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }

                        trigger OnBeforePassVariable()
                        begin
                            // IF PaymentExportDataGroup."Sender Bank BIC" = '' THEN
                            //  currXMLport.SKIP;
                        end;
                    }
                    fieldelement(ChrgBr;PaymentExportDataGroup."SEPA Charge Bearer Text")
                    {

                        trigger OnBeforePassField()
                        begin
                            PaymentExportDataGroup."SEPA Charge Bearer Text" := 'SLEV';
                        end;
                    }
                    tableelement(paymentexportdata;"Payment Export Data")
                    {
                        LinkFields = "Sender Bank BIC"=field("Sender Bank BIC"),"SEPA Instruction Priority Text"=field("SEPA Instruction Priority Text"),"Transfer Date"=field("Transfer Date"),"SEPA Batch Booking"=field("SEPA Batch Booking"),"SEPA Charge Bearer Text"=field("SEPA Charge Bearer Text");
                        LinkTable = PaymentExportDataGroup;
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            fieldelement(EndToEndId;PaymentExportData."End-to-End ID")
                            {
                            }
                        }
                        textelement(Amt)
                        {
                            fieldelement(InstdAmt;PaymentExportData.Amount)
                            {
                                fieldattribute(Ccy;PaymentExportData."Currency Code")
                                {
                                }
                            }
                        }
                        textelement(CdtrAgt)
                        {
                            textelement(cdtragtfininstnid)
                            {
                                XmlName = 'FinInstnId';
                                fieldelement(BIC;PaymentExportData."Recipient Bank BIC")
                                {
                                    FieldValidate = yes;
                                }
                            }

                            trigger OnBeforePassVariable()
                            begin
                                // IF PaymentExportData."Recipient Bank BIC" = '' THEN
                                //  currXMLport.SKIP;
                            end;
                        }
                        textelement(Cdtr)
                        {
                            fieldelement(Nm;PaymentExportData."Recipient Name")
                            {
                            }
                        }
                        textelement(CdtrAcct)
                        {
                            textelement(cdtracctid)
                            {
                                XmlName = 'Id';
                                fieldelement(Iban;PaymentExportData."Recipient Bank Acc. No.")
                                {
                                    FieldValidate = yes;
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                }
                            }
                        }
                        textelement(RmtInf)
                        {
                            MinOccurs = Zero;
                            textelement(remittancetext1)
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';
                            }

                            trigger OnBeforePassVariable()
                            begin
                                RemittanceText1 := '';
                                // RemittanceText2 := '';
                                TempPaymentExportRemittanceText.SetRange("Pmt. Export Data Entry No.",PaymentExportData."Entry No.");
                                if not TempPaymentExportRemittanceText.FindSet then
                                  currXMLport.Skip;
                                RemittanceText1 := TempPaymentExportRemittanceText.Text;
                                if TempPaymentExportRemittanceText.Next = 0 then
                                  exit;
                                // RemittanceText2 := TempPaymentExportRemittanceText.Text;
                            end;
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if not PaymentExportData.GetPreserveNonLatinCharacters then
                      PaymentExportData.CompanyInformationConvertToLatin(CompanyInformation);
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

    trigger OnPreXmlPort()
    begin
        InitData;
    end;

    var
        TempPaymentExportRemittanceText: Record "Payment Export Remittance Text" temporary;
        NoDataToExportErr: label 'There is no data to export.', Comment='%1=Field;%2=Value;%3=Value';

    local procedure InitData()
    var
        SEPACTFillExportBuffer: Codeunit "SEPA CT-Fill Export Buffer";
        PaymentGroupNo: Integer;
    begin
        SEPACTFillExportBuffer.FillExportBuffer("Gen. Journal Line",PaymentExportData);
        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);

        NoOfTransfers := Format(PaymentExportData.Count);
        MessageID := PaymentExportData."Message ID";
        CreatedDateTime := Format(CurrentDatetime,19,9);
        PaymentExportData.CalcSums(Amount);
        ControlSum := Format(PaymentExportData.Amount,0,9);

        PaymentExportData.SetCurrentkey(
          "Sender Bank BIC","SEPA Instruction Priority Text","Transfer Date",
          "SEPA Batch Booking","SEPA Charge Bearer Text");

        if not PaymentExportData.FindSet then
          Error(NoDataToExportErr);

        InitPmtGroup;
        repeat
          if IsNewGroup then begin
            InsertPmtGroup(PaymentGroupNo);
            InitPmtGroup;
          end;
          PaymentExportDataGroup."Line No." += 1;
          PaymentExportDataGroup.Amount += PaymentExportData.Amount;
        until PaymentExportData.Next = 0;
        InsertPmtGroup(PaymentGroupNo);
    end;

    local procedure IsNewGroup(): Boolean
    begin
        exit(
          (PaymentExportData."Sender Bank BIC" <> PaymentExportDataGroup."Sender Bank BIC") or
          (PaymentExportData."SEPA Instruction Priority Text" <> PaymentExportDataGroup."SEPA Instruction Priority Text") or
          (PaymentExportData."Transfer Date" <> PaymentExportDataGroup."Transfer Date") or
          (PaymentExportData."SEPA Batch Booking" <> PaymentExportDataGroup."SEPA Batch Booking") or
          (PaymentExportData."SEPA Charge Bearer Text" <> PaymentExportDataGroup."SEPA Charge Bearer Text"));
    end;

    local procedure InitPmtGroup()
    begin
        PaymentExportDataGroup := PaymentExportData;
        PaymentExportDataGroup."Line No." := 0; // used for counting transactions within group
        PaymentExportDataGroup.Amount := 0; // used for summarizing transactions within group
    end;

    local procedure InsertPmtGroup(var PaymentGroupNo: Integer)
    begin
        PaymentGroupNo += 1;
        PaymentExportDataGroup."Entry No." := PaymentGroupNo;
        PaymentExportDataGroup."Payment Information ID" :=
          CopyStr(
            StrSubstNo('%1/%2',PaymentExportData."Message ID",PaymentGroupNo),
            1,MaxStrLen(PaymentExportDataGroup."Payment Information ID"));
        PaymentExportDataGroup.Insert;
    end;
}

