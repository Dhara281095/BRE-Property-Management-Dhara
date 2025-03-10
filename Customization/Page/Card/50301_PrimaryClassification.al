page 50301 "Primary Classification Card"
{
    PageType = Card;
    SourceTable = "Primary Classification";
    ApplicationArea = All;
    Caption = 'Primary Classification Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Primary Classification Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Classification Name"; Rec."Classification Name")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Classification Name';
                    ShowMandatory = true;
                    NotBlank = true;
                }
            }
        }

    }


}



