Codeunit 50007 "Import PostCodes"
{

    trigger OnRun()
    begin
        ServerFilename := FileManagement.UploadFile('CSV-Datei auswählen', '');
        ServerFile.TextMode(true);
        ServerFile.Open(ServerFilename);

        while ServerFile.Read(Line) <> 0 do
          if Line <> '' then begin
            PostCode.Init;
            PostCode.Validate("Country/Region Code", CopyStr(Line, 1, StrPos(Line, ',')-1));
            Line := CopyStr(Line, StrPos(Line,',')+1);
            PostCode.Code := CopyStr(Line, 1, StrPos(Line, ',')-1);
            PostCode.City := CopyStr(Line, StrPos(Line, ',')+1);
            if not PostCode.Insert(true) then
              PostCode.Modify(true);
          end;

        ServerFile.Close;
    end;

    var
        FileManagement: Codeunit "File Management";
        ServerFilename: Text;
        ServerFile: File;
        Line: Text;
        PostCode: Record "Post Code";
}

