page 50113 "Country Card"
{
    PageType = Card;
    SourceTable = Country;
    ApplicationArea = All;
    Caption = 'Country Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Country Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                }
                field("Sl No."; Rec."Sl No.")
                {
                    ApplicationArea = All;
                }
                field("Country Name"; Rec."Country Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                }
            }
        }

    }
}



