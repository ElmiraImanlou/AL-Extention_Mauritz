Table 50001 "Print Job"
{

    fields
    {
        field(1;"Job No.";Integer)
        {
            Caption = 'Auftragsnr.';
            DataClassification = ToBeClassified;
        }
        field(2;"Report ID";Integer)
        {
            Caption = 'Berichts-ID';
            DataClassification = ToBeClassified;
        }
        field(3;"Record ID";RecordID)
        {
            Caption = 'Datensatz-ID';
            DataClassification = ToBeClassified;
        }
        field(4;Type;Option)
        {
            Caption = 'Art';
            DataClassification = ToBeClassified;
            OptionMembers = Original,Copy;
        }
        field(5;"No OF Copies";Integer)
        {
            Caption = 'Anzahl Kopien';
            DataClassification = ToBeClassified;
        }
        field(6;Finished;Boolean)
        {
            Caption = 'Abgeschlossen';
            DataClassification = ToBeClassified;
        }
        field(7;"User ID";Code[50])
        {
            Caption = 'Benutzername';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Job No.")
        {
            Clustered = true;
        }
        key(Key2;Finished,"User ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        LastPrintJob: Record "Print Job";
    begin
        if LastPrintJob.FindLast then
          "Job No." := LastPrintJob."Job No." + 1
        else
          "Job No." := 1;
    end;
}

