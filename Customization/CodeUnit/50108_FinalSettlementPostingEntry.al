
// codeunit 50108 "Final Settlement Posting Mgt."
// {
//     procedure PostFinalSettlementAmount(FinalSettlement: Record "FinalSettlement")
//     var
//         GenJnlLine: Record "Gen. Journal Line";
//         GenJnlTemplate: Code[10];
//         GenJnlBatch: Code[10];
//         LineNo: Integer;
//         DocNo: Code[20];
//         GenJnlPost: Codeunit "Gen. Jnl.-Post";
//         TenantContract: Record "Final Calculation";
//         PendingReceivableRID: Record "Pending Receviable Grid";
//         AdditionalCharges: Record "Additional Charges Sub";
//         BillingSetup: Record "Final Billing Calculation Grid";
//         TotalReceiveAmount: Decimal;
//         PendingAmount: Decimal;
//         GLSetup: Record "General Ledger Setup";
//         TenantName: Text[100];
//         BankAccount: Record "Bank Account";
//         BankAccountNo: Code[20];
//         CustomerCard: Record Customer;
//     begin
//         // Load G/L Setup for rounding
//         GLSetup.Get();

//         // Set Journal Template and Batch
//         GenJnlTemplate := 'CASH RECE';
//         GenJnlBatch := 'DEFAULT';

//         // Get tenant contract information
//         TenantContract.Reset();
//         TenantContract.SetRange("Contract ID", FinalSettlement."Contract ID");
//         if not TenantContract.FindFirst() then
//             Error('Contract not found for Contract ID %1', FinalSettlement."Contract ID");

//         TenantName := TenantContract."Tenant Name";

//         // Make sure Total Receive amount exists and is not zero
//         TotalReceiveAmount := TenantContract."Total Receive";
//         if TotalReceiveAmount = 0 then
//             Error('Total Receive amount in Final Calculation is zero. Cannot post.');

//         // Get pending receivable information
//         PendingReceivableRID.Reset();
//         PendingReceivableRID.SetRange("Contract ID", FinalSettlement."Contract ID");
//         if not PendingReceivableRID.FindFirst() then
//             Error('Pending receivable not found for Contract ID %1', FinalSettlement."Contract ID");

//         PendingAmount := PendingReceivableRID."Total Receivable";

//         // Make sure Pending Amount exists and is not zero
//         if PendingAmount = 0 then
//             Error('Pending Amount in Pending Receivable Grid is zero. Cannot post.');

//         // Round the amounts according to G/L setup
//         PendingAmount := Round(PendingAmount, GLSetup."Amount Rounding Precision");
//         TotalReceiveAmount := Round(TotalReceiveAmount, GLSetup."Amount Rounding Precision");

//         // Get additional charges information for invoice ID
//         AdditionalCharges.Reset();
//         AdditionalCharges.SetRange("Contract ID", FinalSettlement."Contract ID");
//         if not AdditionalCharges.FindFirst() then
//             Error('Additional charges not found for Contract ID %1', FinalSettlement."Contract ID");

//         // Get billing setup for invoice ID
//         BillingSetup.Reset();
//         BillingSetup.SetRange("Contract ID", FinalSettlement."Contract ID");
//         if not BillingSetup.FindFirst() then
//             Error('Billing setup not found for Contract ID %1', FinalSettlement."Contract ID");

//         // Find the bank account
//         BankAccountNo := '';
//         BankAccount.Reset();
//         BankAccount.SetRange(Name, FinalSettlement."Deposit Bank");
//         if BankAccount.FindFirst() then
//             BankAccountNo := BankAccount."No."
//         else begin
//             // Try to find by No. directly
//             BankAccount.Reset();
//             BankAccount.SetRange("No.", FinalSettlement."Deposit Bank");
//             if BankAccount.FindFirst() then
//                 BankAccountNo := BankAccount."No."
//             else
//                 Error('Bank account "%1" not found. Please check the bank account code.', FinalSettlement."Deposit Bank");
//         end;

//         // Generate Document No
//         DocNo := 'FS-' + Format(FinalSettlement."Contract ID") + '-' + Format(FinalSettlement."FC ID");

//         // Find the next available Line No.
//         GenJnlLine.Reset();
//         GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate);
//         GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch);
//         if GenJnlLine.FindLast() then
//             LineNo := GenJnlLine."Line No." + 1
//         else
//             LineNo := 1;

//         // 1st Line - Total Receive entry
//         Clear(GenJnlLine);
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := GenJnlTemplate;
//         GenJnlLine."Journal Batch Name" := GenJnlBatch;
//         GenJnlLine."Line No." := LineNo;
//         GenJnlLine."Posting Date" := Today;
//         GenJnlLine."Document No." := DocNo;
//         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//         GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
//         GenJnlLine."Account No." := FinalSettlement."Tenant ID";
//         GenJnlLine.Description := TenantName + ' - Total Receive';

//         // Ensure amount is not zero before validation
//         if TotalReceiveAmount <> 0 then
//             GenJnlLine.Validate(Amount, -TotalReceiveAmount)
//         else
//             Error('Total Receive amount cannot be zero');

