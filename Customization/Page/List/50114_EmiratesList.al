page 50114 "Emirate List"
{
    PageType = List;
    SourceTable = Emirate;
    ApplicationArea = All;
    Caption = 'Emirate List';
    UsageCategory = Lists;
    CardPageId = 50115;

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
                    TableRelation = Country;
                    // Display the Primary Classification description
                    Lookup = true; // Enable lookup to Primary Classification
                }
                field("Emirate Name"; Rec."Emirate Name")
                {
                    ApplicationArea = All;
                    Caption = 'Emirate Name';
                }
            }
        }
    }

    // actions
    // {
    //     area(processing)
    //     {
    //         action(New)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'New';
    //             Promoted = true;
    //             PromotedCategory = Process;
    //             trigger OnAction()
    //             begin
    //                 Rec.Init();
    //                 Rec.Insert(true);
    //                 CurrPage.Update();
    //             end;
    //         }
    //     }
    // }

    // Link to open the card page for detailed editing
    // DrillDownPageId = "Secondary Classification Card";
    // EditPageId = "Secondary Classification Card";
}
