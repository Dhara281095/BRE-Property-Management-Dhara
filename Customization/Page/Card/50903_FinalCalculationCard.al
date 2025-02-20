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
                        FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                        if FinalCalculation.FindFirst() then begin

                            StartDate := Rec."Contract Start Date";
                            TerminateDate := Rec."Termination Date";
                            DaysCal := TerminateDate - StartDate + 1;
                            Rec."Actual Contract Tenure" := DaysCal;
                            Rec.Modify();

                        end;
                        GetContractTerminationYear();
                        Fetchperdayrent();
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

                field("Total No. Of Days"; Rec."Total No. Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Total No. Of Days(Termination Year)';
                    ToolTip = 'Enter the Total No. Of Days.';
                    Editable = false;
                }

                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent(Termination Year)';
                    ToolTip = 'Enter the Per Day Rent.';
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


    trigger OnAfterGetRecord()
    var
    begin
        PopulateRevenueCalculationGrid();
        GetDataTenancyContract();

    end;


    //////////////////  START Final Revenue Calculation Grid ////////////////////
    procedure PopulateRevenueCalculationGrid()
    var
        FinalCalcHeader: Record "Final Calculation";
        FinalRevCalcGrid: Record "Final Revenue Calculation Grid";
        RentCalc: Record "Rent Calculation";
        TenancyContractLine: Record "Tenancy Contract Subpage";
    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        FinalRevCalcGrid.SetRange("Contract ID", Rec."Contract ID");
        if FinalRevCalcGrid.FindSet() then begin
            FinalRevCalcGrid.DeleteAll();
        end;


        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc.SetRange("Contract ID", Rec."Contract ID");
        if RentCalc.FindSet() then begin
            repeat
                FinalRevCalcGrid.Init();
                FinalRevCalcGrid."Contract ID" := RentCalc."Contract ID";
                FinalRevCalcGrid."Revenue Description" := RentCalc."Secondary Item Type";
                FinalRevCalcGrid."Original Amount" := RentCalc."Amount";
                FinalRevCalcGrid."Original VAT" := RentCalc."VAT Amount";
                FinalRevCalcGrid."Original Amount Incl." := RentCalc."Amount Including VAT";
                FinalRevCalcGrid.Insert();
                Clear(FinalRevCalcGrid);
            until RentCalc.Next() = 0;
        end;

    end;

    procedure GetDataTenancyContract()
    var
        FinalRevCalcGrid1: Record "Final Revenue Calculation Grid";
        TenancyContractLine1: Record "Tenancy Contract Subpage";
        FinalCalcHeader1: Record "Final Calculation";
    begin

        // TenancyContractLine.Reset();
        TenancyContractLine1.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractLine1.FindSet() then begin
            repeat
                FinalRevCalcGrid1.Init();
                FinalRevCalcGrid1."Contract ID" := Rec."Contract ID";
                FinalRevCalcGrid1."Revenue Description" := TenancyContractLine1."Secondary Item Type";
                FinalRevCalcGrid1."Original Amount" := TenancyContractLine1.Amount;

                // Calculate VAT amount based on percentage
                FinalRevCalcGrid1."Original VAT" := Round(TenancyContractLine1.Amount *
                                                   TenancyContractLine1."VAT %" / 100,
                                                   0.01);

                FinalRevCalcGrid1."Original Amount Incl." := TenancyContractLine1."Amount Including VAT";
                FinalRevCalcGrid1.Insert();
                Clear(FinalRevCalcGrid1);
            until TenancyContractLine1.Next() = 0;
        end;

    end;


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
        RentCalculation: Record "Rent Calculation";
        RentCalculationSub: Record "Rent Calculation Subpage";
        UserEnteredDate: Date;
        Perdayrent: Decimal;
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
            FinalCalculation.Modify();

        end;
    end;

    procedure Fetchperdayrent()
    var
        RentCalculation1: Record "Rent Calculation Subpage";
    begin
        RentCalculation1.SetRange("Contract ID", Rec."Contract ID");
        RentCalculation1.SetRange("Year", Rec."ContractYear(Termination Date)");

        if RentCalculation1.FindSet() then
            repeat
                Rec."Per Day Rent" := RentCalculation1."Per Day Rent";
                Rec.Modify();
            until RentCalculation1.Next() = 0;
    end;
}