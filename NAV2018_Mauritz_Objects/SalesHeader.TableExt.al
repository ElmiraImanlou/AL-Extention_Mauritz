TableExtension 50006 tableextension50006 extends "Sales Header" 
{
    fields
    {

        //Unsupported feature: Code Modification on ""Bill-to Name"(Field 5).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF ShouldLookForCustomerByName("Bill-to Customer No.") THEN
              VALIDATE("Bill-to Customer No.",Customer.GetCustNo("Bill-to Name"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            // HLVNAV::BEGIN
            // IF ShouldLookForCustomerByName("Bill-to Customer No.") THEN
            //  VALIDATE("Bill-to Customer No.",Customer.GetCustNo("Bill-to Name"));
            // HLVNAV::END
            */
        //end;


        //Unsupported feature: Code Modification on ""Requested Delivery Date"(Field 5790).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);
            IF "Promised Delivery Date" <> 0D THEN
              ERROR(
                Text028,
                FIELDCAPTION("Requested Delivery Date"),
                FIELDCAPTION("Promised Delivery Date"));

            IF "Requested Delivery Date" <> xRec."Requested Delivery Date" THEN
              UpdateSalesLines(FIELDCAPTION("Requested Delivery Date"),CurrFieldNo <> 0);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);
            // HLVNAV::BEGIN
            // IF "Promised Delivery Date" <> 0D THEN
            //  ERROR(
            //    Text028,
            //    FIELDCAPTION("Requested Delivery Date"),
            //    FIELDCAPTION("Promised Delivery Date"));
            // HLVNAV::END
            #7..9
            */
        //end;
        field(50000;"Customer EMail";Text[100])
        {
            CalcFormula = lookup(Customer."E-Mail" where ("No."=field("Sell-to Customer No.")));
            Caption = 'Debitor E-Mailadresse';
            FieldClass = FlowField;
        }
        field(50001;"Shipping Avis to Email";Text[50])
        {
            Caption = 'Sendungsavis an E-Mail';
            DataClassification = ToBeClassified;
        }
        field(50002;"Engraving Location";Code[20])
        {
            Caption = 'Gravurort';
            DataClassification = ToBeClassified;
            Description = 'MAURITZ';
            TableRelation = "Engraving Location";
        }
    }


    //Unsupported feature: Code Modification on "InitRecord(PROCEDURE 10)".

    //procedure InitRecord();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesSetup.GET;

        CASE "Document Type" OF
        #4..40

        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote] THEN
          BEGIN
          "Shipment Date" := WORKDATE;
          "Order Date" := WORKDATE;
        END;
        IF "Document Type" = "Document Type"::"Return Order" THEN
        #48..71
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header","Document Type","No.");

        OnAfterInitRecord(Rec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..43
          // HLVNAV::BEGIN
          // "Shipment Date" := WORKDATE;
          // HLVNAV::END
        #45..74
        */
    //end;


    //Unsupported feature: Code Modification on "ShouldLookForCustomerByName(PROCEDURE 181)".

    //procedure ShouldLookForCustomerByName();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF CustomerNo = '' THEN
          EXIT(TRUE);

        IF NOT Customer.GET(CustomerNo) THEN
          EXIT(TRUE);

        EXIT(NOT Customer."Disable Search by Name");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF CustomerNo = '' THEN
        // HLVNAV::BEGIN
        // <<  EXIT(TRUE);
          EXIT(FALSE);
        // HLVNAV::END
        #3..7
        */
    //end;
}

