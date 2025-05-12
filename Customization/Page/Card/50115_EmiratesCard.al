page 50115 "Emirate Card"
{
    PageType = Card;
    SourceTable = Emirate;
    ApplicationArea = All;
    Caption = 'Emirate Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Emirate Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                }
                field("Sl No."; Rec."Sl No.")
                {
                    ApplicationArea = All;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Emirate Name"; Rec."Emirate Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                }
            }
        }
    }
}
