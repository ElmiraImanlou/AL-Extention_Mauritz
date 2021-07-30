PageExtension 50029 pageextension50029 extends "Reminder List" 
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on ""No."(Control 2)".


        //Unsupported feature: Property Insertion (Visible) on ""Currency Code"(Control 16)".

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

