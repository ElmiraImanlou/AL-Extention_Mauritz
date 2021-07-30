PageExtension 50037 pageextension50037 extends "Contact Card"
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on ""Organizational Level Code"(Control 22)".


        //Unsupported feature: Property Insertion (Visible) on ""Correspondence Type"(Control 126)".


        //Unsupported feature: Property Insertion (Visible) on ""Language Code"(Control 33)".


        //Unsupported feature: Property Insertion (Visible) on ""Currency Code"(Control 64)".


        //Unsupported feature: Property Insertion (Visible) on "Control72(Control 72)".

        modify("Exclude from Segment")
        {
            Visible = false;
        }
        modify(Minor)
        {
            Visible = false;
        }
        modify("Parental Consent Received")
        {
            Visible = false;
        }
        // modify("Territory Code")
        // {
        //     Visible = false;
        // }
        addafter(Name)
        {
            field("Name 2"; "Name 2")
            {
                ApplicationArea = Basic;
            }
            field("Name 3"; "Name 3")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Date of Last Interaction")
        {
            field("Created at"; "Created at")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Privacy Blocked")
        {
            field("Industry Group Code"; "Industry Group Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

