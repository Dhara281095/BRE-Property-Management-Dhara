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
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                }
                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Frequency Of Payment"; Rec."Frequency Of Payment")
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
