page 50944 "Vendor Profile List"
{
    PageType = List;
    SourceTable = "Vendor Profile";
    ApplicationArea = All;
    Caption = 'Vendor Profiles';
    UsageCategory = Lists;
    CardPageId = 50942;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Vendor Contact No."; Rec."Vendor Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
