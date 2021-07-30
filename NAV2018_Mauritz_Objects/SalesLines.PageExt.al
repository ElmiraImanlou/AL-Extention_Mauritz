PageExtension 50034 pageextension50034 extends "Sales Lines" 
{
    layout
    {
        modify("Document Type")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Document No.")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Sell-to Customer No.")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Line No.")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify(Type)
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("No.")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Variant Code")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify(Description)
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Location Code")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify(Reserve)
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify(Quantity)
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Qty. to Ship")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Reserved Qty. (Base)")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Unit of Measure Code")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Line Amount")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Job No.")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Work Type Code")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("ShortcutDimCode[3]")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("ShortcutDimCode[4]")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("ShortcutDimCode[5]")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("ShortcutDimCode[6]")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("ShortcutDimCode[7]")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("ShortcutDimCode[8]")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Shipment Date")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        modify("Outstanding Quantity")
        {
            Style = Subordinate;
            StyleExpr = HighlightLine;
        }
        addafter("Sell-to Customer No.")
        {
            field("Customer Name";"Customer Name")
            {
                ApplicationArea = Basic;
                Style = Subordinate;
                StyleExpr = HighlightLine;
            }
        }
    }

    var
        LastDocType: Integer;
        LastDocNo: Code[20];
        [InDataSet]
        HighlightLine: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ShowShortcutDimCode(ShortcutDimCode);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        ShowShortcutDimCode(ShortcutDimCode);

        IF ("Document Type" <> LastDocType) OR ("Document No." <> LastDocNo) THEN
          HighlightLine := NOT HighlightLine;

        LastDocType := "Document Type";
        LastDocNo := "Document No.";
        */
    //end;
}

