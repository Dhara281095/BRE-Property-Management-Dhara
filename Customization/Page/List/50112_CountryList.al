page 50112 "Country List"
{
    PageType = List;
    SourceTable = Country;
    ApplicationArea = All;
    Caption = 'Country List';
    UsageCategory = Lists;
    CardPageId = 50113;

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
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country Code';
                }
                field("Country Name"; Rec."Country Name")
                {
                    ApplicationArea = All;
                    Caption = 'Country Name';
                }
            }
        }
    }

    // Link to open the card page for detailed editing
    // DrillDownPageId = "Primary Classification Card";
    // EditPageId = "Primary Classification Card";
}
