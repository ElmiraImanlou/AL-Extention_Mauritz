Page 60000 "Halvotec ERIC Setup"
{
    ApplicationArea = Basic;
    Caption = 'ELSTER Einrichtung';
    PageType = Card;
    SourceTable = "ERIC Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Allgemeein';
                field("VAT Declaration No. Series"; "VAT Declaration No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("VIES Declaration No. Series"; "VIES Declaration No. Series")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Certificate)
            {
                Caption = 'Zertifikat';
                group(Allgemein)
                {
                    field(CertificateUploaded; CertificateUploaded)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Zertifikat hochgeladen';
                    }
                    field(CertificatePinSet; CertificatePinSet)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Zertifikat-Kennwort gesetzt';
                    }
                }
                group("Kennwort setzen / ändern")
                {
                    Caption = 'Kennwort setzen / ändern';
                    field(Pin1; newPin[1])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Kennwort';
                        ExtendedDatatype = Masked;
                    }
                    field(Pin2; newPin[2])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Kennwort wiederholen';
                        ExtendedDatatype = Masked;

                        trigger OnValidate()
                        var
                            EncryptionManagement: Codeunit "Encryption Management";
                            encryptedPin: Text;
                            OutStr: OutStream;
                        begin
                            if (newPin[1] <> '') and (newPin[2] <> '') then
                                if newPin[1] <> newPin[2] then begin
                                    Error('Kennwort und Kennwortwiederholung stimmen nicht überein.');
                                    Clear(newPin[1]);
                                    Clear(newPin[2]);
                                end else begin
                                    if EncryptionManagement.IsEncryptionPossible then
                                        encryptedPin := EncryptionManagement.Encrypt(newPin[1])
                                    else
                                        encryptedPin := newPin[1];
                                    CalcFields("PFX Pin");
                                    "PFX Pin".CreateOutstream(OutStr);
                                    OutStr.Write(encryptedPin);
                                    Modify(true);
                                end;

                            CurrPage.Update(false);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(UploadPFX)
            {
                ApplicationArea = Basic;
                Caption = 'Zertifikat hochladen';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    TempBlob: Record TempBlob temporary;
                    TempBlob1: Codeunit "Temp Blob";
                    InStr: InStream;
                    OutStr: OutStream;
                begin
                    TempBlob.Insert;
                    FileManagement.BLOBImport(TempBlob1, 'Zertifikat-Datei auswählen');
                    TempBlob.Modify(true);
                    TempBlob.CalcFields(Blob);
                    TempBlob.Blob.CreateInstream(InStr);

                    CalcFields("PFX File");
                    "PFX File".CreateOutstream(OutStr);

                    CopyStream(OutStr, InStr);
                    Modify(true);

                    CurrPage.Update(false);
                end;
            }
            action(ClearPin)
            {
                ApplicationArea = Basic;
                Caption = 'Kennwort zurücksetzen';
                Image = RemoveLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CalcFields("PFX Pin");
                    Clear("PFX Pin");
                    Modify(true);

                    CurrPage.Update(false);
                end;
            }
            action(UploadVIESStylesheet)
            {
                ApplicationArea = Basic;
                Caption = 'Stylesheet für ZM hochladen';
                Image = Import;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    Filename: Text;
                    XSLFile: File;
                    InStr: InStream;
                    OutStr: OutStream;
                begin
                    Filename := FileManagement.UploadFile('XSL-Stylesheet auswählen', Filename);

                    XSLFile.Open(Filename);
                    XSLFile.CreateInstream(InStr);

                    CalcFields("VIES Declaration XSL");
                    "VIES Declaration XSL".CreateOutstream(OutStr);

                    CopyStream(OutStr, InStr);
                    Modify;

                    XSLFile.Close;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields("PFX File", "PFX Pin");
        CertificateUploaded := "PFX File".Hasvalue;
        CertificatePinSet := "PFX Pin".Hasvalue;
    end;

    trigger OnOpenPage()
    begin
        if not Get then
            Insert;
    end;

    var
        CertificateUploaded: Boolean;
        CertificatePinSet: Boolean;
        newPin: array[2] of Text;
}

