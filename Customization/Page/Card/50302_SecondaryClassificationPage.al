page 50302 "Secondary Classification Card"
{
    PageType = Card;
    SourceTable = "Secondary Classification";
    ApplicationArea = All;
    Caption = 'Unit Type';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Unit Type Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Classification Name"; Rec."Classification Name")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Classification';
                    ToolTip = 'Select the associated primary classification.';
                    // TableRelation = "Primary Classification";
                    // Add a lookup to the Primary Classification table
                    // Lookup = true;
                }
                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type';
                    ToolTip = 'Enter the Unit Type.';
                }
            }
        }
    }



    // Adding navigation from the list page
    // usagecategory = Lists;
}
