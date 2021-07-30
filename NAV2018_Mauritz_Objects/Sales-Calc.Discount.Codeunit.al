Codeunit 70060 "Sales-Calc. Discount60"
{

    trigger OnRun()
    begin

        //  OBJECT Modification "Sales-Calc. Discount"(Codeunit 60)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=18.07.19;
        //      Time=113724T;
        //      Modified=Yes;
        //      Version List=NAVW111.00.00.24232;
        //    }
        //    PROPERTIES
        //    {
        //      Target="Sales-Calc. Discount"(Codeunit 60);
        //    }
        //    CHANGES
        //    {
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          SalesLine.COPY(Rec);
        //  
        //                                          TempSalesHeader.GET("Document Type","Document No.");
        //                                          UpdateHeader := TRUE;
        //                                          CalculateInvoiceDiscount(TempSalesHeader,TempSalesLine);
        //  
        //                                          IF GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") THEN;
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          EXIT;
        //                                          #1..7
        //                                        END;
        //  
        //                           Target=OnRun }
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

