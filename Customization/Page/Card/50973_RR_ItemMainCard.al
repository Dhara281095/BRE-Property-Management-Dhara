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
                field("RR_No."; Rec."RR_No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchRevenueDetails)
            {
                Caption = 'Revenue Allocation-Other Charges';
                ApplicationArea = All;
                Image = List;
                trigger OnAction()
                var
                    ConfirmFetch: Boolean;
                    revenueAllocation: Record "Revenue Allocation Details";
                begin
                    // Get the current Revenue Allocation record details
                    if not GetCurrentRevenueAllocation(RevenueAllocation) then begin
                        Message('Unable to get Revenue Allocation details. Please ensure you are on a valid record.');
                        exit;
                    end;

                    // Confirm before fetching details
                    ConfirmFetch := Confirm('Do you want to fetch revenue details for the selected Item Type(s) for %1 %2?',
                        false, Format(RevenueAllocation.Month), RevenueAllocation."Financial Year");

                    if ConfirmFetch then begin
                        // Call the fetch procedure with current allocation details
                        FetchContractDetails(RevenueAllocation);

                        // Show message about fetched details
                        Message('Revenue details have been fetched successfully.');
                    end;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearSubgridData();
    end;

    // Get current Revenue Allocation record
    local procedure GetCurrentRevenueAllocation(var RevenueAllocation: Record "Revenue Allocation Details"): Boolean
    begin
        // Get the current RR_No from the record
        if Rec."RR_No." = 0 then
            exit(false);

        // Find the Revenue Allocation record using RR_No
        RevenueAllocation.Reset();
        RevenueAllocation.SetRange("No.", Rec."RR_No.");
        if RevenueAllocation.FindFirst() then
            exit(true);

        exit(false);
    end;

    procedure ClearSubgridData()
    var
        RevenueItemDetail: Record "Revenue Recognition Details";
    begin
        // Clear existing details for this Revenue Recognition record
        RevenueItemDetail.SetRange("RR_No.", Rec."RR_No.");
        RevenueItemDetail.DeleteAll(true);
    end;

    procedure FetchContractDetails(RevenueAllocation: Record "Revenue Allocation Details")
    var
        TenancyContract: Record "Tenancy Contract";
        RevenueStructure: Record "Revenue Structure";  // Direct reference to Revenue Structure
        RevenueRecognitionDetails: Record "Revenue Recognition Details";
        SelectedItemTypes: List of [Text];
        ProcessedContractCount: Integer;
        ContractProcessed: Boolean;
        RevenueAllocationStartDate: Date;
        RevenueAllocationEndDate: Date;
    begin
        // Clear existing data
        ClearSubgridData();

        // Get selected Item Types for this Revenue Recognition Item
        GetSelectedItemTypes(SelectedItemTypes);

        // If no item types are selected, exit
        if SelectedItemTypes.Count = 0 then begin
            Message('Please select at least one Item Type.');
            exit;
        end;

        // Reset processed contract counter
        ProcessedContractCount := 0;

        // Calculate month start and end dates
        RevenueAllocationStartDate := DMY2Date(1, RevenueAllocation.Month, RevenueAllocation."Financial Year");
        RevenueAllocationEndDate := CalcDate('CM', RevenueAllocationStartDate);

        // Process active contracts directly from Revenue Structure
        if TenancyContract.FindSet() then begin
            repeat
                // Check if contract is active during the selected period
                if (TenancyContract."Contract Start Date" <= RevenueAllocationEndDate) and
                   (TenancyContract."Contract End Date" >= RevenueAllocationStartDate) then begin

                    // Reset flag for each contract
                    ContractProcessed := false;

                    // Get revenue structure details directly for this contract
                    RevenueStructure.Reset();
                    RevenueStructure.SetRange("Contract ID", TenancyContract."Contract ID");

                    // Filter by selected Item Types
                    RevenueStructure.SetFilter("Secondary Item Type", GetItemTypeFilter(SelectedItemTypes));

                    if RevenueStructure.FindSet() then begin
                        repeat
                            // Create Revenue Recognition Detail directly from Revenue Structure
                            CreateRevenueRecognitionDetailDirect(TenancyContract, RevenueStructure, RevenueAllocation);

                            // Mark contract as processed
                            ContractProcessed := true;
                        until RevenueStructure.Next() = 0;
                    end;

                    // Increment processed contract counter if at least one structure was found
                    if ContractProcessed then
                        ProcessedContractCount += 1;
                end;
            until TenancyContract.Next() = 0;
        end;

        // Refresh the page to show new details
        CurrPage.Update(false);

        // Show summary message
        Message(
            'Revenue Details Fetched Summary:\' +
            'Item Types: %1\' +
            'Processed Contracts: %2',
            GetItemTypeFilter(SelectedItemTypes),
            ProcessedContractCount
        );
    end;

    local procedure GetSelectedItemTypes(var pItemTypes: List of [Text])
    var
        RevenueRecognitionItem: Record "Revenue Recognition Item";
    begin
        // Set filter to get all selected Item Types
        RevenueRecognitionItem.SetRange("RR_No.", Rec."RR_No.");

        // Find all records for this Revenue Recognition
        if RevenueRecognitionItem.FindSet() then begin
            repeat
                // Only add non-empty Item Types
                if RevenueRecognitionItem."Item Type" <> '' then begin
                    // Check if Item Type is not already in the list
                    if not pItemTypes.Contains(RevenueRecognitionItem."Item Type") then
                        pItemTypes.Add(RevenueRecognitionItem."Item Type");
                end;
            until RevenueRecognitionItem.Next() = 0;
        end;
    end;

    local procedure GetItemTypeFilter(pItemTypes: List of [Text]): Text
    var
        FilterText: Text;
        ItemType: Text;
    begin
        // Build filter text
        foreach ItemType in pItemTypes do begin
            if FilterText = '' then
                FilterText := ItemType
            else
                FilterText += '|' + ItemType;
        end;

        exit(FilterText);
    end;

    // local procedure IsContractActiveForPeriod(
    //     pTenancyContract: Record "Tenancy Contract";
    //     pRevenueAllocation: Record "Revenue Allocation Details"
    // ): Boolean
    // var
    //     SelectedMonthStart: Date;
    //     SelectedMonthEnd: Date;
    // begin
    //     // Calculate the start and end of the selected month
    //     SelectedMonthStart := DMY2Date(1, pRevenueAllocation.Month + 1, pRevenueAllocation."Financial Year");
    //     SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart);

    //     // Check if contract overlaps with the selected period
    //     exit(
    //         (pTenancyContract."Contract Start Date" <= SelectedMonthEnd) and
    //         (pTenancyContract."Contract End Date" >= SelectedMonthStart)
    //     );
    // end;

    local procedure CalculateNoOfDays(
         pContractStartDate: Date;
         pContractEndDate: Date;
         pAllocationMonth: Integer;
         pAllocationYear: Integer
     ): Integer
    var
        SelectedMonthStart: Date;
        SelectedMonthEnd: Date;
        EffectiveStartDate: Date;
        EffectiveEndDate: Date;
        NoOfDays: Integer;
    begin
        // Start and end of the selected month
        SelectedMonthStart := DMY2Date(1, pAllocationMonth, pAllocationYear);
        SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart);

        // Return 0 if contract is outside of the selected month
        if (pContractStartDate > SelectedMonthEnd) or (pContractEndDate < SelectedMonthStart) then
            exit(0);

        // Determine the effective start date
        if pContractStartDate > SelectedMonthStart then
            EffectiveStartDate := pContractStartDate
        else
            EffectiveStartDate := SelectedMonthStart;

        // Determine the effective end date
        if pContractEndDate < SelectedMonthEnd then
            EffectiveEndDate := pContractEndDate
        else
            EffectiveEndDate := SelectedMonthEnd;

        // Calculate inclusive number of days
        NoOfDays := EffectiveEndDate - EffectiveStartDate + 1;

        exit(NoOfDays);
    end;


    // Create Revenue Recognition Detail directly from Revenue Structure
    local procedure CreateRevenueRecognitionDetailDirect(
        pTenancyContract: Record "Tenancy Contract";
        pRevenueStructure: Record "Revenue Structure";  // Changed from Revenue Item Breakdown Details
        pRevenueAllocation: Record "Revenue Allocation Details"
    )
    var
        RevenueRecognitionDetails: Record "Revenue Recognition Details";
        SuspendedReasonList: Record SuspendReasonTable;
        revenuestructuredetails: Record "Revenue Structure Subpage";
        PostingDate: Date;
        NextEntryNo: Integer;
        NoOfDays: Integer;
        PerDayAmount: Decimal;
    begin
        // Get next entry number
        RevenueRecognitionDetails.Reset();
        if RevenueRecognitionDetails.FindLast() then
            NextEntryNo := RevenueRecognitionDetails."Entry No." + 1
        else
            NextEntryNo := 1;

        // Convert Posting Month + Year to Date (assume 1st of that month)
        PostingDate := DMY2Date(1, pRevenueAllocation.Month, pRevenueAllocation."Financial Year");

        // Calculate number of days for the selected month/year
        NoOfDays := CalculateNoOfDays(
           pTenancyContract."Contract Start Date",
           pTenancyContract."Contract End Date",
           pRevenueAllocation.Month,
           pRevenueAllocation."Financial Year"
       );

        // Calculate per day amount from Revenue Structure
        // Assuming Revenue Structure has Amount field and Contract Tenure
        if pRevenueStructure.Amount > 0 then
            PerDayAmount := pRevenueStructure.Amount / pRevenueStructure.Amount
        else
            PerDayAmount := 0;

        // Create new Revenue Recognition Detail record
        RevenueRecognitionDetails.Init();
        RevenueRecognitionDetails."Entry No." := NextEntryNo;
        RevenueRecognitionDetails."RR_No." := Rec."RR_No.";

        // Copy contract details
        RevenueRecognitionDetails."Contract Id" := pTenancyContract."Contract ID";
        RevenueRecognitionDetails."Property Name" := pTenancyContract."Property Name";
        RevenueRecognitionDetails."Customer Name" := pTenancyContract."Customer Name";
        RevenueRecognitionDetails."Contract Start Date" := pTenancyContract."Contract Start Date";
        RevenueRecognitionDetails."Contract End Date" := pTenancyContract."Contract End Date";
        RevenueRecognitionDetails."Contract Amount" := pRevenueStructure."Amount Including VAT";  // From Revenue Structure
        RevenueRecognitionDetails."Owner Name" := pTenancyContract."Owner's Name";
        RevenueRecognitionDetails."Contract Tenure" := pTenancyContract."Contract Tenor";
        RevenueRecognitionDetails."Grace Days" := pTenancyContract."Grace Period";
        RevenueRecognitionDetails."Grace Start Date" := pTenancyContract."Grace Start Date";
        RevenueRecognitionDetails."Grace End Date" := pTenancyContract."Grace End Date";
        RevenueRecognitionDetails."Per Day Rent" := PerDayAmount;
        RevenueRecognitionDetails."No Of Days" := NoOfDays;
        RevenueRecognitionDetails."Total Value" := NoOfDays * PerDayAmount;
        RevenueRecognitionDetails."Owner Share" := RevenueRecognitionDetails."Total Value";

        // Add allocation period details
        RevenueRecognitionDetails."Posting Month" := pRevenueAllocation.Month;
        RevenueRecognitionDetails."Posting Year" := pRevenueAllocation."Financial Year";
        RevenueRecognitionDetails."Posting Period" :=
            FORMAT(pRevenueAllocation.Month) + ' ' +
            FORMAT(pRevenueAllocation."Financial Year");

        // Get termination date from Final Calculation by Contract ID match
        GetTerminationDate(pTenancyContract."Contract ID", RevenueRecognitionDetails);

        // Get suspension details from Suspended Reason List by Contract ID match
        GetSuspensionDetails(pTenancyContract."Contract ID", RevenueRecognitionDetails);

        revenuestructuredetails.Reset();
        revenuestructuredetails.SetRange("Contract ID", RevenueRecognitionDetails."Contract ID");
        if revenuestructuredetails.FindSet() then begin
            repeat
                if (revenuestructuredetails."Period Start Date" <= PostingDate) and
                   (revenuestructuredetails."Period End Date" >= PostingDate) then begin
                    RevenueRecognitionDetails."Multi Year Start Date" := revenuestructuredetails."Period Start Date";
                    RevenueRecognitionDetails."Multi Year End Date" := revenuestructuredetails."Period End Date";
                    RevenueRecognitionDetails."Annual Amount" := revenuestructuredetails."Amount Including VAT";
                    RevenueRecognitionDetails."Final Annual Amount" := revenuestructuredetails."Amount Including VAT";
                    RevenueRecognitionDetails."Item Type" := revenuestructuredetails."Secondary Item Type";
                end;
            until revenuestructuredetails.Next() = 0;
        end;

        // Insert the record
        RevenueRecognitionDetails.Insert(true);
    end;

    // Get termination date from Final Calculation table
    local procedure GetTerminationDate(ContractID: Integer; var RevenueRecognitionDetails: Record "Revenue Recognition Details")
    var
        FinalCalculation: Record "Final Calculation";  // Replace with actual table name
    begin
        FinalCalculation.Reset();
        FinalCalculation.SetRange("Contract ID", ContractID);
        if FinalCalculation.FindFirst() then
            RevenueRecognitionDetails."Termination Date" := FinalCalculation."Termination Date";
    end;

    // Get suspension details from Suspended Reason table
    local procedure GetSuspensionDetails(ContractID: Integer; var RevenueRecognitionDetails: Record "Revenue Recognition Details")
    var
        SuspendedReasonList: Record SuspendReasonTable;
    begin
        SuspendedReasonList.Reset();
        SuspendedReasonList.SetRange("Contract ID", ContractID);
        if SuspendedReasonList.FindFirst() then begin
            RevenueRecognitionDetails."Suspension Start Date" := SuspendedReasonList.DateEffective;
            RevenueRecognitionDetails."Suspension End Date" := SuspendedReasonList.SuspensionEndDate;
        end;
    end;

    var
        RRID: Integer;

    procedure SetRIID(pRRID: Integer)
    begin
        RRID := pRRID;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."RR_No." := RRID;
        exit(true);
    end;
}