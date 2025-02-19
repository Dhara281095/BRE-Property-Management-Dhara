page 50903 "Final Calculation Card"
{
    PageType = Card;
    SourceTable = "Final Calculation";
    ApplicationArea = All;
    Caption = 'Final Calculation Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {


                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                }

                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                }

                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type';
                    ToolTip = 'Enter the Unit Type.';
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    ToolTip = 'Enter the Contract Amount.';
                }


                field("Initmation Date"; Rec."Initmation Date")
                {
                    ApplicationArea = All;
                    Caption = 'Initmation Date';
                    ToolTip = 'Enter the Initmation Date.';
                    Editable = false;
                }


                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    ToolTip = 'Enter the Termination Date.';
                    Editable = false;
                }


                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Visible = false;

                }
                field("Original Contract Tenure"; Rec."Original Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Original Contract Tenure';
                    ToolTip = 'Enter the Original Contract Tenure.';
                }

                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Contract Tenure';
                    ToolTip = 'Enter the Actual Contract Tenure.';
                    Editable = false;
                }
            }

            group("Final Revenue Calculation")
            {
                part("FinalRevenueCalculation"; "Final Revenue Calculation Grid")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID");
                    ApplicationArea = All;


                }
            }
            group("Billing Calculation")
            {
                part("BillingCalculation"; "Final Billing Calculation")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID");
                    ApplicationArea = All;
                }
            }
        }
    }

}