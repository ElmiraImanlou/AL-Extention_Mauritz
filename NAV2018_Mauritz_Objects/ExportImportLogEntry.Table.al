Table 80004 "Export/Import Log Entry"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            TableRelation = "Export/Import Header";
        }
        field(2;"Start Datetime";DateTime)
        {
            Caption = 'Startzeit';
        }
        field(3;Class;Option)
        {
            Caption = 'Klasse';
            OptionCaption = 'Export / Import,Datei,Datensatz,Feld';
            OptionMembers = ExportImport,File,"Record","Field";
        }
        field(4;"Entry No.";Integer)
        {
            Caption = 'lfd. Nr.';
        }
        field(5;Type;Option)
        {
            Caption = 'Art';
            OptionCaption = 'Info,Warnung,Fehler,Ergebnis';
            OptionMembers = Info,Warning,Error,Result;
        }
        field(6;Message;Text[250])
        {
            Caption = 'Text';
        }
    }

    keys
    {
        key(Key1;"Code","Start Datetime","Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        ExistingLogEntry: Record "Export/Import Log Entry";
    begin
        ExistingLogEntry.SetRange(Code, Code);
        ExistingLogEntry.SetRange("Start Datetime", "Start Datetime");
        //ExistingLogEntry.SETRANGE(Class, Class);
        if ExistingLogEntry.FindLast then
          "Entry No." := ExistingLogEntry."Entry No." + 1
        else
          "Entry No." := 1;
    end;


    procedure InitLog(newCode: Code[20])
    begin
        Code := newCode;
        "Start Datetime" := CurrentDatetime;
        LogResult(1);
    end;


    procedure LogInfo(newClass: Option ExportImport,File,"Record","Field";newMessage: Text)
    begin
        Log(newClass, Type::Info, newMessage);
    end;


    procedure LogWarning(newClass: Option ExportImport,File,"Record","Field";newMessage: Text)
    begin
        Log(newClass, Type::Warning, newMessage);
    end;


    procedure LogError(newClass: Option ExportImport,File,"Record","Field";newMessage: Text;BreakProcess: Boolean)
    begin
        Log(newClass, Type::Error, newMessage);
        if BreakProcess then
          Error('');
    end;


    procedure LogResult(Result: Option Success,Error,NoOperation,Warning)
    var
        TXT_SUCCESS: label 'Erfolgreich beendet.';
        TXT_ERROR: label 'Abgebrochen';
        TXT_NOOP: label 'Keine Aktion durchgeführt.';
        ResultLog: Record "Export/Import Log Entry";
        TXT_WARNING: label 'Mit Fehlern/Warnungen beendet.';
    begin
        ResultLog.SetRange(Code, Code);
        ResultLog.SetRange("Start Datetime", "Start Datetime");
        ResultLog.SetRange(Type, Type::Result);
        ResultLog.DeleteAll;

        case Result of
          Result::Success:      Log(Class::ExportImport, Type::Result, TXT_SUCCESS);
          Result::Error:        Log(Class::ExportImport, Type::Result, TXT_ERROR);
          Result::NoOperation:  Log(Class::ExportImport, Type::Result, TXT_NOOP);
          Result::Warning:      Log(Class::ExportImport, Type::Result, TXT_WARNING);
        end;
    end;

    local procedure Log(newClass: Option ExportImport,File,"Record","Field";newType: Option Info,Warning,Error,Result;newMessage: Text)
    begin
        Class := newClass;
        Type := newType;
        if newMessage <> '' then
          Message := CopyStr(newMessage, 1, MaxStrLen(Message))
        else
          Message := CopyStr(GetLastErrorText, 1, MaxStrLen(Message));

        Insert(true);
        Commit;
    end;
}

