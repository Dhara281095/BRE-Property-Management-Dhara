codeunit 50514 "Cash Receipt Journal Entry"
{
    Subtype = Normal;
    trigger OnRun()
    begin
    end;

    procedure CreateCashReceiptJournal(PaymentSeriesCode: Record "Payment Mode2")
    var
        PaymentSeriesRec: Record "Payment Mode2"; // Your Payment Series Table
        PaymentScheduleRec: Record "Payment Schedule2"; // Your Payment Schedule Table
        GenJournalLineRec: Record "Gen. Journal Line";
        // GenJournalBatchRec: Record "Gen. Journal Batch";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        COACode: Record "COA Setup";
        BankAccountRec: Record "Bank Account";
        LineNumber: Integer;
        ContractRec: Record "Tenancy Contract";
        TenantReceivableGL: Code[20];
        PDCCollectionGL: Code[20];
        BalAccountNo: Code[20];
        BatchName: Code[20];
        ErrorMessage: Text[100];
        PropertyClassification: Text[50];
        CustRec: Record Customer;
    begin
        // Find the Payment Series Record
        // PaymentSeriesRec.Reset();
        PaymentSeriesRec.SetFilter("Payment Series", '%1', PaymentSeriesCode."Payment Series");
        PaymentSeriesRec.SetFilter("Contract ID", Format(PaymentSeriesCode."Contract ID"));
        if PaymentSeriesRec.FindFirst() then begin
            if PaymentSeriesCode."Payment Status" = PaymentSeriesCode."Payment Status"::Received then begin

                // Reset Existing Cash Receipt Journal Lines
                GenJournalLineRec.Reset();
                GenJournalLineRec.SetRange("Journal Template Name", 'CASH RECE');
                GenJournalLineRec.SetRange("Journal Batch Name", 'DEFAULT');
                GenJournalLineRec.SetRange("Line No.", 10000);

                if GenJournalLineRec.FindSet() then begin
                    GenJournalLineRec.DeleteAll();
                end;
                PDCCollectionGL := '2002';
                //  Get Contract Info
                ContractRec.Reset();
                ContractRec.SetRange("Contract ID", PaymentSeriesRec."Contract ID");
                if ContractRec.FindFirst() then
                    // update Customer as before
                    PropertyClassification := ContractRec."Property Classification";
                if CustRec.Get(PaymentScheduleRec."Tenant Id") then begin
                    if ContractRec."Property Classification" <> '' then begin
                        CustRec.Validate("Customer Posting Group", ContractRec."Property Classification");
                        CustRec.Validate("Gen. Bus. Posting Group", ContractRec."Property Classification");
                        CustRec.Modify();

                    end

                end;
            end else
                Error('No contract found with ID %1', PaymentSeriesRec."Contract ID");

            // Loop through Payment Schedule and create individual lines
            PaymentScheduleRec.SetRange("Payment Series", PaymentSeriesRec."Payment Series");
            PaymentScheduleRec.SetRange("Contract ID", PaymentSeriesRec."Contract ID");
            if PaymentScheduleRec.FindSet() then begin
                LineNumber := 0;

                LineNumber := GenJournalLineRec."Line No." + 10000;
                Clear(GenJournalLineRec);
                GenJournalLineRec.Init();
                GenJournalLineRec."Journal Template Name" := 'CASH RECE';
                GenJournalLineRec."Journal Batch Name" := 'DEFAULT';
                GenJournalLineRec."Document No." := Format(PaymentSeriesCode."Entry No.");
                GenJournalLineRec."Posting Date" := Today;
                GenJournalLineRec."Line No." := LineNumber;
                GenJournalLineRec."Document Type" := GenJournalLineRec."Document Type"::Payment;

                if PaymentSeriesRec."Payment Mode" = 'Cheque' then begin
                    GenJournalLineRec."Account Type" := GenJournalLineRec."Account Type"::"G/L Account";
                    GenJournalLineRec."Account No." := PDCCollectionGL;
                    GenJournalLineRec.Description := PaymentSeriesRec."Cheque Number"; // Customer from Payment Series
                end else begin
                    GenJournalLineRec."Account Type" := GenJournalLineRec."Account Type"::Customer;
                    GenJournalLineRec."Account No." := PaymentSeriesRec."Tenant Id"; // Customer from Payment Series
                end;
                // GenJournalLineRec."Account No." := TenantReceivableGL; // Customer from Payment Series
                GenJournalLineRec.Description := PaymentSeriesRec."Invoice #";
                GenJournalLineRec.Validate(Amount, Round(-PaymentSeriesRec."Amount Including VAT"));
                // GenJournalLineRec."Amount (LCY)" := GenJournalLineRec.Amount;
                GenJournalLineRec."Applies-to Doc. Type" := GenJournalLineRec."Applies-to Doc. Type"::Invoice;
                GenJournalLineRec."Applies-to Doc. No." := PaymentSeriesRec."Invoice #";

                // GenJournalLineRec."Bal. Account No." := PaymentSeriesRec."Deposit Bank";
                BankAccountRec.Reset();
                BankAccountRec.SetRange("Search Name", PaymentSeriesRec."Deposit Bank");
                if BankAccountRec.FindSet() then begin
                    GenJournalLineRec."Bal. Account Type" := GenJournalLineRec."Bal. Account Type"::"Bank Account";
                    GenJournalLineRec."Bal. Account No." := BankAccountRec."No.";
                    // GenJournalLineRec."Currency Code" := BankAccountRec."Currency Code";
                end
                else begin
                    GenJournalLineRec."Bal. Account Type" := GenJournalLineRec."Bal. Account Type"::"G/L Account";
                    GenJournalLineRec."Bal. Account No." := '3001';
                end;


                GenJournalLineRec.Insert();

                // Optionally Post the Journal Entry
                GenJnlPostLine.RunWithCheck(GenJournalLineRec);

                // **Delete the Journal Line After Posting**
                GenJournalLineRec.Reset();
                GenJournalLineRec.SetRange("Journal Template Name", 'CASH RECE');
                GenJournalLineRec.SetRange("Journal Batch Name", 'DEFAULT');
                GenJournalLineRec.SetRange("Document No.", Format(PaymentSeriesCode."Entry No."));
                GenJournalLineRec."Posting Date" := Today;
                if GenJournalLineRec.FindSet() then begin
                    GenJournalLineRec.DeleteAll();
                end;
                Message('Cash Receipt journal created successfully.');
            end;
        end;
    end;



    procedure ProcessPDCTransaction(PDCTransactionRec: Record "PDC Transaction")
    var
        PaymentSeriesRec: Record "Payment Mode2";
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        BankAccountRec: Record "Bank Account";
        LineNo: Integer;
        COACode: Record "COA Setup";
        CustRec: Record Customer;
        ContractRec: Record "Tenancy Contract";
        TenantReceivableGL: Code[20];
        BalAccountNo: Code[20];
        ErrorMessage: Text[100];
        PDCReceivedGL: Code[20];
        PropertyClassification: Text[50];


    begin
        LineNo := 0;
        PDCReceivedGL := '2001';

        if PDCTransactionRec."Contract ID" <> 0 then begin
            ContractRec.Reset();
            ContractRec.SetRange("Contract ID", PDCTransactionRec."Contract ID"); // Use correct field name
            if ContractRec.FindFirst() then begin
                PropertyClassification := ContractRec."Property Classification";
                // update Customer as before
                if CustRec.Get(PDCTransactionRec."Tenant Id") then begin
                    if ContractRec."Property Classification" <> '' then begin
                        CustRec.Validate("Customer Posting Group", ContractRec."Property Classification");
                        CustRec.Validate("Gen. Bus. Posting Group", ContractRec."Property Classification");
                        CustRec.Modify();
                        // CustRec."Customer Posting Group" := ContractRec."Property Classification";
                        // CustRec."Gen. Bus. Posting Group" := ContractRec."Property Classification";
                        // CustRec."VAT Bus. Posting Group" := 'RESIDENTIAL_RENTAL';
                    end
                    // else
                    //     if PropertyClassification = 'Commercial' then begin
                    //         CustRec."Customer Posting Group" := ContractRec."Property Classification";
                    //         CustRec."Gen. Bus. Posting Group" := ContractRec."Property Classification";
                    //         CustRec."VAT Bus. Posting Group" := 'DOMESTIC_RENTAL';
                    //     end;


                    // CustRec.Modify();


                end;
            end else
                Error('No contract found with ID %1', PDCTransactionRec."Contract ID");
        end else
            Error('Contract ID is missing in PDC record.');

        // // Update Customer Posting Group based on Property Classification
        // if ContractRec.Get(PDCTransactionRec."Contract ID") then begin
        //     PropertyClassification := ContractRec."Property Classification";

        //     if CustRec.Get(PDCTransactionRec."Tenant Id") then begin
        //         if PropertyClassification = 'Residential' then
        //             CustRec."Customer Posting Group" := ContractRec."Property Classification"
        //         else
        //             if PropertyClassification = 'Commercial' then
        //                 CustRec."Customer Posting Group" := 'Commercial';

        //         CustRec.Modify();
        //     end;
        // end else begin
        //     Error('Contract not found for Contract ID: %1', PDCTransactionRec."Contract ID");
        // end;
        //  Dynamically set Tenant Receivable G/L Account based on Property Type
        LineNo := GenJournalLine."Line No." + 10000;
        Clear(GenJournalLine);
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := 'CASH RECE';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Document No." := PDCTransactionRec."PDC ID";
        GenJournalLine."Posting Date" := Today;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
        GenJournalLine."Account No." := PDCTransactionRec."Tenant Id"; // Customer from Payment Series
        GenJournalLine.Description := 'PDC Received - Cheque No. ' + PDCTransactionRec."Cheque Number";
        GenJournalLine.Validate(Amount, Round(-PDCTransactionRec.Amount));
        // GenJournalLine."Amount (LCY)" := GenJournalLine.Amount;
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := PDCReceivedGL;

        GenJournalLine.Insert();

        // Optionally Post the Journal Entry
        GenJnlPostLine.RunWithCheck(GenJournalLine);
        // **Delete the Journal Line After Posting**
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
        GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        GenJournalLine."Posting Date" := Today;
        if GenJournalLine.FindSet() then begin
            GenJournalLine.DeleteAll();
        end;
        Message('Cash Receipt journal created successfully.');
    end;

    var
        myInt: Integer;
}