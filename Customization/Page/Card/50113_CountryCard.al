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
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country Code';
                }

            }
        }

    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        IsEmpty: Boolean;
    begin
        IsEmpty := (Rec."Country Name" = '') and (Rec."Country Code" = '') and (Rec."ID" = 0);

        if CloseAction = Action::LookupCancel then
            exit(true);

        if IsEmpty then
            exit(true);

        if xRec.IsEmpty and IsEmpty then
            exit(true);

        if not IsEmpty then
            Rec.TestField("Country Name");

        exit(true);
    end;


}



