Codeunit 70000441 "Prepayment Mgt.441"
{

    trigger OnRun()
    begin

        //  OBJECT Modification "Prepayment Mgt."(Codeunit 441)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=28.08.19;
        //      Time=163835T;
        //      Modified=Yes;
        //      Version List=NAVW111.00.00.26401;
        //    }
        //    PROPERTIES
        //    {
        //      Target="Prepayment Mgt."(Codeunit 441);
        //    }
        //    CHANGES
        //    {
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          WITH SalesPrepaymentPct DO BEGIN
        //                                            IF (SalesLine.Type <> SalesLine.Type::Item) OR (SalesLine."No." = '') OR
        //                                               (SalesLine."Document Type" <> SalesLine."Document Type"::Order)
        //                                          #4..15
        //                                                      EXIT;
        //                                                  END;
        //                                                "Sales Type"::"Customer Price Group":
        //                                                  BEGIN
        //                                                    Cust.GET(SalesLine."Bill-to Customer No.");
        //                                                    IF Cust."Customer Price Group" <> '' THEN
        //                                          #22..31
        //                                              END;
        //                                            END;
        //                                          END;
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..18
        //                                                  // HLVNAV::BEGIN
        //                                                  IF SalesLine."Bill-to Customer No." <> '' THEN
        //                                                  // HLVNAV::END
        //                                          #19..34
        //                                        END;
        //  
        //                           Target=SetSalesPrepaymentPct(PROCEDURE 1000000000) }
        //    }
        //    CODE
        //    {
        //  
        //      BEGIN
        //      END.
        //    }
        //  }
        //  
        //  

    end;
}

