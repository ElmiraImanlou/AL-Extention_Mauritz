PageExtension 50033 pageextension50033 extends "Customer Disc. Groups" 
{
    layout
    {
        addafter(Description)
        {
            field("Default Discount %";"Default Discount %")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Insertion (Visible) on "SalesLineDiscounts(Action 10)".

    }
}