//         GenJnlLine."Amount (LCY)" := -TotalReceiveAmount;
//         GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
//         GenJnlLine."Bal. Account No." := BankAccountNo;

//         // Make sure Invoice ID exists
//         if AdditionalCharges."Invoiced ID" <> '' then
//             GenJnlLine."Applies-to Doc. No." := AdditionalCharges."Invoiced ID"
//         else
//             Error('Invoice ID is missing in Additional Charges');

//         GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
//         GenJnlLine.Insert();

//         // 2nd Line - Pending Receivable entry
//         LineNo += 10000;
//         Clear(GenJnlLine);
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := GenJnlTemplate;
//         GenJnlLine."Journal Batch Name" := GenJnlBatch;
//         GenJnlLine."Line No." := LineNo;
//         GenJnlLine."Posting Date" := Today;
//         GenJnlLine."Document No." := DocNo;
//         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//         GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
//         GenJnlLine."Account No." := FinalSettlement."Tenant ID";
//         GenJnlLine.Description := TenantName + ' - Pending Amount';

//         // Ensure amount is not zero before validation
//         if PendingAmount <> 0 then
//             GenJnlLine.Validate(Amount, -PendingAmount)
//         else
//             Error('Pending Amount cannot be zero');

//         GenJnlLine."Amount (LCY)" := -PendingAmount;
//         GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
//         GenJnlLine."Bal. Account No." := BankAccountNo;

//         // Make sure Invoice ID exists
//         if BillingSetup."Invoice ID" <> '' then
//             GenJnlLine."Applies-to Doc. No." := BillingSetup."Invoice ID"
//         else
//             Error('Invoice ID is missing in Billing Setup');

//         GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
//         GenJnlLine.Insert();

//         // Added new functionality: Update customer posting groups if Property Classification exists
//         if TenantContract."Unit Type" <> '' then begin
//             CustomerCard.SetRange("No.", FinalSettlement."Tenant ID");
//             if CustomerCard.FindSet() then begin
//                 CustomerCard.Validate("Gen. Bus. Posting Group", TenantContract."Unit Type");
//                 CustomerCard.Validate("Customer Posting Group", TenantContract."Unit Type");
//                 CustomerCard.Modify();
//             end;
//         end;

//         // Post the Journal
//         GenJnlPost.Run(GenJnlLine);

//         Message('Final Settlement amount posted successfully. Total Receive: %1, Pending: %2', TotalReceiveAmount, PendingAmount);
//     end;

//     procedure receivecashrecipt(finalsettlement: Record "FinalSettlement")
//     var
//         GenJnlLine: Record "Gen. Journal Line";
//         SalesInvoice: Record "Sales Invoice Header";
//         finalcalculation: Record "Final Calculation";
//         GenJnlTemplate: Code[10];
//         GenJnlBatch: Code[10];
//         PostingDate: Date;
//         DocumentNo: Code[20];
//         AccountNo: Code[20];
//         InvoiceNo: Code[20];
//         GenJournalLine: Record "Gen. Journal Line";
//         LastLineNo: Integer;
//         GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
//         TerminationCharges: Record "Termination Charges Sub";
//         TotalRefundableDeposit: Decimal;
//         TerminationChargesub: Record "Additional Charges Sub";
//         Tenantid: Code[20];
//         Tenantname: Text[100];
//         billingcalculation: Record "Final Billing Calculation Grid";
//     begin
//         // Initialize variables
//         GenJnlTemplate := 'CASH RECE';
//         GenJnlBatch := 'DEFAULT';
//         PostingDate := Today();
//         DocumentNo := 'RECEIVE-' + Format(finalsettlement."Contract ID");

//         // Fetch tenant details from Final Calculation
//         finalcalculation.Reset();
//         finalcalculation.SetRange("Contract ID", finalsettlement."Contract ID");
//         if finalcalculation.FindFirst() then begin
//             Tenantid := finalcalculation."Tenant ID";
//             Tenantname := finalcalculation."Tenant Name";
//         end else
//             Error('Final Calculation not found for Contract ID %1', finalsettlement."Contract ID");

//         // Determine Bal. Account based on Refund Payment Mode
//         if UpperCase(finalsettlement."Receivable Payment mode") = 'CASH' then begin
//             AccountNo := '3001'; // Cash G/L Account
//             GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
//         end else begin
//             AccountNo := '3002';
//             GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

//             if AccountNo = '' then
//                 Error('Bank Account No. not found in Final Settlement for Contract ID %1', finalsettlement."Contract ID");
//         end;

//         // Sum Additional Charges and fetch Invoice No.
//         TotalRefundableDeposit := 0;
//         InvoiceNo := '';
//         TerminationChargesub.Reset();
//         TerminationChargesub.SetRange("Contract ID", finalsettlement."Contract ID");
//         if TerminationChargesub.FindSet() then begin
//             repeat
//                 TotalRefundableDeposit += TerminationChargesub."Amount Including VAT";
//                 if InvoiceNo = '' then
//                     InvoiceNo := TerminationChargesub."Posted Invoice ID";
//             until TerminationChargesub.Next() = 0;
//         end else
//             Error('Additional charges not found for Contract ID %1', finalsettlement."Contract ID");

