page 50104 "Selected Unit List"
{
    PageType = List;
    SourceTable = Item;
    ApplicationArea = All;
    Caption = 'Selected Unit List';
    UsageCategory = Lists;
    // CardPageId = 30;

    SourceTableView = where("Unit Status" = const(Selected));

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                }
                field(UnitID; Rec.UnitID)
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Name';
                }
                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Number';
                }
                field("Floor Number"; Rec."Floor Number")
                {
                    ApplicationArea = All;
                    Caption = 'Floor Number';
                }
                field("Usage Type"; Rec."Usage Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Unit Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    // trigger OnOpenPage();
    // begin
    //     Rec.SetRange("Unit Status", 'Selected'); // Filter for only vacant properties
    // end;


    trigger OnOpenPage();
    begin
        Rec.SetRange("Unit Status", Rec."Unit Status"::Selected); // ✅ Filters for "Selected" units
    end;


}





















