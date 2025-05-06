codeunit 50514 "Cash Receipt Journal Entry"
{
    Subtype = Normal;
    trigger OnRun()
    begin
    end;

    // procedure CreateCashReceiptJournal(InvoiceNo: Code[20]; PaymentAmount: Decimal)
    // var
    //     GenJournalLine: Record "Gen. Journal Line";
    //     SalesInvoiceLine: Record "Sales Invoice Line";
    //     SalesInvoiceHeader: Record "Sales Invoice Header";
    //     Customer: Record Customer;
    //     GenJnlTemplate: Record "Gen. Journal Template";
    //     GenJnlBatch: Record "Gen. Journal Batch";
    //     LineNo: Integer;
    // begin
    //     // Fetch Sales Invoice Details
    //     if not SalesInvoiceHeader.Get(InvoiceNo) then
    //         Error('Invoice %1 not found.', InvoiceNo);

    //     if not Customer.Get(SalesInvoiceHeader."Sell-to Customer No.") then
    //         Error('Customer not found for invoice %1.', InvoiceNo);

    //     // Ensure Journal Template Exists
    //     if not GenJnlTemplate.Get('CASHRECPT') then
    //         Error('Cash Receipt Journal Template "CASHRECPT" does not exist.');

    //     if not GenJnlBatch.Get('CASHRECPT', 'DEFAULT') then
    //         Error('Cash Receipt Batch "DEFAULT" does not exist.');

    //     // Create Main Entry (Header Line)
    //     GenJournalLine.Init();
    //     GenJournalLine."Journal Template Name" := 'CASHRECPT';
    //     GenJournalLine."Journal Batch Name" := 'DEFAULT';
    //     GenJournalLine."Line No." := 10000;
    //     GenJournalLine."Document No." := InvoiceNo;
    //     GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
    //     GenJournalLine."Account No." := SalesInvoiceHeader."Sell-to Customer No.";
    //     GenJournalLine."Description" := 'Payment received for Invoice ' + InvoiceNo;
    //     GenJournalLine.Amount := PaymentAmount;
    //     GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
    //     GenJournalLine."Bal. Account No." := 'BANK001'; // Update with actual bank account
    //     GenJournalLine.Insert();

    //     // Loop through Invoice Lines and create detailed journal entries
    //     LineNo := 20000; // Start bifurcating from 20000
    //     SalesInvoiceLine.SetRange("Document No.", InvoiceNo);
    //     if SalesInvoiceLine.FindSet() then begin
    //         repeat
    //             GenJournalLine.Init();
    //             GenJournalLine."Journal Template Name" := 'CASHRECPT';
    //             GenJournalLine."Journal Batch Name" := 'DEFAULT';
    //             GenJournalLine."Line No." := LineNo;
    //             GenJournalLine."Document No." := InvoiceNo;
    //             GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
    //             GenJournalLine."Account No." := SalesInvoiceLine."No."; // Map item to correct G/L
    //             GenJournalLine."Description" := SalesInvoiceLine.Description;
    //             GenJournalLine.Amount := SalesInvoiceLine."Line Amount";
    //             GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Customer;
    //             GenJournalLine."Bal. Account No." := SalesInvoiceHeader."Sell-to Customer No.";
    //             GenJournalLine.Insert();

    //             LineNo += 10000; // Increment Line No. for next item
    //         until SalesInvoiceLine.Next() = 0;
    //     end;

    //     Message('Cash Receipt Journal Entry created successfully for Invoice %1.', InvoiceNo);
    // end;

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
                // GenJournalLineRec.DeleteAll();
                // GenJournalLineRec.Modify();
                if GenJournalLineRec.FindSet() then begin
                    GenJournalLineRec.DeleteAll();
                end;
                PDCCollectionGL := '2002';
                //  Get Contract Info
                ContractRec.Reset();
                ContractRec.SetRange("Contract ID", PaymentSeriesRec."Contract ID");
                if ContractRec.FindFirst() then


                    //  Dynamically set Tenant Receivable G/L Account based on Property Type
                    case UpperCase(ContractRec."Property Classification") of
                        'RESIDENTIAL':
                            TenantReceivableGL := '1501';
                        'COMMERCIAL':
                            TenantReceivableGL := '1506';
                        else
                            Error('Unsupported Property Classification: %1', ContractRec."Property Classification");
                    end;
            end else
                Error('No contract found with ID %1', PaymentSeriesRec."Contract ID");

            // Loop through Payment Schedule and create individual lines
            PaymentScheduleRec.SetRange("Payment Series", PaymentSeriesRec."Payment Series");
            PaymentScheduleRec.SetRange("Contract ID", PaymentSeriesRec."Contract ID");
            if PaymentScheduleRec.FindSet() then begin
                LineNumber := 0;
                // repeat
                //     COACode.Reset();
                //     COACode.SetRange(Item, PaymentScheduleRec."Secondary Item Type");
                //     if COACode.FindFirst() then begin
                //         BalAccountNo := COACode.COA_Account; // Get linked COA No.
                //     end else begin
                //         ErrorMessage := StrSubstNo('No Chart of Account found for description: %1', PaymentScheduleRec."Secondary Item Type");
                //         Error(ErrorMessage);
                //     end;
                //     LineNumber := GenJournalLineRec."Line No." + 10000;
                //     Clear(GenJournalLineRec);
                //     GenJournalLineRec.Init();
                //     GenJournalLineRec."Journal Template Name" := 'CASH RECE';
                //     GenJournalLineRec."Journal Batch Name" := 'DEFAULT';
                //     GenJournalLineRec."Document No." := Format(PaymentSeriesCode."Entry No.");
                //     GenJournalLineRec."Line No." := LineNumber;
                //     GenJournalLineRec."Posting Date" := Today;
                //     GenJournalLineRec."Document Type" := GenJournalLineRec."Document Type"::Payment;
                //     GenJournalLineRec."Account Type" := GenJournalLineRec."Account Type"::Customer;
                //     GenJournalLineRec."Account No." := PaymentSeriesRec."Tenant Id"; // Customer from Payment Series
                //     GenJournalLineRec."Applies-to Doc. Type" := GenJournalLineRec."Applies-to Doc. Type"::Invoice;
                //     GenJournalLineRec."Applies-to Doc. No." := PaymentSeriesRec."Invoice #";
                //     // GenJournalLineRec."Bal. Account Type" := GenJournalLineRec."Bal. Account Type"::"Bank Account";
                //     GenJournalLineRec."Bal. Account No." := BalAccountNo; // Bank from Payment Series
                //     GenJournalLineRec.Description := PaymentScheduleRec."Secondary Item Type";
                //     GenJournalLineRec.Amount := -PaymentScheduleRec."Amount Including VAT";
                //     GenJournalLineRec."Amount (LCY)" := GenJournalLineRec.Amount;
                //     // BankAccountRec.Reset();
                //     // BankAccountRec.SetRange("Search Name", PaymentSeriesRec."Deposit Bank");
                //     // if BankAccountRec.FindSet() then begin
                //     //     //GenJournalLineRec."Bal. Account No." := BankAccountRec."No.";
                //     //     GenJournalLineRec."Currency Code" := BankAccountRec."Currency Code";
                //     // end;
                //     GenJournalLineRec.Insert();

                //     // Optionally Post the Journal Entry
                //     GenJnlPostLine.RunWithCheck(GenJournalLineRec);

                // until PaymentScheduleRec.Next() = 0;

                LineNumber := GenJournalLineRec."Line No." + 10000;
                Clear(GenJournalLineRec);
                GenJournalLineRec.Init();
                GenJournalLineRec."Journal Template Name" := 'CASH RECE';
                GenJournalLineRec."Journal Batch Name" := 'DEFAULT';
                GenJournalLineRec."Document No." := Format(PaymentSeriesCode."Entry No.");
                GenJournalLineRec."Posting Date" := Today;
                GenJournalLineRec."Line No." := LineNumber;
                GenJournalLineRec."Document Type" := GenJournalLineRec."Document Type"::Payment;
                GenJournalLineRec."Account Type" := GenJournalLineRec."Account Type"::"G/L Account";
                if PaymentSeriesRec."Payment Mode" = 'Cheque' then begin
                    GenJournalLineRec."Account No." := PDCCollectionGL;
                    GenJournalLineRec.Description := PaymentSeriesRec."Cheque Number"; // Customer from Payment Series
                end else begin
                    GenJournalLineRec."Account No." := TenantReceivableGL; // Customer from Payment Series
                end;
                // GenJournalLineRec."Account No." := TenantReceivableGL; // Customer from Payment Series
                GenJournalLineRec.Description := PaymentSeriesRec."Invoice #";
                GenJournalLineRec.Amount := -PaymentSeriesRec."Amount Including VAT";
                GenJournalLineRec."Amount (LCY)" := GenJournalLineRec.Amount;
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
        GenJournalLine.Amount := -PDCTransactionRec.Amount;
        GenJournalLine."Amount (LCY)" := GenJournalLine.Amount;
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