//         // Verify we have a valid amount and invoice number
//         if TotalRefundableDeposit <= 0 then
//             Error('Total refundable deposit amount must be greater than zero');

//         if InvoiceNo = '' then
//             Error('Invoice number is missing in Additional Charges');

//         // Find the next line number
//         GenJournalLine.Reset();
//         GenJournalLine.SetRange("Journal Template Name", GenJnlTemplate);
//         GenJournalLine.SetRange("Journal Batch Name", GenJnlBatch);
//         if GenJournalLine.FindLast() then
//             LastLineNo := GenJournalLine."Line No." + 1
//         else
//             LastLineNo := 1;

//         // Insert Gen. Journal Line
//         Clear(GenJnlLine);
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := GenJnlTemplate;
//         GenJnlLine."Journal Batch Name" := GenJnlBatch;
//         GenJnlLine."Line No." := LastLineNo;
//         GenJnlLine."Posting Date" := PostingDate;
//         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//         GenJnlLine."Document No." := DocumentNo;
//         GenJnlLine.Description := Tenantname;
//         GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
//         GenJnlLine."Account No." := Tenantid;
//         GenJnlLine.Validate(Amount, Round(-TotalRefundableDeposit, 0.01));
//         GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
//         GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
//         GenJnlLine."Bal. Account No." := AccountNo;
//         GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
//         GenJnlLine."Applies-to Doc. No." := InvoiceNo;
//         GenJnlLine.Insert(true);

//         // Post the journal
//         GenJnlPostLine.RunWithCheck(GenJnlLine);

//         // Clean up after posting
//         GenJournalLine.Reset();
//         GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
//         GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
//         if GenJournalLine.FindSet() then
//             GenJournalLine.DeleteAll();

//         Message('Cash Receipt journal entries created successfully.');
//     end;

//     procedure receivablecashrecipt(finalsettlement: Record "FinalSettlement")
//     var
//         GenJnlLine: Record "Gen. Journal Line";
//         SalesInvoice: Record "Sales Invoice Header";
//         finalcalculation: Record "Final Calculation";
//         GenJnlTemplate: Code[10];
//         GenJnlBatch: Code[10];
//         PostingDate: Date;
//         DocumentNo: Code[20];
//         AccountNo: Code[20];
//         InvoiceNo: Code[20];
//         GenJournalLine: Record "Gen. Journal Line";
//         LastLineNo: Integer;
//         GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
//         TerminationCharges: Record "Termination Charges Sub";
//         TotalRefundableDeposit: Decimal;
//         TerminationChargesub: Record "Additional Charges Sub";
//         Tenantid: Code[20];
//         Tenantname: Text[100];
//         billingcalculation: Record "Final Billing Calculation Grid";
//     begin
//         // Initialize variables
//         GenJnlTemplate := 'CASH RECE';
//         GenJnlBatch := 'DEFAULT';
//         PostingDate := Today();
//         DocumentNo := 'RECEIVE-' + Format(finalsettlement."Contract ID");

//         // Fetch tenant details from Final Calculation
//         finalcalculation.Reset();
//         finalcalculation.SetRange("Contract ID", finalsettlement."Contract ID");
//         if finalcalculation.FindFirst() then begin
//             Tenantid := finalcalculation."Tenant ID";
//             Tenantname := finalcalculation."Tenant Name";
//         end else
//             Error('Final Calculation not found for Contract ID %1', finalsettlement."Contract ID");

//         // Determine Bal. Account based on Refund Payment Mode
//         if UpperCase(finalsettlement."Receivable Payment mode") = 'CASH' then begin
//             AccountNo := '3001'; // Cash G/L Account
//             GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
//         end else begin
//             AccountNo := '3002';
//             GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

//             if AccountNo = '' then
//                 Error('Bank Account No. not found in Final Settlement for Contract ID %1', finalsettlement."Contract ID");
//         end;

//         // Find Invoice No. based on Contract ID
//         billingcalculation.Reset();
//         billingcalculation.SetRange("Contract ID", finalsettlement."Contract ID");
//         if billingcalculation.FindSet() then begin
//             InvoiceNo := billingcalculation."Posted Invoice ID";
//             TotalRefundableDeposit := billingcalculation."Invoice Amount";

//             if TotalRefundableDeposit <= 0 then
//                 Error('Invoice amount is zero or negative. No journal entry created.');

//             if InvoiceNo = '' then
//                 Error('Posted Invoice ID is missing in Billing Calculation');
//         end else
//             Error('Invoice not found for Contract ID %1', finalcalculation."Contract ID");

//         // Find the next line number
//         GenJournalLine.Reset();
//         GenJournalLine.SetRange("Journal Template Name", GenJnlTemplate);
//         GenJournalLine.SetRange("Journal Batch Name", GenJnlBatch);
//         if GenJournalLine.FindLast() then
//             LastLineNo := GenJournalLine."Line No." + 1
//         else
//             LastLineNo := 1;

