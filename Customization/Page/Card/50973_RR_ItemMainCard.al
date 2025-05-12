page 50973 "Revenue Recognition Item Sub"
{

    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Revenue Recognition Item";
    Caption = 'Revenue Item';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("RR_No."; Rec."RR_No.")  // Add this field
                {
                    ApplicationArea = All;
                    Visible = false;  // Usually kept hidden since it's just for linking
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                }
                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        Revenueitembreakdown: Record "Revenue Item Breakdown";
                    begin
                        Revenueitembreakdown.SetRange("RI_No.", Rec.Link);
                        if Revenueitembreakdown.FindSet() then
                            PAGE.RunModal(PAGE::"Revenue Item Breakdown Card", Revenueitembreakdown)
                        else
                            Message('No Revenue Item Breakdown found using FindFirst either.');
                    end;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
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

                Caption = 'Revenue Details';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    FetchContracts();
                end;
            }
        }
    }


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearSubgridData();
    end;

    procedure ClearSubgridData()
    var
        revenueitemdetail: Record "Revenue Recognition Details";
    begin
        revenueitemdetail.SetRange("RR_No.", Rec."RR_No.");
        revenueitemdetail.DeleteAll();
    end;



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

    procedure GetNextLineNo(): Integer
    var
        FilteredContractRec: Record "Revenue Recognition Details";
        LastLineNo: Integer;
    begin
        FilteredContractRec.Reset();
        FilteredContractRec.SetRange("RR_No.", Rec."RR_No.");
        if FilteredContractRec.FindLast() then
            LastLineNo := FilteredContractRec."Entry No."
        else
            LastLineNo := 0;
        exit(LastLineNo + 1);
    end;

    procedure ShouldKeepEntry(StartDate: Date; EndDate: Date): Boolean
    var
        CheckDate: Date;
        LastDayOfMonth: Date;
        FirstDayOfMonth: Date;
        revenueallocation: Record "Revenue Allocation Details";
    begin
        // Get first day of selected month
        FirstDayOfMonth := DMY2Date(1, revenueallocation.Month + 1, revenueallocation."Financial Year");

        // Get last day of selected month
        LastDayOfMonth := CALCDATE('<+1M-1D>', FirstDayOfMonth);

        // Check if selected month's date range overlaps with the given date range
        // A period overlaps if:
        // 1. The start date is before or equal to the last day of the month AND
        // 2. The end date is after or equal to the first day of the month
        if (StartDate <= LastDayOfMonth) and (EndDate >= FirstDayOfMonth) then
            exit(true);


        exit(false);
    end;

    // Helper procedure to insert allocation line
    procedure InsertAllocationLine(
      ContractRec: Record "Tenancy Contract";
      MultiYearStartDate: Date;
      MultiYearEndDate: Date;
      NoOfDays: Integer;
      PerDayRent: Decimal;
      TotalAnnualAmount: Decimal;
      OwnerShareAmount: Decimal;
    TerminationDate: Date; // New parameter for Termination Date
      LineNo: Integer;
      MonthNo: Integer;
      FinancialYear: Integer)
    var
        FilteredContractRec: Record "Revenue Recognition Details";
        SuspensionRec: Record SuspendReasonTable;
        CalculatedDays: Integer;
        NewLineNo: Integer;
        TotalDays: Integer;
        DailyRate: Decimal;
        RevenueItemRec: Record "Revenue Item Breakdown Details";
        TotalMergedAmount: Decimal;
        PerDayMergedAmount: Decimal;
        revenueitem: Record "Revenue Recognition Item";
    // CalculatedTotalValue: Decimal;
    // CalculatedOwnerShare: Decimal;
    begin
        // Check if December 2024 falls within multi year date range
        if not ShouldKeepEntry(MultiYearStartDate, MultiYearEndDate) then
            exit;

        // 🚨 Prevent inserting duplicate Contract ID + RR_No. combination
        FilteredContractRec.Reset();
        FilteredContractRec.SetRange("RR_No.", Rec."RR_No.");
        FilteredContractRec.SetRange("Contract Id", ContractRec."Contract ID");

        if FilteredContractRec.FindFirst() then
            exit; // Record already exists, so skip inserting

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


        FilteredContractRec.Init();
        FilteredContractRec."Entry No." := NewLineNo;
        FilteredContractRec."RR_No." := Rec."RR_No.";
        FilteredContractRec."Property Name" := ContractRec."Property Name";
        FilteredContractRec."Contract Id" := ContractRec."Contract ID";
        FilteredContractRec."Contract Tenure" := ContractRec."Contract Tenor";
        FilteredContractRec."Customer Name" := ContractRec."Customer Name";
        FilteredContractRec."Contract Start Date" := ContractRec."Contract Start Date";
        FilteredContractRec."Contract End Date" := ContractRec."Contract End Date";
        FilteredContractRec."Grace Days" := ContractRec."Grace Period";
        FilteredContractRec."Contract Amount" := ContractRec."Contract Amount Including VAT";
        FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
        FilteredContractRec."Owner Name" := ContractRec."Owner's Name";


        RevenueItemRec.Reset();
        RevenueItemRec.SetRange("Contract ID", ContractRec."Contract ID");
        RevenueItemRec.SetRange("Item Type", revenueitem."Item Type");
        if RevenueItemRec.FindSet() then begin
            repeat
                // Sum all charges (adjust field name as per your table)
                PerDayMergedAmount += RevenueItemRec."Per Day Amount"; // Replace "Amount" with your actual charge field
                TotalMergedAmount += RevenueItemRec."Total Value";
            until RevenueItemRec.Next() = 0;
        end;
        FilteredContractRec."No Of Days" := RevenueItemRec."No Of Days";
        FilteredContractRec."Per Day Amount" := PerDayMergedAmount;
        FilteredContractRec."Total Value" := TotalMergedAmount;
        FilteredContractRec."Owner Share" := TotalMergedAmount; // If same as Total Value
        // TotalDays := FilteredContractRec."Contract End Date" - FilteredContractRec."Contract Start Date" + 1;
        // if TotalDays <= 0 then
        //     Error('Invalid contract dates. End date must be after start date.');

        // // Calculate per day amount and value
        // DailyRate := FilteredContractRec."Contract Amount" / TotalDays;
        // // FilteredContractRec."Multi Year Start Date" := MultiYearStartDate;
        // // FilteredContractRec."Multi Year End Date" := MultiYearEndDate;
        // FilteredContractRec."No Of Days" := CalculatedDays;
        // FilteredContractRec."Per Day Amount" := Round(DailyRate);
        // FilteredContractRec."Total Value" := CalculatedDays * FilteredContractRec."Per Day Amount";
        // FilteredContractRec."Owner Share" := CalculatedDays * FilteredContractRec."Per Day Amount";

        // // Add this line to store the Final Annual Amount
        // // FilteredContractRec."Final Annual Amount" := TotalAnnualAmount;
        // // FilteredContractRec."Posting Month" := MonthNo - 1;
        // // FilteredContractRec."Posting Year" := FinancialYear;
        // // FilteredContractRec."Posting Period" := Format(FilteredContractRec."Posting Month") +
        // //     ' ' + Format(FilteredContractRec."Posting Year") + ' ' + '-' + ' ' +
        // //     Format(FilteredContractRec."Posting Month") + ' ' + Format(FilteredContractRec."Posting Year");
        // FilteredContractRec."Owner Name" := ContractRec."Owner's Name";
        FilteredContractRec.Insert();
    end;

    // Then modify the FetchContracts procedure to use this
    procedure FetchContracts()
    var
        FilterHeader: Record "Revenue Allocation Details";
        ContractRec: Record "Tenancy Contract";
        FilteredContractRec: Record "Revenue Recognition Details";
        SuspensionRec: Record SuspendReasonTable;
        FinalCalculationRec: Record "Final Calculation"; // New record for Final Calculation
        SelectedMonthStart: Date;
        SelectedMonthEnd: Date;
        MonthNo: Integer;
        FinancialYear: Integer;
        LineNo: Integer;
        TerminationDate: Date; // Variable to store Termination Date
        revenueallocation: Record "Revenue Allocation Details";

    begin
        ClearSubgridData();

        MonthNo := revenueallocation.Month + 1;
        FinancialYear := revenueallocation."Financial Year";


        SelectedMonthStart := DMY2Date(01, MonthNo, FinancialYear);
        SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart);

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
                        TerminationDate := 0D; // Default to blank if no termination date
                end;
            until ContractRec.Next() = 0;
        end;
    end;

    procedure SetRIID(pRRID: Integer)
    begin
        RRID := pRRID;

    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."RR_No." := RRID;
    end;

    var
        RRID: Integer;

}
