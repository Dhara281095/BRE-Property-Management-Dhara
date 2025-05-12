page 50110 "Property Type Card"
{
    PageType = Card;
    SourceTable = "Property Type";
    ApplicationArea = All;
    Caption = 'Property Type Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Property Type Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                }
                field("Classification Name"; Rec."Classification Name")
                {
                    ApplicationArea = All;
                }
                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