//         // Insert Gen. Journal Line
//         Clear(GenJnlLine);
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := GenJnlTemplate;
//         GenJnlLine."Journal Batch Name" := GenJnlBatch;
//         GenJnlLine."Line No." := LastLineNo;
//         GenJnlLine."Posting Date" := PostingDate;
//         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//         GenJnlLine."Document No." := DocumentNo;
//         GenJnlLine.Description := Tenantname;
//         GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
//         GenJnlLine."Account No." := Tenantid;
//         GenJnlLine.Validate(Amount, Round(-TotalRefundableDeposit, 0.01));
//         GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
//         GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
//         GenJnlLine."Bal. Account No." := AccountNo;
//         GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
//         GenJnlLine."Applies-to Doc. No." := InvoiceNo;
//         GenJnlLine.Insert(true);

//         // Post the journal
//         GenJnlPostLine.RunWithCheck(GenJnlLine);

//         // Clean up after posting
//         GenJournalLine.Reset();
//         GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
//         GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
//         if GenJournalLine.FindSet() then
//             GenJournalLine.DeleteAll();

//         Message('Cash Receipt journal entries created successfully.');
//     end;
// }

codeunit 50108 "Final Settlement Posting Mgt."
{
    procedure PostFinalSettlementAmount(FinalSettlement: Record "FinalSettlement")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Code[10];
        GenJnlBatch: Code[10];
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
        CustomerCard: Record Customer; // Added for new functionality
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
        GenJnlTemplate := 'CASH RECE';
        GenJnlBatch := 'DEFAULT';

        // Get tenant contract information
        TenantContract.Reset();
        TenantContract.SetRange("Contract ID", FinalSettlement."Contract ID");
        if not TenantContract.FindFirst() then
            Error('Contract not found for Contract ID %1', FinalSettlement."Contract ID");

        TenantName := TenantContract."Tenant Name"; // Assuming this field exists

        // Get pending receivable information
        PendingReceivableRID.Reset();
        PendingReceivableRID.SetRange("Contract ID", FinalSettlement."Contract ID");
        if not PendingReceivableRID.FindFirst() then
            Error('Pending receivable not found for Contract ID %1', FinalSettlement."Contract ID");

        PendingAmount := PendingReceivableRID."Total Receivable";

        // Get additional charges information for invoice ID
        AdditionalCharges.Reset();
        AdditionalCharges.SetRange("Contract ID", FinalSettlement."Contract ID");
        if not AdditionalCharges.FindFirst() then
            Error('Additional charges not found for Contract ID %1', FinalSettlement."Contract ID");

        // Find the bank account
        // Try to find the bank account first
        BankAccountNo := '';
        BankAccount.Reset();
        BankAccount.SetRange(Name, FinalSettlement."Deposit Bank");
        if BankAccount.FindFirst() then
            BankAccountNo := BankAccount."No."
        else begin
            // Try to find by No. directly
            BankAccount.Reset();
            BankAccount.SetRange("No.", FinalSettlement."Deposit Bank");
            if BankAccount.FindFirst() then
                BankAccountNo := BankAccount."No."
            else
                Error('Bank account "%1" not found. Please check the bank account code.', FinalSettlement."Deposit Bank");
        end;

        // Generate Document No
        DocNo := 'FS-' + Format(FinalSettlement."Contract ID") + '-' + Format(FinalSettlement."FC ID");

        // Find the next available Line No.
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate);
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch);
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 1
        else
            LineNo := 1;

        // 1st Line - Bank Account entry
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := GenJnlTemplate;
        GenJnlLine."Journal Batch Name" := GenJnlBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Posting Date" := Today;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := FinalSettlement."Tenant ID";
        GenJnlLine.Description := TenantName;
        GenJnlLine.Validate(Amount, -TenantContract."Total Receive");
        GenJnlLine."Amount (LCY)" := -TenantContract."Total Receive";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := BankAccountNo;
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := AdditionalCharges."Invoiced ID";
        GenJnlLine.Insert();

        // 2nd Line - Pending Receivable entry
        LineNo += 10000;
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := GenJnlTemplate;
        GenJnlLine."Journal Batch Name" := GenJnlBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Posting Date" := Today;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := FinalSettlement."Tenant ID";
        GenJnlLine.Description := TenantName;
        GenJnlLine.Validate(Amount, -PendingAmount);
        GenJnlLine."Amount (LCY)" := -PendingAmount;
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := BankAccountNo;
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := BillingSetup."Invoice ID";
        GenJnlLine.Insert();

        // Added new functionality: Update customer posting groups if Property Classification exists
        if TenantContract."Unit Type" <> '' then begin
            CustomerCard.SetRange("No.", FinalSettlement."Tenant ID");
            if CustomerCard.FindSet() then begin
                CustomerCard.Validate("Gen. Bus. Posting Group", TenantContract."Unit Type");
                CustomerCard.Validate("Customer Posting Group", TenantContract."Unit Type");
                CustomerCard.Modify();
            end;
        end;

        // Post the Journal
        GenJnlPost.Run(GenJnlLine);

        Message('Final Settlement amount posted successfully. Total: %1, Pending: %2', Amount, PendingAmount);
    end;


    procedure receivecashrecipt(FinalSettlement: Record "FinalSettlement")
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
    // finalsettlement: Record "FinalSettlement";

    begin
        GenJnlTemplate := 'CASH RECE';
        GenJnlBatch := 'DEFAULT';
        PostingDate := Today(); // You can replace with actual Posting Date

        // Add validation for finalsettlement record
        if finalsettlement."Contract ID" = 0 then
            Error('Contract ID is missing in the Final Settlement record');

        DocumentNo := 'RECEIVE-' + Format(finalsettlement."Contract ID"); // Customize as needed

        // Fetch tenant details from Final Calculation
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", finalsettlement."Contract ID");
        if finalcalculation.FindFirst() then begin
            Tenantid := finalcalculation."Tenant ID";
            Tenantname := finalcalculation."Tenant Name";
        end else begin
            Error('Final Calculation not found for Contract ID %1', finalsettlement."Contract ID");
        end;

        // Determine Bal. Account based on Refund Payment Mode
        finalsettlement.Reset();
        finalsettlement.SetRange("FC ID", finalsettlement."FC ID");
        if finalsettlement.FindFirst() then begin
            if UpperCase(finalsettlement."Receivable Payment mode") = 'CASH' then begin
                AccountNo := '3001'; // Cash G/L Account
            end else begin
                AccountNo := '3002';
                if AccountNo = '' then
                    Error('Bank Account No. not found in Final Settlement for Contract ID %1', finalsettlement."Contract ID");
            end;
        end else begin
            Error('Final Settlement not found for Contract ID %1', finalsettlement."Contract ID");
        end;

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
        end else begin
            Error('Additional charges not found for Contract ID %1', finalsettlement."Contract ID");
        end;

        // Validate amount before proceeding
        if TotalRefundableDeposit = 0 then
            Error('Amount cannot be zero. Check termination charges for Contract ID %1', finalsettlement."Contract ID");

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", GenJnlTemplate);
        GenJournalLine.SetRange("Journal Batch Name", GenJnlBatch);
        if GenJournalLine.FindLast() then
            LastLineNo := GenJournalLine."Line No." + 10000
        else
            LastLineNo := 10000;

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
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := AccountNo;
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := InvoiceNo;

        // Validate the amount is not zero before inserting
        if GenJnlLine.Amount = 0 then
            Error('Amount cannot be zero for journal line');

        GenJnlLine.Insert(true);

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
        GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if GenJournalLine.FindSet() then
            GenJournalLine.DeleteAll();

        Message('Cash Receipt journal entries created successfully.');
    end;

    procedure receivablecashrecipt(FinalSettlement: Record "FinalSettlement")
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
    // finalsettlement: Record "FinalSettlement";

    begin
        GenJnlTemplate := 'CASH RECE';
        GenJnlBatch := 'DEFAULT';
        PostingDate := Today(); // You can replace with actual Posting Date

        // Add validation for finalsettlement record
        if finalsettlement."Contract ID" = 0 then
            Error('Contract ID is missing in the Final Settlement record');

        DocumentNo := 'RECEIVE-' + Format(finalsettlement."Contract ID"); // Customize as needed

        // Fetch tenant details from Final Calculation
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", finalsettlement."Contract ID");
        if finalcalculation.FindFirst() then begin
            Tenantid := finalcalculation."Tenant ID";
            Tenantname := finalcalculation."Tenant Name";
        end else begin
            Error('Final Calculation not found for Contract ID %1', finalsettlement."Contract ID");
        end;

        // Determine Bal. Account based on Refund Payment Mode
        finalsettlement.Reset();
        finalsettlement.SetRange("FC ID", finalsettlement."FC ID");
        if finalsettlement.FindFirst() then begin
            if UpperCase(finalsettlement."Receivable Payment mode") = 'CASH' then begin
                AccountNo := '3001'; // Cash G/L Account
            end else begin
                AccountNo := '3002';
                if AccountNo = '' then
                    Error('Bank Account No. not found in Final Settlement for Contract ID %1', finalsettlement."Contract ID");
            end;
        end else begin
            Error('Final Settlement not found for Contract ID %1', finalsettlement."Contract ID");
        end;

        // 2. Find Invoice No. based on Contract ID
        billingcalculation.Reset();  // Add Reset() before SetRange
        billingcalculation.SetRange("Contract ID", finalsettlement."Contract ID");
        if billingcalculation.FindSet() then begin
            InvoiceNo := billingcalculation."Posted Invoice ID";
            TotalRefundableDeposit := billingcalculation."Invoice Amount";

            if TotalRefundableDeposit <= 0 then begin
                Error('Invoice amount is zero or negative for Contract ID %1. Cannot create journal entry.', finalsettlement."Contract ID");
            end;
        end else begin
            Error('Invoice not found for Contract ID %1', finalsettlement."Contract ID");
        end;

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", GenJnlTemplate);
        GenJournalLine.SetRange("Journal Batch Name", GenJnlBatch);
        if GenJournalLine.FindLast() then
            LastLineNo := GenJournalLine."Line No." + 10000  // Use standard NAV increment of 10000
        else
            LastLineNo := 10000;  // Start with 10000 as standard in NAV

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
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := AccountNo;
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := InvoiceNo;

        // Validate the amount is not zero before inserting
        if GenJnlLine.Amount = 0 then
            Error('Amount cannot be zero for journal line');

        GenJnlLine.Insert(true);

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
        GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if GenJournalLine.FindSet() then
            GenJournalLine.DeleteAll();

        Message('Cash Receipt journal entries created successfully.');
    end;
}






















