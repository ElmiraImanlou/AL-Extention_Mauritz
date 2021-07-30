PageExtension 50028 pageextension50028 extends "Post Codes" 
{
    actions
    {
        addfirst(processing)
        {
            action("Import CSV")
            {
                ApplicationArea = Basic;
                Caption = 'Import CSV';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Codeunit "Import PostCodes";
            }
        }
    }
}

