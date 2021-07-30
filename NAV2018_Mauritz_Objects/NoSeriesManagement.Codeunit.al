Codeunit 70000396 NoSeriesManagement396
{

    trigger OnRun()
    begin

        //  OBJECT Modification NoSeriesManagement(Codeunit 396)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=04092019D;
        //      Time=110635T;
        //      Modified=Yes;
        //      Version List=NAVW111.00;
        //    }
        //    PROPERTIES
        //    {
        //      Target=NoSeriesManagement(Codeunit 396);
        //    }
        //    CHANGES
        //    {
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          IF SeriesDate = 0D THEN
        //                                            SeriesDate := WORKDATE;
        //  
        //                                          #4..60
        //                                              Text007,
        //                                              NoSeriesLine."Ending No.",NoSeriesCode);
        //                                          END;
        //                                          NoSeriesLine.VALIDATE(Open);
        //  
        //                                          IF ModifySeries THEN
        //                                            NoSeriesLine.MODIFY
        //                                          ELSE
        //                                            LastNoSeriesLine := NoSeriesLine;
        //                                          EXIT(NoSeriesLine."Last No. Used");
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..63
        //  
        //                                          IF ModifySeries THEN BEGIN
        //                                            NoSeriesLine.VALIDATE(Open);
        //                                            NoSeriesLine.MODIFY
        //                                          END ELSE
        //                                            LastNoSeriesLine := NoSeriesLine;
        //                                          EXIT(NoSeriesLine."Last No. Used");
        //                                        END;
        //  
        //                           Target=GetNextNo3(PROCEDURE 22) }
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

