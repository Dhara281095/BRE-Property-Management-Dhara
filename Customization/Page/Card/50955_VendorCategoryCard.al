page 50955 "Vendor Category Card"
{
    PageType = Card;
    SourceTable = "Vendor Category";
    ApplicationArea = All;
    Caption = 'Vendor Category Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Vendor Category Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Vendor Category Type"; Rec."Vendor Category Type")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Classification Name';
                    ToolTip = 'Enter the primary classification name.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
            }
        }
    }


}



