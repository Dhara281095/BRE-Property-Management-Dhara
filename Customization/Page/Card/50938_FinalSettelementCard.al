page 50938 "FinalSettlemtCard"
{
    PageType = ListPart;
    SourceTable = "FinalSettlement";
    ApplicationArea = All;
    Caption = 'Final Settlement Details';
    //UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(ReceivableDetails)
            {
                Caption = 'Receivable Details';
                field("Receivable from the Tenant"; Rec."Receivable from the Tenant")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Payment Processed"; Rec."Payment Processed")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Balance Receivable"; Rec."Balance Receivable")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("PaymentStatus"; Rec."PaymentStatus")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
            }


            repeater(ReceivablePaymentDetails)
            {
                Caption = 'Receivable Payment Details';
                // Editable = (Rec."Receivable Payment Status" <> PaymentStatus::Received);
                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'FC ID';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                }
                field("Receivable Total Amount"; Rec."Receivable Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Receivable Due Date"; Rec."Receivable Due Date")
                {
                    ApplicationArea = All;
                }
                field("Receivable Payment mode"; Rec."Receivable Payment mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Receivable Payment Status"; Rec."Receivable Payment Status")
                {
                    ApplicationArea = All;
                    //Editable = false;

                    trigger OnValidate()
                    var
                        PaymentStatus: Enum "Payment Status";
                    begin
                        // Check if Receivable Payment Status is 'Received'
                        if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
                            // Set PaymentStatus to 'Received' as well
                            Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                            Rec.Modify();  // Save changes to the current record
                        end;

                        if Rec."Receivable Payment Status" <> PaymentStatus::Received then begin
                            // Set PaymentStatus to 'Received' as well
                            Rec."PaymentStatus" := Rec."PaymentStatus"::Pending;
                            Rec.Modify();  // Save changes to the current record
                        end;
                    end;
                }
                field("Receivable Cheque No."; Rec."Receivable Cheque No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        paymentmode: Record "Payment Type";
                    begin
                        if Rec."Receivable Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;
                }

                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;

                    trigger OnValidate()
                    var
                        paymentmode: Record "Payment Type";
                    begin
                        if Rec."Receivable Payment Mode" = 'Cash' then
                            Error('Deposit Bank is not valid for Cash');
                    end;
                }

                field("Deposit Status"; Rec."Deposit Status")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnValidate()
                    var
                        paymentmode: Record "Payment Type";
                    begin
                        if Rec."Receivable Payment Mode" = 'Cash' then
                            Error('Deposit Bank is not valid for Cash');
                    end;
                }

                field("Payment Receipt"; Rec."Payment Receipt")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt';
                    //  Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."Payment Receipt document URL";


                        if FileURL = '' then
                            Error('No document is available to view.');


                        OpenFileInBrowser1(FileURL);
                    end;
                }
                field("Payment Receipt document URL"; Rec."Payment Receipt document URL")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt document URL';
                    // Visible = false;
                }


                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    // Visible = false;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                    // Editable = false;
                }
                // field("Entry No."; Rec."Entry No.")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     //  Visible = false;
                // }
            }
        }
    }



    procedure OpenFileInBrowser1(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    /////////////////////////// SALES INVOICE //////////////////////////////////////

    trigger OnModifyRecord(): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin

        /////////////////////////// Receivable final settlement /////////////////////////////////

        if Rec."Receivable Cheque No." = '' then
            Rec."Receivable Cheque No." := '-';

        if Rec."Receivable Payment mode" = '' then begin
            if paymentTypeRec.FindFirst() then
                Rec."Receivable Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindSet() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Receivable from the Tenant" := finalCalculationgrid."Net Receivable From The Tenant";
            Rec."Balance Receivable" := Rec."Receivable from the Tenant";
            Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";
            if Rec."Receivable Payment Status" = PaymentStatus::" " then
                Rec."Receivable Payment Status" := PaymentStatus::Scheduled;

            if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                Rec."Balance Receivable" := 0;
                Rec."Payment Processed" := Rec."Receivable from the Tenant";
                receivecashrecipt();
                receivablecashrecipt();
                Rec.Modify();
            end;

            if Rec."Receivable Payment Status" = PaymentStatus::Received then
                exit;

            if Rec."Receivable Due Date" = Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Due;
            end
            else if Rec."Receivable Due Date" > Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Scheduled;
            end
            else if Rec."Receivable Due Date" = 0D then begin
                Rec."Receivable Payment Status" := PaymentStatus::Scheduled;
            end
            else if Rec."Receivable Due Date" < Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Overdue;
            end;
            Rec.Modify();
        end;
    end;

    trigger OnAfterGetRecord()
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin

        /////////////////////////// Receivable final settlement /////////////////////////////////

        if Rec."Receivable Cheque No." = '' then
            Rec."Receivable Cheque No." := '-';

        if Rec."Receivable Payment mode" = '' then begin
            if paymentTypeRec.FindFirst() then
                Rec."Receivable Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindSet() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Receivable from the Tenant" := finalCalculationgrid."Net Receivable From The Tenant";
            Rec."Balance Receivable" := Rec."Receivable from the Tenant";
            Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";
            if Rec."Receivable Payment Status" = PaymentStatus::" " then
                Rec."Receivable Payment Status" := PaymentStatus::Scheduled;

            if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                Rec."Balance Receivable" := 0;
                Rec."Payment Processed" := Rec."Receivable from the Tenant";
                receivecashrecipt();
                receivablecashrecipt();
                Rec.Modify();
            end;

            if Rec."Receivable Payment Status" = PaymentStatus::Received then
                exit;

            if Rec."Receivable Due Date" = Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Due;
            end
            else if Rec."Receivable Due Date" > Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Scheduled;
            end
            else if Rec."Receivable Due Date" = 0D then begin
                Rec."Receivable Payment Status" := PaymentStatus::Scheduled;
            end
            else if Rec."Receivable Due Date" < Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Overdue;
            end;
            Rec.Modify();

        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin

        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;

        /////////////////////////// Receivable final settlement /////////////////////////////////

        if Rec."Receivable Cheque No." = '' then
            Rec."Receivable Cheque No." := '-';

        if Rec."Receivable Payment mode" = '' then begin
            if paymentTypeRec.FindFirst() then
                Rec."Receivable Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindSet() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Receivable from the Tenant" := finalCalculationgrid."Net Receivable From The Tenant";
            Rec."Balance Receivable" := Rec."Receivable from the Tenant";
            Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";
            // finalCalculationgrid.SetRange("Tenant ID", Rec."Receivable Tenant ID");
            if Rec."Receivable Payment Status" = PaymentStatus::" " then
                Rec."Receivable Payment Status" := PaymentStatus::Scheduled;

            if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                Rec."Balance Receivable" := 0;
                Rec."Payment Processed" := Rec."Receivable from the Tenant";
                receivecashrecipt();
                receivablecashrecipt();
                Rec.Modify();
            end;

            if Rec."Receivable Payment Status" = PaymentStatus::Received then
                exit;

            if Rec."Receivable Due Date" = Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Due;
            end
            else if Rec."Receivable Due Date" > Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Scheduled;
            end
            else if Rec."Receivable Due Date" = 0D then begin
                Rec."Receivable Payment Status" := PaymentStatus::Scheduled;
            end
            else if Rec."Receivable Due Date" < Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Overdue;
            end;
            Rec.Modify();

        end;


    end;

    // trigger OnAfterGetCurrRecord()
    // var
    //     finalcalculationcard: Record "Final Calculation";
    //     PaymentStatus: Enum "Payment Status";

    // begin

    //     finalcalculationcard.SetRange("FC ID", Rec."FC ID");
    //     if finalcalculationcard.FindSet() then begin
    //         Rec."Contract ID" := finalcalculationcard."Contract ID";
    //         Rec."Tenant ID" := finalcalculationcard."Tenant ID";
    //         Rec."Receivable from the Tenant" := finalcalculationcard."Net Receivable From The Tenant";
    //         Rec."Balance Receivable" := Rec."Receivable from the Tenant";
    //         Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";


    //         if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
    //             Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
    //             Rec."Balance Receivable" := 0;
    //             Rec."Payment Processed" := Rec."Receivable from the Tenant";
    //             Rec.Modify();
    //         end;

    //         if Rec."Receivable Payment Status" <> PaymentStatus::Received then begin
    //             Rec."PaymentStatus" := Rec."PaymentStatus"::Pending;
    //             Rec."Balance Receivable" := Rec."Receivable from the Tenant";
    //             Rec."Payment Processed" := 0;
    //             Rec.Modify();
    //         end;

    //         // if finalcalculationcard."Net Receivable From The Tenant" <> 0 then
    //         //     IsReceivable := true
    //         // else
    //         //     IsReceivable := false;
    //         // Rec.Modify();
    //     end;
    // end;

    // trigger OnOpenPage()
    // var
    //     finalcalculationcard1: Record "Final Calculation";
    //     PaymentStatus: Enum "Payment Status";


    // begin
    //     finalcalculationcard1.SetRange("FC ID", Rec."FC ID");
    //     if finalcalculationcard1.FindSet() then begin
    //         Rec."Contract ID" := finalcalculationcard1."Contract ID";
    //         Rec."Tenant ID" := finalcalculationcard1."Tenant ID";
    //         Rec."Receivable from the Tenant" := finalcalculationcard1."Net Receivable From The Tenant";
    //         Rec."Balance Receivable" := Rec."Receivable from the Tenant";
    //         Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";


    //         if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
    //             Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
    //             Rec."Balance Receivable" := 0;
    //             Rec."Payment Processed" := Rec."Receivable from the Tenant";
    //             Rec.Modify();
    //         end;

    //         if Rec."Receivable Payment Status" <> PaymentStatus::Received then begin
    //             Rec."PaymentStatus" := Rec."PaymentStatus"::Pending;
    //             Rec."Balance Receivable" := Rec."Receivable from the Tenant";
    //             Rec."Payment Processed" := 0;
    //             Rec.Modify();
    //         end;

    //         // if finalcalculationcard1."Net Receivable From The Tenant" <> 0 then
    //         //     IsReceivable := true
    //         // else
    //         //     IsReceivable := false;
    //         // Rec.Modify();
    //     end;
    // end;


    procedure SetContractID(pContractID: Integer)
    begin
        contractID := pContractID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;

    var

        contractID: Integer;
        tenantID: Code[20];
        IsRefundable: Boolean;
        IsReceivable: Boolean;
        PaymentStatus: Enum "Payment Status";


    procedure receivecashrecipt()
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
        finalsettlement: Record "FinalSettlement";

    begin
        GenJnlTemplate := 'CASH RECE';
        GenJnlBatch := 'DEFAULT';
        PostingDate := Today(); // You can replace with actual Posting Date
        DocumentNo := 'RECEIVE-' + Format(Rec."Contract ID"); // Customize as needed
        // AccountNo := '3001'; // Cash Account G/L
        // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

        // Fetch tenant details from Final Calculation
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", Rec."Contract ID");
        if finalcalculation.FindFirst() then begin
            Tenantid := finalcalculation."Tenant ID";
            Tenantname := finalcalculation."Tenant Name";
        end else
            Message('Final Calculation not found for Contract ID %1', Rec."Contract ID");

        // Determine Bal. Account based on Refund Payment Mode
        finalsettlement.Reset();
        finalsettlement.SetRange("FC ID", Rec."FC ID");
        if finalsettlement.FindFirst() then begin
            if UpperCase(finalsettlement."Receivable Payment mode") = 'CASH' then begin
                AccountNo := '3001'; // Cash G/L Account
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            end else begin
                AccountNo := '3002';
                // AccountNo := finalsettlement."Deposit Bank"; // This should be a valid Bank Account No.
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

                if AccountNo = '' then
                    Message('Bank Account No. not found in Final Settlement for Contract ID %1', Rec."Contract ID");
            end;
        end else
            Message('Final Settlement not found for Contract ID %1', Rec."Contract ID");


        // Sum Additional Charges and fetch Invoice No.
        TotalRefundableDeposit := 0;
        InvoiceNo := '';
        TerminationChargesub.Reset();
        TerminationChargesub.SetRange("Contract ID", Rec."Contract ID");
        if TerminationChargesub.FindSet() then begin
            repeat
                TotalRefundableDeposit += TerminationChargesub."Amount Including VAT";
                if InvoiceNo = '' then
                    InvoiceNo := TerminationChargesub."Posted Invoice ID";
            until TerminationChargesub.Next() = 0;
        end else
            Message('Additional charges not found for Contract ID %1', Rec."Contract ID");

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
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
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


    procedure receivablecashrecipt()
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
        finalsettlement: Record "FinalSettlement";

    begin
        GenJnlTemplate := 'CASH RECE';
        GenJnlBatch := 'DEFAULT';
        PostingDate := Today(); // You can replace with actual Posting Date
        DocumentNo := 'RECEIVE-' + Format(Rec."Contract ID"); // Customize as needed
        // AccountNo := '3001'; // Cash Account G/L
        // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

        // Fetch tenant details from Final Calculation
        finalcalculation.Reset();
        finalcalculation.SetRange("Contract ID", Rec."Contract ID");
        if finalcalculation.FindFirst() then begin
            Tenantid := finalcalculation."Tenant ID";
            Tenantname := finalcalculation."Tenant Name";
        end else
            Error('Final Calculation not found for Contract ID %1', Rec."Contract ID");

        // Determine Bal. Account based on Refund Payment Mode
        finalsettlement.Reset();
        finalsettlement.SetRange("FC ID", Rec."FC ID");
        if finalsettlement.FindFirst() then begin
            if UpperCase(finalsettlement."Receivable Payment mode") = 'CASH' then begin
                AccountNo := '3001'; // Cash G/L Account
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            end else begin
                // AccountNo := finalsettlement."Deposit Bank"; // This should be a valid Bank Account No.
                AccountNo := '3002';
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

                if AccountNo = '' then
                    Message('Bank Account No. not found in Final Settlement for Contract ID %1', Rec."Contract ID");
            end;
        end else
            Message('Final Settlement not found for Contract ID %1', Rec."Contract ID");


        // 2. Find Invoice No. based on Contract ID
        billingcalculation.SetRange("Contract ID", Rec."Contract ID");
        if billingcalculation.FindSet() then begin
            InvoiceNo := billingcalculation."Posted Invoice ID";
            TotalRefundableDeposit := billingcalculation."Invoice Amount";

            if TotalRefundableDeposit <= 0 then begin
                Message('Invoice amount is zero or negative. No journal entry created.');
                exit;
            end;

        end else
            Error('Invoice not found for Contract ID %1', finalcalculation."Contract ID");

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
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
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

}