page 50103 "Free Unit List"
{
    PageType = List;
    SourceTable = item;
    ApplicationArea = All;
    Caption = 'Free Unit List';
    UsageCategory = Lists;
    // CardPageId = 31;
    // SourceTableView = where("Unit Status" = const('Free'));
    SourceTableView = where("Unit Status" = const(Free));


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
    //     Rec.SetRange("Unit Status", 'Free'); // Filter for only vacant properties
    // end;

    trigger OnOpenPage();
    begin
        Rec.SetRange("Unit Status", Rec."Unit Status"::Free); // ✅ Filter for vacant units
    end;


}





















