Report 50014 ExportBuchungenXLS
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(CustLedgEntry;"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Customer No.","Posting Date","Currency Code") order(ascending);
            column(ReportForNavId_50001; 50001)
            {
            }
            dataitem(CustGLEntry;"G/L Entry")
            {
                DataItemTableView = sorting("Entry No.") order(ascending);
                column(ReportForNavId_50000; 50000)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ExcelBuffer.NewRow();
                    ExcelBuffer.AddColumn(Format("Document Type"), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn("Document No.", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(CustLedgEntry."External Document No.", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Format(CustLedgEntry."Document Date", 0, '<Day,2>.<Month,2>.<Year4>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Format("Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Buchungstext(CustGLEntry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(CustLedgEntry."Customer No.", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(GetGLAccountNo(CustLedgEntry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn("Global Dimension 1 Code", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Steuerschluessel(0, "VAT Bus. Posting Group", "VAT Prod. Posting Group"), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Format(ROUND(Amount+"VAT Amount", 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                    if "Credit Amount" <> 0 then begin
                      ExcelBuffer.AddColumn(Format(ROUND(Abs("Credit Amount")+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                      ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                    end else begin
                      ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                      ExcelBuffer.AddColumn(Format(ROUND(Abs("Debit Amount")+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                    end;
                    ExcelBuffer.AddColumn(UmsatzsteuerID(CustGLEntry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    if "Credit Amount" <> 0 then
                      ExcelBuffer.AddColumn('H', false, '', false, false, false, '', ExcelBuffer."cell type"::Text)
                    else
                      ExcelBuffer.AddColumn('S', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                end;

                trigger OnPostDataItem()
                begin
                    CountDone += 1;

                    ProcessDialog.Update(1, StrSubstNo('%1 von %2', CountDone, CountAll));
                    ProcessDialog.Update(2, ROUND(CountDone / CountAll) * 10000);
                end;

                trigger OnPreDataItem()
                begin
                    Reset;
                    SetRange("Transaction No.", CustLedgEntry."Transaction No.");

                    case CustLedgEntry."Document Type" of
                      CustGLEntry."document type"::Invoice:
                        SetRange("Gen. Posting Type", CustGLEntry."gen. posting type"::Sale);
                      CustGLEntry."document type"::"Credit Memo":
                        SetRange("Gen. Posting Type", CustGLEntry."gen. posting type"::Sale);
                      CustGLEntry."document type"::Payment:
                        begin
                          FindFirst;
                          SetRange("Entry No.", CustGLEntry."Entry No.");
                        end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CustGLEntry.Reset;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Document Type", "document type"::" ", "document type"::"Credit Memo");
                SetRange("Posting Date", fromPostingDate, toPostingDate);

                CountAll := Count;
                CountDone := 0;
            end;
        }
        dataitem(VendLedgEntry;"Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Vendor No.","Posting Date","Currency Code") order(ascending);
            column(ReportForNavId_50002; 50002)
            {
            }
            dataitem(VendGLEntry;"G/L Entry")
            {
                DataItemTableView = sorting("Entry No.") order(ascending);
                column(ReportForNavId_50004; 50004)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ExcelBuffer.NewRow();
                    ExcelBuffer.AddColumn(Format("Document Type"), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn("Document No.", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(VendLedgEntry."External Document No.", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Format(VendLedgEntry."Document Date", 0, '<Day,2>.<Month,2>.<Year4>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Format("Posting Date", 0, '<Day,2>.<Month,2>.<Year4>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Buchungstext(VendGLEntry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(VendLedgEntry."Vendor No.", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(GetGLAccountNo(VendLedgEntry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn("Global Dimension 1 Code", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Steuerschluessel(0, "VAT Bus. Posting Group", "VAT Prod. Posting Group"), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    ExcelBuffer.AddColumn(Format(ROUND(Amount + "VAT Amount", 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                    if "Credit Amount" <> 0 then begin
                      ExcelBuffer.AddColumn(Format(ROUND(Abs("Credit Amount")+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                      ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                    end else begin
                      ExcelBuffer.AddColumn('0,00', false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                      ExcelBuffer.AddColumn(Format(ROUND(Abs("Debit Amount")+Abs("VAT Amount"), 0.01), 0, '<Integer><Decimals,3><Comma,,>'), false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                    end;
                    ExcelBuffer.AddColumn(UmsatzsteuerID(VendGLEntry), false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                    if "Credit Amount" <> 0 then
                      ExcelBuffer.AddColumn('H', false, '', false, false, false, '', ExcelBuffer."cell type"::Text)
                    else
                      ExcelBuffer.AddColumn('S', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                end;

                trigger OnPostDataItem()
                begin
                    CountDone += 1;

                    ProcessDialog.Update(3, StrSubstNo('%1 von %2', CountDone, CountAll));
                    ProcessDialog.Update(4, ROUND(CountDone / CountAll) * 10000);
                end;

                trigger OnPreDataItem()
                begin
                    Reset;
                    SetRange("Transaction No.", VendLedgEntry."Transaction No.");
                    case VendLedgEntry."Document Type" of
                      "document type"::Invoice:
                        SetRange("Gen. Posting Type", "gen. posting type"::Purchase);
                      "document type"::"Credit Memo":
                         SetRange("Gen. Posting Type", "gen. posting type"::Purchase);
                      "document type"::Payment:
                        begin
                          FindFirst;
                          SetRange("Entry No.", "Entry No.");
                        end;
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange("Document Type", "document type"::" ", "document type"::"Credit Memo");
                SetRange("Posting Date", fromPostingDate, toPostingDate);

                CountAll := Count;
                CountDone := 0;
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
                }
                field(toPostingDate;toPostingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'bis';
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
        ExcelBuffer.AddColumn('Umsatz in Euro', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatz Haben in Euro', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatz Soll in Euro', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Umsatzsteuer-ID', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Vorzeichen', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);

        ProcessDialog.Open('Debitorposten  #1################### @2@@@@@@@\'+
                           'Kreditorposten #3################### @4@@@@@@@');
    end;

    var
        VATPostingSetup: Record "VAT Posting Setup";
        ExcelBuffer: Record "Excel Buffer";
        LastVATAmount: Decimal;
        fromPostingDate: Date;
        toPostingDate: Date;
        ProcessDialog: Dialog;
        CountAll: Integer;
        CountDone: Integer;

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
          if VATPostingSetup."VAT %" = 7 then
            exit('2');
          if VATPostingSetup."VAT %" = 19 then
            exit('3');
        end;

        if Type = Type::Purchase then begin
          if VATPostingSetup."VAT %" = 7 then
            exit('8');
          if VATPostingSetup."VAT %" = 19 then
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
              end;
            "document type"::"Credit Memo":
              begin
                if ("Gen. Posting Type" = "gen. posting type"::Sale) and SalesCrMemoHeader.Get("Document No.") then
                  exit(SalesCrMemoHeader."Bill-to Customer No.");
                if ("Gen. Posting Type" = "gen. posting type"::Purchase) and PurchCrMemoHdr.Get("Document No.") then
                  exit(PurchCrMemoHdr."Pay-to Vendor No.");
              end;
          end;
        end;
    end;

    local procedure UmsatzsteuerID(GLEntry: Record "G/L Entry"): Text
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
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

    local procedure GetGLAccountNo(CustVendLedgerEntry: Variant) GLAccountNo: Code[20]
    var
        CustVendLederEntryRef: RecordRef;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GLEntry: Record "G/L Entry";
    begin
        CustVendLederEntryRef.GetTable(CustVendLedgerEntry);
        case CustVendLederEntryRef.Number of
          Database::"Cust. Ledger Entry":
            begin
              CustLedgerEntry.Get(CustVendLederEntryRef.RecordId);
              GLEntry.SetRange("Transaction No.", CustLedgerEntry."Transaction No.");
            end;
          Database::"Vendor Ledger Entry":
            begin
              VendorLedgerEntry.Get(CustVendLederEntryRef.RecordId);
              GLEntry.SetRange("Transaction No.", VendorLedgerEntry."Transaction No.");
            end;
        end;

        if GLEntry.FindFirst then
          GLAccountNo := GLEntry."G/L Account No.";

        while (StrLen(GLAccountNo) > 4) and (GLAccountNo[StrLen(GLAccountNo)] = '0') do
          GLAccountNo := CopyStr(GLAccountNo, 1, StrLen(GLAccountNo)-1);
    end;
}

