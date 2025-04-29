// page 50129 "Security Deposit Entries"
// {
//     PageType = List;
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     SourceTable = "Security Deposit Entry";
//     Caption = 'Security Deposit Entries';

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("Entry No."; Rec."Entry No.")
//                 {
//                     ApplicationArea = All;
//                     Editable = IsFinanceManager;
//                 }
//                 field("Security Deposit ID"; Rec."Security Deposit ID")
//                 {
//                     ApplicationArea = All;
//                     Editable = IsFinanceManager;
//                 }
//                 field("Contract ID"; Rec."Contract ID")
//                 {
//                     ApplicationArea = All;
//                     Editable = IsFinanceManager;
//                 }
//                 field("Main Security Deposit"; Rec."Main Security Deposit")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                     Editable = IsFinanceManager;
//                 }
//                 field("Security Deposit"; Rec."Security Deposit")
//                 {
//                     ApplicationArea = All;
//                     Editable = IsFinanceManager;
//                 }
//                 field("Start Date"; Rec."Start Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = IsFinanceManager;
//                 }
//                 field("End Date"; Rec."End Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = IsFinanceManager;
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     ApplicationArea = All;
//                     Editable = IsFinanceManager;
//                 }
//                 field("Total Amount"; Rec."Total Amount")
//                 {
//                     ApplicationArea = All;
//                     Editable = IsFinanceManager;
//                 }
//             }
//         }
//     }
//     actions
//     {
//         area(Processing)
//         {

//             action(Approve)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Approve Entry';
//                 Image = Approve;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Visible = IsFinanceManager; // Only show this action to Finance Managers

//                 trigger OnAction()
//                 var
//                     AdjustSecurityDeposit: Record "Adjustment Security Deposit";
//                     FinaCalculation: Record "Final Calculation";
//                     CarryForwardGrid: Record "Carry Forward Grid";
//                     SecurityDeposit: Record "Security Deposit";
//                     TenancyContract: Record "Tenancy Contract";
//                     TenancyContractSubpage: Record "Tenancy Contract Subpage";
//                     TerminationAddCharges: Record "Additional Charges Sub";
//                     PendingReceivableGrid: Record "Pending Receviable Grid";
//                     GenJournalLine: Record "Gen. Journal Line";
//                     GenJournalBatch: Record "Gen. Journal Batch";
//                     NoSeriesMgt: Codeunit NoSeriesManagement;
//                     GLSetup: Record "General Ledger Setup";
//                     ChillarDepositAmount: Decimal;
//                     OtherDepositAmount: Decimal;
//                     NetBalanceAmount: Decimal;
//                     TotalRefundableDeposit: Decimal;
//                     TotalClaimAmount: Decimal;
//                     AmountIncludingVAT: Decimal;
//                     TotalRefundableAmount: Decimal;
//                     TotalReceivableAmount: Decimal;
//                     AdjustedTotalClaimAmount: Decimal;
//                     LastLineNo: Integer;
//                     PostingDate: Date;
//                     DocumentNo: Code[20];
//                     TenantNo: Code[20];
//                     TenantReceivableResAcc: Code[20];
//                     TenantReceivableComAcc: Code[20];
//                     SecurityDepositRefundAcc: Code[20];
//                     ChillerDepositRefundAcc: Code[20];
//                 begin
//                     if Rec.Status = Rec.Status::Approved then
//                         Error('This entry is already approved');

//                     if Confirm('Do you want to approve this entry?') then begin
//                         // Update entry status
//                         Rec.Status := Rec.Status::Approved;
//                         Rec.Modify();

//                         // Get accounts from G/L Setup
//                         GLSetup.Get();
//                         // Default account numbers (can be replaced with actual G/L Setup fields)
//                         TenantReceivableResAcc := '1501'; // Default Tenant Receivable Residential Account
//                         TenantReceivableComAcc := '1506'; // Default Tenant Receivable Commercial Account
//                         SecurityDepositRefundAcc := '4502'; // Default Security Deposit Refund Account
//                         ChillerDepositRefundAcc := '4508'; // Default Chiller Deposit Refund Account

//                         // If you have these accounts in G/L Setup, you can use them instead:
//                         // TenantReceivableResAcc := GLSetup."Tenant Receivable Res. Acc.";
//                         // TenantReceivableComAcc := GLSetup."Tenant Receivable Com. Acc.";
//                         // SecurityDepositRefundAcc := GLSetup."Security Deposit Refund Acc.";
//                         // ChillerDepositRefundAcc := GLSetup."Chiller Deposit Refund Acc.";

//                         // Update main record status
//                         if AdjustSecurityDeposit.Get(Rec."Security Deposit ID") then begin
//                             AdjustSecurityDeposit.Status := AdjustSecurityDeposit.Status::Approved;

