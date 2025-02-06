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
                    Caption = 'No.';
                    trigger OnValidate()
                    begin
                        if xRec."No." <> Rec."No." then
                            ClearSubgridData();
                    end;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                    Caption = 'Month';

                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                    Caption = 'Financial Year';
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
        FilteredContractRec: Record "Revenue Allocation SubGrid";
    begin
        FilteredContractRec.Reset();
        FilteredContractRec.SetRange("Header No.", Rec."No.");
        FilteredContractRec.DeleteAll();
    end;
    // Helper procedure to insert allocation line
    procedure InsertAllocationLine(
        ContractRec: Record "Tenancy Contract";
        MultiYearStartDate: Date;
        MultiYearEndDate: Date;
        NoOfDays: Integer;
        PerDayRent: Decimal;
        LineNo: Integer;
        MonthNo: Integer;
        FinancialYear: Integer)
    var
        FilteredContractRec: Record "Revenue Allocation SubGrid";
        SuspensionRec: Record SuspendReasonTable;
    begin
        FilteredContractRec.Init();
        FilteredContractRec."Line No." := LineNo;
        FilteredContractRec."Header No." := Rec."No.";
        FilteredContractRec."Property Name" := ContractRec."Property Name";
        FilteredContractRec."Contract Id" := ContractRec."Contract ID";
        FilteredContractRec."Contract Tenure" := ContractRec."Contract Tenor";
        FilteredContractRec."Customer Name" := ContractRec."Customer Name";
        FilteredContractRec."Contract Start Date" := ContractRec."Contract Start Date";
        FilteredContractRec."Contract End Date" := ContractRec."Contract End Date";
        FilteredContractRec."Grace Days" := ContractRec."Grace Period";

        // Look up suspension dates
        SuspensionRec.Reset();
        SuspensionRec.SetRange("Contract ID", ContractRec."Contract ID");
        if SuspensionRec.FindFirst() then begin
            FilteredContractRec."Suspension Start Date" := SuspensionRec.DateEffective;
            FilteredContractRec."Suspension End Date" := SuspensionRec.SuspensionEndDate;
        end;

        FilteredContractRec."Multi Year Start Date" := MultiYearStartDate;
        FilteredContractRec."Multi Year End Date" := MultiYearEndDate;
        FilteredContractRec."No Of Days" := NoOfDays;
        FilteredContractRec."Per Day Rent" := PerDayRent;  // <-- NEW FIELD
        FilteredContractRec."Contract Amount" := ContractRec."Annual Rent Amount";
        FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
        FilteredContractRec."Posting Month" := MonthNo - 1;
        FilteredContractRec."Posting Year" := FinancialYear;
        FilteredContractRec."Posting Period" := Format(FilteredContractRec."Posting Month") +
            ' ' + Format(FilteredContractRec."Posting Year") + ' ' + '-' + ' ' +
            Format(FilteredContractRec."Posting Month") + ' ' + Format(FilteredContractRec."Posting Year");
        FilteredContractRec."Owner Name" := ContractRec."Owner's Name";

        FilteredContractRec.Insert();
    end;

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
        SelectedMonthStart: Date;
        SelectedMonthEnd: Date;
        MonthNo: Integer;
        FinancialYear: Integer;
        NextLineNo: Integer;
        Debug: Text;
        ContractsChecked: Integer;
        ContractsInRange: Integer;
        RecordsInserted: Integer;
    begin
        ClearSubgridData();

        MonthNo := Rec.Month + 1;
        FinancialYear := Rec."Financial Year";
        NextLineNo := 1;

        SelectedMonthStart := DMY2Date(01, MonthNo, FinancialYear);
        SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart);

        // Debug := 'Fetching contracts for:\';
        // Debug += 'Month: ' + Format(MonthNo) + '\';
        // Debug += 'Year: ' + Format(FinancialYear) + '\';
        // Debug += 'Date Range: ' + Format(SelectedMonthStart) + ' to ' + Format(SelectedMonthEnd) + '\';

        if ContractRec.FindSet() then begin
            repeat
                ContractsChecked += 1;
                // Debug += '\Contract ' + ContractRec."Contract ID" + ':\';
                // Debug += '  Dates: ' + Format(ContractRec."Contract Start Date") + ' to ' + Format(ContractRec."Contract End Date");

                if ((ContractRec."Contract Start Date" <= SelectedMonthEnd) and
                    (ContractRec."Contract End Date" >= SelectedMonthStart)) then begin
                    ContractsInRange += 1;
                    // Debug += '  (In Range)\';

                    // Check Single Unit Rent grid
                    SingleUnitRent.Reset();
                    SingleUnitRent.SetRange("Contract ID", ContractRec."Contract ID");
                    // Debug += '    SingleUnitRent Records: ' + Format(SingleUnitRent.Count) + '\';

                    // Check Multi Unit Rent grid
                    MultiUnitRent.Reset();
                    MultiUnitRent.SetRange("Contract ID", ContractRec."Contract ID");
                    // Debug += '    MultiUnitRent Records: ' + Format(MultiUnitRent.Count) + '\';

                    // Check Merged Single Rent grid
                    MergedSingleRent.Reset();
                    MergedSingleRent.SetRange("Contract ID", ContractRec."Contract ID");
                    // Debug += '    MergedSingleRent Records: ' + Format(MergedSingleRent.Count) + '\';

                    // Check Merged Multi Rent grid
                    MergedMultiRent.Reset();
                    MergedMultiRent.SetRange("Contract ID", ContractRec."Contract ID");
                    // Debug += '    MergedMultiRent Records: ' + Format(MergedMultiRent.Count) + '\';

                    // Check Special Rent grid
                    SpecialRent.Reset();
                    SpecialRent.SetRange("Contract ID", ContractRec."Contract ID");
                    // Debug += '    SpecialRent Records: ' + Format(SpecialRent.Count) + '\';

                    // Now try to insert records from each grid...
                    if SingleUnitRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec, SingleUnitRent."Start Date", SingleUnitRent."End Date",
                                SingleUnitRent."Number of Days", SingleUnitRent."Per Day Rent", NextLineNo, MonthNo, FinancialYear);
                            NextLineNo += 1;
                            RecordsInserted += 1;
                        until SingleUnitRent.Next() = 0;
                    end;
                    // Now try to insert records from each grid...
                    if MultiUnitRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec, MultiUnitRent."SL_Start Date", MultiUnitRent."SL_End Date",
                                MultiUnitRent."SL_Number of Days", MultiUnitRent."SL_Per Day Rent", NextLineNo, MonthNo, FinancialYear);
                            NextLineNo += 1;
                            RecordsInserted += 1;
                        until MultiUnitRent.Next() = 0;
                    end;
                    // Now try to insert records from each grid...
                    if MergedSingleRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec, MergedSingleRent."MS_Start Date", MergedSingleRent."MS_End Date",
                                MergedSingleRent."MS_Number of Days", MergedSingleRent."MS_Per Day Rent", NextLineNo, MonthNo, FinancialYear);
                            NextLineNo += 1;
                            RecordsInserted += 1;
                        until MergedSingleRent.Next() = 0;
                    end;
                    // Now try to insert records from each grid...
                    if MergedMultiRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec, MergedMultiRent."MD_Start Date", MergedMultiRent."MD_End Date",
                                MergedMultiRent."MD_Number of Days", MergedMultiRent."MD_Per Day Rent", NextLineNo, MonthNo, FinancialYear);
                            NextLineNo += 1;
                            RecordsInserted += 1;
                        until MergedMultiRent.Next() = 0;
                    end;
                    // Now try to insert records from each grid...
                    if SpecialRent.FindSet() then begin
                        repeat
                            InsertAllocationLine(
                                ContractRec, SpecialRent."ML_Start Date", SpecialRent."ML_End Date",
                                SpecialRent."ML_Number of Days", SpecialRent."ML_Per Day Rent", NextLineNo, MonthNo, FinancialYear);
                            NextLineNo += 1;
                            RecordsInserted += 1;
                        until SpecialRent.Next() = 0;
                    end;

                    // ... [Rest of the insertion code remains the same]

                end
            // Debug += '  (Out of Range)';

            until ContractRec.Next() = 0;
        end;

        // Debug += '\\\Summary:\';
        // Debug += Format(ContractsChecked) + ' contracts checked\';
        // Debug += Format(ContractsInRange) + ' contracts in date range\';
        // Debug += Format(RecordsInserted) + ' total records inserted';

        // Message(Debug);
    end;


}
