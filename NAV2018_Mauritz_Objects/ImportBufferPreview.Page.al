Page 80004 "Import Buffer Preview"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Integer";
    SourceTableView = sorting(Number)
                      order(ascending)
                      where(Number=filter(1..));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Number;Number)
                {
                    ApplicationArea = Basic;
                }
                field(Column_01;GetBufferedValue(Header.Code,Number,1))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,1);
                }
                field(Column_02;GetBufferedValue(Header.Code,Number,2))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,2);
                }
                field(Column_03;GetBufferedValue(Header.Code,Number,3))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,3);
                }
                field(Column_04;GetBufferedValue(Header.Code,Number,4))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,4);
                }
                field(Column_05;GetBufferedValue(Header.Code,Number,5))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,5);
                }
                field(Column_06;GetBufferedValue(Header.Code,Number,6))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,6);
                }
                field(Column_07;GetBufferedValue(Header.Code,Number,7))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,7);
                }
                field(Column_08;GetBufferedValue(Header.Code,Number,8))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,8);
                }
                field(Column_09;GetBufferedValue(Header.Code,Number,9))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,9);
                }
                field(Column_10;GetBufferedValue(Header.Code,Number,10))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,10);
                }
                field(Column_11;GetBufferedValue(Header.Code,Number,11))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,11);
                }
                field(Column_12;GetBufferedValue(Header.Code,Number,12))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,12);
                }
                field(Column_13;GetBufferedValue(Header.Code,Number,13))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,13);
                }
                field(Column_14;GetBufferedValue(Header.Code,Number,14))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,14);
                }
                field(Column_15;GetBufferedValue(Header.Code,Number,15))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,15);
                }
                field(Column_16;GetBufferedValue(Header.Code,Number,16))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,16);
                }
                field(Column_17;GetBufferedValue(Header.Code,Number,17))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,17);
                }
                field(Column_18;GetBufferedValue(Header.Code,Number,18))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,18);
                }
                field(Column_19;GetBufferedValue(Header.Code,Number,19))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,19);
                }
                field(Column_20;GetBufferedValue(Header.Code,Number,20))
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+GetCaption(Header.Code,20);
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(DecColumn)
            {
                ApplicationArea = Basic;
                Caption = 'Vorherige Spalten';
                Image = PreviousSet;
                Scope = Repeater;

                trigger OnAction()
                begin
                    ColumnOffset -= 20;
                    if ColumnOffset < 0 then
                      ColumnOffset := 0;
                end;
            }
            action(IncColumn)
            {
                ApplicationArea = Basic;
                Caption = 'Nächste Spalten';
                Image = NextSet;

                trigger OnAction()
                begin
                    ColumnOffset += 20;
                end;
            }
        }
    }

    var
        Header: Record "Export/Import Header";
        ColumnOffset: Integer;

    local procedure GetBufferedValue("Code": Code[20];RecordNo: Integer;"ValueNo.": Integer) Value: Text
    var
        ImportBuffer: Record "Import Buffer";
    begin
        if ImportBuffer.Get(Code, RecordNo, "ValueNo." + ColumnOffset) then
          exit(ImportBuffer.Value);
    end;

    local procedure GetCaption("Code": Code[20];ColumnNo: Integer) Caption: Text
    var
        ImportBuffer: Record "Import Buffer";
        ImportLine: Record "Import Line";
        "Field": Record "Field";
        FirstRecordNo: Integer;
    begin
        ImportBuffer.SetRange(Code, Code);
        if ImportBuffer.FindFirst then
          FirstRecordNo := ImportBuffer."Record No.";

        if not ImportBuffer.Get(Code, FirstRecordNo, ColumnNo + ColumnOffset) then
          exit('');

        if not ImportLine.Get(Code, ImportBuffer."Source Line No.") then
          exit('');

        if ImportLine."Source Field Name" <> '' then
          exit(ImportLine."Source Field Name");

        if Field.Get(Header."Table No.", ImportLine."Destination Field No.") then
          exit(Field."Field Caption");

        if ImportLine."Source Field No." <> 0 then
          exit(Format(ImportLine."Source Field No."));
    end;


    procedure SetHeader(ImportHeader: Record "Export/Import Header")
    begin
        Header := ImportHeader;
    end;
}

