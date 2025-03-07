page 50918 "Workflow Frequency Card"
{
    PageType = ListPart;
    SourceTable = "Workflow Frequency";
    ApplicationArea = All;
    Caption = 'Workflow Frequency Card';
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
                }
                field("frequncy Status"; Rec."frequncy Status")
                {
                    ApplicationArea = All;
                    Caption = 'frequncy Status';
                }

                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                }

            }
        }
    }

    var
        IsApproved: Boolean;

    trigger OnModifyRecord(): Boolean
    begin
        IsApproved := (Rec."frequncy Status" <> Rec."frequncy Status"::Property);
    end;
}