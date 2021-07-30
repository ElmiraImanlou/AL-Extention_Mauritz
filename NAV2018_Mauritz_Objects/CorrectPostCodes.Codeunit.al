Codeunit 50004 "Correct Post Codes"
{

    trigger OnRun()
    begin
        // Customer.SETRANGE("Country/Region Code", 'DE');
        Customer.SetFilter("Post Code", '*,*');
        if Customer.FindSet then
          repeat
            Customer.CalcFields("Contact No.");
            if Contact.Get(Customer."Contact No.") then begin
              Customer."Post Code" := Contact."Post Code";
              Customer.Modify(false);
            end;
          until Customer.Next = 0;
    end;

    var
        Customer: Record Customer;
        Contact: Record Contact;
}

