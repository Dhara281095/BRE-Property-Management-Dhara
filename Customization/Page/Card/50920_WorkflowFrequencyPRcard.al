page 50920 "Workflow Frequency PR Card"
{
    PageType = ListPart;
    SourceTable = "Workflow Frequency PR";
    ApplicationArea = All;
    Caption = 'Workflow Frequency PR Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Company ID"; Rec."Company ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing

                }

                field("Workflow"; Rec."Workflow")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("frequncy Status"; Rec."frequncy Status")
                {
                    ApplicationArea = All;
                    Caption = 'frequncy Status';
                    Editable = false;
                }

                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                    // Editable = IsApproved;
                }

                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing

                }

            }
        }
    }

    // var
    //     IsApproved: Boolean;

    // trigger OnModifyRecord(): Boolean
    // begin
    //     IsApproved := (Rec."frequncy Status" <> Rec."frequncy Status"::Property);
    // end;
}