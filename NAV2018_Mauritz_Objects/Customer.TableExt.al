TableExtension 50001 tableextension50001 extends Customer
{

    //Unsupported feature: Property Insertion (DataPerCompany) on "Customer(Table 18)".

    fields
    {
        field(50000; "Industry Group Code"; Code[20])
        {
            Caption = 'Branchencode';
            TableRelation = "Industry Group";
        }
        field(50002; "Cont. Bus. Rel. Filter"; Code[20])
        {
            Caption = 'Geschäftsbez.-Filter';
            FieldClass = FlowFilter;
            TableRelation = "Business Relation";
        }
        field(50003; "Contact No."; Code[20])
        {
            CalcFormula = lookup("Contact Business Relation"."Contact No." where("No." = field("No."),
                                                                                  "Business Relation Code" = field("Cont. Bus. Rel. Filter")));
            Caption = 'Kontaktnr.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Name 3"; Text[50])
        {
            Caption = 'Name 3';
            DataClassification = ToBeClassified;
        }
        field(50005; "Total Sales (LCY)"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Sales (LCY)" where("Customer No." = field("No."),
                                                                        "Posting Date" = field("Date Filter")));
            Caption = 'Gesamtumsatz';
            FieldClass = FlowField;
        }
        // field(50006;"Mobile Phone No.";Text[30])
        // {
        //     Caption = 'Mobile Phone No.';
        //     DataClassification = ToBeClassified;
        //     ExtendedDatatype = PhoneNo;
        // }
        field(50007; "Cash Sales Amount"; Decimal)
        {
            CalcFormula = sum("Customer Cash Sales"."Cash Amount" where("Customer No." = field("No."),
                                                                         "Posting Date" = field("Date Filter")));
            Caption = 'Barumsatz';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "Created at"; Date)
        {
            Caption = 'Erstellt am';
            DataClassification = ToBeClassified;
        }
        field(50015; Memo; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        // Unsupported feature: Key containing base fields
        // key(Key1;Address)
        // {
        // }
        // Unsupported feature: Key containing base fields
        // key(Key2;"E-Mail")
        // {
        // }
    }

    local procedure "+++ HALVOTEC NAV +++"()
    begin
    end;

    procedure GetMemo() CustomerMemo: Text
    var
        InStr: InStream;
    begin
        CalcFields(Memo);
        Memo.CreateInstream(InStr);
        InStr.Read(CustomerMemo);
    end;

    procedure SetMemo(CustomerMemo: Text)
    var
        OutStr: OutStream;
    begin
        CalcFields(Memo);
        Memo.CreateOutstream(OutStr);
        OutStr.Write(CustomerMemo);
    end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".

}

