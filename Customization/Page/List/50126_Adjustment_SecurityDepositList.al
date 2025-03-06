page 50126 "Adjustment_Security_Deposit"
{
    PageType = List;
    SourceTable = "Adjustment Security Deposit";
    ApplicationArea = All;
    Caption = 'Adjustment Security Deposit';
    UsageCategory = Lists;
    CardPageId = 50125;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                }

                field("Security Deposit"; Rec."Security Deposit")
                {
                    ApplicationArea = All;
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                }

                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }

                field("Security Amount Status"; Rec."Security Amount Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
