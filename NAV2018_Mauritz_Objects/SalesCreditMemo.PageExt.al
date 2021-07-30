PageExtension 50014 pageextension50014 extends "Sales Credit Memo"
{
    layout
    {
        modify("Bill-to Contact")
        {
            Visible = false;
        }
        addafter("Job Queue Status")
        {
            field("Engraving Location"; "Engraving Location")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Bill-to Name")
        {
            field("Bill-to Name 2"; "Bill-to Name 2")
            {
                ApplicationArea = Basic;
                Caption = 'Bill-to Name 2';
            }
            // field("Bill-to Contact";"Bill-to Contact")
            // {
            //     ApplicationArea = Basic;
            //     Caption = 'Bill-to Contact';
            // }
        }
    }
}

