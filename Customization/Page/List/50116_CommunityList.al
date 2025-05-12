page 50116 "Community List"
{
    PageType = List;
    SourceTable = Community;
    ApplicationArea = All;
    Caption = 'Community List';
    UsageCategory = Lists;
    CardPageId = 50117;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                }
                field("Sl No."; Rec."Sl No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sl No.';
                }
                field("Emirate Name"; Rec."Emirate Name")
                {
                    ApplicationArea = All;
                    Caption = 'Emirate Name';
                    TableRelation = Emirate;
                    Lookup = true;
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
                }
            }
        }
    }
}