// codeunit 50108 "Final Settlement Posting Mgt."
// {
//     procedure PostFinalSettlementAmount(FinalSettlement: Record "FinalSettlement")
//     var
//         GenJnlLine: Record "Gen. Journal Line";
//         GenJnlTemplate: Code[10];
//         GenJnlBatch: Code[10];
//         LineNo: Integer;
//         DocNo: Code[20];
//         GenJnlPost: Codeunit "Gen. Jnl.-Post";
//         TenantContract: Record "Final Calculation"; // Adjust to your actual Contract table name
//         TenantReceivableAccount: Code[20];
//         BankCashAccount: Code[20];
//         Amount: Decimal;
//         CurrencyRounding: Record Currency;
//         GLSetup: Record "General Ledger Setup";
//     begin
//         // Load G/L Setup for rounding
//         GLSetup.Get();

//         // Check if there's any amount to post
//         Amount := FinalSettlement."Receivable Total Amount";
//         if Amount = 0 then
//             Error('Final Settlement Amount is zero. Cannot post.');

//         // Round the amount according to G/L setup
//         Amount := Round(Amount, GLSetup."Amount Rounding Precision");
//         // Set Journal Template and Batch
//         GenJnlTemplate := 'CASH RECE';
//         GenJnlBatch := 'DEFAULT';

