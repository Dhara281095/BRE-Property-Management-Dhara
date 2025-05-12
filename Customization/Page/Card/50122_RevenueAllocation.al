page 50122 "Revenue Allocation Card"
{
    PageType = Card;
    SourceTable = "Revenue Allocation Details";
    ApplicationArea = All;
    Caption = 'Revenue Allocation Details';
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Revenue Allocation Details';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if xRec."No." <> Rec."No." then
                            ClearSubgridData();
                    end;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                }
            }
            group("Revenue Allocation Report Details")
            {
                Caption = 'Revenue Allocation Report Details';
                part("Revenue Allocation Details"; "Revenue Allocation SubGrid")
                {
                    SubPageLink = "Header No." = field("No.");
                }
            }
            group("Total Calculations")
            {
                Caption = 'Total Calculations';
                field(TotalContractAmount; TotalContractAmount)
                {
                    Caption = 'Total Contract Amount';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(TotalAnnualAmount; TotalAnnualAmount)
                {
                    Caption = 'Total Annual Amount';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(TotalFinalAnnualAmount; TotalFinalAnnualAmount)
                {
                    Caption = 'Total Final Annual Amount';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(TotalValue; TotalValue)
                {
                    Caption = 'Total Value';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FilterSubgrid)
            {
                trigger OnAction()
                begin
                    FetchContracts();
                    CalculateTotals();
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearSubgridData();
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateTotals();
    end;


    //---------------Calculate Totals--------------//
    var
        TotalContractAmount: Decimal;
        TotalAnnualAmount: Decimal;
        TotalFinalAnnualAmount: Decimal;
        TotalValue: Decimal;

    procedure CalculateTotals()
    var
        FilteredContractRec: Record "Revenue Allocation SubGrid";
    begin
        // Reset totals
        TotalContractAmount := 0;
        TotalAnnualAmount := 0;
        TotalFinalAnnualAmount := 0;
        TotalValue := 0;

        // Filter records for the current header
        FilteredContractRec.Reset();
        FilteredContractRec.SetRange("Header No.", Rec."No.");

        // Calculate totals
        if FilteredContractRec.FindSet() then begin
            repeat
                TotalContractAmount += FilteredContractRec."Contract Amount";
                TotalAnnualAmount += FilteredContractRec."Annual Amount";
                TotalFinalAnnualAmount += FilteredContractRec."Final Annual Amount";
                TotalValue += FilteredContractRec."Total Value";
            until FilteredContractRec.Next() = 0;
        end;

        // Refresh the page to show the calculated totals
        CurrPage.Update(false);
    end;


    //---------------Calculate Days In SelectedMonth--------------//
    procedure CalculateDaysInSelectedMonth(
       ContractStartDate: Date;
       ContractEndDate: Date;
       MultiYearStartDate: Date;
       MultiYearEndDate: Date;
       SelectedMonth: Integer;
       SelectedYear: Integer): Integer
    var
        StartDate: Date;
        EndDate: Date;
        MonthStartDate: Date;
        MonthEndDate: Date;
    begin
        // Get first day of selected month
        MonthStartDate := DMY2Date(1, SelectedMonth + 1, SelectedYear);
        // Get last day of selected month
        MonthEndDate := CALCDATE('<+1M-1D>', MonthStartDate);

        // Check if selected month falls in multi-year start date month
        if (Date2DMY(MultiYearStartDate, 2) = (SelectedMonth + 1)) and
           (Date2DMY(MultiYearStartDate, 3) = SelectedYear) then begin
            // Use contract start date if it falls in same month
            if (Date2DMY(ContractStartDate, 2) = (SelectedMonth + 1)) and
               (Date2DMY(ContractStartDate, 3) = SelectedYear) then
                StartDate := ContractStartDate
            else
                StartDate := MultiYearStartDate;

            EndDate := MonthEndDate;
        end

        // Check if selected month falls in multi-year end date month
        else if (Date2DMY(MultiYearEndDate, 2) = (SelectedMonth + 1)) and
                (Date2DMY(MultiYearEndDate, 3) = SelectedYear) then begin
            StartDate := MonthStartDate;
            // Use contract end date if it falls in same month
            if (Date2DMY(ContractEndDate, 2) = (SelectedMonth + 1)) and
               (Date2DMY(ContractEndDate, 3) = SelectedYear) then
                EndDate := ContractEndDate
            else
                EndDate := MultiYearEndDate;
        end
        // For months between start and end dates
        else begin
            StartDate := MonthStartDate;
            EndDate := MonthEndDate;
        end;

        // Calculate and return the number of days
        exit(EndDate - StartDate + 1);
    end;


    //---------------Clear Subgrid Data--------------//
    procedure ClearSubgridData()
    var
        FilteredContractRec: Record "Revenue Allocation SubGrid";
    begin
        FilteredContractRec.Reset();
        FilteredContractRec.SetRange("Header No.", Rec."No.");
        FilteredContractRec.DeleteAll();
    end;


    //---------------Get Next LineNo--------------//
    procedure GetNextLineNo(): Integer
    var
        FilteredContractRec: Record "Revenue Allocation SubGrid";
        LastLineNo: Integer;
    begin
        FilteredContractRec.Reset();
        FilteredContractRec.SetRange("Header No.", Rec."No.");
        if FilteredContractRec.FindLast() then
            LastLineNo := FilteredContractRec."Line No."
        else
            LastLineNo := 0;
        exit(LastLineNo + 1);
    end;


    //---------------Should Keep Entry--------------//
    procedure ShouldKeepEntry(StartDate: Date; EndDate: Date): Boolean
    var
        CheckDate: Date;
        LastDayOfMonth: Date;
        FirstDayOfMonth: Date;
    begin
        // Get first day of selected month
        FirstDayOfMonth := DMY2Date(1, Rec.Month + 1, Rec."Financial Year");

        // Get last day of selected month
        LastDayOfMonth := CALCDATE('<+1M-1D>', FirstDayOfMonth);

        // Check if selected month's date range overlaps with the given date range
        // A period overlaps if:
        if (StartDate <= LastDayOfMonth) and (EndDate >= FirstDayOfMonth) then
            exit(true);

        exit(false);
    end;


    //---------------Insert Allocation Line--------------//

    // Helper procedure to insert allocation line
    procedure InsertAllocationLine(
      ContractRec: Record "Tenancy Contract";
      MultiYearStartDate: Date;
      MultiYearEndDate: Date;
      NoOfDays: Integer;
      PerDayRent: Decimal;
      TotalAnnualAmount: Decimal;
      OwnerShareAmount: Decimal;
      TerminationDate: Date;
      LineNo: Integer;
      MonthNo: Integer;
      FinancialYear: Integer)
    var
        FilteredContractRec: Record "Revenue Allocation SubGrid";
        SuspensionRec: Record SuspendReasonTable;
        CalculatedDays: Integer;
        NewLineNo: Integer;
    // CalculatedTotalValue: Decimal;
    // CalculatedOwnerShare: Decimal;
    begin
        // Check if December 2024 falls within multi year date range
        if not ShouldKeepEntry(MultiYearStartDate, MultiYearEndDate) then
            exit;

        // Get new line number
        NewLineNo := GetNextLineNo();

        // Calculate the actual number of days for the selected month
        CalculatedDays := CalculateDaysInSelectedMonth(
            ContractRec."Contract Start Date",
            ContractRec."Contract End Date",
            MultiYearStartDate,
            MultiYearEndDate,
            MonthNo - 1,
            FinancialYear
        );

        // Calculate Total Value and Owner Share with exact multiplication
        // CalculatedTotalValue := PerDayRent * CalculatedDays;  // Direct multiplication without rounding
        // CalculatedOwnerShare := CalculatedTotalValue; // Setting Owner Share equal to Total Value

        FilteredContractRec.Init();
        FilteredContractRec."Line No." := NewLineNo;
        FilteredContractRec."Header No." := Rec."No.";
        FilteredContractRec."Property Name" := ContractRec."Property Name";
        FilteredContractRec."Contract Id" := ContractRec."Contract ID";
        FilteredContractRec."Contract Tenure" := ContractRec."Contract Tenor";
        FilteredContractRec."Customer Name" := ContractRec."Customer Name";
        FilteredContractRec."Contract Start Date" := ContractRec."Contract Start Date";
        FilteredContractRec."Contract End Date" := ContractRec."Contract End Date";
        FilteredContractRec."Grace Days" := ContractRec."Grace Period";

        // Add Termination Date
        if TerminationDate = 0D then
            FilteredContractRec."Termination Date" := 0D
        else
            FilteredContractRec."Termination Date" := TerminationDate;

        SuspensionRec.Reset();
        SuspensionRec.SetRange("Contract ID", ContractRec."Contract ID");
        if SuspensionRec.FindFirst() then begin
            FilteredContractRec."Suspension Start Date" := SuspensionRec.DateEffective;
            FilteredContractRec."Suspension End Date" := SuspensionRec.SuspensionEndDate;
        end;

        FilteredContractRec."Multi Year Start Date" := MultiYearStartDate;
        FilteredContractRec."Multi Year End Date" := MultiYearEndDate;
        FilteredContractRec."No Of Days" := CalculatedDays;
        FilteredContractRec."Per Day Rent" := Round(PerDayRent);
        FilteredContractRec."Contract Amount" := ContractRec."Annual Rent Amount";
        FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
        FilteredContractRec."Total Value" := CalculatedDays * FilteredContractRec."Per Day Rent";
        FilteredContractRec."Owner Share" := CalculatedDays * FilteredContractRec."Per Day Rent";
        // Add this line to store the Final Annual Amount
        FilteredContractRec."Final Annual Amount" := TotalAnnualAmount;
        FilteredContractRec."Posting Month" := MonthNo - 1;
        FilteredContractRec."Posting Year" := FinancialYear;
        FilteredContractRec."Posting Period" := Format(FilteredContractRec."Posting Month") +
            ' ' + Format(FilteredContractRec."Posting Year") + ' ' + '-' + ' ' +
            Format(FilteredContractRec."Posting Month") + ' ' + Format(FilteredContractRec."Posting Year");
        FilteredContractRec."Owner Name" := ContractRec."Owner's Name";

        FilteredContractRec.Insert();
    end;


    //---------------Fetch Contracts--------------//

    // Then modify the FetchContracts procedure to use this
    procedure FetchContracts()
    var
        FilterHeader: Record "Revenue Allocation Details";
        ContractRec: Record "Tenancy Contract";
        FilteredContractRec: Record "Revenue Allocation SubGrid";
        SuspensionRec: Record SuspendReasonTable;
        SingleUnitRent: Record "TC Single Unit Rent SubPage";
        MultiUnitRent: Record "TC Single LumAnnualAmnt SP";
        MergedSingleRent: Record "TC Merge SameSqure SubPage";
        MergedMultiRent: Record "TC Merge DifferentSq SubPage";
        SpecialRent: Record "TC Merge LumAnnualAmount SP";
        FinalCalculationRec: Record "Final Calculation";
        SelectedMonthStart: Date;
        SelectedMonthEnd: Date;
        MonthNo: Integer;
        FinancialYear: Integer;
        LineNo: Integer;
        TerminationDate: Date;
    begin
        ClearSubgridData();

        MonthNo := Rec.Month + 1;
        FinancialYear := Rec."Financial Year";

        SelectedMonthStart := DMY2Date(01, MonthNo, FinancialYear);
        SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart);

        // Add filter for active contracts
        ContractRec.SetRange(ContractRec."Tenant Contract Status", ContractRec."Tenant Contract Status"::Active);

        if ContractRec.FindSet() then begin
            repeat
                if ((ContractRec."Contract Start Date" <= SelectedMonthEnd) and
                    (ContractRec."Contract End Date" >= SelectedMonthStart)) then begin

                    // Retrieve Termination Date from Final Calculation
                    FinalCalculationRec.Reset();
                    FinalCalculationRec.SetRange("Contract ID", ContractRec."Contract ID");
                    if FinalCalculationRec.FindFirst() then
                        TerminationDate := FinalCalculationRec."Termination Date"
                    else
                        TerminationDate := 0D;

                    // Check Single Unit Rent grid
                    SingleUnitRent.Reset();
                    SingleUnitRent.SetRange("Contract ID", ContractRec."Contract ID");
                    if SingleUnitRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec,
                                SingleUnitRent."Start Date",
                                SingleUnitRent."End Date",
                                SingleUnitRent."Number of Days",
                                SingleUnitRent."Per Day Rent",
                                SingleUnitRent."Final Annual Amount",
                                SingleUnitRent."Final Annual Amount",
                                TerminationDate,
                                LineNo,  // Use sequential number
                                MonthNo,
                                FinancialYear);
                        // LineNo += 1;  // Increment by 1
                        until SingleUnitRent.Next() = 0;
                    end;

                    // Check Multi Unit Rent grid
                    MultiUnitRent.Reset();
                    MultiUnitRent.SetRange("Contract ID", ContractRec."Contract ID");
                    if MultiUnitRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec,
                                MultiUnitRent."SL_Start Date",
                                MultiUnitRent."SL_End Date",
                                MultiUnitRent."SL_Number of Days",
                                MultiUnitRent."SL_Per Day Rent",
                                MultiUnitRent."SL_Final Annual Amount",
                                MultiUnitRent."SL_Final Annual Amount",
                                TerminationDate,
                                LineNo,  // Use sequential number
                                MonthNo,
                                FinancialYear);
                        // LineNo += 1;  // Increment by 1
                        until MultiUnitRent.Next() = 0;
                    end;

                    // Check Merged Single Rent grid
                    MergedSingleRent.Reset();
                    MergedSingleRent.SetRange("Contract ID", ContractRec."Contract ID");
                    if MergedSingleRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec,
                                MergedSingleRent."MS_Start Date",
                                MergedSingleRent."MS_End Date",
                                MergedSingleRent."MS_Number of Days",
                                MergedSingleRent."MS_Per Day Rent",
                                MergedSingleRent."MS_Final Annual Amount",
                                MergedSingleRent."MS_Final Annual Amount",
                                TerminationDate,
                                LineNo,  // Use sequential number
                                MonthNo,
                                FinancialYear);
                        // LineNo += 1;  // Increment by 1
                        until MergedSingleRent.Next() = 0;
                    end;

                    // Check Merged Multi Rent grid
                    MergedMultiRent.Reset();
                    MergedMultiRent.SetRange("Contract ID", ContractRec."Contract ID");
                    if MergedMultiRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec,
                                MergedMultiRent."MD_Start Date",
                                MergedMultiRent."MD_End Date",
                                MergedMultiRent."MD_Number of Days",
                                MergedMultiRent."MD_Per Day Rent",
                                MergedMultiRent."MD_Final Annual Amount",
                                MergedMultiRent."MD_Final Annual Amount",
                                TerminationDate,
                                LineNo,  // Use sequential number
                                MonthNo,
                                FinancialYear);
                        // LineNo += 1;  // Increment by 1
                        until MergedMultiRent.Next() = 0;
                    end;

                    // Check Special Rent grid
                    SpecialRent.Reset();
                    SpecialRent.SetRange("Contract ID", ContractRec."Contract ID");
                    if SpecialRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec,
                                SpecialRent."ML_Start Date",
                                SpecialRent."ML_End Date",
                                SpecialRent."ML_Number of Days",
                                SpecialRent."ML_Per Day Rent",
                                SpecialRent."ML_Final Annual Amount",
                                SpecialRent."ML_Final Annual Amount",
                                TerminationDate,
                                LineNo,  // Use sequential number
                                MonthNo,
                                FinancialYear);
                        // LineNo += 1;  // Increment by 1
                        until SpecialRent.Next() = 0;
                    end;
                end;
            until ContractRec.Next() = 0;
        end;
        CalculateTotals();
    end;
}
