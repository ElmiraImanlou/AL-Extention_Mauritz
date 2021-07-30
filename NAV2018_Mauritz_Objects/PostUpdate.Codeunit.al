Codeunit 50001 "Post Update"
{

    trigger OnRun()
    var
        Contact: Record Contact;
    begin
        // Contact.FINDSET;
        // REPEAT
        //  IF Contact."Territory Code" = '' THEN
        //    Contact."Territory Code" := 'I';
        //
        //  IF Contact."Salesperson Code" = '' THEN
        //    Contact."Salesperson Code" := '0';
        //
        //  Contact.MODIFY(FALSE);
        // UNTIL Contact.NEXT = 0;
        // EXIT;

        kastl.Open('#1####################\#2####################');
        UpdateBOMComponentDescription;


        kastl.Close;
    end;

    var
        kastl: Dialog;
        CountAll: Integer;
        CountDone: Integer;

    local procedure AssignIndustryGroupToContacts()
    var
        Contact: Record Contact;
        ContactIndustryGroup: Record "Contact Industry Group";
        Customer: Record Customer;
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        if not Contact.FindSet then
          exit;

        CountAll := Contact.Count;
        CountDone := 0;

        repeat
          if Customer.Get(Contact."No.") then begin
            if not ContactBusinessRelation.Get(Contact."No.", 'DEB') then begin
              ContactBusinessRelation.Init;
              ContactBusinessRelation."Contact No." := Contact."No.";
              ContactBusinessRelation."Business Relation Code" := 'DEB';
              ContactBusinessRelation."Link to Table" := ContactBusinessRelation."link to table"::Customer;
              ContactBusinessRelation."No." := Contact."No.";
              ContactBusinessRelation.Insert(true);
            end;
            if Contact."Industry Group Code" <> '' then
              if Customer."Industry Group Code" = '' then begin
                Customer."Industry Group Code" := Contact."Industry Group Code";
                Customer.Modify(false);
              end;
          end;
          CountDone += 1;
          kastl.Update(2, ROUND(CountDone/CountAll*10000, 1));
        until Contact.Next = 0;
    end;

    local procedure AssignCustomersToContacts()
    var
        Customer: Record Customer;
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        MarketingSetup: Record "Marketing Setup";
    begin
        if not Customer.FindSet then
          exit;

        MarketingSetup.Get;
        CountAll := Customer.Count;
        CountDone := 0;

        repeat
          Customer.CalcFields("Contact No.");
          if Customer."Contact No." = '' then
            if Contact.Get(Customer."No.") then begin
              ContactBusinessRelation.Init;
              ContactBusinessRelation."Contact No." := Contact."No.";
              ContactBusinessRelation."No." := Customer."No.";
              ContactBusinessRelation."Link to Table" := ContactBusinessRelation."link to table"::Customer;
              ContactBusinessRelation."Business Relation Code" := MarketingSetup."Bus. Rel. Code for Customers";
              if ContactBusinessRelation.Insert then;
            end;

          CountDone += 1;
          kastl.Update(2, ROUND(CountDone/CountAll*10000, 1));

        until Customer.Next = 0;
    end;

    local procedure AssignVendorsToContacts()
    var
        Vendor: Record Vendor;
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        MarketingSetup: Record "Marketing Setup";
    begin
        if not Vendor.FindSet then
          exit;

        MarketingSetup.Get;
        CountAll := Vendor.Count;
        CountDone := 0;

        repeat
          Vendor.CalcFields("Contact No.");
          if Vendor."Contact No." = '' then
            if Contact.Get(Vendor."No.") then
              if (Contact.Name = Vendor.Name) and (Contact."Name 2" = Vendor."Name 2") and (Contact."Name 3" = Vendor."Name 3") and
                 (Contact.Address = Vendor.Address) and (Contact."Address 2" = Vendor."Address 2") and
                 (Contact."Post Code" = Vendor."Post Code") and (Contact.City = Vendor.City)
              then begin
                ContactBusinessRelation.Init;
                ContactBusinessRelation."Contact No." := Contact."No.";
                ContactBusinessRelation."No." := Vendor."No.";
                ContactBusinessRelation."Link to Table" := ContactBusinessRelation."link to table"::Vendor;
                ContactBusinessRelation."Business Relation Code" := MarketingSetup."Bus. Rel. Code for Vendors";
                if ContactBusinessRelation.Insert then;
              end;

          CountDone += 1;
          kastl.Update(2, ROUND(CountDone/CountAll*10000, 1));

        until Vendor.Next = 0;
    end;

    local procedure TransferContactAddressToCustomer()
    var
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        PostCode: Record "Post Code";
    begin
        with ContactBusinessRelation do begin
          SetRange("Link to Table", "link to table"::Customer);
          CountAll := Count;
          CountDone := 0;
          if FindSet(false) then
            repeat
              if Contact.Get("Contact No.") and Customer.Get(Customer."No.") then begin
                Contact.Name := DelChr(Contact.Name, '>', ' ');
                Contact."Name 2" := DelChr(Contact."Name 2", '>', ' ');
                Contact."Name 3" := DelChr(Contact."Name 3", '>', ' ');
                Contact.Address := DelChr(Contact.Address, '>', ' ');
                Contact."Address 2" := DelChr(Contact."Address 2", '>', ' ');
                Contact.Modify(false);

                Customer.Name := Contact.Name;
                Customer."Name 2" := Contact."Name 2";
                Customer."Name 3" := Contact."Name 3";
                Customer.Address := Contact.Address;
                Customer."Address 2" := Contact."Address 2";
                Customer."Post Code" := Contact."Post Code";
                Customer.City := Contact.City;
                Customer."Country/Region Code" := Contact."Country/Region Code";
                Customer.Modify(false);
              end;
              CountDone += 1;
              kastl.Update(2, ROUND(CountDone/CountAll*10000, 1));

            until ContactBusinessRelation.Next = 0;
        end;

        Customer.Reset;
        Contact.Reset;

        if Customer.FindSet(true) then repeat
          if (StrLen(Customer."Post Code") = 4) and (Customer."VAT Bus. Posting Group" = 'INLAND') then begin
            PostCode.SetRange("Country/Region Code", 'DE');
            PostCode.SetRange(Code, StrSubstNo('0%1', Customer."Post Code"));
            if PostCode.FindFirst then begin
              Customer."Post Code" := PostCode.Code;
              Customer.City := PostCode.City;
              Customer."Country/Region Code" := PostCode."Country/Region Code";
              Customer.Modify(false);

              Customer.CalcFields("Contact No.");
              if Contact.Get(Customer."Contact No.") then begin
                Contact."Post Code" := Customer."Post Code";
                Contact.City := Customer.City;
                Contact."Country/Region Code" := Customer."Country/Region Code";
                Contact.Modify(false);
              end;
            end;
          end;
        until Customer.Next = 0;
    end;

    local procedure UpdateBOMComponentDescription()
    var
        BOMComponent: Record "BOM Component";
        Item: Record Item;
    begin
        CountAll := BOMComponent.Count;
        CountDone := 0;

        if BOMComponent.FindSet then
          repeat
            if (BOMComponent.Type = BOMComponent.Type::Item) and (BOMComponent.Description = '') then
              if Item.Get(BOMComponent."No.") then begin
                BOMComponent.Description := Item.Description;
                BOMComponent.Modify(false);
              end;
            CountDone += 1;
            kastl.Update(2, ROUND(CountDone/CountAll*10000, 1));

          until BOMComponent.Next = 0;
    end;
}