//         // Get property type from Contract table
//         TenantContract.Reset();
//         TenantContract.SetRange("Contract ID", FinalSettlement."Contract ID");
//         if not TenantContract.FindFirst() then
//             Error('Contract not found for Contract ID %1', FinalSettlement."Contract ID");

//         // Set G/L Accounts based on Property Type
//         case TenantContract."Unit Type" of
//             'Residential':
//                 TenantReceivableAccount := '1501';  // Replace with your actual G/L Account
//             'Commercial':
//                 TenantReceivableAccount := '1506';  // Replace with your actual G/L Account
//             else
//                 Error('Invalid Property Type. Must be Residential or Commercial.');
//         end;

//         // Set Bank/Cash Account based on Payment Mode
//         if FinalSettlement."Receivable Payment mode" = 'Cash' then
//             BankCashAccount := '3001'  // Replace with your actual Cash G/L Account
//         else
//             BankCashAccount := '3002'; // Replace with your actual Bank G/L Account

//         // Generate Document No
//         DocNo := 'FS-' + Format(FinalSettlement."Contract ID") + '-' + Format(FinalSettlement."FC ID");

//         // Find the next available Line No.
//         GenJnlLine.Reset();
//         GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate);
//         GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch);
//         if GenJnlLine.FindLast() then
//             LineNo := GenJnlLine."Line No." + 1
//         else
//             LineNo := 1;

//         // 1st Line - Tenant Receivable (-Amount) - Decrease receivable
//         Clear(GenJnlLine);
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := GenJnlTemplate;
//         GenJnlLine."Journal Batch Name" := GenJnlBatch;
//         GenJnlLine."Line No." := LineNo;
//         GenJnlLine."Posting Date" := Today;
//         GenJnlLine."Document No." := DocNo;
//         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//         GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
//         GenJnlLine."Account No." := TenantReceivableAccount;
//         GenJnlLine.Validate(Amount, -Amount); // Negative amount to DECREASE tenant receivable
//         GenJnlLine."Source Code" := 'FINSETTLE';
//         GenJnlLine.Description := StrSubstNo('Final Settlement for Contract %1', FinalSettlement."Contract ID");
//         GenJnlLine.Insert();

//         // 2nd Line - Bank/Cash Account (+Amount) - Increase bank account
//         LineNo += 10000;
//         Clear(GenJnlLine);
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := GenJnlTemplate;
//         GenJnlLine."Journal Batch Name" := GenJnlBatch;
//         GenJnlLine."Line No." := LineNo;
//         GenJnlLine."Posting Date" := Today;
//         GenJnlLine."Document No." := DocNo;
//         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//         GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
//         GenJnlLine."Account No." := BankCashAccount;
//         GenJnlLine.Validate(Amount, Amount); // Positive amount to INCREASE bank account
//         GenJnlLine."Source Code" := 'FINSETTLE';
//         GenJnlLine.Description := StrSubstNo('Final Settlement for Contract %1', FinalSettlement."Contract ID");
//         GenJnlLine.Insert();

//         // Post the Journal
//         GenJnlPost.Run(GenJnlLine);

//         Message('Final Settlement amount of %1 posted successfully.', Amount);
//     end;
// }