//                             // Get the Amount Including VAT from the Adjustment Security Deposit table
//                             AmountIncludingVAT := AdjustSecurityDeposit."Amount Including VAT";

//                             AdjustSecurityDeposit.Modify();

//                             // Get Chillar Deposit amount from Tenancy Contract Subpage
//                             ChillarDepositAmount := 0;
//                             OtherDepositAmount := 0;
//                             TenancyContract.Reset();
//                             TenancyContract.SetRange("Contract ID", Rec."Contract ID");
//                             if TenancyContract.FindFirst() then begin
//                                 // Store tenant number for journal entries
//                                 TenantNo := TenancyContract."Tenant ID";

//                                 TenancyContractSubpage.Reset();
//                                 TenancyContractSubpage.SetRange(ContractID, TenancyContract."Contract ID");
//                                 TenancyContractSubpage.SetRange("Secondary Item Type", 'Chiller Deposit Amount');
//                                 if TenancyContractSubpage.FindFirst() then begin
//                                     ChillarDepositAmount := TenancyContractSubpage.Amount;
//                                 end;
//                                 // Get Other Deposit amount
//                                 TenancyContractSubpage.Reset();
//                                 TenancyContractSubpage.SetRange(ContractID, TenancyContract."Contract ID");
//                                 TenancyContractSubpage.SetRange("Secondary Item Type", 'Other Deposit');
//                                 if TenancyContractSubpage.FindFirst() then begin
//                                     OtherDepositAmount := TenancyContractSubpage.Amount;
//                                 end;
//                             end;

//                             // Calculate Net Balance for Security Deposit
//                             NetBalanceAmount := Rec."Security Deposit";

//                             // Calculate Total Refundable Deposit
//                             TotalRefundableDeposit := 0;  // Initialize to zero
//                             TotalRefundableDeposit := NetBalanceAmount + ChillarDepositAmount + OtherDepositAmount;

//                             // Get the Total Amount from Additional Charges Sub directly from Final Calculation
//                             TotalClaimAmount := 0;

//                             // Get Total Refundable from Pending Receivable Grid
//                             TotalRefundableAmount := 0;
//                             PendingReceivableGrid.Reset();
//                             PendingReceivableGrid.SetRange("Contract ID", Rec."Contract ID");
//                             if PendingReceivableGrid.FindFirst() then begin
//                                 TotalRefundableAmount := PendingReceivableGrid."Total Refundable";
//                             end;

//                             FinaCalculation.Reset();
//                             FinaCalculation.SetRange("Contract ID", Rec."Contract ID");
//                             if FinaCalculation.FindFirst() then begin
//                                 // Try to find the related Termination Additional Charges records
//                                 TerminationAddCharges.Reset();
//                                 TerminationAddCharges.SetRange("Contract ID", Rec."Contract ID");
//                                 if TerminationAddCharges.FindSet() then begin
//                                     repeat
//                                         // Add up the "Amount Including VAT" values
//                                         TotalClaimAmount += TerminationAddCharges."Amount Including VAT";
//                                     until TerminationAddCharges.Next() = 0;
//                                 end;

//                                 // If we couldn't find records or the total is still 0, try getting the TotalAmount field
//                                 if TotalClaimAmount = 0 then begin
//                                     // Check if there's a field called TotalAmount in the Termination Additional Charges table
//                                     // or try to access it from another source
//                                     TerminationAddCharges.Reset();
//                                     TerminationAddCharges.SetRange("Contract ID", Rec."Contract ID");
//                                     TerminationAddCharges.CalcSums(Amount); // Try to use Amount if TotalAmount doesn't exist
//                                     TotalClaimAmount := TerminationAddCharges.Amount;

//                                     if TotalClaimAmount = 0 then begin
//                                         // Final attempt - try to get it from a parent record if needed
//                                         TotalClaimAmount := GetTotalAmountFromTermination(Rec."Contract ID");
//                                     end;
//                                 end;

//                                 // Debug message to see what we found
//                                 Message('Total Claim Amount calculated: %1', TotalClaimAmount + PendingReceivableGrid."Total Receivable");

//                                 // Debug message to see what we found
//                                 Message('Amount Including VAT from Adjustment Security Deposit: %1', AmountIncludingVAT);

