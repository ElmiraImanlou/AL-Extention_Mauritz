Page 50015 "Customer Memo"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field(txtMemo;txtMemo)
            {
                ApplicationArea = Basic;
                MultiLine = true;

                trigger OnValidate()
                begin
                    SetMemo(txtMemo);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        txtMemo := GetMemo;
    end;

    var
        txtMemo: Text;
}

