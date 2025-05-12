page 50117 "Community Card"
{
    PageType = Card;
    SourceTable = Community;
    ApplicationArea = All;
    Caption = 'Community Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Community Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                }
                field("Sl No."; Rec."Sl No.")
                {
                    ApplicationArea = All;
                }
                field("Emirate Name"; Rec."Emirate Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Community Code"; Rec."Community Code")
                {
                    ApplicationArea = All;
                }
                field("Community Name"; Rec."Community Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                }
            }
        }
    }
}