//                                 // Update Fina Calculation
//                                 FinaCalculation."Security Deposit" := Rec."Main Security Deposit";
//                                 FinaCalculation."Adjustment Security Deposit" := Rec."Main Security Deposit" - Rec."Security Deposit";
//                                 FinaCalculation."Net Balance" := Rec."Security Deposit";
//                                 // Update Chillar Deposit field
//                                 FinaCalculation."Chiller Deposit" := ChillarDepositAmount;
//                                 FinaCalculation."Other Deposit" := OtherDepositAmount;
//                                 // Update Total Refundable Deposit
//                                 FinaCalculation."Total Refundable Deposit" := TotalRefundableDeposit;
//                                 // Update Total Claim with the sum of Total Amount from Additional Charges Sub
//                                 FinaCalculation."Total Claim" := TotalClaimAmount;
//                                 FinaCalculation."Total Refund" := FinaCalculation."Total Claim" - FinaCalculation."Total Refundable Deposit";
//                                 // Add this new line to calculate Net Balance as requested
//                                 FinaCalculation."Summery Net Balance" := FinaCalculation."Total Refund" - PendingReceivableGrid."Total Refundable" + PendingReceivableGrid."Total Receivable";
//                                 // NEW CODE: Check if Summary Net Balance is positive or negative and update respective fields
//                                 if FinaCalculation."Summery Net Balance" > 0 then begin
//                                     // Positive value goes to Net Receivable From The Tenant
//                                     FinaCalculation."Net Receivable From The Tenant" := FinaCalculation."Summery Net Balance";
//                                     FinaCalculation."Amount Refundable" := 0; // Clear the other field
//                                 end else begin
//                                     // Negative value goes to Amount Refundable (as positive amount)
//                                     FinaCalculation."Amount Refundable" := Abs(FinaCalculation."Summery Net Balance");
//                                     FinaCalculation."Net Receivable From The Tenant" := 0; // Clear the other field
//                                 end;
//                                 FinaCalculation.Modify();

//                                 // NEW CODE: Create and post journal entries
//                                 // Set posting date to today
//                                 PostingDate := Today;

//                                 // Get next document number
//                                 DocumentNo := 'RFND-' + Format(TenancyContract."Contract ID") + '-' + Format(FinaCalculation."FC ID");

//                                 // Initialize General Journal Batch
//                                 GenJournalBatch.Reset();
//                                 GenJournalBatch.SetRange("Journal Template Name", 'GENERAL');
//                                 GenJournalBatch.SetRange(Name, 'DEFAULT');
//                                 if not GenJournalBatch.FindFirst() then
//                                     Error('Journal batch DEFAULT in template GENERAL not found');

//                                 // Find last line number in the journal
//                                 GenJournalLine.Reset();
//                                 GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
//                                 GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
//                                 if GenJournalLine.FindLast() then
//                                     LastLineNo := GenJournalLine."Line No." + 10000
//                                 else
//                                     LastLineNo := 10000;

//                                 // 1. Post TotalRefundableDeposit entry to appropriate Tenant Receivable account based on Property Classification (negative)
//                                 if TotalRefundableDeposit <> 0 then begin
//                                     // Check Property Classification in Tenancy Contract
//                                     TenancyContract.Reset();
//                                     TenancyContract.SetRange("Contract ID", Rec."Contract ID");
//                                     if TenancyContract.FindFirst() then begin
//                                         // Choose appropriate G/L Account based on Property Classification
//                                         if TenancyContract."Property Classification" = 'Residential' then
//                                             CreateJournalLine(
//                                                 'GENERAL', 'DEFAULT', LastLineNo,
//                                                 PostingDate, DocumentNo,
//                                                 'G/L Account', TenantReceivableResAcc, // Tenant Receivable Residential Account
//                                                 Format(Rec."Contract ID") + ' - Tenant Receivable Residential',
//                                                 -TotalRefundableDeposit, TenantNo
//                                             )
//                                         else if TenancyContract."Property Classification" = 'Commercial' then
//                                             CreateJournalLine(
//                                                 'GENERAL', 'DEFAULT', LastLineNo,
//                                                 PostingDate, DocumentNo,
//                                                 'G/L Account', TenantReceivableComAcc, // Tenant Receivable Commercial Account
//                                                 Format(Rec."Contract ID") + ' - Tenant Receivable Commercial',
//                                                 -TotalRefundableDeposit, TenantNo
//                                             )
//                                         else
//                                             // Default account if classification doesn't match expected values
//                                             CreateJournalLine(
//                                                 'GENERAL', 'DEFAULT', LastLineNo,
//                                                 PostingDate, DocumentNo,
//                                                 'G/L Account', TenantReceivableResAcc, // Default to Residential account
//                                                 Format(Rec."Contract ID") + ' - Tenant Receivable',
//                                                 -TotalRefundableDeposit, TenantNo
//                                             );
//                                     end else
//                                         // If tenancy contract not found, use default account
//                                         CreateJournalLine(
//                                             'GENERAL', 'DEFAULT', LastLineNo,
//                                             PostingDate, DocumentNo,
//                                             'G/L Account', TenantReceivableResAcc, // Default Tenant Receivable Account
//                                             Format(Rec."Contract ID") + ' - Tenant Receivable',
//                                             -TotalRefundableDeposit, TenantNo
//                                         );

