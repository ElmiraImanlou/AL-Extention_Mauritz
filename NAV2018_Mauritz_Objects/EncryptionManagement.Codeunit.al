Codeunit 60126 "Encryption Management"
{
    Permissions = TableData "Service Password" = rm;

    trigger OnRun()
    begin
    end;

    var
        ExportEncryptionKeyFileDialogTxt: label 'Choose the location where you want to save the encryption key.';
        ExportEncryptionKeyConfirmQst: label 'The encryption key file must be protected by a password and stored in a safe location.\\Do you want to save the encryption key?';
        FileImportCaptionMsg: label 'Select a key file to import.';
        DefaultEncryptionKeyFileNameTxt: label 'EncryptionKey.key';
        EncryptionKeyFilExtnTxt: label '.key';
        KeyFileFilterTxt: label 'Key File(*.key)|*.key';
        ReencryptConfirmQst: label 'The encryption is already enabled. Continuing will decrypt the encrypted data and encrypt it again with the new key.\\Do you want to continue?';
        EncryptionKeyImportedMsg: label 'The key was imported successfully.';
        EnableEncryptionConfirmTxt: label 'Enabling encryption will generate an encryption key on the server.\It is recommended that you save a copy of the encryption key in a safe location.\\Do you want to continue?';
        DisableEncryptionConfirmQst: label 'Disabling encryption will decrypt the encrypted data and store it in the database in an unsecure way.\\Do you want to continue?';
        EncryptionCheckFailErr: label 'Encryption is either not enabled or the encryption key cannot be found.';
        GlblSilentFileUploadDownload: Boolean;
        GlblTempClientFileName: Text;
        FileNameNotSetForSilentUploadErr: label 'A file name was not specified for silent upload.';
        DeleteEncryptedDataConfirmQst: label 'If you continue with this action all data that is encrypted will be deleted and lost.\Are you sure you want to delete all encrypted data?';
        EncryptionIsNotActivatedQst: label 'Data encryption is not activated. It is recommended that you encrypt data. \Do you want to open the Data Encryption Management window?';

    procedure Encrypt(Text: Text): Text
    begin
        AssertEncryptionPossible;
        if Text = '' then
            exit('');
        exit(Encrypt(Text));
    end;

    procedure Decrypt(Text: Text): Text
    begin
        AssertEncryptionPossible;
        if Text = '' then
            exit('');
        exit(Decrypt(Text))
    end;


    procedure ExportKey()
    var
        StdPasswordDialog: Page UnknownPage9815;
        ServerFilename: Text;
    begin
        AssertEncryptionPossible;
        if Confirm(ExportEncryptionKeyConfirmQst, true) then begin
            StdPasswordDialog.EnableBlankPassword(false);
            if StdPasswordDialog.RunModal <> Action::OK then
                exit;
            ServerFilename := ExportEncryptionKey(StdPasswordDialog.GetPasswordValue);
            DownloadFile(ServerFilename);
        end;
    end;


    procedure ImportKey()
    var
        FileManagement: Codeunit "File Management";
        StdPasswordDialog: Page UnknownPage9815;
        TempKeyFilePath: Text;
    begin
        TempKeyFilePath := UploadFile;

        // TempKeyFilePath is '' if the used cancelled the Upload file dialog.
        if TempKeyFilePath = '' then
            exit;

        StdPasswordDialog.EnableGetPasswordMode(false);
        StdPasswordDialog.DisablePasswordConfirmation;
        if StdPasswordDialog.RunModal = Action::OK then begin
            if EncryptionEnabled then
                // Encryption is already enabled so we're just importing the key. If the imported
                // key does not match the already enabled encryption key the process will fail.
                ImportKeyWithoutEncryptingData(TempKeyFilePath, StdPasswordDialog.GetPasswordValue)
            else
                ImportKeyAndEncryptData(TempKeyFilePath, StdPasswordDialog.GetPasswordValue);
        end;

        FileManagement.DeleteServerFile(TempKeyFilePath);
    end;


    procedure ChangeKey()
    var
        FileManagement: Codeunit "File Management";
        StdPasswordDialog: Page UnknownPage9815;
        TempKeyFilePath: Text;
    begin
        TempKeyFilePath := UploadFile;

        // TempKeyFilePath is '' if the used cancelled the Upload file dialog.
        if TempKeyFilePath = '' then
            exit;

        StdPasswordDialog.EnableGetPasswordMode(false);
        StdPasswordDialog.DisablePasswordConfirmation;
        if StdPasswordDialog.RunModal = Action::OK then begin
            if IsEncryptionEnabled then begin
                if not Confirm(ReencryptConfirmQst, true) then
                    exit;
                DisableEncryption(true);
            end;

            ImportKeyAndEncryptData(TempKeyFilePath, StdPasswordDialog.GetPasswordValue);
        end;

        FileManagement.DeleteServerFile(TempKeyFilePath);
    end;


    procedure EnableEncryption()
    begin
        if Confirm(EnableEncryptionConfirmTxt, true) then
            EnableEncryptionSilently;
    end;


    procedure EnableEncryptionSilently()
    begin
        // no user interaction on webservices
        CreateEncryptionKey;
        ExportKey;
        EncryptDataInAllCompanies;
    end;


    procedure DisableEncryption(Silent: Boolean)
    begin
        // Silent is FALSE when we want the user to take action on if the encryption should be disabled or not. In cases like import key
        // Silent should be TRUE as disabling encryption is a must before importing a new key, else data will be lost.
        if not Silent then
            if not Confirm(DisableEncryptionConfirmQst, true) then
                exit;

        DecryptDataInAllCompanies;
        DeleteEncryptionKey;
    end;

    procedure DeleteEncryptedDataInAllCompanies()
    var
        Company: Record Company;
    begin
        if Confirm(DeleteEncryptedDataConfirmQst) then begin
            Company.FindSet;
            repeat
                DeleteServicePasswordData(Company.Name);
                DeleteKeyValueData(Company.Name);
            until Company.Next = 0;
            DeleteEncryptionKey;
        end;
    end;

    procedure IsEncryptionEnabled(): Boolean
    begin
        exit(EncryptionEnabled);
    end;

    procedure IsEncryptionPossible(): Boolean
    begin
        // ENCRYPTIONKEYEXISTS checks if the correct key is present, which only works if encryption is enabled
        exit(EncryptionKeyExists);
    end;

    local procedure AssertEncryptionPossible()
    begin
        if IsEncryptionEnabled then
            if IsEncryptionPossible then
                exit;

        Error(EncryptionCheckFailErr);
    end;


    procedure EncryptDataInAllCompanies()
    var
        Company: Record Company;
    begin
        Company.FindSet;
        repeat
            EncryptServicePasswordData(Company.Name);
            EncryptKeyValueData(Company.Name);
        until Company.Next = 0;
    end;

    local procedure DecryptDataInAllCompanies()
    var
        Company: Record Company;
    begin
        Company.FindSet;
        repeat
            DecryptServicePasswordData(Company.Name);
            DecryptKeyValueData(Company.Name);
        until Company.Next = 0;
    end;

    local procedure EncryptServicePasswordData(CompanyName: Text[30])
    var
        ServicePassword: Record "Service Password";
        InStream: InStream;
        UnencryptedText: Text;
    begin
        ServicePassword.ChangeCompany(CompanyName);
        if ServicePassword.FindSet then
            repeat
                ServicePassword.CalcFields(Value);
                ServicePassword.Value.CreateInstream(InStream);
                InStream.ReadText(UnencryptedText);

                Clear(ServicePassword.Value);
                ServicePassword.SavePassword(UnencryptedText);
                ServicePassword.Modify;
            until ServicePassword.Next = 0;
    end;

    local procedure DecryptServicePasswordData(CompanyName: Text[30])
    var
        ServicePassword: Record "Service Password";
        OutStream: OutStream;
        EncryptedText: Text;
    begin
        ServicePassword.ChangeCompany(CompanyName);
        if ServicePassword.FindSet then
            repeat
                EncryptedText := ServicePassword.GetPassword;

                Clear(ServicePassword.Value);
                ServicePassword.Value.CreateOutstream(OutStream);
                OutStream.WriteText(EncryptedText);
                ServicePassword.Modify;
            until ServicePassword.Next = 0;
    end;

    procedure DeleteServicePasswordData(CompanyName: Text[30])
    var
        ServicePassword: Record "Service Password";
    begin
        ServicePassword.ChangeCompany(CompanyName);
        if ServicePassword.FindSet then
            repeat
                Clear(ServicePassword.Value);
                ServicePassword.Modify;
            until ServicePassword.Next = 0;
    end;

    local procedure EncryptKeyValueData(CompanyName: Text[30])
    var
        EncryptedKeyValue: Record "Encrypted Key/Value";
        InStream: InStream;
        UnencryptedText: Text;
    begin
        EncryptedKeyValue.ChangeCompany(CompanyName);
        if EncryptedKeyValue.FindSet then
            repeat
                EncryptedKeyValue.CalcFields(Value);
                EncryptedKeyValue.Value.CreateInstream(InStream);
                InStream.ReadText(UnencryptedText);

                Clear(EncryptedKeyValue.Value);
                EncryptedKeyValue.InsertValue(UnencryptedText);
                EncryptedKeyValue.Modify;
            until EncryptedKeyValue.Next = 0;
    end;

    local procedure DecryptKeyValueData(CompanyName: Text[30])
    var
        EncryptedKeyValue: Record "Encrypted Key/Value";
        OutStream: OutStream;
        EncryptedText: Text;
    begin
        EncryptedKeyValue.ChangeCompany(CompanyName);
        if EncryptedKeyValue.FindSet then
            repeat
                EncryptedText := EncryptedKeyValue.GetValue;

                Clear(EncryptedKeyValue.Value);
                EncryptedKeyValue.Value.CreateOutstream(OutStream);
                OutStream.WriteText(EncryptedText);
                EncryptedKeyValue.Modify;
            until EncryptedKeyValue.Next = 0;
    end;

    local procedure DeleteKeyValueData(CompanyName: Text[30])
    var
        EncryptedKeyValue: Record "Encrypted Key/Value";
    begin
        EncryptedKeyValue.ChangeCompany(CompanyName);
        if EncryptedKeyValue.FindSet then
            repeat
                Clear(EncryptedKeyValue.Value);
                EncryptedKeyValue.Modify;
            until EncryptedKeyValue.Next = 0;
    end;

    local procedure UploadFile(): Text
    var
        FileManagement: Codeunit "File Management";
    begin
        if GlblSilentFileUploadDownload then begin
            if GlblTempClientFileName = '' then
                Error(FileNameNotSetForSilentUploadErr);
            exit(FileManagement.UploadFileSilent(GlblTempClientFileName));
        end;

        exit(FileManagement.UploadFileWithFilter(FileImportCaptionMsg,
            DefaultEncryptionKeyFileNameTxt, KeyFileFilterTxt, EncryptionKeyFilExtnTxt));
    end;

    local procedure DownloadFile(ServerFileName: Text)
    var
        FileManagement: Codeunit "File Management";
    begin
        if GlblSilentFileUploadDownload then
            GlblTempClientFileName := FileManagement.DownloadTempFile(ServerFileName)
        else
            FileManagement.DownloadHandler(ServerFileName, ExportEncryptionKeyFileDialogTxt,
              '', KeyFileFilterTxt, DefaultEncryptionKeyFileNameTxt);
    end;

    procedure SetSilentFileUploadDownload(IsSilent: Boolean; SilentFileUploadName: Text)
    begin
        GlblSilentFileUploadDownload := IsSilent;
        GlblTempClientFileName := SilentFileUploadName;
    end;

    procedure GetGlblTempClientFileName(): Text
    begin
        exit(GlblTempClientFileName);
    end;

    local procedure ImportKeyAndEncryptData(KeyFilePath: Text; Password: Text)
    begin
        ImportEncryptionKey(KeyFilePath, Password);
        EncryptDataInAllCompanies;
        Message(EncryptionKeyImportedMsg);
    end;

    local procedure ImportKeyWithoutEncryptingData(KeyFilePath: Text; Password: Text)
    begin
        ImportEncryptionKey(KeyFilePath, Password);
        Message(EncryptionKeyImportedMsg);
    end;


    procedure GetEncryptionIsNotActivatedQst(): Text
    begin
        exit(EncryptionIsNotActivatedQst);
    end;

    procedure GenerateHash(InputString: Text; HashAlgorithmType: Option MD5,Sha1,Sha256,Sha384,Sha512): Text
    var
        HashBytes: dotnet Array;
    begin
        if not GenerateHashBytes(HashBytes, InputString, HashAlgorithmType) then
            exit('');
        exit(ConvertByteHashToString(HashBytes));
    end;

    procedure GenerateHashAsBase64String(InputString: Text; HashAlgorithmType: Option MD5,Sha1,Sha256,Sha384,Sha512): Text
    var
        HashBytes: dotnet Array;
    begin
        if not GenerateHashBytes(HashBytes, InputString, HashAlgorithmType) then
            exit('');
        exit(ConvertByteHashToBase64String(HashBytes));
    end;

    local procedure GenerateHashBytes(var HashBytes: dotnet Array; InputString: Text; HashAlgorithmType: Option MD5,Sha1,Sha256,Sha384,Sha512): Boolean
    var
        Encoding: dotnet Encoding;
    begin
        if InputString = '' then
            exit(false);
        if not TryGenerateHash(HashBytes, Encoding.UTF8.GetBytes(InputString), Format(HashAlgorithmType)) then
            Error(GetLastErrorText);
        exit(true);
    end;

    [TryFunction]
    local procedure TryGenerateHash(var HashBytes: dotnet Array; Bytes: dotnet Array; Algorithm: Text)
    var
        HashAlgorithm: dotnet HashAlgorithm;
    begin
        HashAlgorithm := HashAlgorithm.Create(Algorithm);
        HashBytes := HashAlgorithm.ComputeHash(Bytes);
        HashAlgorithm.Dispose;
    end;

    procedure GenerateKeyedHash(InputString: Text; "Key": Text; HashAlgorithmType: Option HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512): Text
    var
        HashBytes: dotnet Array;
    begin
        if not GenerateKeyedHashBytes(HashBytes, InputString, Key, HashAlgorithmType) then
            exit('');
        exit(ConvertByteHashToString(HashBytes));
    end;

    procedure GenerateKeyedHashAsBase64String(InputString: Text; "Key": Text; HashAlgorithmType: Option HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512): Text
    var
        HashBytes: dotnet Array;
    begin
        if not GenerateKeyedHashBytes(HashBytes, InputString, Key, HashAlgorithmType) then
            exit('');
        exit(ConvertByteHashToBase64String(HashBytes));
    end;

    local procedure GenerateKeyedHashBytes(var HashBytes: dotnet Array; InputString: Text; "Key": Text; HashAlgorithmType: Option HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512): Boolean
    begin
        if (InputString = '') or (Key = '') then
            exit(false);
        if not TryGenerateKeyedHash(HashBytes, InputString, Key, Format(HashAlgorithmType)) then
            Error(GetLastErrorText);
        exit(true);
    end;

    [TryFunction]
    local procedure TryGenerateKeyedHash(var HashBytes: dotnet Array; InputString: Text; "Key": Text; Algorithm: Text)
    var
        KeyedHashAlgorithm: dotnet KeyedHashAlgorithm;
        Encoding: dotnet Encoding;
    begin
        KeyedHashAlgorithm := KeyedHashAlgorithm.Create(Algorithm);
        KeyedHashAlgorithm.Key(Encoding.UTF8.GetBytes(Key));
        HashBytes := KeyedHashAlgorithm.ComputeHash(Encoding.UTF8.GetBytes(InputString));
        KeyedHashAlgorithm.Dispose;
    end;

    local procedure ConvertByteHashToString(HashBytes: dotnet Array): Text
    var
        Byte: dotnet Byte;
        StringBuilder: dotnet StringBuilder;
        I: Integer;
    begin
        StringBuilder := StringBuilder.StringBuilder;
        for I := 0 to HashBytes.Length - 1 do begin
            Byte := HashBytes.GetValue(I);
            StringBuilder.Append(Byte.ToString('X2'));
        end;
        exit(StringBuilder.ToString);
    end;

    local procedure ConvertByteHashToBase64String(HashBytes: dotnet Array): Text
    var
        Convert: dotnet Convert;
    begin
        exit(Convert.ToBase64String(HashBytes));
    end;
}