// codeunit 50108 "Final Settlement Posting Mgt."
// {
//     procedure PostFinalSettlementAmount(FinalSettlement: Record "FinalSettlement")
//     var
//         GenJnlLine: Record "Gen. Journal Line";
//         GenJnlTemplate: Code[10];
//         GenJnlBatch: Code[10];
//         LineNo: Integer;
//         DocNo: Code[20];
//         GenJnlPost: Codeunit "Gen. Jnl.-Post";
//         TenantContract: Record "Final Calculation";
//         PendingReceivableRID: Record "Pending Receviable Grid";
//         AdditionalCharges: Record "Additional Charges Sub";
//         BillingSetup: Record "Final Billing Calculation Grid";
//         PendingAmount: Decimal;
//         TotalReceiveAmount: Decimal;
//         GLSetup: Record "General Ledger Setup";
//         TenantName: Text[100];
//         BankAccount: Record "Bank Account";
//         BankAccountNo: Code[20];
//     begin
//         // Load G/L Setup for rounding
//         GLSetup.Get();

//         // Set Journal Template and Batch
//         GenJnlTemplate := 'CASH RECE';
//         GenJnlBatch := 'DEFAULT';

//         // Get tenant contract information
//         TenantContract.Reset();
//         TenantContract.SetRange("Contract ID", FinalSettlement."Contract ID");
//         if not TenantContract.FindFirst() then
//             Error('Contract not found for Contract ID %1', FinalSettlement."Contract ID");

//         TenantName := TenantContract."Tenant Name"; // Assuming this field exists

//         // Get the Total Receive value from Final Calculation
//         TotalReceiveAmount := TenantContract."Total Receive";

//         // Get pending receivable information
//         PendingReceivableRID.Reset();
//         PendingReceivableRID.SetRange("Contract ID", FinalSettlement."Contract ID");
//         if not PendingReceivableRID.FindFirst() then
//             Error('Pending receivable not found for Contract ID %1', FinalSettlement."Contract ID");

//         PendingAmount := PendingReceivableRID."Total Receivable";

//         // Check if there's any amount to post
//         if PendingAmount = 0 then
//             Error('Pending Amount is zero. Cannot post.');

//         // Round the amount according to G/L setup
//         PendingAmount := Round(PendingAmount, GLSetup."Amount Rounding Precision");
//         TotalReceiveAmount := Round(TotalReceiveAmount, GLSetup."Amount Rounding Precision");

//         // Get additional charges information for invoice ID
//         AdditionalCharges.Reset();
//         AdditionalCharges.SetRange("Contract ID", FinalSettlement."Contract ID");
//         if not AdditionalCharges.FindFirst() then
//             Error('Additional charges not found for Contract ID %1', FinalSettlement."Contract ID");

//         // Find the bank account
//         // Try to find the bank account first
//         BankAccountNo := '';
//         BankAccount.Reset();
//         BankAccount.SetRange(Name, FinalSettlement."Deposit Bank");
//         if BankAccount.FindFirst() then
//             BankAccountNo := BankAccount."No."
//         else begin
//             // Try to find by No. directly
//             BankAccount.Reset();
//             BankAccount.SetRange("No.", FinalSettlement."Deposit Bank");
//             if BankAccount.FindFirst() then
//                 BankAccountNo := BankAccount."No."
//             else
//                 Error('Bank account "%1" not found. Please check the bank account code.', FinalSettlement."Deposit Bank");
//         end;

//         // Generate Document No
//         DocNo := 'FS-' + Format(FinalSettlement."Contract ID") + '-' + Format(FinalSettlement."FC ID");

//         // Find the next available Line No.
//         GenJnlLine.Reset();
//         GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate);
//         GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch);
//         if GenJnlLine.FindLast() then
//             LineNo := GenJnlLine."Line No." + 1
//         else
//             LineNo := 1;

//         // 1st Line - Pending Receivable entry
//         Clear(GenJnlLine);
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := GenJnlTemplate;
//         GenJnlLine."Journal Batch Name" := GenJnlBatch;
//         GenJnlLine."Line No." := LineNo;
//         GenJnlLine."Posting Date" := Today;
//         GenJnlLine."Document No." := DocNo;
//         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//         GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
//         GenJnlLine."Account No." := FinalSettlement."Tenant ID";
//         GenJnlLine.Description := TenantName;
//         GenJnlLine.Validate(Amount, -PendingAmount);
//         GenJnlLine."Amount (LCY)" := -PendingAmount;
//         GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
//         GenJnlLine."Bal. Account No." := BankAccountNo;
//         GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
//         GenJnlLine."Applies-to Doc. No." := AdditionalCharges."Invoiced ID";
//         GenJnlLine.Insert();

//         // 2nd Line - Total Receive entry from Final Calculation
//         LineNo += 10000;
//         Clear(GenJnlLine);
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := GenJnlTemplate;
//         GenJnlLine."Journal Batch Name" := GenJnlBatch;
//         GenJnlLine."Line No." := LineNo;
//         GenJnlLine."Posting Date" := Today;
//         GenJnlLine."Document No." := DocNo;
//         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
//         GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
//         GenJnlLine."Account No." := FinalSettlement."Tenant ID";
//         GenJnlLine.Description := TenantName;
//         GenJnlLine.Validate(Amount, -TotalReceiveAmount);
//         GenJnlLine."Amount (LCY)" := -TotalReceiveAmount;
//         GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
//         GenJnlLine."Bal. Account No." := BankAccountNo;
//         GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
//         GenJnlLine."Applies-to Doc. No." := BillingSetup."Invoice ID";
//         GenJnlLine.Insert();

