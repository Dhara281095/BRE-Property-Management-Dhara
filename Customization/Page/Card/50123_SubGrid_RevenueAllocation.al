page 50123 "Revenue Allocation SubGrid"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Revenue Allocation SubGrid";
    Caption = 'Revenue Allocation Report';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                }
                field("Contract Id"; Rec."Contract Id")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Id';
                }
                field("Contract Tenure"; Rec."Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Tenure';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                }
                field("Grace Days"; Rec."Grace Days")
                {
                    ApplicationArea = All;
                    Caption = 'Grace Days';
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                }
                field("Suspension Start Date"; Rec."Suspension Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Suspension Start Date';
                }
                field("Suspension End Date"; Rec."Suspension End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Suspension End Date';
                }
                field("Multi Year Start Date"; Rec."Multi Year Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Multi Year Start Date';
                }
                field("Multi Year End Date"; Rec."Multi Year End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Multi Year End Date';
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                }
                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                }
                field("Posting Month"; Rec."Posting Month")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Month';
                }
                field("Posting Year"; Rec."Posting Year")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Year';
                }
                field("Posting Period"; Rec."Posting Period")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Period';
                }
                field("No Of Days"; Rec."No Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'No Of Days';
                }
                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                }
                field("Total Value"; Rec."Total Value")
                {
                    ApplicationArea = All;
                    Caption = 'Total Value';
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    Caption = 'Owner Name';
                }
                field("Owner Share"; Rec."Owner Share")
                {
                    ApplicationArea = All;
                    Caption = 'Owner Share';
                }
            }
        }
    }
}