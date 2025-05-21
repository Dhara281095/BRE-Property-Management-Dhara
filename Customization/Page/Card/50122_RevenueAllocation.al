page 50122 "Revenue Allocation Card"
{
    PageType = Card;
    SourceTable = "Revenue Allocation Details";
    ApplicationArea = All;
    Caption = 'Revenue Allocation Details';
    //  UsageCategory = Administration;

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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
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

            group("Revenue Recognition Item")
            {
                Caption = 'Revenue Item Details';
                part("Revenue Recognition Item Details"; "Revenue Recognition Item Sub")
                {
                    SubPageLink = "RR_No." = field("No.");
                }
            }

            group("Revenue Recognition Detail")
            {
                Caption = 'Revenue Recognition Details';
                part("Revenue Recognition Details"; "Revenue Recognition Detail Sub")
                {
                    SubPageLink = "RR_No." = field("No.");
                }
            }
            group(" ")
            {
                field("Total Amount"; totalamounts)
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field("Total Contract Amount"; totalcontractAmounts)
                {
                    ApplicationArea = All;
                    Caption = 'Total Contract Amount';
                    Editable = false;
                }
            }
            group("Final Amount")
            {
                Caption = 'Final Amount';

                field(TotalAnnualAmounts; TotalAnnualAmount)
                {
                    Caption = 'Total Annual Amount';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(TotalFinalAnnualAmounts; TotalFinalAnnualAmount)
                {
                    Caption = 'Total Final Annual Amount';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Amounts"; totalcombineamounts)
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field("Total Contract Amounts"; totalcombinecontractAmounts)
                {
                    ApplicationArea = All;
                    Caption = 'Total Contract Amount';
                    Editable = false;
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
                Caption = 'Revenue Allocation-Rent';
                trigger OnAction()
                begin
                    FetchContracts();
                    CalculateTotals();
                end;
            }

            action("Process Selected Items")
            {
                Caption = 'Process Other Charges';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SourceRec: Record "Revenue Item Breakdown";
                    TargetRec: Record "Revenue Recognition Item";
                begin
                    // ✅ Set the RR_No. filter BEFORE calling FindSet
                    TargetRec.Reset();
                    TargetRec.SetRange("RR_No.", Rec."No.");

                    if TargetRec.FindSet() then begin
                        repeat
                            // Find matching Revenue Item Breakdown by Item Type
                            SourceRec.Reset();
                            SourceRec.SetRange("Item Type", TargetRec."Item Type");

                            if SourceRec.FindFirst() then begin
                                TargetRec.Link := SourceRec."RI_No.";
                                TargetRec."RR_No." := Rec."No."; // Set header ID
                                TargetRec.Modify(true); // Save changes and keep record visible
                            end;
                        until TargetRec.Next() = 0;

                        Message('Selected records processed successfully.');
                    end else
                        Message('No selected records found.');
                end;
            }

            action(RevenueAllocation)
            {
                ApplicationArea = All;
                Caption = 'Revenue Allocation Approval';
                Image = PostDocument;
                Enabled = Rec.Status = Rec.Status::Pending;

                trigger OnAction()
                var
                    Approvalrevenueallocation: Record "Revenue Allocation Approval";
                    revenueallocation: Record "Revenue Allocation Details";
                begin
                    // Validate required fields
                    if Rec."No." = 0 then
                        Error('No must be specified');

                    Approvalrevenueallocation.SetRange("ID", Rec."No.");

                    if Approvalrevenueallocation.FindSet() then begin
                        // Modify existing approval record
                        Approvalrevenueallocation."ID" := Rec."No.";
                        Approvalrevenueallocation."Month" := revenueallocation."Month";
                        Approvalrevenueallocation."Financial Year" := Rec."Financial Year";
                        Approvalrevenueallocation."Status" := revenueallocation."Status";
                        Approvalrevenueallocation.Modify();
                        Message('Approval Request Modified successfully!');
                    end else begin
                        // Insert new approval record
                        Approvalrevenueallocation.Init();
                        Approvalrevenueallocation."ID" := Rec."No.";
                        Approvalrevenueallocation."Financial Year" := Rec."Financial Year";
                        Approvalrevenueallocation."Month" := revenueallocation."Month";
                        Approvalrevenueallocation."Status" := revenueallocation."Status";

                        Approvalrevenueallocation.Insert();
                        Message('Approval Request Sent successfully!');
                    end;
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
        CurrPage."Revenue Recognition Item Details".Page.SetRIID(Rec."No.");
        CurrPage."Revenue Recognition Details".Page.SetRIID(Rec."No.");
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
        SuspensionRec: Record SuspendReasonTable;
        SelectedMonthStart: Date;
        SelectedMonthEnd: Date;
    begin
        // Reset totals
        TotalContractAmount := 0;
        TotalAnnualAmount := 0;
        TotalFinalAnnualAmount := 0;
        TotalValue := 0;

        // Get first and last day of selected month
        SelectedMonthStart := DMY2Date(1, Rec.Month + 1, Rec."Financial Year");
        SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart);

        // Filter records for the current header
        FilteredContractRec.Reset();
        FilteredContractRec.SetRange("Header No.", Rec."No.");

        // Calculate totals
        if FilteredContractRec.FindSet() then begin
            repeat
                // Check if the contract is suspended during the selected month
                SuspensionRec.Reset();
                SuspensionRec.SetRange("Contract ID", FilteredContractRec."Contract Id");
                SuspensionRec.SetFilter(DateEffective, '..%1', SelectedMonthEnd);
                SuspensionRec.SetFilter(SuspensionEndDate, '%1..', SelectedMonthStart);

                // Only add to totals if the contract is NOT suspended during the selected month
                if not SuspensionRec.FindFirst() then begin
                    TotalContractAmount += FilteredContractRec."Contract Amount";
                    TotalAnnualAmount += FilteredContractRec."Annual Amount";
                    TotalFinalAnnualAmount += FilteredContractRec."Final Annual Amount";
                    TotalValue += FilteredContractRec."Total Value";
                end;
            until FilteredContractRec.Next() = 0;
        end;
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
        revenueitem: Record "Revenue Recognition Item";
    begin
        FilteredContractRec.Reset();
        FilteredContractRec.SetRange("Header No.", Rec."No.");
        FilteredContractRec.DeleteAll();
        revenueitem.Reset();
        revenueitem.SetRange("RR_No.", Rec."No.");
        revenueitem.DeleteAll();
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
        PerDayRentWithoutGracePeriod: Decimal;
        PerDayRentWithGracePeriod: Decimal;
        TotalContractDays: Integer;
        TotalContractDaysWithGrace: Integer;
        DifferencePerDayRent: Decimal;
        GracePeriodAdjustmentValue: Decimal;
        GridAnnualAmount: Decimal;
    begin
        // Check if entry should be kept based on date range
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

        // Get the days in the specific grid record's date range
        TotalContractDays := MultiYearEndDate - MultiYearStartDate + 1;

        // Calculate Total Contract Days (with grace period)
        TotalContractDaysWithGrace := TotalContractDays + ContractRec."Grace Period";

        // Use the annual amount from the grid record instead of the main contract
        GridAnnualAmount := TotalAnnualAmount;

        // Calculate Per Day Rent without Grace Period (using grid's annual amount)
        PerDayRentWithoutGracePeriod := Round(GridAnnualAmount / TotalContractDays);

        // Calculate Per Day Rent with Grace Period (using grid's annual amount)
        PerDayRentWithGracePeriod := Round(GridAnnualAmount / TotalContractDaysWithGrace);

        // Calculate the difference per day
        DifferencePerDayRent := PerDayRentWithoutGracePeriod - PerDayRentWithGracePeriod;

        // Calculate total adjustment value for the month
        GracePeriodAdjustmentValue := DifferencePerDayRent * CalculatedDays;

        // -----------------------------------------------
        // Insert main allocation line (without grace period adjustment)
        // -----------------------------------------------
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
        FilteredContractRec."Per Day Rent" := Round(PerDayRent); // Use the per day rent passed from the grid
        FilteredContractRec."Contract Amount" := GridAnnualAmount; // Use grid's annual amount
        FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
        FilteredContractRec."Total Value" := CalculatedDays * FilteredContractRec."Per Day Rent";
        FilteredContractRec."Owner Share" := CalculatedDays * FilteredContractRec."Per Day Rent";
        FilteredContractRec."Final Annual Amount" := TotalAnnualAmount;
        FilteredContractRec."Posting Month" := MonthNo - 1;
        FilteredContractRec."Posting Year" := FinancialYear;
        FilteredContractRec."Posting Period" := Format(FilteredContractRec."Posting Month") +
            ' ' + Format(FilteredContractRec."Posting Year") + ' ' + '-' + ' ' +
            Format(FilteredContractRec."Posting Month") + ' ' + Format(FilteredContractRec."Posting Year");
        FilteredContractRec."Owner Name" := ContractRec."Owner's Name";
        FilteredContractRec.Insert();

        // -----------------------------------------------
        // Insert grace period adjustment line (negative allocation)
        // -----------------------------------------------
        // Only insert the adjustment line if there is a grace period
        if ContractRec."Grace Period" > 0 then begin
            NewLineNo := GetNextLineNo();

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

            if SuspensionRec.FindFirst() then begin
                FilteredContractRec."Suspension Start Date" := SuspensionRec.DateEffective;
                FilteredContractRec."Suspension End Date" := SuspensionRec.SuspensionEndDate;
            end;

            FilteredContractRec."Multi Year Start Date" := MultiYearStartDate;
            FilteredContractRec."Multi Year End Date" := MultiYearEndDate;
            FilteredContractRec."No Of Days" := CalculatedDays;
            FilteredContractRec."Per Day Rent" := -DifferencePerDayRent; // Negative value
            FilteredContractRec."Contract Amount" := GridAnnualAmount; // Use grid's annual amount
            FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
            FilteredContractRec."Total Value" := -GracePeriodAdjustmentValue; // Negative adjustment
            FilteredContractRec."Owner Share" := -GracePeriodAdjustmentValue; // Negative adjustment
            FilteredContractRec."Final Annual Amount" := TotalAnnualAmount;
            FilteredContractRec."Posting Month" := MonthNo - 1;
            FilteredContractRec."Posting Year" := FinancialYear;
            FilteredContractRec."Posting Period" := Format(FilteredContractRec."Posting Month") +
                ' ' + Format(FilteredContractRec."Posting Year") + ' ' + '-' + ' ' +
                Format(FilteredContractRec."Posting Month") + ' ' + Format(FilteredContractRec."Posting Year");
            FilteredContractRec."Owner Name" := ContractRec."Owner's Name";
            // Add a description to indicate this is a grace period adjustment
            // FilteredContractRec."Description" := 'Grace Period Adjustment';
            FilteredContractRec.Insert();
        end;
    end;


    // Add this new helper procedure to handle missed revenue allocations
    procedure HandleMissedAllocation(
     ContractRec: Record "Tenancy Contract";
     MonthNo: Integer;
     FinancialYear: Integer)
    var
        PreviousMonthNo: Integer;
        PreviousYearNo: Integer;
        PreviousMonthStart: Date;
        PreviousMonthEnd: Date;
        CurrentMonthStart: Date;
        CurrentMonthEnd: Date;
        ContractStartDate: Date;
        MissedDays: Integer;
        SingleUnitRent: Record "TC Single Unit Rent SubPage";
        MultiUnitRent: Record "TC Single LumAnnualAmnt SP";
        MergedSingleRent: Record "TC Merge SameSqure SubPage";
        MergedMultiRent: Record "TC Merge DifferentSq SubPage";
        SpecialRent: Record "TC Merge LumAnnualAmount SP";
        FinalCalculationRec: Record "Final Calculation";
        TerminationDate: Date;
        LineNo: Integer;
    begin
        // Calculate previous month and year
        if MonthNo = 1 then begin
            PreviousMonthNo := 12;
            PreviousYearNo := FinancialYear - 1;
        end else begin
            PreviousMonthNo := MonthNo - 1;
            PreviousYearNo := FinancialYear;
        end;

        // Calculate date ranges
        PreviousMonthStart := DMY2Date(1, PreviousMonthNo, PreviousYearNo);
        PreviousMonthEnd := CALCDATE('<+1M-1D>', PreviousMonthStart);
        CurrentMonthStart := DMY2Date(1, MonthNo, FinancialYear);
        CurrentMonthEnd := CALCDATE('<+1M-1D>', CurrentMonthStart);
        ContractStartDate := ContractRec."Contract Start Date";

        // Check if contract started in previous month
        if (ContractStartDate >= PreviousMonthStart) and (ContractStartDate <= PreviousMonthEnd) then begin
            // Contract started in previous month, so we need to allocate missed days
            MissedDays := PreviousMonthEnd - ContractStartDate + 1;

            // Retrieve Termination Date from Final Calculation
            FinalCalculationRec.Reset();
            FinalCalculationRec.SetRange("Contract ID", ContractRec."Contract ID");
            if FinalCalculationRec.FindFirst() then
                TerminationDate := FinalCalculationRec."Termination Date"
            else
                TerminationDate := 0D;

            // Process each rent type for missed allocation
            // Check Single Unit Rent grid
            SingleUnitRent.Reset();
            SingleUnitRent.SetRange("Contract ID", ContractRec."Contract ID");
            if SingleUnitRent.FindSet() then begin
                repeat
                    if (SingleUnitRent."Start Date" <= PreviousMonthEnd) and (SingleUnitRent."End Date" >= ContractStartDate) then begin
                        InsertMissedAllocationLine(
                            ContractRec,
                            SingleUnitRent."Start Date",
                            SingleUnitRent."End Date",
                            SingleUnitRent."Number of Days",
                            SingleUnitRent."Per Day Rent",
                            SingleUnitRent."Final Annual Amount",
                            SingleUnitRent."Final Annual Amount",
                            TerminationDate,
                            LineNo,
                            PreviousMonthNo,
                            PreviousYearNo,
                            ContractStartDate,
                            PreviousMonthEnd);
                    end;
                until SingleUnitRent.Next() = 0;
            end;

            // Check Multi Unit Rent grid
            MultiUnitRent.Reset();
            MultiUnitRent.SetRange("Contract ID", ContractRec."Contract ID");
            if MultiUnitRent.FindSet() then begin
                repeat
                    if (MultiUnitRent."SL_Start Date" <= PreviousMonthEnd) and (MultiUnitRent."SL_End Date" >= ContractStartDate) then begin
                        InsertMissedAllocationLine(
                            ContractRec,
                            MultiUnitRent."SL_Start Date",
                            MultiUnitRent."SL_End Date",
                            MultiUnitRent."SL_Number of Days",
                            MultiUnitRent."SL_Per Day Rent",
                            MultiUnitRent."SL_Final Annual Amount",
                            MultiUnitRent."SL_Final Annual Amount",
                            TerminationDate,
                            LineNo,
                            PreviousMonthNo,
                            PreviousYearNo,
                            ContractStartDate,
                            PreviousMonthEnd);
                    end;
                until MultiUnitRent.Next() = 0;
            end;

            // Check Merged Single Rent grid
            MergedSingleRent.Reset();
            MergedSingleRent.SetRange("Contract ID", ContractRec."Contract ID");
            if MergedSingleRent.FindSet() then begin
                repeat
                    if (MergedSingleRent."MS_Start Date" <= PreviousMonthEnd) and (MergedSingleRent."MS_End Date" >= ContractStartDate) then begin
                        InsertMissedAllocationLine(
                            ContractRec,
                            MergedSingleRent."MS_Start Date",
                            MergedSingleRent."MS_End Date",
                            MergedSingleRent."MS_Number of Days",
                            MergedSingleRent."MS_Per Day Rent",
                            MergedSingleRent."MS_Final Annual Amount",
                            MergedSingleRent."MS_Final Annual Amount",
                            TerminationDate,
                            LineNo,
                            PreviousMonthNo,
                            PreviousYearNo,
                            ContractStartDate,
                            PreviousMonthEnd);
                    end;
                until MergedSingleRent.Next() = 0;
            end;

            // Check Merged Multi Rent grid
            MergedMultiRent.Reset();
            MergedMultiRent.SetRange("Contract ID", ContractRec."Contract ID");
            if MergedMultiRent.FindSet() then begin
                repeat
                    if (MergedMultiRent."MD_Start Date" <= PreviousMonthEnd) and (MergedMultiRent."MD_End Date" >= ContractStartDate) then begin
                        InsertMissedAllocationLine(
                            ContractRec,
                            MergedMultiRent."MD_Start Date",
                            MergedMultiRent."MD_End Date",
                            MergedMultiRent."MD_Number of Days",
                            MergedMultiRent."MD_Per Day Rent",
                            MergedMultiRent."MD_Final Annual Amount",
                            MergedMultiRent."MD_Final Annual Amount",
                            TerminationDate,
                            LineNo,
                            PreviousMonthNo,
                            PreviousYearNo,
                            ContractStartDate,
                            PreviousMonthEnd);
                    end;
                until MergedMultiRent.Next() = 0;
            end;

            // Check Special Rent grid
            SpecialRent.Reset();
            SpecialRent.SetRange("Contract ID", ContractRec."Contract ID");
            if SpecialRent.FindSet() then begin
                repeat
                    if (SpecialRent."ML_Start Date" <= PreviousMonthEnd) and (SpecialRent."ML_End Date" >= ContractStartDate) then begin
                        InsertMissedAllocationLine(
                            ContractRec,
                            SpecialRent."ML_Start Date",
                            SpecialRent."ML_End Date",
                            SpecialRent."ML_Number of Days",
                            SpecialRent."ML_Per Day Rent",
                            SpecialRent."ML_Final Annual Amount",
                            SpecialRent."ML_Final Annual Amount",
                            TerminationDate,
                            LineNo,
                            PreviousMonthNo,
                            PreviousYearNo,
                            ContractStartDate,
                            PreviousMonthEnd);
                    end;
                until SpecialRent.Next() = 0;
            end;
        end;
    end;

    // Helper procedure to insert missed allocation lines
    procedure InsertMissedAllocationLine(
     ContractRec: Record "Tenancy Contract";
     MultiYearStartDate: Date;
     MultiYearEndDate: Date;
     NoOfDays: Integer;
     PerDayRent: Decimal;
     TotalAnnualAmount: Decimal;
     OwnerShareAmount: Decimal;
     TerminationDate: Date;
     LineNo: Integer;
     PreviousMonthNo: Integer;
     PreviousYearNo: Integer;
     ContractStartDate: Date;
     PreviousMonthEnd: Date)
    var
        FilteredContractRec: Record "Revenue Allocation SubGrid";
        SuspensionRec: Record SuspendReasonTable;
        CalculatedDays: Integer;
        NewLineNo: Integer;
        PerDayRentWithoutGracePeriod: Decimal;
        PerDayRentWithGracePeriod: Decimal;
        TotalContractDays: Integer;
        TotalContractDaysWithGrace: Integer;
        DifferencePerDayRent: Decimal;
        GracePeriodAdjustmentValue: Decimal;
        GridAnnualAmount: Decimal;
        MissedDays: Integer;
    begin
        // Calculate missed days
        MissedDays := PreviousMonthEnd - ContractStartDate + 1;

        // Get new line number
        NewLineNo := GetNextLineNo();

        // Use the annual amount from the grid record instead of the main contract
        GridAnnualAmount := TotalAnnualAmount;

        // Calculate Total Contract Days
        TotalContractDays := MultiYearEndDate - MultiYearStartDate + 1;

        // Calculate Total Contract Days (with grace period)
        TotalContractDaysWithGrace := TotalContractDays + ContractRec."Grace Period";

        // Calculate Per Day Rent without Grace Period (using grid's annual amount)
        PerDayRentWithoutGracePeriod := Round(GridAnnualAmount / TotalContractDays);

        // Calculate Per Day Rent with Grace Period (using grid's annual amount)
        PerDayRentWithGracePeriod := Round(GridAnnualAmount / TotalContractDaysWithGrace);

        // Calculate the difference per day
        DifferencePerDayRent := PerDayRentWithoutGracePeriod - PerDayRentWithGracePeriod;

        // Calculate total adjustment value for the missed days
        GracePeriodAdjustmentValue := DifferencePerDayRent * MissedDays;

        // -----------------------------------------------
        // Insert missed allocation line (without grace period adjustment)
        // -----------------------------------------------
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
        FilteredContractRec."No Of Days" := MissedDays;
        FilteredContractRec."Per Day Rent" := Round(PerDayRent);
        FilteredContractRec."Contract Amount" := GridAnnualAmount;
        FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
        FilteredContractRec."Total Value" := MissedDays * FilteredContractRec."Per Day Rent";
        FilteredContractRec."Owner Share" := MissedDays * FilteredContractRec."Per Day Rent";
        FilteredContractRec."Final Annual Amount" := TotalAnnualAmount;
        FilteredContractRec."Posting Month" := PreviousMonthNo;
        FilteredContractRec."Posting Year" := PreviousYearNo;
        FilteredContractRec."Posting Period" := GetMonthName(PreviousMonthNo) + ' ' +
            Format(PreviousYearNo) + ' ' + '-' + ' ' + GetMonthName(PreviousMonthNo) + ' ' + Format(PreviousYearNo);
        FilteredContractRec."Owner Name" := ContractRec."Owner's Name";
        FilteredContractRec.Insert();

        // -----------------------------------------------
        // Insert grace period adjustment line (negative allocation) for missed days
        // -----------------------------------------------
        // Only insert the adjustment line if there is a grace period
        if ContractRec."Grace Period" > 0 then begin
            NewLineNo := GetNextLineNo();

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

            if SuspensionRec.FindFirst() then begin
                FilteredContractRec."Suspension Start Date" := SuspensionRec.DateEffective;
                FilteredContractRec."Suspension End Date" := SuspensionRec.SuspensionEndDate;
            end;

            FilteredContractRec."Multi Year Start Date" := MultiYearStartDate;
            FilteredContractRec."Multi Year End Date" := MultiYearEndDate;
            FilteredContractRec."No Of Days" := MissedDays;
            FilteredContractRec."Per Day Rent" := -DifferencePerDayRent; // Negative value
            FilteredContractRec."Contract Amount" := GridAnnualAmount;
            FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
            FilteredContractRec."Total Value" := -GracePeriodAdjustmentValue; // Negative adjustment
            FilteredContractRec."Owner Share" := -GracePeriodAdjustmentValue; // Negative adjustment
            FilteredContractRec."Final Annual Amount" := TotalAnnualAmount;
            FilteredContractRec."Posting Month" := PreviousMonthNo;
            FilteredContractRec."Posting Year" := PreviousYearNo;
            FilteredContractRec."Posting Period" := GetMonthName(PreviousMonthNo) + ' ' +
                Format(PreviousYearNo) + ' ' + '-' + ' ' + GetMonthName(PreviousMonthNo) + ' ' + Format(PreviousYearNo);
            FilteredContractRec."Owner Name" := ContractRec."Owner's Name";
            FilteredContractRec.Insert();
        end;
    end;

    // Helper function to get month name from month number
    procedure GetMonthName(MonthNo: Integer): Text
    begin
        case MonthNo of
            1:
                exit('January');
            2:
                exit('February');
            3:
                exit('March');
            4:
                exit('April');
            5:
                exit('May');
            6:
                exit('June');
            7:
                exit('July');
            8:
                exit('August');
            9:
                exit('September');
            10:
                exit('October');
            11:
                exit('November');
            12:
                exit('December');
            else
                exit(Format(MonthNo)); // Fallback to number if invalid
        end;
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

                    // HANDLE MISSED ALLOCATION: Check for missed allocation from previous month
                    HandleMissedAllocation(ContractRec, MonthNo, FinancialYear);

                    // Continue with normal allocation process for current month

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

    procedure CalculateAndStoreTotalRevenue()
    var
        revenueItemLine: Record "Revenue Recognition Details";
        revenueAllocLine: Record "Revenue Allocation Subgrid";
    begin
        Clear(totalcontractAmounts);
        Clear(totalamounts);

        revenueItemLine.SetRange("RR_No.", Rec."No.");
        if revenueItemLine.FindSet() then
            repeat
                totalcontractAmounts += revenueItemLine."Contract Amount";
                totalamounts += revenueItemLine."Total Value";
            until revenueItemLine.Next() = 0;


        revenueAllocLine.SetRange("Header No.", Rec."No.");
        if revenueAllocLine.FindSet() then
            repeat
                totalcontractAmountsss += revenueAllocLine."Contract Amount";
                totalamountsss += revenueAllocLine."Total Value";
                totalannualamountsss += revenueAllocLine."Annual Amount";
                totalfinalannualamountsss += revenueAllocLine."Final Annual Amount";
            until revenueAllocLine.Next() = 0;


        totalcombinecontractAmounts := totalcontractAmountsss + totalcontractAmounts;
        totalcombineamounts := totalamountsss + totalamounts;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateAndStoreTotalRevenue();
    end;


    var

        totalcontractAmountsss: Decimal;
        totalamountsss: Decimal;
        totalannualamountsss: Decimal;
        totalfinalannualamountsss: Decimal;

        totalcontractAmounts: Decimal;
        totalamounts: Decimal;

        totalcombinecontractAmounts: Decimal;
        totalcombineamounts: Decimal;

    // trigger OnAfterGetRecord()
    // begin
    //     CurrPage."Revenue Recognition Item Details".Page.SetRIID(Rec."No.");
    //     CurrPage."Revenue Recognition Details".Page.SetRIID(Rec."No.");
    // end;


    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Revenue Recognition Item Details".Page.SetRIID(Rec."No.");
        CurrPage."Revenue Recognition Details".Page.SetRIID(Rec."No.");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Revenue Recognition Item Details".Page.SetRIID(Rec."No.");
        CurrPage."Revenue Recognition Details".Page.SetRIID(Rec."No.");
        CalculateAndStoreTotalRevenue();
    end;
}
