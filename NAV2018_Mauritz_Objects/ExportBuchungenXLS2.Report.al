Report 50015 ExportBuchungenXLS2
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Transaction;"G/L Entry")
        {
            DataItemTableView = sorting("Entry No.") order(ascending);
            RequestFilterFields = "Posting Date","Transaction No.";
            column(ReportForNavId_50000; 50000)
            {
            }
            dataitem(Entry;"G/L Entry")
            {
                DataItemLink = "Transaction No."=field("Transaction No.");
                DataItemTableView = sorting("Entry No.") order(ascending) where(Reversed=const(false));
                column(ReportForNavId_50003; 50003)
                {
                }

                trigger OnAfterGetRecord()
                var
                    Factor: Decimal;
                begin
                    CountDone += 1;
                    ActualEntry += 1;

                    if ActualEntry = CountEntry then
                      CurrReport.Skip;
                    if (LastVATAmount <> 0) and (LastVATAmount = Amount) then
                      CurrReport.Skip;

                    ExcelBuffer.NewRow();
                    ExcelBuffer.AddColumn(Format("Document Type"), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn("Document No.", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn("External Document No.", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Format("Document Date", 0, '<Day,2>.<Month,2>.<Year4>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Format("Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Buchungstext(Entry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Gegenkonto(Entry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(GetGLAccountNo(Entry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn("Global Dimension 1 Code", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Steuerschluessel(0, "VAT Bus. Posting Group", "VAT Prod. Posting Group"), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);

                    if "Credit Amount" <> 0 then begin
                      if "Credit Amount" > 0 then begin
                        ExcelBuffer.AddColumn(Format(ROUND(Abs(Amount), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs("Credit Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs(Amount)+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs("Credit Amount")+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(UmsatzsteuerID(Entry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                        ExcelBuffer.AddColumn('H', false, '', false, false, false, '', ExcelBuffer."cell type"::Text)
                      end;
                      if "Credit Amount" < 0 then begin
                        ExcelBuffer.AddColumn(Format(ROUND(Abs(Amount), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs("Credit Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs(Amount)+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs("Credit Amount")+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(UmsatzsteuerID(Entry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                        ExcelBuffer.AddColumn('S', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                      end;
                    end;

                    if "Debit Amount" <> 0 then begin
                      if "Debit Amount" < 0 then begin
                        ExcelBuffer.AddColumn(Format(ROUND(Abs(Amount), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs("Debit Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs(Amount)+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs("Debit Amount")+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(UmsatzsteuerID(Entry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                        ExcelBuffer.AddColumn('H', false, '', false, false, false, '', ExcelBuffer."cell type"::Text)
                      end;
                      if "Debit Amount" > 0 then begin
                        ExcelBuffer.AddColumn(Format(ROUND(Abs(Amount), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs("Debit Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs(Amount)+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(Format(ROUND(Abs("Debit Amount")+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                        ExcelBuffer.AddColumn(UmsatzsteuerID(Entry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                        ExcelBuffer.AddColumn('S', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                      end;
                    end;

                    ExcelBuffer.AddColumn("Transaction No.", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                    ExcelBuffer.AddColumn(GegenkontoName(Entry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);

                    LastVATAmount := "VAT Amount";

                    ProcessDialog.Update(1, StrSubstNo('%1 von %2', CountDone, CountAll));
                    ProcessDialog.Update(2, ROUND(CountDone/CountAll) * 10000);
                end;

                trigger OnPreDataItem()
                begin
                    CountEntry := Count;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Transaction No." = LastTransactionNo then
                  CurrReport.Skip;

                Clear(ActualEntry);
                Clear(LastVATAmount);
                LastTransactionNo := "Transaction No.";
            end;

            trigger OnPreDataItem()
            begin
                Clear(CountAll);
                Clear(CountDone);

                // SETRANGE("Posting Date", fromPostingDate, toPostingDate);
                CountAll := Count;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(fromPostingDate;fromPostingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'von';
                    Visible = false;
                }
                field(toPostingDate;toPostingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'bis';
                    Visible = false;
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

    trigger OnPostReport()
    var
        ClientFilename: Text;
    begin
        ProcessDialog.Close;

        ClientFilename := StrSubstNo('Buchungen %1 bis %2.xlsx', fromPostingDate, toPostingDate);
        ExcelBuffer.CreateBookAndOpenExcel('', 'Buchungen', '', '', UserId);
    end;

    trigger OnPreReport()
    begin
        ExcelBuffer.DeleteAll;
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Belegart', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Belegnummer', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Fremdbelegnummer', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Belegdatum', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Buchungsdatum', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Buchungstext', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Gegenkonto', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Sachkonto', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Kostenstelle', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Steuerschlüssel', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatz in Euro (netto)', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatz Haben in Euro (netto)', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatz Soll in Euro (netto)', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatz in Euro (brutto)', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatz Haben in Euro (brutto)', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatz Soll in Euro (brutto)', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatzsteuer-ID', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Vorzeichen', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Transaktionsnr.', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Gegenkontoname', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);

        ProcessDialog.Open('Sachposten  #1################### @2@@@@@@@\');
    end;

    var
        VATPostingSetup: Record "VAT Posting Setup";
        ExcelBuffer: Record "Excel Buffer";
        fromPostingDate: Date;
        toPostingDate: Date;
        ProcessDialog: Dialog;
        CountAll: Integer;
        CountDone: Integer;
        CountEntry: Integer;
        ActualEntry: Integer;
        VATGLAccountNo: Code[20];
        LastVATAmount: Decimal;
        LastTransactionNo: Integer;

    local procedure AddExcelCell(var Buffer: Record "Excel Buffer";RowNo: Integer;ColNo: Integer;Value: Text)
    begin
        Buffer.Init;
        Buffer.Validate("Row No.", RowNo);
        Buffer.Validate("Column No.", ColNo);
        Buffer.Validate("Cell Type", Buffer."cell type"::Text);
        Buffer.Validate("Cell Value as Text", Value);
        Buffer.Insert(true);
    end;

    local procedure Steuerschluessel(Type: Option Sale,Purchase;VATBusPostGroup: Code[20];VATProdPostGroup: Code[20]): Text
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        CustVendLederEntryRef: RecordRef;
        VATBusPostingGroup: Code[20];
        VATProdPostingGroup: Code[20];
    begin
        Clear(VATPostingSetup);
        if not VATPostingSetup.Get(VATBusPostGroup, VATProdPostGroup) then
          exit('0');

        if Type = Type::Sale then begin
          if VATPostingSetup."VAT %" = 0 then
            exit('1');
          if VATPostingSetup."VAT %" in [5, 7] then
            exit('2');
          if VATPostingSetup."VAT %" in [16, 19] then
            exit('3');
        end;

        if Type = Type::Purchase then begin
          if VATPostingSetup."VAT %" in [5, 7] then
            exit('8');
          if VATPostingSetup."VAT %" in [16, 19] then
            exit('9');
        end;

        exit('0')
    end;

    local procedure Gegenkonto(GLEntry: Record "G/L Entry"): Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        with GLEntry do begin
          if "Bal. Account No." <> '' then
            exit("Bal. Account No.");

          case "Document Type" of
            "document type"::Invoice:
              begin
                if ("Gen. Posting Type" = "gen. posting type"::Sale) and SalesInvoiceHeader.Get("Document No.") then
                  exit(SalesInvoiceHeader."Bill-to Customer No.");
                if ("Gen. Posting Type" = "gen. posting type"::Purchase) and PurchInvHeader.Get("Document No.") then
                  exit(PurchInvHeader."Pay-to Vendor No.");
                if "Source No." <> '' then
                  exit("Source No.");
              end;
            "document type"::"Credit Memo":
              begin
                if ("Gen. Posting Type" = "gen. posting type"::Sale) and SalesCrMemoHeader.Get("Document No.") then
                  exit(SalesCrMemoHeader."Bill-to Customer No.");
                if ("Gen. Posting Type" = "gen. posting type"::Purchase) and PurchCrMemoHdr.Get("Document No.") then
                  exit(PurchCrMemoHdr."Pay-to Vendor No.");
                if "Source No." <> '' then
                  exit("Source No.");
              end;
            "document type"::Payment:
              begin
                if "Source No." <> '' then
                  exit("Source No.");
              end;
          end;
        end;
    end;

    local procedure GegenkontoName(GLEntry: Record "G/L Entry"): Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        with GLEntry do begin
          if "Bal. Account No." <> '' then
            exit("Bal. Account No.");

          case "Document Type" of
            "document type"::Invoice:
              begin
                if ("Gen. Posting Type" = "gen. posting type"::Sale) and SalesInvoiceHeader.Get("Document No.") then
                  exit(SalesInvoiceHeader."Bill-to Name");
                if ("Gen. Posting Type" = "gen. posting type"::Purchase) and PurchInvHeader.Get("Document No.") then
                  exit(PurchInvHeader."Pay-to Name");
                if "Source No." <> '' then
                  exit("Source No.");
              end;
            "document type"::"Credit Memo":
              begin
                if ("Gen. Posting Type" = "gen. posting type"::Sale) and SalesCrMemoHeader.Get("Document No.") then
                  exit(SalesCrMemoHeader."Bill-to Name");
                if ("Gen. Posting Type" = "gen. posting type"::Purchase) and PurchCrMemoHdr.Get("Document No.") then
                  exit(PurchCrMemoHdr."Pay-to Name");
                if "Source No." <> '' then
                  exit("Source No.");
              end;
            "document type"::Payment:
              begin
                if "Source No." <> '' then
                  exit("Source No.");
              end;
          end;
        end;
    end;

    local procedure UmsatzsteuerID(GLEntry: Record "G/L Entry"): Text
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        VATEntry: Record "VAT Entry";
    begin
        VATEntry.SetRange("Transaction No.", GLEntry."Transaction No.");
        VATEntry.SetFilter("VAT Registration No.", '<>%1', '');
        if VATEntry.FindFirst then
          exit(VATEntry."VAT Registration No.");

        with GLEntry do begin
          case "Bal. Account Type" of
            "bal. account type"::Customer:
              if Customer.Get("Bal. Account No.") then
                exit(Customer."VAT Registration No.");
            "bal. account type"::Vendor:
              if Vendor.Get("Bal. Account No.") then
                exit(Vendor."VAT Registration No.");
          end;
        end;
    end;

    local procedure Buchungstext(GLEntry: Record "G/L Entry"): Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        with GLEntry do begin
          if Description <> '' then
            exit(Description);

          case "Document Type" of
            "document type"::Invoice:
              begin
                if ("Gen. Posting Type" = "gen. posting type"::Sale) and SalesInvoiceHeader.Get("Document No.") then begin
                  if SalesInvoiceHeader."Order No." <> '' then
                    exit(StrSubstNo('Auftrag %1', SalesInvoiceHeader."Order No."))
                  else
                    exit(StrSubstNo('Rechn. %1, Deb. %2', "Document No.", SalesInvoiceHeader."Bill-to Customer No."));
                end;
                if ("Gen. Posting Type" = "gen. posting type"::Purchase) and PurchInvHeader.Get("Document No.") then begin
                  if PurchInvHeader."Order No." <> '' then
                    exit(StrSubstNo('Bestellung %1', PurchInvHeader."Order No."))
                  else
                    exit(StrSubstNo('Rechn. %1, Kred. %2', "Document No.", PurchInvHeader."Pay-to Vendor No."));
                end;
              end;
            "document type"::"Credit Memo":
              begin
                if ("Gen. Posting Type" = "gen. posting type"::Sale) and SalesCrMemoHeader.Get("Document No.") then begin
                  if SalesCrMemoHeader."Applies-to Doc. No." <> '' then
                    exit(StrSubstNo('Storno: %1 %2', SalesCrMemoHeader."Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. No."))
                  else
                    exit(StrSubstNo('Gutschr. %1, Deb. %2', "Document No.", SalesCrMemoHeader."Bill-to Customer No."));
                end;
                if ("Gen. Posting Type" = "gen. posting type"::Purchase) and PurchCrMemoHdr.Get("Document No.") then begin
                  if PurchCrMemoHdr."Applies-to Doc. No." <> '' then
                    exit(StrSubstNo('Storno: %1 %2', PurchCrMemoHdr."Applies-to Doc. Type", PurchCrMemoHdr."Applies-to Doc. No."))
                  else
                    exit(StrSubstNo('Gutschr. %1, Kred. %2', "Document No.", PurchCrMemoHdr."Pay-to Vendor No."));
                end;
              end;
          end;
        end;
    end;

    local procedure GetGLAccountNo(GLEntry: Record "G/L Entry") GLAccountNo: Code[20]
    begin
        GLAccountNo := GLEntry."G/L Account No.";

        while (StrLen(GLAccountNo) > 4) and (GLAccountNo[StrLen(GLAccountNo)] = '0') do
          GLAccountNo := CopyStr(GLAccountNo, 1, StrLen(GLAccountNo)-1);
    end;
}

