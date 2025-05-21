
codeunit 50108 "Final Settlement Posting Mgt."
{
    procedure PostFinalSettlementAmount(FinalSettlement: Record "FinalSettlement")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        DocNo: Code[20];
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        TenantContract: Record "Final Calculation";
        PendingReceivableRID: Record "Pending Receviable Grid";
        AdditionalCharges: Record "Additional Charges Sub";
        BillingSetup: Record "Final Billing Calculation Grid";
        Amount: Decimal;
        PendingAmount: Decimal;
        GLSetup: Record "General Ledger Setup";
        TenantName: Text[100];
        BankAccount: Record "Bank Account";
        BankAccountNo: Code[20];
        CustomerCard: Record Customer;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        // Load G/L Setup for rounding
        GLSetup.Get();

        // Check if there's any amount to post
        Amount := FinalSettlement."Receivable Total Amount";
        if Amount = 0 then
            Error('Final Settlement Amount is zero. Cannot post.');

        // Round the amount according to G/L setup
        Amount := Round(Amount, GLSetup."Amount Rounding Precision");

        // Set Journal Template and Batch
        JournalTemplateName := 'CASH RECE';
        JournalBatchName := 'DEFAULT';

        // // Verify that the template and batch exist
        // if not GenJnlTemplate.Get(JournalTemplateName) then
        //     Error('The Journal Template %1 does not exist.', JournalTemplateName);

        // GenJnlBatch.Reset();
        // GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        // GenJnlBatch.SetRange(Name, JournalBatchName);
        // if not GenJnlBatch.FindFirst() then
        //     Error('The Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);

        // Get tenant contract information
        TenantContract.Reset();
        TenantContract.SetRange("Contract ID", FinalSettlement."Contract ID");
        if not TenantContract.FindFirst() then
            Error('Contract not found for Contract ID %1', FinalSettlement."Contract ID");

        TenantName := TenantContract."Tenant Name";

        // Get pending receivable information
        PendingReceivableRID.Reset();
        PendingReceivableRID.SetRange("Contract ID", FinalSettlement."Contract ID");
        if not PendingReceivableRID.FindFirst() then
            Error('Pending receivable not found for Contract ID %1', FinalSettlement."Contract ID");

        PendingAmount := PendingReceivableRID."Total Receivable";

        // Verify pending amount
        if PendingAmount <= 0 then
            Error('Pending amount is zero or negative (%1) for Contract ID %2',
                  PendingAmount, FinalSettlement."Contract ID");

        // Get additional charges information for invoice ID
        AdditionalCharges.Reset();
        AdditionalCharges.SetRange("Contract ID", FinalSettlement."Contract ID");
        if not AdditionalCharges.FindFirst() then
            Error('Additional charges not found for Contract ID %1', FinalSettlement."Contract ID");

        // Find the bank account
        // BankAccountNo := '';
        // BankAccount.Reset();
        // BankAccount.SetRange(Name, FinalSettlement."Deposit Bank");
        // if BankAccount.FindFirst() then
        //     BankAccountNo := BankAccount."No."
        // else begin
        //     // Try to find by No. directly
        //     BankAccount.Reset();
        //     BankAccount.SetRange("No.", FinalSettlement."Deposit Bank");
        //     if BankAccount.FindFirst() then
        //         BankAccountNo := BankAccount."No."
        //     else
        //         Error('Bank account "%1" not found. Please check the bank account code.', FinalSettlement."Deposit Bank");
        // end;

        // Generate Document No
        DocNo := 'FS-' + Format(FinalSettlement."Contract ID") + '-' + Format(FinalSettlement."FC ID");


        // Start with first line number
        LineNo := 10000;

        // Validate total to receive amount
        if TenantContract."Total Receive" <= 0 then
            Error('Total receive amount is zero or negative (%1) for Contract ID %2',
                  TenantContract."Total Receive", FinalSettlement."Contract ID");

        // 1st Line - Bank Account entry
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Posting Date" := Today;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine.Description := BillingSetup."Invoice ID";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := FinalSettlement."Tenant ID";
        GenJnlLine.Description := TenantName;

        // Use Validate to ensure all dependent fields are calculated
        GenJnlLine.Validate(Amount, -TenantContract."Total Receive");

        // Double-check that amount is not zero after validation
        if GenJnlLine.Amount = 0 then
            Error('Amount became zero after validation for first journal line. Check Customer %1 and amount %2',
                  FinalSettlement."Tenant ID", TenantContract."Total Receive");
        BankAccount.Reset();
        BankAccount.SetRange("Search Name", FinalSettlement."Deposit Bank");
        if BankAccount.FindSet() then begin
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
            GenJnlLine."Bal. Account No." := BankAccount."No.";
            // GenJournalLineRec."Currency Code" := BankAccountRec."Currency Code";
        end
        else begin
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := '3001';
        end;
        // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        // GenJnlLine."Bal. Account No." := BankAccountNo;
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := AdditionalCharges."Invoiced ID";
        GenJnlLine.Insert();

        // 2nd Line - Pending Receivable entry
        LineNo += 10000;
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Posting Date" := Today;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine.Description := AdditionalCharges."Invoiced ID";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := FinalSettlement."Tenant ID";
        GenJnlLine.Description := TenantName;

        // Use Validate to ensure all dependent fields are calculated
        GenJnlLine.Validate(Amount, -PendingAmount);

        // Double-check that amount is not zero after validation
        if GenJnlLine.Amount = 0 then
            Error('Amount became zero after validation for second journal line. Check Customer %1 and amount %2',
                  FinalSettlement."Tenant ID", PendingAmount);

        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := BankAccountNo;
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;

        // Make sure BillingSetup has a value
        BillingSetup.Reset();
        BillingSetup.SetRange("Contract ID", FinalSettlement."Contract ID");
        if BillingSetup.FindFirst() then
            GenJnlLine."Applies-to Doc. No." := BillingSetup."Invoice ID"
        else
            Error('No billing setup found for Contract ID %1', FinalSettlement."Contract ID");

        GenJnlLine.Insert();

        // Added new functionality: Update customer posting groups if Property Classification exists
        if TenantContract."Unit Type" <> '' then begin
            CustomerCard.Reset();
            CustomerCard.SetRange("No.", FinalSettlement."Tenant ID");
            if CustomerCard.FindFirst() then begin
                CustomerCard.Validate("Gen. Bus. Posting Group", TenantContract."Unit Type");
                CustomerCard.Validate("Customer Posting Group", TenantContract."Unit Type");
                CustomerCard.Modify();
            end;
        end;

        // Post the Journal
        GenJnlPost.Run(GenJnlLine);

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindSet() then
            GenJnlLine.DeleteAll(true);

        Message('Final Settlement amount posted successfully. Total: %1, Pending: %2', Amount, PendingAmount);
    end;


    procedure receivecashrecipt(FinalSettlement: Record "FinalSettlement")
    var
        GenJnlLine: Record "Gen. Journal Line";
        SalesInvoice: Record "Sales Invoice Header";
        finalcalculation: Record "Final Calculation";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
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
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        // Initialize journal template and batch names
        JournalTemplateName := 'CASH RECE';
        JournalBatchName := 'DEFAULT';

        // Verify that the template and batch exist
        if not GenJnlTemplate.Get(JournalTemplateName) then
            Error('The Journal Template %1 does not exist.', JournalTemplateName);

        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlBatch.SetRange(Name, JournalBatchName);
        if not GenJnlBatch.FindFirst() then
            Error('The Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);

        PostingDate := Today();

        // Add validation for finalsettlement record
        if FinalSettlement."Contract ID" = 0 then
            Error('Contract ID is missing in the Final Settlement record');

        DocumentNo := 'RECEIVE-' + Format(FinalSettlement."Contract ID");

        // Fetch tenant details from Final Calculation
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", FinalSettlement."Contract ID");
        if finalcalculation.FindFirst() then begin
            Tenantid := finalcalculation."Tenant ID";
            Tenantname := finalcalculation."Tenant Name";
        end else begin
            Error('Final Calculation not found for Contract ID %1', FinalSettlement."Contract ID");
        end;

        // Determine Bal. Account based on Refund Payment Mode
        if UpperCase(FinalSettlement."Receivable Payment mode") = 'CASH' then begin
            AccountNo := '3001'; // Cash G/L Account
        end else begin
            AccountNo := '3002';
            if AccountNo = '' then
                Error('Bank Account No. not found for Contract ID %1', FinalSettlement."Contract ID");
        end;

        // Sum Additional Charges and fetch Invoice No.
        TotalRefundableDeposit := 0;
        InvoiceNo := '';

        TerminationChargesub.Reset();
        TerminationChargesub.SetRange("Contract ID", FinalSettlement."Contract ID");
        if TerminationChargesub.FindSet() then begin
            repeat
                TotalRefundableDeposit += TerminationChargesub."Amount Including VAT";
                if InvoiceNo = '' then
                    InvoiceNo := TerminationChargesub."Posted Invoice ID";
            until TerminationChargesub.Next() = 0;
        end else begin
            Error('Additional charges not found for Contract ID %1', FinalSettlement."Contract ID");
        end;

        // Critical validation - ensure amount is not zero
        if TotalRefundableDeposit <= 0 then
            Error('Total refundable deposit amount is zero or negative (%1) for Contract ID %2. Cannot create journal entry.',
                  TotalRefundableDeposit, FinalSettlement."Contract ID");

        // Clear any existing journal lines in this batch
        // GenJournalLine.Reset();
        // GenJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        // GenJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        // if not GenJournalLine.IsEmpty() then
        //     GenJournalLine.DeleteAll(true);

        // Start with standard line number
        LastLineNo := 10000;

        // Create journal line
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        GenJnlLine."Line No." := LastLineNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine.Description := Tenantname;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Tenantid;

        // Use Validate to ensure all dependent fields are calculated
        GenJnlLine.Validate(Amount, -TotalRefundableDeposit);

        // Double-check that amount is not zero after validation
        if GenJnlLine.Amount = 0 then
            Error('Amount became zero after validation. Check Customer %1 and amount %2',
                  Tenantid, TotalRefundableDeposit);

        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := AccountNo;
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := InvoiceNo;

        // Insert the journal line
        GenJnlLine.Insert(true);

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindSet() then
            GenJnlLine.DeleteAll(true);

        // Post the journal line
        if GenJnlLine.Amount <> 0 then begin
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            Message('Cash Receipt journal entries created and posted successfully.');
        end else begin
            Error('Journal posting skipped because amount is zero.');
        end;
    end;

    procedure receivablecashrecipt(FinalSettlement: Record "FinalSettlement")
    var
        GenJnlLine: Record "Gen. Journal Line";
        SalesInvoice: Record "Sales Invoice Header";
        finalcalculation: Record "Final Calculation";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
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
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        // Initialize journal template and batch names
        JournalTemplateName := 'CASH RECE';
        JournalBatchName := 'DEFAULT';

        // Verify that the template and batch exist
        if not GenJnlTemplate.Get(JournalTemplateName) then
            Error('The Journal Template %1 does not exist.', JournalTemplateName);

        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlBatch.SetRange(Name, JournalBatchName);
        if not GenJnlBatch.FindFirst() then
            Error('The Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);

        PostingDate := Today();

        // Add validation for finalsettlement record
        if FinalSettlement."Contract ID" = 0 then
            Error('Contract ID is missing in the Final Settlement record');

        DocumentNo := 'RECEIVE-' + Format(FinalSettlement."Contract ID");

        // Fetch tenant details from Final Calculation
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", FinalSettlement."Contract ID");
        if finalcalculation.FindFirst() then begin
            Tenantid := finalcalculation."Tenant ID";
            Tenantname := finalcalculation."Tenant Name";
        end else begin
            Error('Final Calculation not found for Contract ID %1', FinalSettlement."Contract ID");
        end;

        // Determine Bal. Account based on Refund Payment Mode
        if UpperCase(FinalSettlement."Receivable Payment mode") = 'CASH' then begin
            AccountNo := '3001'; // Cash G/L Account
        end else begin
            AccountNo := '3002';
            if AccountNo = '' then
                Error('Bank Account No. not found for Contract ID %1', FinalSettlement."Contract ID");
        end;

        // Find Invoice No. and Amount based on Contract ID
        billingcalculation.Reset();
        billingcalculation.SetRange("Contract ID", FinalSettlement."Contract ID");
        if billingcalculation.FindSet() then begin
            InvoiceNo := billingcalculation."Posted Invoice ID";
            TotalRefundableDeposit := billingcalculation."Invoice Amount";

            // Critical check: Ensure amount is not zero or negative
            if TotalRefundableDeposit <= 0 then
                Error('Invoice amount is zero or negative (%1) for Contract ID %2. Cannot create journal entry.',
                      TotalRefundableDeposit, FinalSettlement."Contract ID");
        end else begin
            Error('Invoice not found for Contract ID %1', FinalSettlement."Contract ID");
        end;

        // Clear any existing journal lines in this batch
        // GenJournalLine.Reset();
        // GenJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        // GenJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        // if not GenJournalLine.IsEmpty() then
        //     GenJournalLine.DeleteAll(true);

        // Start with standard line number
        LastLineNo := 10000;

        // Create journal line
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        GenJnlLine."Line No." := LastLineNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine.Description := Tenantname;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Tenantid;

        // Use Validate for Amount to trigger proper calculations
        GenJnlLine.Validate(Amount, -TotalRefundableDeposit);

        // Double check amount not zero after validation
        if GenJnlLine.Amount = 0 then
            Error('Amount became zero after validation. Check Customer %1 and amount %2',
                  Tenantid, TotalRefundableDeposit);

        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := AccountNo;
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := InvoiceNo;

        // Insert the journal line
        GenJnlLine.Insert(true);

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindSet() then
            GenJnlLine.DeleteAll(true);

        // Post the journal line using RunWithCheck to catch any posting errors
        if GenJnlLine.Amount <> 0 then begin
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            Message('Cash Receipt journal entries created and posted successfully.');
        end else begin
            Error('Journal posting skipped because amount is zero.');
        end;
    end;
}