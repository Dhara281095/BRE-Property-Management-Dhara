page 50304 "Secondary Classification List"
{
    PageType = List;
    SourceTable = "Secondary Classification";
    ApplicationArea = All;
    Caption = 'Unit Type List';
    UsageCategory = Lists;
    CardPageId = 50302;

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
                field("Classification Name"; Rec."Classification Name")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Classification';
                    TableRelation = "Primary Classification";
                    // Display the Primary Classification description
                    Lookup = true; // Enable lookup to Primary Classification
                }
                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(New)
            {
                ApplicationArea = All;
                Caption = 'New';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Rec.Init();
                    Rec.Insert(true);
                    CurrPage.Update();
                end;
            }
        }
    }

    // Link to open the card page for detailed editing
    // DrillDownPageId = "Secondary Classification Card";
    // EditPageId = "Secondary Classification Card";
}
