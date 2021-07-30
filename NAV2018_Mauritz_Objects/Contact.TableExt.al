TableExtension 50019 tableextension50019 extends Contact 
{

    //Unsupported feature: Property Insertion (DataPerCompany) on "Contact(Table 5050)".

    fields
    {
        field(50000;"Industry Group Code";Code[20])
        {
            Caption = 'Branchencode';
            TableRelation = "Industry Group";
        }
        field(50004;"Name 3";Text[50])
        {
            Caption = 'Name 3';
            DataClassification = ToBeClassified;
        }
        field(50005;"Assigned Customer";Code[20])
        {
            CalcFormula = lookup("Contact Business Relation"."No." where ("Contact No."=field("No."),
                                                                          "Link to Table"=const(Customer)));
            Caption = 'Debitor';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006;"Assigned Vendor";Code[20])
        {
            CalcFormula = lookup("Contact Business Relation"."No." where ("Contact No."=field("No."),
                                                                          "Link to Table"=const(Vendor)));
            Caption = 'Kreditor';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007;"Created at";Date)
        {
            Caption = 'Angelegt am';
            DataClassification = ToBeClassified;
        }
    }


    //Unsupported feature: Code Modification on "CreateCustomer(PROCEDURE 3)".

    //procedure CreateCustomer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
        CheckIfPrivacyBlockedGeneric;
        RMSetup.GET;
        #4..50
          Cust."Payment Method Code" := CustTemplate."Payment Method Code";
          Cust."Prices Including VAT" := CustTemplate."Prices Including VAT";
          Cust."Shipment Method Code" := CustTemplate."Shipment Method Code";
          Cust.MODIFY;

          DefaultDim.SETRANGE("Table ID",DATABASE::"Customer Template");
        #57..74
        ELSE
          IF NOT HideValidationDialog THEN
            MESSAGE(RelatedRecordIsCreatedMsg,Cust.TABLECAPTION);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..53
          // HLVNAV::BEGIN
          Cust."Reminder Terms Code" := CustTemplate."Reminder Terms Code";
          // HLVNAV::END
        #54..77

        // HLVNAV::BEGIN
        PAGE.RUN(PAGE::"Customer Card",Cust);
        // HLVNAV::END
        */
    //end;
}

