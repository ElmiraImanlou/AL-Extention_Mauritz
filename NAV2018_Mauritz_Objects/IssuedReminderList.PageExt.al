PageExtension 50030 pageextension50030 extends "Issued Reminder List" 
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on ""Currency Code"(Control 12)".


        //Unsupported feature: Property Deletion (Visible) on ""No. Printed"(Control 46)".


        //Unsupported feature: Property Deletion (Visible) on ""Post Code"(Control 38)".


        //Unsupported feature: Property Deletion (Visible) on "City(Control 14)".

        addfirst(Control1)
        {
            field("Posting Date";"Posting Date")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Name)
        {
            field("Reminder Level";"Reminder Level")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