//                                     LastLineNo += 10000;
//                                 end;

//                                 // 2. Post NetBalanceAmount to Security Refund Deposit account (positive)
//                                 if NetBalanceAmount <> 0 then begin
//                                     CreateJournalLine(
//                                         'GENERAL', 'DEFAULT', LastLineNo,
//                                         PostingDate, DocumentNo,
//                                         'G/L Account', SecurityDepositRefundAcc, // Security Refund Deposit Account
//                                         Format(Rec."Contract ID") + ' - Security Deposit Refund',
//                                         NetBalanceAmount, TenantNo
//                                     );
//                                     LastLineNo += 10000;
//                                 end;

//                                 // 3. Post Chiller Deposit to Chiller Deposit Refund account (positive)
//                                 if ChillarDepositAmount <> 0 then begin
//                                     CreateJournalLine(
//                                         'GENERAL', 'DEFAULT', LastLineNo,
//                                         PostingDate, DocumentNo,
//                                         'G/L Account', ChillerDepositRefundAcc, // Chiller Deposit Refund Account
//                                         Format(Rec."Contract ID") + ' - Chiller Deposit Refund',
//                                         ChillarDepositAmount, TenantNo
//                                     );
//                                     LastLineNo += 10000;
//                                 end;

//                                 // 4. Post Other Deposit to Chiller Deposit Refund account (positive) - using same account
//                                 if OtherDepositAmount <> 0 then begin
//                                     CreateJournalLine(
//                                         'GENERAL', 'DEFAULT', LastLineNo,
//                                         PostingDate, DocumentNo,
//                                         'G/L Account', ChillerDepositRefundAcc, // Using Chiller Deposit account for Other Deposit too
//                                         Format(Rec."Contract ID") + ' - Other Deposit Refund',
//                                         OtherDepositAmount, TenantNo
//                                     );
//                                 end;

//                                 // Post the journal
//                                 Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
//                                 Message('Journal entries have been created and posted successfully');
//                             end else begin
//                                 Message('No Pending Receivable Grid record found for Contract ID: %1', Rec."Contract ID");
//                             end;

//                             Message('Final Calculation updated with Security Deposit: %1', Rec."Main Security Deposit");
//                         end else
//                             Message('No Fina Calculation record found for Contract ID: %1', Rec."Contract ID");

//                         // Handle carry forward grid for security deposits
//                         SecurityDeposit.Reset();
//                         SecurityDeposit.SetRange("Contract ID", Rec."Contract ID");

//                         if SecurityDeposit.FindSet() then begin
//                             repeat
//                                 // Check if a Carry Forward Grid record already exists
//                                 CarryForwardGrid.Reset();
//                                 CarryForwardGrid.SetRange("Contract ID", SecurityDeposit."Contract ID");
//                                 CarryForwardGrid.SetRange("New Contract ID", SecurityDeposit."New_Contract ID");
//                                 CarryForwardGrid.SetRange("Total Amount", SecurityDeposit."New_Security Deposit Amount"); // Additional Check

//                                 if not CarryForwardGrid.FindFirst() then begin
//                                     // Create new record only if it doesn't exist
//                                     CarryForwardGrid.Init();
//                                     // Get the next available Entry No.
//                                     CarryForwardGrid."Entry No." := GetNextEntryNo();
//                                     CarryForwardGrid."Contract ID" := SecurityDeposit."Contract ID";
//                                     CarryForwardGrid."New Contract ID" := SecurityDeposit."New_Contract ID";
//                                     CarryForwardGrid."Total Amount" := SecurityDeposit."New_Security Deposit Amount";
//                                     CarryForwardGrid."Security Deposit" := 'Security Deposit';
//                                     CarryForwardGrid.Insert();
//                                 end else begin
//                                     // Update existing record
//                                     CarryForwardGrid."Total Amount" := SecurityDeposit."New_Security Deposit Amount";
//                                     CarryForwardGrid."Security Deposit" := 'Security Deposit';
//                                     CarryForwardGrid.Modify();
//                                 end;
//                             until SecurityDeposit.Next() = 0;
//                         end else begin
//                             // If no Security Deposit records exist, create a basic Carry Forward Grid record
//                             CarryForwardGrid.Reset();
//                             CarryForwardGrid.SetRange("Contract ID", Rec."Contract ID");

