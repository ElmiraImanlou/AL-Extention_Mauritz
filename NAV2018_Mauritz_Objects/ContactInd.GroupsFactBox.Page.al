Page 50003 "Contact Ind. Groups FactBox"
{
    Caption = 'Branchen';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Contact Industry Group";
    SourceTableView = sorting("Contact No.","Industry Group Code")
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Industry Group Code";"Industry Group Code")
                {
                    ApplicationArea = Basic;
                }
                field("Industry Group Description";"Industry Group Description")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Edit)
            {
                ApplicationArea = Basic;
                Caption = 'Bearbeiten';
                Image = Edit;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ContactIndustryGroup: Record "Contact Industry Group";
                begin
                    FilterGroup(4);
                    ContactIndustryGroup.SetRange("Contact No.", GetFilter("Contact No."));
                    Page.RunModal(Page::"Contact Industry Groups", ContactIndustryGroup);
                    FilterGroup(0);

                    CurrPage.Update(false);
                end;
            }
        }
    }
}

