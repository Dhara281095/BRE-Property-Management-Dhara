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
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Sl No."; Rec."Sl No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sl No.';
                    Editable = false;
                }
                field("Emirate Name"; Rec."Emirate Name")
                {
                    ApplicationArea = All;
                    Caption = 'Emirate Name';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Community Code"; Rec."Community Code")
                {
                    ApplicationArea = All;
                    Caption = 'Community Code';
                }
                field("Community Name"; Rec."Community Name")
                {
                    ApplicationArea = All;
                    Caption = 'Community Name';
                    ShowMandatory = true;
                    NotBlank = true;
                }
            }
        }
    }



    // Adding navigation from the list page
    // usagecategory = Lists;
}
