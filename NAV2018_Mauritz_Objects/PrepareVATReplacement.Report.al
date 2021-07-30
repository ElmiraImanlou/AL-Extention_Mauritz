Report 50700 "Prepare VAT Replacement"
{
    Caption = 'Umsetzung der MwSt.-Anpassung durch die Bundesregierung';
    Permissions = TableData "VAT Product Posting Group" = rim,
                  TableData "VAT Posting Setup" = ri;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
            column(ReportForNavId_50000; 50000)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("7")
                {
                    Caption = '7 -> 5 %';
                    field("VATProdPostGrpFrom[1]"; VATProdPostGrpFrom[1])
                    {
                        ApplicationArea = Basic;
                        Caption = 'MwSt. Prod.-Buchungsgruppe 7%';
                        TableRelation = "VAT Product Posting Group";
                    }
                    field("VATProdPostGrpTo[1]"; VATProdPostGrpTo[1])
                    {
                        ApplicationArea = Basic;
                        Caption = 'MwSt. Prod.-Buchungsgruppe 5%';
                    }
                }
                group("19")
                {
                    Caption = '19 -> 16 %';
                    field("VATProdPostGrpFrom[2]"; VATProdPostGrpFrom[2])
                    {
                        ApplicationArea = Basic;
                        Caption = 'MwSt. Prod.-Buchungsgruppe 19%';
                        TableRelation = "VAT Product Posting Group";
                    }
                    field("VATProdPostGrpTo[2]"; VATProdPostGrpTo[2])
                    {
                        ApplicationArea = Basic;
                        Caption = 'MwSt. Prod.-Buchungsgruppe 7%';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        i: Integer;
        VATProductPostingGroup: array[2] of Record "VAT Product Posting Group";
        VATPostingSetup: array[2] of Record "VAT Posting Setup";
    begin
        for i := 1 to 2 do begin
            if VATProductPostingGroup[1].Get(VATProdPostGrpFrom[i]) then begin
                VATProductPostingGroup[1]."Replace Start Date" := 20200701D;
                VATProductPostingGroup[1]."Replace End Date" := 20201231D;
                VATProductPostingGroup[1]."Replace by Code" := VATProdPostGrpTo[i];
                VATProductPostingGroup[1].Modify(true);

                VATProductPostingGroup[2].Init;
                VATProductPostingGroup[2].Code := VATProdPostGrpTo[i];
                if i = 1 then
                    VATProductPostingGroup[2].Description := Regex.Replace(VATProductPostingGroup[1].Description, '7', '5')
                else
                    VATProductPostingGroup[2].Description := Regex.Replace(VATProductPostingGroup[1].Description, '19', '16');

                if VATProductPostingGroup[2].Insert then;

                VATPostingSetup[1].SetRange("VAT Prod. Posting Group", VATProdPostGrpFrom[i]);
                if VATPostingSetup[1].FindSet(false) then
                    repeat
                        VATPostingSetup[2].Init;
                        VATPostingSetup[2].TransferFields(VATPostingSetup[1]);
                        VATPostingSetup[2]."VAT Bus. Posting Group" := VATPostingSetup[1]."VAT Bus. Posting Group";
                        VATPostingSetup[2]."VAT Prod. Posting Group" := VATProdPostGrpTo[i];
                        if i = 1 then begin
                            if VATPostingSetup[2]."VAT %" = 7 then
                                VATPostingSetup[2]."VAT %" := 5;
                            VATPostingSetup[2]."VAT Identifier" := Regex.Replace(VATPostingSetup[2]."VAT Identifier", '7', '5');
                        end else begin
                            if VATPostingSetup[2]."VAT %" = 19 then
                                VATPostingSetup[2]."VAT %" := 16;
                            VATPostingSetup[2]."VAT Identifier" := Regex.Replace(VATPostingSetup[2]."VAT Identifier", '19', '16');
                        end;
                        if VATPostingSetup[2].Insert then;
                    until VATPostingSetup[1].Next = 0
            end;
        end;
    end;

    var
        VATProdPostGrpFrom: array[2] of Code[10];
        VATProdPostGrpTo: array[2] of Code[10];
        Regex: dotnet Regex;
}

