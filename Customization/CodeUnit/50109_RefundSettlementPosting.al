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
            LineNo := GenJnlLine."Line No." + 1
        else
            LineNo := 1;

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

        // Clear journal lines after posting
        ClearJournalLines(GenJnlTemplate, GenJnlBatch);

        Message('Refund amount of %1 posted successfully.', Amount);
    end;

    procedure refundcashrecipt()
    var
        GenJnlLine: Record "Gen. Journal Line";
        SalesInvoice: Record "Sales Invoice Header";
        finalcalculation: Record "Final Calculation";
        GenJnlTemplate: Code[10];
        GenJnlBatch: Code[10];
        PostingDate: Date;
        DocumentNo: Code[20];
        AccountNo: Code[20];
        InvoiceNo: Code[20];
        GenJournalLine: Record "Gen. Journal Line";
        LastLineNo: Integer;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        TerminationCharges: Record "Termination Charges Sub";
        TotalRefundableDeposit: Decimal;
        TerminationChargesub: Record "Additional Charges Sub";
        Tenantid: Code[20];
        Tenantname: Text[100];
        billingcalculation: Record "Final Billing Calculation Grid";
        finalsettlement: Record "FinalSettlementRefund";
        balaccounttype: Option;

    begin
        GenJnlTemplate := 'CASH RECE';
        GenJnlBatch := 'DEFAULT';
        PostingDate := Today(); // You can replace with actual Posting Date
        DocumentNo := 'REFUND-' + Format(finalsettlement."Contract ID"); // Customize as needed
        AccountNo := '3001'; // Cash Account G/L
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

        // Fetch tenant details from Final Calculation
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", finalsettlement."Contract ID");
        if finalcalculation.FindFirst() then begin
            Tenantid := finalcalculation."Tenant ID";
            Tenantname := finalcalculation."Tenant Name";
        end else
            Error('Final Calculation not found for Contract ID %1', finalsettlement."Contract ID");


        // Sum Additional Charges and fetch Invoice No.
        TotalRefundableDeposit := 0;
        InvoiceNo := '';
        TerminationChargesub.Reset();
        TerminationChargesub.SetRange("Contract ID", finalsettlement."Contract ID");
        if TerminationChargesub.FindSet() then begin
            repeat
                TotalRefundableDeposit += TerminationChargesub."Amount Including VAT";
                if InvoiceNo = '' then
                    InvoiceNo := TerminationChargesub."Posted Invoice ID";
            until TerminationChargesub.Next() = 0;
        end else
            Error('Additional charges not found for Contract ID %1', finalsettlement."Contract ID");

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", GenJnlTemplate);
        GenJournalLine.SetRange("Journal Batch Name", GenJnlBatch);
        if GenJournalLine.FindLast() then
            LastLineNo := GenJournalLine."Line No." + 1// Always increment by a safe step (standard NAV step is 10000)
        else
            LastLineNo := 1;
        // 3. Insert Gen. Journal Line
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := GenJnlTemplate;
        GenJnlLine."Journal Batch Name" := GenJnlBatch;
        GenJnlLine."Line No." := LastLineNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine.Description := Tenantname;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Tenantid;
        GenJnlLine.Amount := Round(-TotalRefundableDeposit, 0.01);
        GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
        // Bal. Account Type already assigned above
        GenJnlLine."Bal. Account No." := AccountNo;
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := InvoiceNo;
        GenJnlLine.Insert(true);

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
        GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if GenJournalLine.FindSet() then
            GenJournalLine.DeleteAll();

        Message('Cash Receipt journal entries created successfully.');
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
}