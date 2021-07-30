PageExtension 50027 pageextension50027 extends "Ship-to Address" 
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on "GLN(Control 7)".

        addafter(Name)
        {
            field("Name 2";"Name 2")
            {
                ApplicationArea = Basic;
            }
        }
    }


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF Customer.GET(GetFilterCustNo) THEN BEGIN
          VALIDATE(Name,Customer.Name);
          VALIDATE(Address,Customer.Address);
          VALIDATE("Address 2",Customer."Address 2");
          VALIDATE("Country/Region Code",Customer."Country/Region Code");
          VALIDATE(City,Customer.City);
          VALIDATE(County,Customer.County);
          VALIDATE("Post Code",Customer."Post Code");
          VALIDATE(Contact,Customer.Contact);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
          "Country/Region Code" := Customer."Country/Region Code";
          City := Customer.City;
          County := Customer.County;
          "Post Code" := Customer."Post Code";
          VALIDATE(Contact,Customer.Contact);
        END;
        */
    //end;
}

