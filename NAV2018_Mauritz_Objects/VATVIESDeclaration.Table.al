Table 60001 "VAT VIES Declaration"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2;Year;Integer)
        {
            Caption = 'Jahr';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Year > 0 then
                  case Period of
                    1..4:
                      Validate("From Date", Dmy2date(1, Period*3, Year));
                    5:
                      Validate("From Date", Dmy2date(1, 1, Year));
                    10..14:
                      Validate("From Date", Dmy2date(1, (Period-10)*3-2, Year));
                    21..32:
                      Validate("From Date", Dmy2date(1, Period-20, Year));
                  end;
            end;
        }
        field(3;Period;Option)
        {
            Caption = 'Periode';
            DataClassification = ToBeClassified;
            OptionCaption = ',Quartal 1,Quartal 2,Quartal 3,Quartal 4,Jahr,,,,,0,Jan/Feb,Apr/Mai,Jul/Aug,Okt/Nov,,,,,,,Januar,Februar,März,April,Mai,Juni,Juli,August,September,Oktober,November,Dezember';
            OptionMembers = ,Quarter1,Quarter2,Quarter3,Quarter4,Year,,,,,,"Jan/Feb","Apr/May","Jul/Aug","Oct/Nov",,,,,,,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec;

            trigger OnValidate()
            begin
                if Year > 0 then
                  case Period of
                    1..4:
                      Validate("From Date", Dmy2date(1, Period*3-2, Year));
                    5:
                      Validate("From Date", Dmy2date(1, 1, Year));
                    10..14:
                      Validate("From Date", Dmy2date(1, (Period-10)*3-2, Year));
                    21..32:
                      Validate("From Date", Dmy2date(1, Period-20, Year));
                  end;
            end;
        }
        field(4;"From Date";Date)
        {
            Caption = 'Von Datum';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Year > 0 then
                  case Period of
                    1..4:
                      Validate("To Date", CalcDate('<CQ>', "From Date"));
                    5:
                      Validate("To Date", CalcDate('<CY>', "From Date"));
                    10..14:
                      Validate("To Date", CalcDate('<CM+1M>', "From Date"));
                    21..32:
                      Validate("To Date", CalcDate('<CM>', "From Date"));
                  end;
            end;
        }
        field(5;"To Date";Date)
        {
            Caption = 'Bis Datum';
            DataClassification = ToBeClassified;
        }
        field(6;"VAT Posting Group Filter";Text[100])
        {
            Caption = 'MwSt-Buchungsgruppenfilter';
            DataClassification = ToBeClassified;
        }
        field(7;Correction;Boolean)
        {
            Caption = 'Berichtigung';
            DataClassification = ToBeClassified;
        }
        field(8;Cancelation;Boolean)
        {
            Caption = 'Widerruf';
            DataClassification = ToBeClassified;
        }
        field(9;"XML Document";Blob)
        {
            Caption = 'XML-Dokument';
            DataClassification = ToBeClassified;
        }
        field(10;"XML Document created";Boolean)
        {
            Caption = 'XML-Dokument erstellt';
            DataClassification = ToBeClassified;
        }
        field(11;"Transmission DateTime";DateTime)
        {
            Caption = 'Übertragung durchgeführt';
            DataClassification = ToBeClassified;
        }
        field(12;"Transmission successfull";Boolean)
        {
            Caption = 'Übertragung erfolgreich';
            DataClassification = ToBeClassified;
        }
        field(13;"Transmission Response Document";Blob)
        {
            Caption = 'Übertragungsprotokoll';
            DataClassification = ToBeClassified;
        }
        field(14;Test;Boolean)
        {
            Caption = 'Test';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        xRec.TestField("Transmission successfull", false);
    end;
}

