PageExtension 50038 pageextension50038 extends "Contact List"
{
    layout
    {
        // modify("Territory Code")
        // {
        //     Visible = false;
        // }
        modify("Currency Code")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Industry Group Code"; "Industry Group Code")
            {
                ApplicationArea = Basic;
            }
        }
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
        addafter("Company Name")
        {
            field(Address; Address)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Post Code")
        {
            field(City; City)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("E-Mail")
        {
            // field("Territory Code"; "Territory Code")
            // {
            //     ApplicationArea = Basic;
            //     Caption = 'Territory Code';
            // }
        }
        addafter("Parental Consent Received")
        {
            field("Assigned Customer"; "Assigned Customer")
            {
                ApplicationArea = Basic;
            }
            field("Assigned Vendor"; "Assigned Vendor")
            {
                ApplicationArea = Basic;
            }
            field("Created at"; "Created at")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter(FullSyncWithExchange)
        {
            action(IToK)
            {
                ApplicationArea = Basic;
                Caption = 'I=>K';
                Enabled = ItoK_Enabled;
                Image = EditList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Contact: Record Contact;
                begin
                    CurrPage.SetSelectionFilter(Contact);
                    Contact.SetRange("Territory Code", 'I');
                    Contact.ModifyAll("Territory Code", 'K');
                end;
            }
        }
        addafter("Contact Labels")
        {
            action(Action50010)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Contact Labels';
                Image = "Report";
                RunObject = Report Kontaktetiketten;
                ToolTip = 'View mailing labels with names and addresses of your contacts. For example, you can use the report to review contact information before you send sales and marketing campaign letters.';
            }
        }
    }

    var
        ItoK_Enabled: Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //begin
    /*
    ItoK_Enabled := ItoKEnabled;
    */
    //end;

    local procedure ItoKEnabled() Enabled: Boolean
    var
        Contact: Record Contact;
    begin
        CurrPage.SetSelectionFilter(Contact);
        Contact.SetRange("Territory Code", 'I');
        Enabled := not Contact.IsEmpty;
    end;
}

