Page 50009 "Ind. Grp. Cont. Status Filter"
{
    ApplicationArea = Basic;
    Caption = 'Kontaktstatusfilter';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Ind. Group Cont. Status Filter";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Industry Group Code";"Industry Group Code")
                {
                    ApplicationArea = Basic;
                }
                field("Contact Status Filter";"Contact Status Filter")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

