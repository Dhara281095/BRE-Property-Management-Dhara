page 50523 "COA Setup List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "COA Setup";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Item; Rec.Item) { ApplicationArea = All; }
                field(COA_Account; Rec.COA_Account) { ApplicationArea = All; }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}