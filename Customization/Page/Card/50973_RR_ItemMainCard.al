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

                    trigger OnValidate()
                    begin
                        // Optional: Add any validation logic for Item Type selection
                    end;
                }
                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        RevenueItemBreakdown: Record "Revenue Item Breakdown";
                    begin
                        // Filter and open Revenue Item Breakdown Card
                        RevenueItemBreakdown.SetRange("RI_No.", Rec.Link);
                        if RevenueItemBreakdown.FindSet() then
                            PAGE.Run(PAGE::"Revenue Item Breakdown Card", RevenueItemBreakdown)
                        else
                            Message('No Revenue Item Breakdown found.');
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
            action(FetchRevenueDetails)
            {
                Caption = 'Revenue Allocation-Other Charges';
                ApplicationArea = All;
                Image = List;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;

                trigger OnAction()
                var
                    ConfirmFetch: Boolean;
                begin
                    // Confirm before fetching details
                    ConfirmFetch := Confirm('Do you want to fetch revenue details for the selected Item Type(s)?', false);

                    if ConfirmFetch then begin
                        // Call the fetch procedure
                        FetchContractDetails();

                        // Show message about fetched details
                        Message('Revenue details have been fetched successfully.');
                    end;
                end;
            }

            // action(ViewRevenueDetails)
            // {
            //     Caption = 'View Revenue Details';
            //     ApplicationArea = All;
            //     Image = View;
            //     Promoted = true;
            //     PromotedCategory = Process;

            //     trigger OnAction()
            //     var
            //         RevenueRecognitionDetails: Record "Revenue Recognition Details";
            //     begin
            //         // Filter and show Revenue Recognition Details for this RR_No.
            //         RevenueRecognitionDetails.SetRange("RR_No.", Rec."RR_No.");
            //         // if RevenueRecognitionDetails.FindSet() then
            //         // PAGE.Run(PAGE::"Revenue Recognition Detail Sub", RevenueRecognitionDetails)
            //         // else
            //         // Message('No Revenue Recognition Details found.');
            //     end;
            // }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearSubgridData();
    end;

    procedure ClearSubgridData()
    var
        RevenueItemDetail: Record "Revenue Recognition Details";
    begin
        // Clear existing details for this Revenue Recognition record
        RevenueItemDetail.SetRange("RR_No.", Rec."RR_No.");
        RevenueItemDetail.DeleteAll(true);
    end;

    procedure FetchContractDetails()
    var
        TenancyContract: Record "Tenancy Contract";
        RevenueAllocation: Record "Revenue Allocation Details";
        RevenueRecognitionDetails: Record "Revenue Recognition Details";
        RevenueItemBreakdown: Record "Revenue Item Breakdown Details";
        SuspendedReasonList: Record SuspendReasonTable;  // Added suspended reason list record
        SelectedItemTypes: List of [Text];
        ProcessedContractCount: Integer;
        ContractProcessed: Boolean;
    begin
        // Clear existing data
        ClearSubgridData();

        // Get current month and financial year from Revenue Allocation
        if not RevenueAllocation.FindFirst() then begin
            Message('No Revenue Allocation found. Please set up Revenue Allocation first.');
            exit;
        end;

        // Get selected Item Types for this Revenue Recognition Item
        GetSelectedItemTypes(SelectedItemTypes);

        // If no item types are selected, exit
        if SelectedItemTypes.Count = 0 then begin
            Message('Please select at least one Item Type.');
            exit;
        end;

        // Reset processed contract counter
        ProcessedContractCount := 0;

        // Process active contracts
        if TenancyContract.FindSet() then begin
            repeat
                // Check if contract is active during the selected period
                if IsContractActiveForPeriod(TenancyContract, RevenueAllocation) then begin
                    // Reset flag for each contract
                    ContractProcessed := false;

                    // Retrieve associated revenue item breakdown for all selected item types
                    RevenueItemBreakdown.Reset();
                    RevenueItemBreakdown.SetRange("Contract ID", TenancyContract."Contract ID");

                    // Filter by selected Item Types
                    RevenueItemBreakdown.SetFilter("Item Type", GetItemTypeFilter(SelectedItemTypes));

                    if RevenueItemBreakdown.FindSet() then begin
                        repeat
                            // Create Revenue Recognition Detail
                            CreateRevenueRecognitionDetail(TenancyContract, RevenueItemBreakdown, RevenueAllocation);

                            // Mark contract as processed
                            ContractProcessed := true;
                        until RevenueItemBreakdown.Next() = 0;
                    end;

                    // Increment processed contract counter if at least one breakdown was found
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
        // Clear the list first
        // pItemTypes.Clear();

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

    local procedure IsContractActiveForPeriod(
        pTenancyContract: Record "Tenancy Contract";
        pRevenueAllocation: Record "Revenue Allocation Details"
    ): Boolean
    var
        SelectedMonthStart: Date;
        SelectedMonthEnd: Date;
    begin
        // Calculate the start and end of the selected month
        SelectedMonthStart := DMY2Date(1, pRevenueAllocation.Month + 1, pRevenueAllocation."Financial Year");
        SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart);

        // Check if contract overlaps with the selected period
        exit(
            (pTenancyContract."Contract Start Date" <= SelectedMonthEnd) and
            (pTenancyContract."Contract End Date" >= SelectedMonthStart)
        );
    end;

    local procedure CreateRevenueRecognitionDetail(
        pTenancyContract: Record "Tenancy Contract";
        pRevenueItemBreakdown: Record "Revenue Item Breakdown Details";
        pRevenueAllocation: Record "Revenue Allocation Details"
    )
    var
        RevenueRecognitionDetails: Record "Revenue Recognition Details";
        SuspendedReasonList: Record SuspendReasonTable;  // Added suspended reason list record
        NextEntryNo: Integer;
    begin
        // Get next entry number
        RevenueRecognitionDetails.Reset();
        if RevenueRecognitionDetails.FindLast() then
            NextEntryNo := RevenueRecognitionDetails."Entry No." + 1
        else
            NextEntryNo := 1;

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
        RevenueRecognitionDetails."Contract Amount" := pRevenueItemBreakdown."Contract Amount";
        // RevenueRecognitionDetails."Annual Amount" := pRevenueItemBreakdown."Annual Amount";
        RevenueRecognitionDetails."Owner Name" := pTenancyContract."Owner's Name";
        RevenueRecognitionDetails."Termination Date" := pTenancyContract."Termination Date";
        // RevenueRecognitionDetails."Final Annual Amount" := RevenueRecognitionDetails."Annual Amount";

        // Copy revenue item breakdown details
        RevenueRecognitionDetails."Item Type" := pRevenueItemBreakdown."Item Type";
        RevenueRecognitionDetails."Contract Tenure" := pRevenueItemBreakdown."Contract Tenure";
        RevenueRecognitionDetails."Grace Days" := pRevenueItemBreakdown."Grace Days";
        // RevenueRecognitionDetails."Termination Date" := pRevenueItemBreakdown.;
        RevenueRecognitionDetails."No Of Days" := pRevenueItemBreakdown."No Of Days";
        RevenueRecognitionDetails."Per Day Amount" := pRevenueItemBreakdown."Per Day Amount";
        RevenueRecognitionDetails."Total Value" := pRevenueItemBreakdown."Total Value";
        RevenueRecognitionDetails."Owner Share" := pRevenueItemBreakdown."Total Value";

        // Add allocation period details
        RevenueRecognitionDetails."Posting Month" := pRevenueAllocation.Month;
        RevenueRecognitionDetails."Posting Year" := pRevenueAllocation."Financial Year";
        RevenueRecognitionDetails."Posting Period" :=
            FORMAT(pRevenueAllocation.Month) + ' ' +
            FORMAT(pRevenueAllocation."Financial Year");

        // Get suspension details from Suspended Reason List
        SuspendedReasonList.Reset();
        SuspendedReasonList.SetRange("Contract ID", pTenancyContract."Contract ID");
        if SuspendedReasonList.FindSet() then begin
            // Add suspension information to RevenueRecognitionDetails
            RevenueRecognitionDetails."Suspension Start Date" := SuspendedReasonList.SuspensionEffectiveDate;
            RevenueRecognitionDetails."Suspension End Date" := SuspendedReasonList.SuspensionEndDate;
            // You can add more fields from SuspendedReasonList if needed
        end;
        // Insert the record
        RevenueRecognitionDetails.Insert(true);
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