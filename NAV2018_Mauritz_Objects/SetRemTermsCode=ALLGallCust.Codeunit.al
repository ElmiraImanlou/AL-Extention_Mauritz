Codeunit 50009 "SetRemTermsCode=ALLG allCust"
{

    trigger OnRun()
    var
        Customer: Record Customer;
    begin
        Customer.ModifyAll("Reminder Terms Code", 'ALLGEMEIN');
    end;
}