//         // Post the Journal
//         GenJnlPost.Run(GenJnlLine);

//         Message('Final Settlement amount posted successfully. Pending Amount: %1, Total Receive: %2', PendingAmount, TotalReceiveAmount);
//     end;
// }


























// // codeunit 50108 "Final Settlement Posting Mgt."
// // {
// //     procedure PostFinalSettlementAmount(FinalSettlement: Record "FinalSettlement")
// //     var
// //         GenJnlLine: Record "Gen. Journal Line";
// //         GenJnlTemplate: Code[10];
// //         GenJnlBatch: Code[10];
// //         LineNo: Integer;
// //         DocNo: Code[20];
// //         GenJnlPost: Codeunit "Gen. Jnl.-Post";
// //         TenantContract: Record "Final Calculation"; // Adjust to your actual Contract table name
// //         TenantReceivableAccount: Code[20];
// //         BankCashAccount: Code[20];
// //         Amount: Decimal;
// //         CurrencyRounding: Record Currency;
// //         GLSetup: Record "General Ledger Setup";
// //     begin
// //         // Load G/L Setup for rounding
// //         GLSetup.Get();

// //         // Check if there's any amount to post
// //         Amount := FinalSettlement."Receivable Total Amount";
// //         if Amount = 0 then
// //             Error('Final Settlement Amount is zero. Cannot post.');

// //         // Round the amount according to G/L setup
// //         Amount := Round(Amount, GLSetup."Amount Rounding Precision");
// //         // Set Journal Template and Batch
// //         GenJnlTemplate := 'GENERAL';
// //         GenJnlBatch := 'DEFAULT';

// //         // Get property type from Contract table
// //         TenantContract.Reset();
// //         TenantContract.SetRange("Contract ID", FinalSettlement."Contract ID");
// //         if not TenantContract.FindFirst() then
// //             Error('Contract not found for Contract ID %1', FinalSettlement."Contract ID");

// //         // Set G/L Accounts based on Property Type
// //         case TenantContract."Unit Type" of
// //             'Residential':
// //                 TenantReceivableAccount := '1501';  // Replace with your actual G/L Account
// //             'Commercial':
// //                 TenantReceivableAccount := '1506';  // Replace with your actual G/L Account
// //             else
// //                 Error('Invalid Property Type. Must be Residential or Commercial.');
// //         end;

// //         // Set Bank/Cash Account based on Payment Mode
// //         if FinalSettlement."Receivable Payment mode" = 'Cash' then
// //             BankCashAccount := '3001'  // Replace with your actual Cash G/L Account
// //         else
// //             BankCashAccount := '3002'; // Replace with your actual Bank G/L Account

// //         // Generate Document No
// //         DocNo := 'FS-' + Format(FinalSettlement."Contract ID") + '-' + Format(FinalSettlement."FC ID");

// //         // Find the next available Line No.
// //         GenJnlLine.Reset();
// //         GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate);
// //         GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch);
// //         if GenJnlLine.FindLast() then
// //             LineNo := GenJnlLine."Line No." + 10000
// //         else
// //             LineNo := 10000;

// //         // 1st Line - Tenant Receivable (-Amount)
// //         Clear(GenJnlLine);
// //         GenJnlLine.Init();
// //         GenJnlLine."Journal Template Name" := GenJnlTemplate;
// //         GenJnlLine."Journal Batch Name" := GenJnlBatch;
// //         GenJnlLine."Line No." := LineNo;
// //         GenJnlLine."Posting Date" := Today;
// //         GenJnlLine."Document No." := DocNo;
// //         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
// //         GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
// //         GenJnlLine."Account No." := TenantReceivableAccount;
// //         GenJnlLine.Validate(Amount, -Amount); // Using Validate for proper rounding
// //         GenJnlLine."Source Code" := 'FINSETTLE';
// //         GenJnlLine.Description := StrSubstNo('Final Settlement for Contract %1', FinalSettlement."Contract ID");
// //         GenJnlLine.Insert();

// //         // 2nd Line - Bank/Cash Account (+Amount)
// //         LineNo += 10000;
// //         Clear(GenJnlLine);
// //         GenJnlLine.Init();
// //         GenJnlLine."Journal Template Name" := GenJnlTemplate;
// //         GenJnlLine."Journal Batch Name" := GenJnlBatch;
// //         GenJnlLine."Line No." := LineNo;
// //         GenJnlLine."Posting Date" := Today;
// //         GenJnlLine."Document No." := DocNo;
// //         GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
// //         GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
// //         GenJnlLine."Account No." := BankCashAccount;
// //         GenJnlLine.Validate(Amount, Amount); // Using Validate for proper rounding
// //         GenJnlLine."Source Code" := 'FINSETTLE';
// //         GenJnlLine.Description := StrSubstNo('Final Settlement for Contract %1', FinalSettlement."Contract ID");
// //         GenJnlLine.Insert();

// //         // Post the Journal
// //         GenJnlPost.Run(GenJnlLine);

// //         Message('Final Settlement amount of %1 posted successfully.', Amount);
// //     end;
// // }