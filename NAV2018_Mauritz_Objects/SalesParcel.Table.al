Table 50010 "Sales Parcel"
{

    fields
    {
        field(1;"Document Type";Option)
        {
            Caption = 'Belegart';
            DataClassification = ToBeClassified;
            OptionCaption = 'Auftrag,Reklamation,Geb. Rechnung,Geb. Lieferung';
            OptionMembers = SalesOrder,SalesReturnOrder,PostedSalesInvoice,PostedSalesShipment;
        }
        field(2;"Document No.";Code[20])
        {
            Caption = 'Belegnr.';
            DataClassification = ToBeClassified;
        }
        field(3;"Entry No.";Integer)
        {
            Caption = 'lfd. Nr.';
            DataClassification = ToBeClassified;
        }
        field(10;Weight;Decimal)
        {
            Caption = 'Gewicht (kg)';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(11;"Tracking No.";Text[50])
        {
            Caption = 'Sendungsverfolgungsnr.';
            DataClassification = ToBeClassified;
        }
        field(12;"Location Code";Code[20])
        {
            Caption = 'Lagerort';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Location;
        }
        field(13;PDFBase64;Blob)
        {
            Caption = 'PDF';
            DataClassification = ToBeClassified;
        }
        field(14;Printed;Boolean)
        {
            Caption = 'Gedruckt';
            DataClassification = ToBeClassified;
        }
        field(15;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Versandauftrag erhalten,Versandauftrag akzeptiert,Versanddepot,unterwegs,Auslieferdepot,Ausgeliefert';
            OptionMembers = SHIPMENT,ACCEPTED,AT_SENDING_DEPOT,ON_THE_ROAD,AT_DELIVERY_DEPOT,DELIVERED;
        }
        field(16;"Status Date";DateTime)
        {
            Caption = 'Statusdatum';
            DataClassification = ToBeClassified;
        }
        field(17;"Delivered Date";Date)
        {
            Caption = 'Ausgeliefert';
            DataClassification = ToBeClassified;
        }
        field(18;Info;Text[250])
        {
            Caption = 'Information';
            DataClassification = ToBeClassified;
        }
        field(19;Express;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20;"Parcel Order Date";Date)
        {
            Caption = 'Versanddatum';
            DataClassification = ToBeClassified;
        }
        field(21;"COD Amount";Decimal)
        {
            Caption = 'Nachnahme-Betrag';
            DataClassification = ToBeClassified;
        }
        field(22;"COD Currency";Code[10])
        {
            Caption = 'Nachnahme Währung';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(23;"Sell-to Customer Name";Text[100])
        {
            Caption = 'Verk. an Debitor Name';
            DataClassification = ToBeClassified;
        }
        field(24;"Sell-to Customer Name 2";Text[100])
        {
            Caption = 'Verk. an Debitor Name 2';
            DataClassification = ToBeClassified;
        }
        field(25;"Sell-to Post Code";Code[20])
        {
            Caption = 'Verk. an PLZ-Code';
            DataClassification = ToBeClassified;
        }
        field(26;"XML Response";Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(27;"Ship-to Name";Text[100])
        {
            Caption = 'Lief. an Name';
            DataClassification = ToBeClassified;
        }
        field(28;"Ship-to Name 2";Text[100])
        {
            Caption = 'Lief. an Name 2';
            DataClassification = ToBeClassified;
        }
        field(29;"Ship-to Post Code";Code[20])
        {
            Caption = 'Lief. an PLZ-Code';
            DataClassification = ToBeClassified;
        }
        field(30;"XML Request";Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(31;"Ship-to Country/Region Code";Code[10])
        {
            Caption = 'Lief. an Ländercode';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Entry No.")
        {
            Clustered = true;
        }
        key(Key2;Status,"Delivered Date","Tracking No.")
        {
        }
        key(Key3;"Parcel Order Date")
        {
        }
    }

    fieldgroups
    {
    }
}

