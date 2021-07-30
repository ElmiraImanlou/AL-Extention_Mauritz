PageExtension 50017 pageextension50017 extends "Purchase Order"
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on ""Due Date"(Control 36)".


        //Unsupported feature: Property Insertion (Visible) on ""No. of Archived Versions"(Control 171)".


        //Unsupported feature: Property Insertion (Visible) on ""Order Date"(Control 14)".


        //Unsupported feature: Property Insertion (Visible) on ""Order Address Code"(Control 96)".


        //Unsupported feature: Property Insertion (Visible) on ""Responsibility Center"(Control 131)".


        //Unsupported feature: Property Insertion (Visible) on ""Assigned User ID"(Control 72)".

        // modify("Requested Receipt Date")
        // {
        //     Visible = false;
        // }
        // modify("Promised Receipt Date")
        // {
        //     Visible = false;
        // }
        // addafter("Due Date")
        // {
        //     field("Requested Receipt Date";"Requested Receipt Date")
        //     {
        //         ApplicationArea = Basic;
        //     }
        // }
        // addafter("Inbound Whse. Handling Time")
        // {
        //     field("Promised Receipt Date";"Promised Receipt Date")
        //     {
        //         ApplicationArea = Basic;
        //     }
        // }
    }
}