//                             if not CarryForwardGrid.FindFirst() then begin
//                                 CarryForwardGrid.Init();
//                                 // Get the next available Entry No.
//                                 CarryForwardGrid."Entry No." := GetNextEntryNo();
//                                 CarryForwardGrid."Contract ID" := Rec."Contract ID";
//                                 // You'll need to determine the New Contract ID from elsewhere
//                                 CarryForwardGrid."Total Amount" := Rec."Security Deposit";
//                                 CarryForwardGrid."Security Deposit" := 'Security Deposit';
//                                 CarryForwardGrid.Insert();
//                             end;
//                         end;
//                     end;

//                     Message('Entry has been approved successfully!');
//                 end;
//             }
//         }
//     }

//     local procedure GetNextEntryNo(): Integer
//     var
//         CarryForwardGrid: Record "Carry Forward Grid";
//     begin
//         CarryForwardGrid.Reset();
//         if CarryForwardGrid.FindLast() then
//             exit(CarryForwardGrid."Entry No." + 1)
//         else
//             exit(1);
//     end;

//     // New procedure to create journal lines
//     local procedure CreateJournalLine(JournalTemplate: Code[20]; JournalBatch: Code[20]; LineNo: Integer; PostingDate: Date; DocumentNo: Code[20]; AccountType: Text[30]; AccountNo: Code[20]; Description: Text[100]; Amount: Decimal; TenantNo: Code[20])
//     var
//         GenJournalLine: Record "Gen. Journal Line";
//     begin
//         // Ensure Document No. is not empty
//         if DocumentNo = '' then
//             Error('Document No. must have a value.');

//         GenJournalLine.Init();
//         GenJournalLine."Journal Template Name" := JournalTemplate;
//         GenJournalLine."Journal Batch Name" := JournalBatch;
//         GenJournalLine."Line No." := LineNo;
//         GenJournalLine."Posting Date" := PostingDate;
//         GenJournalLine."Document No." := DocumentNo; // Assign Document No.

//         // Set account type
//         case AccountType of
//             'G/L Account':
//                 GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
//             'Customer':
//                 GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
//             'Vendor':
//                 GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
//             else
//                 Error('Invalid Account Type: %1', AccountType);
//         end;

//         GenJournalLine."Account No." := AccountNo;
//         GenJournalLine.Description := Description;
//         GenJournalLine.Amount := Amount;
//         GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";

//         // If tenant number is provided, set it in Source Code field
//         if TenantNo <> '' then
//             GenJournalLine."Source Code" := TenantNo;

//         GenJournalLine.Insert(true);
//     end;

//     var
//         IsFinanceManager: Boolean;
//         IsFieldEditable: Boolean;

//     // Add this trigger to check user permissions when the page loads
//     trigger OnOpenPage()
//     var
//         PermissionSet: Record "User Personalization";
//     begin
//         // Check if the current user has the 'FINANCE MANAGER' profile
//         IsFinanceManager := false;
//         PermissionSet.SetRange("User ID", UserId());

//         if PermissionSet.FindSet() then begin
//             repeat
//                 if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
//                     IsFinanceManager := true;
//             until (PermissionSet.Next() = 0) or IsFinanceManager;
//         end;

//         // If user is not a Finance Manager, show error and exit
//         if not IsFinanceManager then
//             Error('You do not have permission to access this page. Only Finance Managers can access this page.');
//     end;

//     // Helper function to get the total amount from a parent termination record if needed
//     local procedure GetTotalAmountFromTermination(ContractID: Integer): Decimal
//     var
//         TerminationHeader: Record "Additional Charges Sub"; // Use the actual table name
//         TotalAmount: Decimal;
//     begin
//         TotalAmount := 0;
//         TerminationHeader.Reset();
//         TerminationHeader.SetRange("Contract ID", ContractID);
//         if TerminationHeader.FindFirst() then begin
//             // Try to get TotalAmount field or equivalent
//             if TerminationHeader.Get(ContractID) then
//                 TotalAmount := TerminationHeader."Total Amount"; // Use the correct field name
//         end;
//         exit(TotalAmount);
//     end;
// }









