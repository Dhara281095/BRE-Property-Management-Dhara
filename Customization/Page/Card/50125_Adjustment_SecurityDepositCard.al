page 50125 "Adjustment Security Deposit"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Adjustment Security Deposit";
    Caption = 'Adjustment Security Deposit';

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("Main Security Deposit"; Rec."Main Security Deposit")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                }
                field("Security Deposit"; Rec."Security Deposit")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    // Editable = false;
                    trigger OnValidate()
                    begin
                        if (Rec."Status" = Rec."Status"::Approved) then begin
                            AdditinalchargescashReceipt();
                            // receivablecashrecipt();
                        end;
                    end;

                }

                field("Security Amount Status"; Rec."Security Amount Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetControlVisibility();
                        if ShowTerminationCharges then
                            FetchAdditionalChargesData();
                        CurrPage.Update();
                    end;
                }
            }
            group(Adjust_Installment)
            {
                Visible = ShowAdjustInstallment;
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Termination_Charges)
            {
                Visible = ShowTerminationCharges;
                part(TerminationChargesLines; "Termination Charges Sub Card")
                {
                    ApplicationArea = All;
                    SubPageLink = "Contract ID" = field("Contract ID");  // Changed from ID to Contract ID
                    UpdatePropagation = Both;
                }
            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post Entry';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SecurityDepositEntry: Record "Security Deposit Entry";
                    terminationcharges: Record "Termination Charges Sub";
                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    if (Rec."Security Amount Status" = Rec."Security Amount Status"::" ") then
                        Error('Please select Security Amount Status');

                    // if Rec.Amount = 0 then
                    //     Error('Amount must be specified');

                    // Create new entry
                    SecurityDepositEntry.Init();
                    SecurityDepositEntry."Security Deposit ID" := Rec.ID;
                    SecurityDepositEntry."Contract ID" := Rec."Contract ID";
                    SecurityDepositEntry."Main Security Deposit" := Rec."Main Security Deposit";
                    SecurityDepositEntry."Security Deposit" := Rec."Security Deposit";
                    SecurityDepositEntry."Start Date" := Rec."Contract Start Date";
                    SecurityDepositEntry."End Date" := Rec."Contract End Date";
                    SecurityDepositEntry.Status := Rec.Status; // Set initial status as Open
                    SecurityDepositEntry.Insert(true);
                    Message('Entry posted successfully!');

                    // Open the entries list
                    // Page.Run(Page::"Security Deposit Entries");
                end;
            }
        }
    }
    var
        ShowAdjustInstallment: Boolean;
        ShowTerminationCharges: Boolean;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility();
        if ShowTerminationCharges then
            FetchAdditionalChargesData();
    end;

    // trigger OnModifyRecord(): Boolean
    // begin
    //     if (Rec."Status" = Rec."Status"::Approved) then begin
    //         CreateCashReceiptForRefund();
    //  receivablecashrecipt();
    //     end;
    // end;

    local procedure FetchAdditionalChargesData()
    var
        AdditionalCharges: Record "Additional Charges Sub";
        TerminationCharges: Record "Termination Charges Sub";
        FinalCalculation: Record "Final Calculation";
        NextEntryNo: Integer;
    begin
        if Rec."Contract ID" = 0 then
            exit;

        // Check if Final Calculation exists with same Contract ID
        FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
        if not FinalCalculation.FindFirst() then
            exit;

        // Clear existing termination charges for this contract
        TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
        TerminationCharges.DeleteAll();

        // Find the next available Entry No.
        if TerminationCharges.FindLast() then
            NextEntryNo := TerminationCharges."Entry No." + 1
        else
            NextEntryNo := 1; // If no records exist, start from 1

        // Copy data from Additional Charges to Termination Charges
        AdditionalCharges.SetRange("Contract ID", Rec."Contract ID");
        if AdditionalCharges.FindSet() then
            repeat
                TerminationCharges.Init();
                TerminationCharges."Entry No." := NextEntryNo; // Assign unique Entry No.
                TerminationCharges."Contract ID" := Rec."Contract ID";
                TerminationCharges."Secondary Item Type" := AdditionalCharges."Secondary Item Type";
                TerminationCharges.Amount := AdditionalCharges.Amount;
                TerminationCharges."VAT %" := AdditionalCharges."VAT %";
                TerminationCharges."VAT Amount" := AdditionalCharges."VAT Amount";
                TerminationCharges."Amount Including VAT" := AdditionalCharges."Amount Including VAT";
                TerminationCharges."Start Date" := AdditionalCharges."Start Date";
                TerminationCharges."End Date" := AdditionalCharges."End Date";
                TerminationCharges."Posted Invoice ID" := AdditionalCharges."Posted Invoice ID";

                TerminationCharges.Insert();
                NextEntryNo += 1; // Increment for the next record
            until AdditionalCharges.Next() = 0;
    end;

    local procedure SetControlVisibility()
    begin
        case Rec."Security Amount Status" of
            Rec."Security Amount Status"::"Adjust Installment":
                begin
                    ShowAdjustInstallment := true;
                    ShowTerminationCharges := false;
                end;
            Rec."Security Amount Status"::"Termination Charges":
                begin
                    ShowAdjustInstallment := false;
                    ShowTerminationCharges := true;

                    // Clear Adjust Installment fields
                    Rec."Payment Series" := '';
                    Rec.Amount := 0;
                    Rec."VAT Amount" := 0;
                    Rec."Amount Including VAT" := 0;
                    Rec."Due Date" := 0D;
                    Rec.Modify(false);
                end;
            Rec."Security Amount Status"::"All Charges":  // NEW CASE for "All Charges"
                begin
                    ShowAdjustInstallment := true;
                    ShowTerminationCharges := true;
                end;
            else begin
                ShowAdjustInstallment := false;
                ShowTerminationCharges := false;

                // Clear Adjust Installment fields
                Rec."Payment Series" := '';
                Rec.Amount := 0;
                Rec."VAT Amount" := 0;
                Rec."Amount Including VAT" := 0;
                Rec."Due Date" := 0D;
                Rec.Modify(false);
            end;
        end;
    end;

    procedure AdditinalchargescashReceipt()
    var
        GenJnlLine: Record "Gen. Journal Line";
        finalcalculation: Record "Final Calculation";
        TerminationCharges: Record "Termination Charges Sub";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        PostingDate: Date;
        DocumentNo: Code[20];
        InvoiceNo: Code[20];
        Tenantid: Code[20];
        Tenantname: Text[100];
        AccountNo: Code[20];
        LastLineNo: Integer;
        AppliedAmount: Decimal;
        RemainingCharges: Decimal;
        securitydeposit: Decimal;
        chillerdeposit: Decimal;
        otherdeposit: Decimal;
        Totaladdtionalcharges: Decimal;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        JournalTemplateName := 'CASH RECE';
        JournalBatchName := 'DEFAULT';

        if not GenJnlTemplate.Get(JournalTemplateName) then
            Error('The Journal Template %1 does not exist.', JournalTemplateName);

        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlBatch.SetRange(Name, JournalBatchName);
        if not GenJnlBatch.FindFirst() then
            Error('The Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);

        PostingDate := Today();
        DocumentNo := 'REFUND-' + Format(Rec."Contract ID");

        finalcalculation.SetRange("Contract ID", Rec."Contract ID");
        if not finalcalculation.FindFirst() then
            Error('Invoice not found for Contract ID %1', Rec."Contract ID");

        Tenantid := finalcalculation."Tenant ID";
        Tenantname := finalcalculation."Tenant Name";
        securitydeposit := finalcalculation."Net Balance";
        chillerdeposit := finalcalculation."Chiller Deposit";
        otherdeposit := finalcalculation."Other Deposit";

        TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
        if not TerminationCharges.FindFirst() then
            Error('Invoice not found for Contract ID %1', Rec."Contract ID");

        InvoiceNo := TerminationCharges."Posted Invoice ID";

        Totaladdtionalcharges := 0;
        TerminationCharges.Reset();
        TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
        if TerminationCharges.FindSet() then
            repeat
                Totaladdtionalcharges += TerminationCharges."Amount Including VAT";
            until TerminationCharges.Next() = 0;

        RemainingCharges := Totaladdtionalcharges;

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast() then
            LastLineNo := GenJnlLine."Line No." + 10000
        else
            LastLineNo := 10000;

        // === Apply to Security Deposit ===
        if RemainingCharges > 0 then begin
            if RemainingCharges < securitydeposit then
                AppliedAmount := RemainingCharges
            else
                AppliedAmount := securitydeposit;

            if AppliedAmount > 0 then begin
                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Security Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine.Amount := -AppliedAmount;
                GenJnlLine."Amount (LCY)" := -AppliedAmount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4502';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                GenJnlLine.Insert(true);

                RemainingCharges -= AppliedAmount;
                LastLineNo += 10000;
            end;
        end;

        // === Apply to Chiller Deposit ===
        if RemainingCharges > 0 then begin
            if RemainingCharges < chillerdeposit then
                AppliedAmount := RemainingCharges
            else
                AppliedAmount := chillerdeposit;

            if AppliedAmount > 0 then begin
                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Chiller Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine.Amount := -AppliedAmount;
                GenJnlLine."Amount (LCY)" := -AppliedAmount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4508';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                GenJnlLine.Insert(true);

                RemainingCharges -= AppliedAmount;
                LastLineNo += 10000;
            end;
        end;

        // === Apply to Other Deposit ===
        if RemainingCharges > 0 then begin
            if RemainingCharges < otherdeposit then
                AppliedAmount := RemainingCharges
            else
                AppliedAmount := otherdeposit;

            if AppliedAmount > 0 then begin
                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Other Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine.Amount := -AppliedAmount;
                GenJnlLine."Amount (LCY)" := -AppliedAmount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4508';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                GenJnlLine.Insert(true);

                RemainingCharges -= AppliedAmount;
                LastLineNo += 10000;
            end;
        end;

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if not GenJnlLine.IsEmpty() then
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);

        Message('Journal entries have been created and posted successfully');
    end;

    // procedure AdditionalchargescashReceipt()
    // var
    //     GenJnlLine: Record "Gen. Journal Line";
    //     finalcalculation: Record "Final Calculation";
    //     TerminationCharges: Record "Termination Charges Sub";
    //     GenJnlTemplate: Record "Gen. Journal Template";
    //     GenJnlBatch: Record "Gen. Journal Batch";
    //     PostingDate: Date;
    //     DocumentNo: Code[20];
    //     InvoiceNo: Code[20];
    //     Tenantid: Code[20];
    //     Tenantname: Text[100];
    //     AccountNo: Code[20];
    //     LastLineNo: Integer;
    //     AppliedAmount: Decimal;
    //     RemainingCharges: Decimal;
    //     securitydeposit: Decimal;
    //     chillerdeposit: Decimal;
    //     otherdeposit: Decimal;
    //     Totaladdtionalcharges: Decimal;
    //     JournalTemplateName: Code[10];
    //     JournalBatchName: Code[10];
    // begin
    //     // 1. Initialize with default template/batch names or use preset values
    //     JournalTemplateName := 'CASH RECE';
    //     JournalBatchName := 'DEFAULT';

    //     // Key fix: Ensure template name is not empty
    //     if JournalTemplateName = '' then
    //         JournalTemplateName := 'CASH RECE';

    //     // 2. Ensure template exists - create if not
    //     if not GenJnlTemplate.Get(JournalTemplateName) then begin
    //         GenJnlTemplate.Init();
    //         GenJnlTemplate.Name := JournalTemplateName;
    //         GenJnlTemplate.Description := 'Cash Receipts';
    //         GenJnlTemplate.Type := GenJnlTemplate.Type::"Cash Receipts";
    //         // Add basic required fields
    //         GenJnlTemplate."Source Code" := 'CASHRECJNL';
    //         GenJnlTemplate."Force Doc. Balance" := true;
    //         // Insert with validate to fill in any system-required fields
    //         if not GenJnlTemplate.Insert(true) then
    //             Error('Failed to create template %1. Please create it manually.', JournalTemplateName);
    //     end;

    //     // 3. Ensure batch exists - create if not
    //     GenJnlBatch.Reset();
    //     if not GenJnlBatch.Get(JournalTemplateName, JournalBatchName) then begin
    //         GenJnlBatch.Init();
    //         GenJnlBatch."Journal Template Name" := JournalTemplateName;
    //         GenJnlBatch.Name := JournalBatchName;
    //         GenJnlBatch.Description := 'Default Batch';
    //         // Insert with validate to fill in any system-required fields
    //         if not GenJnlBatch.Insert(true) then
    //             Error('Failed to create batch %1. Please create it manually.', JournalBatchName);
    //     end;

    //     // 4. Continue with main logic
    //     PostingDate := Today();
    //     DocumentNo := 'REFUND-' + Format(Rec."Contract ID");

    //     // Get final calculation data
    //     finalcalculation.SetRange("Contract ID", Rec."Contract ID");
    //     if not finalcalculation.FindFirst() then
    //         Error('Final calculation not found for Contract ID %1', Rec."Contract ID");

    //     Tenantid := finalcalculation."Tenant ID";
    //     Tenantname := finalcalculation."Tenant Name";
    //     securitydeposit := finalcalculation."Net Balance";
    //     chillerdeposit := finalcalculation."Chiller Deposit";
    //     otherdeposit := finalcalculation."Other Deposit";

    //     // Get posted invoice
    //     TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
    //     if not TerminationCharges.FindFirst() then
    //         Error('Termination charges not found for Contract ID %1', Rec."Contract ID");

    //     InvoiceNo := TerminationCharges."Posted Invoice ID";

    //     // Calculate total additional charges
    //     Totaladdtionalcharges := 0;
    //     TerminationCharges.Reset();
    //     TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
    //     if TerminationCharges.FindSet() then
    //         repeat
    //             Totaladdtionalcharges += TerminationCharges."Amount Including VAT";
    //         until TerminationCharges.Next() = 0;

    //     RemainingCharges := Totaladdtionalcharges;

    //     // Clear any existing journal lines to avoid conflicts
    //     ClearJournalLines(JournalTemplateName, JournalBatchName);

    //     // Get last line number
    //     GenJnlLine.Reset();
    //     GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
    //     GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
    //     if GenJnlLine.FindLast() then
    //         LastLineNo := GenJnlLine."Line No." + 10000
    //     else
    //         LastLineNo := 10000;

    //     // Apply to Security Deposit
    //     if RemainingCharges > 0 then begin
    //         AppliedAmount := RemainingCharges < securitydeposit ? RemainingCharges : securitydeposit;
    //         if AppliedAmount > 0 then begin
    //             InsertJournalLine(LastLineNo, PostingDate, DocumentNo, Tenantname + ' - Security Deposit',
    //                             Tenantid, -AppliedAmount, '4502', InvoiceNo, JournalTemplateName, JournalBatchName);
    //             RemainingCharges -= AppliedAmount;
    //             LastLineNo += 10000;
    //         end;
    //     end;

    //     // Apply to Chiller Deposit
    //     if RemainingCharges > 0 then begin
    //         AppliedAmount := RemainingCharges < chillerdeposit ? RemainingCharges : chillerdeposit;
    //         if AppliedAmount > 0 then begin
    //             InsertJournalLine(LastLineNo, PostingDate, DocumentNo, Tenantname + ' - Chiller Deposit',
    //                             Tenantid, -AppliedAmount, '4508', InvoiceNo, JournalTemplateName, JournalBatchName);
    //             RemainingCharges -= AppliedAmount;
    //             LastLineNo += 10000;
    //         end;
    //     end;

    //     // Apply to Other Deposit
    //     if RemainingCharges > 0 then begin
    //         AppliedAmount := RemainingCharges < otherdeposit ? RemainingCharges : otherdeposit;
    //         if AppliedAmount > 0 then begin
    //             InsertJournalLine(LastLineNo, PostingDate, DocumentNo, Tenantname + ' - Other Deposit',
    //                             Tenantid, -AppliedAmount, '4508', InvoiceNo, JournalTemplateName, JournalBatchName);
    //             RemainingCharges -= AppliedAmount;
    //             LastLineNo += 10000;
    //         end;
    //     end;

    //     // Post journal lines
    //     GenJnlLine.Reset();
    //     GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
    //     GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
    //     if not GenJnlLine.IsEmpty() then begin
    //         Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
    //         Message('Journal entries have been successfully created and posted');
    //     end else
    //         Message('No journal entries were created');
    // end;

    // // Helper procedure to clear existing journal lines
    // local procedure ClearJournalLines(TemplateName: Code[10]; BatchName: Code[10])
    // var
    //     GenJnlLine: Record "Gen. Journal Line";
    // begin
    //     GenJnlLine.Reset();
    //     GenJnlLine.SetRange("Journal Template Name", TemplateName);
    //     GenJnlLine.SetRange("Journal Batch Name", BatchName);
    //     if not GenJnlLine.IsEmpty() then
    //         GenJnlLine.DeleteAll();
    // end;

    // local procedure InsertJournalLine(
    //     LineNo: Integer;
    //     PostDate: Date;
    //     DocNo: Code[20];
    //     Desc: Text[100];
    //     AccNo: Code[20];
    //     Amt: Decimal;
    //     BalAcc: Code[20];
    //     Invoice: Code[20];
    //     Template: Code[10];
    //     Batch: Code[10])
    // var
    //     JnlLine: Record "Gen. Journal Line";
    // begin
    //     JnlLine.Init();
    //     JnlLine."Journal Template Name" := Template;
    //     JnlLine."Journal Batch Name" := Batch;
    //     JnlLine."Line No." := LineNo;
    //     JnlLine."Posting Date" := PostDate;
    //     JnlLine."Document Type" := JnlLine."Document Type"::Payment;
    //     JnlLine."Document No." := DocNo;
    //     JnlLine.Description := Desc;
    //     JnlLine."Account Type" := JnlLine."Account Type"::Customer;
    //     JnlLine."Account No." := AccNo;
    //     JnlLine.Amount := Amt;
    //     JnlLine."Amount (LCY)" := Amt;
    //     JnlLine."Bal. Account Type" := JnlLine."Bal. Account Type"::"G/L Account";
    //     JnlLine."Bal. Account No." := BalAcc;
    //     JnlLine."Applies-to Doc. Type" := JnlLine."Applies-to Doc. Type"::Invoice;
    //     JnlLine."Applies-to Doc. No." := Invoice;
    //     JnlLine.Insert(true);
    // end;

}
