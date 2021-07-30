TableExtension 50014 tableextension50014 extends "Post Code" 
{
    fields
    {

        //Unsupported feature: Code Modification on "Code(Field 1).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            PostCode.SETRANGE("Search City","Search City");
            PostCode.SETRANGE(Code,Code);
            IF NOT PostCode.ISEMPTY THEN
              ERROR(Text000,FIELDCAPTION(Code),Code);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF "Search City" <> '' THEN BEGIN
              PostCode.SETRANGE("Search City","Search City");
              PostCode.SETRANGE(Code,Code);
              IF NOT PostCode.ISEMPTY THEN
                ERROR(Text000,FIELDCAPTION(Code),Code);
            END;
            */
        //end;
    }
}

