codeunit 50109 "Refund Settlement Posting Mgt."
{
    procedure PostRefundJournalLines(FinalSettlementRefund: Record "FinalSettlementRefund")
    var
        GenJnlLine: Record "Gen. Journal Line";
        // GenJnlTemplate: Record "Gen. Journal Template";
        // GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlTemplate: Code[10];
        GenJnlBatch: Code[10];
        LineNo: Integer;
        DocNo: Code[20];
        PostingDate: Date;
        // DocNo;: Code[20];
        // LastLineNo: Integer;
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        TenantContract: Record "Final Calculation"; // Adjust to your actual Contract table name
        TenantReceivableAccount: Code[20];
        BankCashAccount: Code[20];
        BankGLAccount: Code[20];
        RefundOtherDepositGL: Code[20];
        RefundChillerDepositGL: Code[20];
        RefundSecurityDepositGL: Code[20];
        TenantReceivableGL: Code[20];
        NetRefundToTenant: Decimal;
        adjustsecurityDeposit: Decimal;
        adjustChillerDeposit: Decimal;
        adjustotherDeposit: Decimal;
        BankAccount: Record "Bank Account";
        appliedamount: Decimal;
        customer: Record Customer;
        customerpostinggroup: Record "Customer Posting Group";
    begin
        // Set your G/L Account numbers here
        // BankGLAccount := 'YOUR_BANK_GL'; // Replace with your Bank G/L Account No.
        RefundOtherDepositGL := '4508'; // Replace with Refund Other Deposit G/L Account No.
        RefundChillerDepositGL := '4508'; // Replace with Refund Chiller Deposit G/L Account No.
        RefundSecurityDepositGL := '4502'; // Replace with Refund Security Deposit G/L Account No.
                                           // TenantReceivableGL := 'YOUR_TENANT_REC_GL';// Replace with Tenant Receivable G/L Account No.
        NetRefundToTenant := Round(FinalSettlementRefund."Net Refund to the Tenant");
        adjustsecurityDeposit := FinalSettlementRefund."Adjust Security Deposit";
        adjustChillerDeposit := FinalSettlementRefund."Adjust Chiller Deposit";
        adjustotherDeposit := FinalSettlementRefund."Adjust other deposit";

        // Setup Journal Template and Batch
        // if not GenJnlTemplate.Get('CASH RECE') then
        //     Error('Journal Template not found.');
        // if not GenJnlBatch.Get('CASH RECE', 'DEFAULT') then
        //     Error('Journal Batch not found.');

        PostingDate := Today();
        // DocumentNo := 'REFUND-' + Format(Rec."Contract ID");

        // // Find last line number
        // GenJnlLine.Reset();
        // GenJnlLine.SetRange("Journal Template Name", 'CASH RECE');
        // GenJnlLine.SetRange("Journal Batch Name", 'DEFAULT');
        // if GenJnlLine.FindLast() then
        //     LastLineNo := GenJnlLine."Line No." + 10000
        // else
        //     LastLineNo := 10000;
        GenJnlTemplate := 'CASH RECE';
        GenJnlBatch := 'DEFAULT';

        // Clear any existing journal lines in this batch before creating new ones
        ClearJournalLines(GenJnlTemplate, GenJnlBatch);

        // Get property type from Contract table
        TenantContract.Reset();
        TenantContract.SetRange("FC ID", FinalSettlementRefund."FC ID");
        if not TenantContract.FindFirst() then
            Error('Final Calculation not found for FC ID %1', FinalSettlementRefund."FC ID");

        // Set G/L Accounts based on Property Type
        // case TenantContract."Unit Type" of
        //     'Residential':
        //         TenantReceivableAccount := '1501';  // Replace with your actual Residential Receivable G/L Account
        //     'Commercial':
        //         TenantReceivableAccount := '1506';  // Replace with your actual Commercial Receivable G/L Account
        //     else
        //         Error('Invalid Property Type. Must be Residential or Commercial.');
        // end;

        customer.SetRange("No.", FinalSettlementRefund."Tenant ID");
        if customer.FindSet() then begin
            // Set the Tenant Receivable Account based on the Customer
            // if customerpostinggroup.Get(customer."Customer Posting Group") then begin
            //     TenantReceivableAccount := customerpostinggroup."Receivables Account";
            // end;
            TenantReceivableAccount := customer."No.";
        end;


        // Generate Document No
        DocNo := 'RFND-' + Format(FinalSettlementRefund."Contract ID") + '-' + Format(FinalSettlementRefund."FC ID");

        // Find the next available Line No.
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate);
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch);
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 10000
        else
            LineNo := 10000;

        // 1. If Adjust Other Deposit > 0
        if FinalSettlementRefund."Adjust other deposit" > 0 then begin
            // Refund Other Deposit (Credit)
            AppliedAmount := Round(Min(adjustotherDeposit, NetRefundToTenant));
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := 'CASH RECE';
            GenJnlLine."Journal Batch Name" := 'DEFAULT';
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.Description := 'Refund Other Deposit';
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := RefundOtherDepositGL;
            GenJnlLine.Validate(Amount, Round(appliedamount));
            BankAccount.Reset();
            BankAccount.SetRange("Search Name", FinalSettlementRefund."Deposit Bank");
            if BankAccount.FindSet()
            then begin
                GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"Bank Account";
                GenJnlLine."Bal. Account No." := BankAccount."No.";
                // BankCashAccount := BankAccount."Bank Account No.";
            end else begin
                GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '3001'; // Default to Cash G/L Account if not found
            end;

            GenJnlLine.Insert(true);
            NetRefundToTenant -= AppliedAmount;
            adjustotherDeposit -= AppliedAmount;
            LineNo += 10000;
        end;

        // 2. If Adjust Chiller Deposit > 0
        if FinalSettlementRefund."Adjust Chiller Deposit" > 0 then begin
            // Refund Chiller Deposit (Credit)
            AppliedAmount := Round(Min(adjustChillerDeposit, NetRefundToTenant));
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := 'CASH RECE';
            GenJnlLine."Journal Batch Name" := 'DEFAULT';
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.Description := 'Refund Chiller Deposit';
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := RefundChillerDepositGL;
            GenJnlLine.Validate(Amount, Round(appliedamount));
            BankAccount.Reset();
            BankAccount.SetRange("Search Name", FinalSettlementRefund."Deposit Bank");
            if BankAccount.FindSet()
            then begin
                GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"Bank Account";
                GenJnlLine."Bal. Account No." := BankAccount."No.";
                // BankCashAccount := BankAccount."Bank Account No.";
            end else begin
                GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '3001'; // Default to Cash G/L Account if not found
            end;
            GenJnlLine.Insert(true);
            NetRefundToTenant -= AppliedAmount;
            adjustChillerDeposit -= AppliedAmount;

            LineNo += 10000;
        end;

        // 3. If Adjust Security Deposit > 0
        if FinalSettlementRefund."Adjust Security Deposit" > 0 then begin
            // Refund Security Deposit (Credit)
            AppliedAmount := Round(Min(adjustsecurityDeposit, NetRefundToTenant));
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := 'CASH RECE';
            GenJnlLine."Journal Batch Name" := 'DEFAULT';
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.Description := 'Refund Security Deposit';
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := RefundSecurityDepositGL;
            GenJnlLine.Validate(Amount, Round(appliedamount));
            BankAccount.Reset();
            BankAccount.SetRange("Search Name", FinalSettlementRefund."Deposit Bank");
            if BankAccount.FindSet()
            then begin
                GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"Bank Account";
                GenJnlLine."Bal. Account No." := BankAccount."No.";
                // BankCashAccount := BankAccount."Bank Account No.";
            end else begin
                GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '3001'; // Default to Cash G/L Account if not found
            end;
            GenJnlLine.Insert(true);
            NetRefundToTenant -= AppliedAmount;
            adjustsecurityDeposit -= AppliedAmount;
            LineNo += 10000;
        end;

        // 4. If all Adjust fields are zero, use Net Refund to the Tenant
        if (adjustsecurityDeposit = 0) and (adjustChillerDeposit = 0) and (adjustotherDeposit = 0) then begin
            if NetRefundToTenant > 0 then begin
                AppliedAmount := Round(NetRefundToTenant);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := 'CASH RECE';
                GenJnlLine."Journal Batch Name" := 'DEFAULT';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                GenJnlLine."Document No." := DocNo;
                GenJnlLine.Description := 'Refund to Tenant';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := TenantReceivableAccount;
                GenJnlLine.Validate(Amount, Round(appliedamount));
                BankAccount.Reset();
                BankAccount.SetRange("Search Name", FinalSettlementRefund."Deposit Bank");
                if BankAccount.FindSet()
                then begin
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    GenJnlLine."Bal. Account No." := BankAccount."No.";
                    // BankCashAccount := BankAccount."Bank Account No.";
                end else begin
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '3001'; // Default to Cash G/L Account if not found
                end;

                GenJnlLine.Insert(true);
                NetRefundToTenant -= AppliedAmount;
                LineNo += 10000;
            end;
        end;


        // Post the journal lines
        GenJnlPost.Run(GenJnlLine);


    end;


    local procedure ClearJournalLines(TemplateName: Code[10]; BatchName: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", TemplateName);
        GenJnlLine.SetRange("Journal Batch Name", BatchName);
        if not GenJnlLine.IsEmpty() then
            GenJnlLine.DeleteAll(true);
    end;

    local procedure Min(a: Decimal; b: Decimal): Decimal
    begin
        if a < b then
            exit(a)
        else
            exit(b);
    end;

}