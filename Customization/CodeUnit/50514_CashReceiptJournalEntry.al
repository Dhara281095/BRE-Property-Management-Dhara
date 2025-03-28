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
        LineNumber: Integer;
        BalAccountNo: Code[20];
        BatchName: Code[20];
    begin
        // Find the Payment Series Record
        // PaymentSeriesRec.Reset();
        PaymentSeriesRec.SetFilter("Payment Series", '%1', PaymentSeriesCode."Payment Series");
        PaymentSeriesRec.SetFilter("Contract ID", Format(PaymentSeriesCode."Contract ID"));
        if PaymentSeriesRec.FindFirst() then begin
            if PaymentSeriesCode."Payment Status" = PaymentSeriesCode."Payment Status"::Received then begin

                // // Create a new Journal Batch (if not exist)
                // if not GenJournalBatchRec.Get('CASH', 'REVENUE') then begin
                //     GenJournalBatchRec.Init();
                //     GenJournalBatchRec."Journal Template Name" := 'CASH';
                //     GenJournalBatchRec."Name" := 'REVENUE';
                //     GenJournalBatchRec.Insert();
                // end;

                // Loop through Payment Schedule and create individual lines
                PaymentScheduleRec.SetRange("Payment Series", PaymentSeriesRec."Payment Series");
                PaymentScheduleRec.SetRange("Contract ID", PaymentSeriesRec."Contract ID");
                if PaymentScheduleRec.FindSet() then begin
                    LineNumber := 0;
                    repeat
                        COACode.Reset();
                        COACode.SetRange(Item, PaymentScheduleRec."Secondary Item Type");
                        if COACode.FindFirst() then begin
                            BalAccountNo := COACode.COA_Account; // Get linked COA No.
                        end else begin
                            Error('No Chart of Account found for description: %1', PaymentScheduleRec."Secondary Item Type");
                        end;
                        LineNumber := GenJournalLineRec."Line No." + 10000;
                        Clear(GenJournalLineRec);
                        GenJournalLineRec.Init();
                        GenJournalLineRec."Journal Template Name" := 'CASH RECE';
                        GenJournalLineRec."Journal Batch Name" := 'DEFAULT';
                        GenJournalLineRec."Document No." := Format(PaymentSeriesCode."Entry No.");
                        GenJournalLineRec."Line No." := LineNumber;
                        GenJournalLineRec."Posting Date" := Today;
                        GenJournalLineRec."Document Type" := GenJournalLineRec."Document Type"::Payment;
                        GenJournalLineRec."Account Type" := GenJournalLineRec."Account Type"::Customer;
                        GenJournalLineRec."Account No." := PaymentSeriesRec."Tenant Id"; // Customer from Payment Series
                        GenJournalLineRec."Applies-to Doc. Type" := GenJournalLineRec."Applies-to Doc. Type"::Invoice;
                        GenJournalLineRec."Applies-to Doc. No." := PaymentSeriesRec."Invoice #";
                        // GenJournalLineRec."Bal. Account Type" := GenJournalLineRec."Bal. Account Type"::"Bank Account";
                        GenJournalLineRec."Bal. Account No." := BalAccountNo; // Bank from Payment Series
                        GenJournalLineRec.Description := PaymentScheduleRec."Secondary Item Type";
                        GenJournalLineRec.Amount := -PaymentSeriesRec."Amount Including VAT";
                        GenJournalLineRec."Amount (LCY)" := GenJournalLineRec.Amount;
                        GenJournalLineRec.Insert();

                        // Optionally Post the Journal Entry
                        GenJnlPostLine.RunWithCheck(GenJournalLineRec);


                        // **Delete the Journal Line After Posting**
                        GenJournalLineRec.Reset();
                        GenJournalLineRec.SetRange("Journal Template Name", 'CASH RECE');
                        GenJournalLineRec.SetRange("Journal Batch Name", 'DEFAULT');
                        GenJournalLineRec.SetRange("Document No.", Format(PaymentSeriesCode."Entry No."));

                        if GenJournalLineRec.FindSet() then begin
                            GenJournalLineRec.DeleteAll();
                        end;

                    until PaymentScheduleRec.Next() = 0;
                    Message('Cash Receipt journal created successfully.');
                end;
                // Message('1111');
            end;
            // Message('22222');
        end;
        // Message('33333');
    end;

    var
        myInt: Integer;
}