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
                    Editable = false;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                    Editable = false;
                }

                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type';
                    ToolTip = 'Enter the Unit Type.';
                    Editable = false;
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    ToolTip = 'Enter the Contract Amount.';
                    Editable = false;
                }


                field("Intimation Date"; Rec."Intimation Date")
                {
                    ApplicationArea = All;
                    Caption = 'Intimation Date';
                    ToolTip = 'Enter the Initmation Date.';

                }


                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    ToolTip = 'Enter the Termination Date.';

                    trigger OnValidate()
                    var
                        TerminateDate: Date;
                        DaysCal: Integer;
                        StartDate: Date;
                        FinalCalculation: Record "Final Calculation";

                    begin
                        FinalCalculation.SetRange("FC ID", Rec."FC ID");
                        if FinalCalculation.FindFirst() then begin
                            TerminateDate := FinalCalculation."Termination Date";
                            StartDate := FinalCalculation."Contract Start Date";
                            DaysCal := TerminateDate - StartDate + 1;
                            FinalCalculation."Actual Contract Tenure" := DaysCal;
                            FinalCalculation.Modify(true);

                        end;
                        GetContractTerminationYear();
                    end;
                }
                field("ContractYear(Termination Date)"; Rec."ContractYear(Termination Date)")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Year On Termination Date';
                    ToolTip = 'Enter the ContractYear(Termination Date).';
                    Editable = false;



                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Editable = false;

                }
                field("Original Contract Tenure"; Rec."Original Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Original Contract Tenure';
                    ToolTip = 'Enter the Original Contract Tenure.';
                    Editable = false;
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

            group("Pending receivable/Payable")
            {
                part("Pendingreceivable/Payable"; "Pending Recevieable Grid")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID");
                    ApplicationArea = All;
                }
            }
        }
    }



    procedure GetContractTerminationYear()
    var
        ContractStartDate: Date;
        ContractEndDate: Date;
        YearStartDate: Date;
        YearEndDate: Date;
        YearNumber: Integer;
        StartYear: Integer;
        UserYear: Integer;
        FinalCalculation: Record "Final Calculation";
        UserEnteredDate: Date;
    begin

        FinalCalculation.SetRange("FC ID", Rec."FC ID");
        if FinalCalculation.FindFirst() then begin
            // Set Contract start and end dates
            ContractStartDate := FinalCalculation."Contract Start Date"; // 1st January 2022
            ContractEndDate := FinalCalculation."Contract End Date"; // 31st December 2026
            UserEnteredDate := FinalCalculation."Termination Date";

            // Extract the year from the user entered date and contract start date
            StartYear := Date2DMY(ContractStartDate, 3); // 3 = year
            UserYear := Date2DMY(UserEnteredDate, 3); // 3 = year

            // Calculate year number based on difference between user entered year and start year
            YearNumber := UserYear - StartYear + 1;
            FinalCalculation."ContractYear(Termination Date)" := YearNumber;

            // // Check if the entered date is within the contract period
            // if (UserEnteredDate >= ContractStartDate) and (UserEnteredDate <= ContractEndDate) then
            //     exit(YearNumber);

            // // Return -1 if the date is outside the contract range
            // exit(-1);
        end;
    end;

}