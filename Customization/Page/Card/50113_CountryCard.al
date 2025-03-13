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
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Sl No."; Rec."Sl No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sl No.';
                    Editable = false;
                }
                field("Country Name"; Rec."Country Name")
                {
                    ApplicationArea = All;
                    Caption = 'Country Name';
                    ShowMandatory = true;
                    NotBlank = true;
                    // trigger OnValidate()
                    // begin
                    //     CurrPage.Update(true);
                    // end;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country Code';
                }

            }
        }

    }
}



