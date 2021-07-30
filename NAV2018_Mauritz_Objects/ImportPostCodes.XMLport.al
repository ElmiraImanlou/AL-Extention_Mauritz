XmlPort 50001 "Import PostCodes"
{
    Direction = Import;

    schema
    {
        textelement(Element)
        {
            tableelement("Post Code";"Post Code")
            {
                XmlName = 'PLZ';
                fieldelement(Country;"Post Code"."Country/Region Code")
                {
                }
                fieldelement(PostCode;"Post Code".Code)
                {
                }
                fieldelement(City;"Post Code".City)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