page 50129 "Security Deposit Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Security Deposit Entry";
    Caption = 'Security Deposit Entries';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Security Deposit ID"; Rec."Security Deposit ID")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Main Security Deposit"; Rec."Main Security Deposit")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = IsFinanceManager;
                }
                field("Security Deposit"; Rec."Security Deposit")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve Entry';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsFinanceManager; // Only show this action to Finance Managers

                trigger OnAction()
                var
                    AdjustSecurityDeposit: Record "Adjustment Security Deposit";
                    FinaCalculation: Record "Final Calculation";
                    CarryForwardGrid: Record "Carry Forward Grid";
                    SecurityDeposit: Record "Security Deposit";
                    TenancyContract: Record "Tenancy Contract";
                    TenancyContractSubpage: Record "Tenancy Contract Subpage";
                    TerminationAddCharges: Record "Additional Charges Sub";
                    PendingReceivableGrid: Record "Pending Receviable Grid";
                    ChillarDepositAmount: Decimal;
                    OtherDepositAmount: Decimal;
                    NetBalanceAmount: Decimal;
                    TotalRefundableDeposit: Decimal;
                    TotalClaimAmount: Decimal;
                    AmountIncludingVAT: Decimal;
                    TotalRefundableAmount: Decimal;
                    TotalReceivableAmount: Decimal;
                    AdjustedTotalClaimAmount: Decimal; // New variable for adjusted total claim
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error('This entry is already approved');

                    if Confirm('Do you want to approve this entry?') then begin
                        // Update entry status
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify();

                        // Update main record status
                        if AdjustSecurityDeposit.Get(Rec."Security Deposit ID") then begin
                            AdjustSecurityDeposit.Status := AdjustSecurityDeposit.Status::Approved;

                            // Get the Amount Including VAT from the Adjustment Security Deposit table
                            AmountIncludingVAT := AdjustSecurityDeposit."Amount Including VAT";

                            AdjustSecurityDeposit.Modify();

                            // Get Chillar Deposit amount from Tenancy Contract Subpage
                            ChillarDepositAmount := 0;
                            OtherDepositAmount := 0;
                            TenancyContract.Reset();
                            TenancyContract.SetRange("Contract ID", Rec."Contract ID");
                            if TenancyContract.FindFirst() then begin
                                TenancyContractSubpage.Reset();
                                TenancyContractSubpage.SetRange(ContractID, TenancyContract."Contract ID");
                                TenancyContractSubpage.SetRange("Secondary Item Type", 'Chiller Deposit Amount');
                                if TenancyContractSubpage.FindFirst() then begin
                                    ChillarDepositAmount := TenancyContractSubpage.Amount;
                                end;
                                // Get Other Deposit amount
                                TenancyContractSubpage.Reset();
                                TenancyContractSubpage.SetRange(ContractID, TenancyContract."Contract ID");
                                TenancyContractSubpage.SetRange("Secondary Item Type", 'Other Deposit');
                                if TenancyContractSubpage.FindFirst() then begin
                                    OtherDepositAmount := TenancyContractSubpage.Amount;
                                end;
                            end;

                            // Calculate Net Balance for Security Deposit
                            NetBalanceAmount := Rec."Security Deposit";

                            // Calculate Total Refundable Deposit
                            TotalRefundableDeposit := 0;  // Initialize to zero
                            TotalRefundableDeposit := NetBalanceAmount + ChillarDepositAmount + OtherDepositAmount;

                            // Get the Total Amount from Additional Charges Sub directly from Final Calculation
                            TotalClaimAmount := 0;

                            // Get Total Refundable from Pending Receivable Grid
                            TotalRefundableAmount := 0;
                            PendingReceivableGrid.Reset();
                            PendingReceivableGrid.SetRange("Contract ID", Rec."Contract ID");
                            if PendingReceivableGrid.FindFirst() then begin
                                TotalRefundableAmount := PendingReceivableGrid."Total Refundable";
                            end;

                            FinaCalculation.Reset();
                            FinaCalculation.SetRange("Contract ID", Rec."Contract ID");
                            if FinaCalculation.FindFirst() then begin
                                // Try to find the related Termination Additional Charges records
                                TerminationAddCharges.Reset();
                                TerminationAddCharges.SetRange("Contract ID", Rec."Contract ID");
                                if TerminationAddCharges.FindSet() then begin
                                    repeat
                                        // Add up the "Amount Including VAT" values
                                        TotalClaimAmount += TerminationAddCharges."Amount Including VAT";
                                    until TerminationAddCharges.Next() = 0;
                                end;

                                // If we couldn't find records or the total is still 0, try getting the TotalAmount field
                                if TotalClaimAmount = 0 then begin
                                    // Check if there's a field called TotalAmount in the Termination Additional Charges table
                                    // or try to access it from another source
                                    TerminationAddCharges.Reset();
                                    TerminationAddCharges.SetRange("Contract ID", Rec."Contract ID");
                                    TerminationAddCharges.CalcSums(Amount); // Try to use Amount if TotalAmount doesn't exist
                                    TotalClaimAmount := TerminationAddCharges.Amount;

                                    if TotalClaimAmount = 0 then begin
                                        // Final attempt - try to get it from a parent record if needed
                                        TotalClaimAmount := GetTotalAmountFromTermination(Rec."Contract ID");
                                    end;
                                end;

                                // NEW CODE: Calculate adjusted Total Claim by adding Total Receivable and subtracting Total Refundable
                                // AdjustedTotalClaimAmount := FinaCalculation."Total Refund" + PendingReceivableGrid."Total Receivable" - PendingReceivableGrid."Total Refundable";

                                // Debug message to see what we found
                                Message('Total Claim Amount calculated: %1', TotalClaimAmount + PendingReceivableGrid."Total Receivable");

                                // Debug message to see what we found
                                Message('Amount Including VAT from Adjustment Security Deposit: %1', AmountIncludingVAT);

                                // Update Fina Calculation
                                // FinaCalculation.Reset();
                                // FinaCalculation.SetRange("Contract ID", Rec."Contract ID");
                                // if FinaCalculation.FindFirst() then begin
                                FinaCalculation."Security Deposit" := Rec."Main Security Deposit";
                                FinaCalculation."Adjustment Security Deposit" := Rec."Main Security Deposit" - Rec."Security Deposit";
                                FinaCalculation."Net Balance" := Rec."Security Deposit";
                                // Update Chillar Deposit field
                                FinaCalculation."Chiller Deposit" := ChillarDepositAmount;
                                FinaCalculation."Other Deposit" := OtherDepositAmount;
                                // Update Total Refundable Deposit
                                FinaCalculation."Total Refundable Deposit" := TotalRefundableDeposit;
                                // Update Total Claim with the sum of Total Amount from Additional Charges Sub
                                FinaCalculation."Total Claim" := TotalClaimAmount;
                                // Store the Amount Including VAT in the Total Adjustment field
                                // FinaCalculation."Final Calculation Result" := TotalClaimAmount - TotalRefundableDeposit;
                                // FinaCalculation."Total Adjustment" := AmountIncludingVAT;
                                FinaCalculation."Total Refund" := FinaCalculation."Total Claim" - FinaCalculation."Total Refundable Deposit";
                                // Add this new line to calculate Net Balance as requested
                                // FinaCalculation."Summery Net Balance" := FinaCalculation."Total Claim" + FinaCalculation."Total Adjustment" - FinaCalculation."Total Refund";
                                FinaCalculation."Summery Net Balance" := FinaCalculation."Total Refund" - PendingReceivableGrid."Total Refundable" + PendingReceivableGrid."Total Receivable";
                                // NEW CODE: Check if Summary Net Balance is positive or negative and update respective fields
                                if FinaCalculation."Summery Net Balance" > 0 then begin
                                    // Positive value goes to Net Receivable From The Tenant
                                    FinaCalculation."Net Receivable From The Tenant" := FinaCalculation."Summery Net Balance";
                                    FinaCalculation."Amount Refundable" := 0; // Clear the other field
                                end else begin
                                    // Negative value goes to Amount Refundable (as positive amount)
                                    FinaCalculation."Amount Refundable" := Abs(FinaCalculation."Summery Net Balance");
                                    FinaCalculation."Net Receivable From The Tenant" := 0; // Clear the other field
                                end;
                                FinaCalculation.Modify();


                            end else begin
                                Message('No Pending Receivable Grid record found for Contract ID: %1', Rec."Contract ID");
                            end;

                            Message('Final Calculation updated with Security Deposit: %1', Rec."Main Security Deposit");
                        end else
                            Message('No Fina Calculation record found for Contract ID: %1', Rec."Contract ID");

                        // // Handle carry forward grid for security deposits
                        SecurityDeposit.Reset();
                        SecurityDeposit.SetRange("Contract ID", Rec."Contract ID");

                        if SecurityDeposit.FindSet() then begin
                            repeat
                                // Check if a Carry Forward Grid record already exists
                                CarryForwardGrid.Reset();
                                CarryForwardGrid.SetRange("Contract ID", SecurityDeposit."Contract ID");
                                CarryForwardGrid.SetRange("New Contract ID", SecurityDeposit."New_Contract ID");
                                CarryForwardGrid.SetRange("Total Amount", SecurityDeposit."New_Security Deposit Amount"); // Additional Check

                                if not CarryForwardGrid.FindFirst() then begin
                                    // Create new record only if it doesn't exist
                                    CarryForwardGrid.Init();
                                    // Get the next available Entry No.
                                    CarryForwardGrid."Entry No." := GetNextEntryNo();
                                    CarryForwardGrid."Contract ID" := SecurityDeposit."Contract ID";
                                    CarryForwardGrid."New Contract ID" := SecurityDeposit."New_Contract ID";
                                    CarryForwardGrid."Total Amount" := SecurityDeposit."New_Security Deposit Amount";
                                    CarryForwardGrid."Security Deposit" := 'Security Deposit';
                                    CarryForwardGrid.Insert();
                                end else begin
                                    // Update existing record
                                    CarryForwardGrid."Total Amount" := SecurityDeposit."New_Security Deposit Amount";
                                    CarryForwardGrid."Security Deposit" := 'Security Deposit';
                                    CarryForwardGrid.Modify();
                                end;
                            until SecurityDeposit.Next() = 0;
                        end else begin
                            // If no Security Deposit records exist, create a basic Carry Forward Grid record
                            CarryForwardGrid.Reset();
                            CarryForwardGrid.SetRange("Contract ID", Rec."Contract ID");

                            if not CarryForwardGrid.FindFirst() then begin
                                CarryForwardGrid.Init();
                                // Get the next available Entry No.
                                CarryForwardGrid."Entry No." := GetNextEntryNo();
                                CarryForwardGrid."Contract ID" := Rec."Contract ID";
                                // You'll need to determine the New Contract ID from elsewhere
                                CarryForwardGrid."Total Amount" := Rec."Security Deposit";
                                CarryForwardGrid."Security Deposit" := 'Security Deposit';
                                CarryForwardGrid.Insert();
                            end;
                        end;
                    end;

                    Message('Entry has been approved successfully!');
                end;
                // end;

                // trigger OnAction()
                // var
                //     AdjustSecurityDeposit: Record "Adjustment Security Deposit";
                //     FinaCalculation: Record "Final Calculation";
                // begin
                //     if Rec.Status = Rec.Status::Approved then
                //         Error('This entry is already approved');

                //     if Confirm('Do you want to approve this entry?') then begin
                //         // Update entry status
                //         Rec.Status := Rec.Status::Approved;
                //         Rec.Modify();

                //         // Update main record status
                //         if AdjustSecurityDeposit.Get(Rec."Security Deposit ID") then begin
                //             AdjustSecurityDeposit.Status := AdjustSecurityDeposit.Status::Approved;
                //             AdjustSecurityDeposit.Modify();

                //             // Get the security deposit value directly from the current record
                //             // Message('Using Security Deposit value: %1', Rec."Main Security Deposit");

                //             // Update Fina Calculation
                //             FinaCalculation.Reset();
                //             FinaCalculation.SetRange("Contract ID", Rec."Contract ID");
                //             if FinaCalculation.FindFirst() then begin
                //                 FinaCalculation."Security Deposit" := Rec."Main Security Deposit";
                //                 FinaCalculation."Adjustment Security Deposit" := Rec."Security Deposit";
                //                 FinaCalculation."Net Balance" := Rec."Main Security Deposit" - Rec."Security Deposit";
                //                 FinaCalculation.Modify();
                //                 Message('Fina Calculation updated with Security Deposit: %1', Rec."Main Security Deposit");
                //             end else
                //                 Message('No Fina Calculation record found for Contract ID: %1', Rec."Contract ID");
                //         end;

                //         Message('Entry has been approved successfully!');
                //     end;
                // end;
            }
        }
    }

    local procedure GetNextEntryNo(): Integer
    var
        CarryForwardGrid: Record "Carry Forward Grid";
    begin
        CarryForwardGrid.Reset();
        if CarryForwardGrid.FindLast() then
            exit(CarryForwardGrid."Entry No." + 1)
        else
            exit(1);
    end;

    var
        IsFinanceManager: Boolean;
        IsFieldEditable: Boolean;

    // Add this trigger to check user permissions when the page loads
    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'FINANCE MANAGER' profile
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());

        if PermissionSet.FindSet() then begin
            repeat
                if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                    IsFinanceManager := true;
            until (PermissionSet.Next() = 0) or IsFinanceManager;
        end;

        // If user is not a Finance Manager, show error and exit
        if not IsFinanceManager then
            Error('You do not have permission to access this page. Only Finance Managers can access this page.');
    end;

    // Helper function to get the total amount from a parent termination record if needed
    local procedure GetTotalAmountFromTermination(ContractID: Integer): Decimal
    var
        TerminationHeader: Record "Additional Charges Sub"; // Use the actual table name
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        TerminationHeader.Reset();
        TerminationHeader.SetRange("Contract ID", ContractID);
        if TerminationHeader.FindFirst() then begin
            // Try to get TotalAmount field or equivalent
            if TerminationHeader.Get(ContractID) then
                TotalAmount := TerminationHeader."Total Amount"; // Use the correct field name
        end;
        exit(TotalAmount); // Fixed: Changed "return" to "exit"
    end;



}