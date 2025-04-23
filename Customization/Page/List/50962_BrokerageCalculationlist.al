page 50962 "Brokerage Calculation List"
{
    PageType = List;
    SourceTable = "Brokerage Calculation";
    ApplicationArea = All;
    Caption = 'Brokerage Calculation List';
    UsageCategory = Lists;
    CardPageId = 50963;

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
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    Caption = 'Owner Name';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                }

            }
        }
    }

}
