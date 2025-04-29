codeunit 50109 "Refund Settlement Posting Mgt."
{
    procedure PostRefundSettlementAmount(FinalSettlementRefund: Record "FinalSettlementRefund")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Code[10];
        GenJnlBatch: Code[10];
        LineNo: Integer;
        DocNo: Code[20];
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        TenantContract: Record "Final Calculation"; // Adjust to your actual Contract table name
        TenantReceivableAccount: Code[20];
        BankCashAccount: Code[20];
        Amount: Decimal;
        GLSetup: Record "General Ledger Setup";
    begin
        // Load G/L Setup for rounding
        GLSetup.Get();

        // Check if there's any amount to post
        Amount := FinalSettlementRefund."Refund Total Amount";
        if Amount = 0 then
            Error('Refund Amount is zero. Cannot post.');

        // Round the amount according to G/L setup
        Amount := Round(Amount, GLSetup."Amount Rounding Precision");

        // Set Journal Template and Batch
        GenJnlTemplate := 'GENERAL';
        GenJnlBatch := 'DEFAULT';

        // Get property type from Contract table
        TenantContract.Reset();
        TenantContract.SetRange("FC ID", FinalSettlementRefund."FC ID");
        if not TenantContract.FindFirst() then
            Error('Final Calculation not found for FC ID %1', FinalSettlementRefund."FC ID");

        // Set G/L Accounts based on Property Type
        case TenantContract."Unit Type" of
            'Residential':
                TenantReceivableAccount := '1501';  // Replace with your actual Residential Receivable G/L Account
            'Commercial':
                TenantReceivableAccount := '1506';  // Replace with your actual Commercial Receivable G/L Account
            else
                Error('Invalid Property Type. Must be Residential or Commercial.');
        end;

        // Set Bank/Cash Account based on Payment Mode
        if FinalSettlementRefund."Refund Payment mode" = 'Cash' then
            BankCashAccount := '3001'  // Replace with your actual Cash G/L Account
        else
            BankCashAccount := '3002'; // Replace with your actual Bank G/L Account

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

        // 1st Line - Tenant Receivable (+Amount)
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := GenJnlTemplate;
        GenJnlLine."Journal Batch Name" := GenJnlBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Posting Date" := Today;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := TenantReceivableAccount;
        GenJnlLine.Validate(Amount, Amount); // Positive amount to INCREASE tenant receivable
        GenJnlLine."Source Code" := 'REFUND';
        GenJnlLine.Description := StrSubstNo('Refund for Contract %1', FinalSettlementRefund."Contract ID");
        GenJnlLine.Insert();

        // 2nd Line - Bank/Cash Account (-Amount)
        LineNo += 10000;
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := GenJnlTemplate;
        GenJnlLine."Journal Batch Name" := GenJnlBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Posting Date" := Today;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := BankCashAccount;
        GenJnlLine.Validate(Amount, -Amount); // Negative amount to DECREASE bank account
        GenJnlLine."Source Code" := 'REFUND';
        GenJnlLine.Description := StrSubstNo('Refund for Contract %1', FinalSettlementRefund."Contract ID");
        GenJnlLine.Insert();

        // Post the Journal
        GenJnlPost.Run(GenJnlLine);

        Message('Refund amount of %1 posted successfully.', Amount);
    end;
}