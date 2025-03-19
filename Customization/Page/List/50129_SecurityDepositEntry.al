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
                    ChillarDepositAmount: Decimal;
                    OtherDepositAmount: Decimal;
                    NetBalanceAmount: Decimal;
                    TotalRefundableDeposit: Decimal;
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

                            // Update Fina Calculation
                            FinaCalculation.Reset();
                            FinaCalculation.SetRange("Contract ID", Rec."Contract ID");
                            if FinaCalculation.FindFirst() then begin
                                FinaCalculation."Security Deposit" := Rec."Main Security Deposit";
                                FinaCalculation."Adjustment Security Deposit" := Rec."Main Security Deposit" - Rec."Security Deposit";
                                FinaCalculation."Net Balance" := Rec."Security Deposit";
                                // Update Chillar Deposit field
                                FinaCalculation."Chiller Deposit" := ChillarDepositAmount;
                                FinaCalculation."Other Deposit" := OtherDepositAmount;
                                // Update Total Refundable Deposit
                                FinaCalculation."Total Refundable Deposit" := TotalRefundableDeposit;
                                FinaCalculation.Modify();
                                Message('Fina Calculation updated with Security Deposit: %1', Rec."Main Security Deposit");
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
                end;

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



}