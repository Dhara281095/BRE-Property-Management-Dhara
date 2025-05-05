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
                            Additinalchargescashreceipt();
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


    procedure Additinalchargescashreceipt()
    var
        GenJnlLine: Record "Gen. Journal Line";
        finalcalculation: Record "Final Calculation";
        TerminationCharges: Record "Termination Charges Sub";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        TenancyContract: Record "Tenancy Contract"; // Added to get property classification
        SelectedTemplate: Code[10];
        SelectedBatch: Code[10];
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
        SecurityDepositAccount: Code[20]; // For storing the G/L account based on property classification
        ChillerDepositAccount: Code[20]; // Account for chiller deposit
        OtherDepositAccount: Code[20]; // Account for other deposit

    begin
        // Find a valid General Journal Template for cash receipts
        if not FindCashReceiptTemplate(SelectedTemplate, SelectedBatch) then
            Error('No suitable journal template and batch found. Please create a cash receipt journal template and batch.');

        PostingDate := Today();
        DocumentNo := 'REFUND-' + Format(Rec."Contract ID");

        // 1. Get final calculation data
        finalcalculation.SetRange("Contract ID", Rec."Contract ID");
        if not finalcalculation.FindFirst() then
            Error('Invoice not found for Contract ID %1', Rec."Contract ID");

        Tenantid := finalcalculation."Tenant ID";
        Tenantname := finalcalculation."Tenant Name";
        securitydeposit := finalcalculation."Net Balance";
        chillerdeposit := finalcalculation."Chiller Deposit";
        otherdeposit := finalcalculation."Other Deposit";

        // 2. Get posted invoice
        TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
        if not TerminationCharges.FindFirst() then
            Error('Invoice not found for Contract ID %1', Rec."Contract ID");

        InvoiceNo := TerminationCharges."Posted Invoice ID";

        // 3. Calculate total additional charges
        repeat
            Totaladdtionalcharges += TerminationCharges."Amount Including VAT";
        until TerminationCharges.Next() = 0;

        RemainingCharges := Totaladdtionalcharges;

        // 4. Get last line number
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", SelectedTemplate);
        GenJnlLine.SetRange("Journal Batch Name", SelectedBatch);
        if GenJnlLine.FindLast() then
            LastLineNo := GenJnlLine."Line No." + 1
        else
            LastLineNo := 1;

        // 5. Get property classification from Tenancy Contract
        TenancyContract.Reset();
        TenancyContract.SetRange("Contract ID", Rec."Contract ID");
        if not TenancyContract.FindFirst() then
            Error('Tenancy Contract not found for Contract ID %1', Rec."Contract ID");

        // 6. Determine G/L accounts based on property classification
        // Default account for security deposit
        SecurityDepositAccount := '4502';
        // Specific accounts for chiller deposit and other deposit
        ChillerDepositAccount := '4508'; // Chiller deposit refund account
        OtherDepositAccount := '4508';   // Using same account for other deposit

        // Check the property classification and set appropriate account for security deposit
        if TenancyContract.Get(Rec."Contract ID") then begin
            if HasResidentialClassification(TenancyContract) then
                SecurityDepositAccount := '1501' // Residential tenant receivable G/L account
            else if HasCommercialClassification(TenancyContract) then
                SecurityDepositAccount := '1506'; // Commercial tenant receivable G/L account
        end;

        // === Apply to Security Deposit ===
        if RemainingCharges > 0 then begin
            if RemainingCharges < securitydeposit then
                AppliedAmount := RemainingCharges
            else
                AppliedAmount := securitydeposit;

            if AppliedAmount > 0 then begin
                InsertJournalLine(LastLineNo, PostingDate, DocumentNo, Tenantname + ' Security Deposit',
                                  Tenantid, -AppliedAmount, SecurityDepositAccount, InvoiceNo, SelectedTemplate, SelectedBatch);
                RemainingCharges -= AppliedAmount;
                LastLineNo += 10000;
            end;
        end;

        // === Apply to Chiller Deposit ===
        if RemainingCharges > 0 then begin
            // Chiller Deposit
            if RemainingCharges < chillerdeposit then
                AppliedAmount := RemainingCharges
            else
                AppliedAmount := chillerdeposit;
            if AppliedAmount > 0 then begin
                InsertJournalLine(LastLineNo, PostingDate, DocumentNo, Tenantname + ' Chiller Deposit',
                                  Tenantid, -AppliedAmount, ChillerDepositAccount, InvoiceNo, SelectedTemplate, SelectedBatch);
                RemainingCharges -= AppliedAmount;
                LastLineNo += 10000;
            end;
        end;

        // === Apply to Other Deposit ===
        if RemainingCharges > 0 then begin
            // Other Deposit
            if RemainingCharges < otherdeposit then
                AppliedAmount := RemainingCharges
            else
                AppliedAmount := otherdeposit;
            if AppliedAmount > 0 then begin
                InsertJournalLine(LastLineNo, PostingDate, DocumentNo, Tenantname + ' Other Deposit',
                                  Tenantid, -AppliedAmount, OtherDepositAccount, InvoiceNo, SelectedTemplate, SelectedBatch);
                RemainingCharges -= AppliedAmount;
                LastLineNo += 10000;
            end;
        end;
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
        Message('Journal entries have been created and posted successfully');
    end;

    // New procedure to find an available cash receipt template and batch
    local procedure FindCashReceiptTemplate(var TemplateName: Code[10]; var BatchName: Code[10]): Boolean
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        // First try to find a cash receipt template
        GenJnlTemplate.Reset();
        GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::"Cash Receipts");
        if GenJnlTemplate.FindFirst() then begin
            TemplateName := GenJnlTemplate.Name;

            // Now find a batch in this template
            GenJnlBatch.Reset();
            GenJnlBatch.SetRange("Journal Template Name", TemplateName);
            if GenJnlBatch.FindFirst() then begin
                BatchName := GenJnlBatch.Name;
                exit(true);
            end;
        end;

        // If no cash receipt template found, try to find any general journal template
        GenJnlTemplate.Reset();
        if GenJnlTemplate.FindFirst() then begin
            TemplateName := GenJnlTemplate.Name;

            // Find a batch in this template
            GenJnlBatch.Reset();
            GenJnlBatch.SetRange("Journal Template Name", TemplateName);
            if GenJnlBatch.FindFirst() then begin
                BatchName := GenJnlBatch.Name;
                exit(true);
            end;
        end;

        exit(false); // No suitable template and batch found
    end;

    // Check if tenancy contract has residential classification
    local procedure HasResidentialClassification(TenancyContract: Record "Tenancy Contract"): Boolean
    var
        PropertyClassification: Text;
    begin
        PropertyClassification := Format(TenancyContract."Property Classification");
        exit((PropertyClassification = 'Residential') or (PropertyClassification = '0'));
    end;

    // Check if tenancy contract has commercial classification
    local procedure HasCommercialClassification(TenancyContract: Record "Tenancy Contract"): Boolean
    var
        PropertyClassification: Text;
    begin
        PropertyClassification := Format(TenancyContract."Property Classification");
        exit((PropertyClassification = 'Commercial') or (PropertyClassification = '1'));
    end;

    local procedure InsertJournalLine(LineNo: Integer; PostDate: Date; DocNo: Code[20]; Desc: Text[100]; AccNo: Code[20];
                                      Amt: Decimal; BalAcc: Code[20]; Invoice: Code[20];
                                      Template: Code[10]; Batch: Code[10])

    var
        JnlLine: Record "Gen. Journal Line";
    begin
        Clear(JnlLine);
        JnlLine.Init();
        JnlLine."Journal Template Name" := Template;
        JnlLine."Journal Batch Name" := Batch;
        JnlLine."Line No." := LineNo;
        JnlLine."Posting Date" := PostDate;
        JnlLine."Document Type" := JnlLine."Document Type"::Payment;
        JnlLine."Document No." := DocNo;
        JnlLine.Description := Desc;
        JnlLine."Account Type" := JnlLine."Account Type"::Customer;
        JnlLine."Account No." := AccNo;
        JnlLine.Amount := Amt;
        JnlLine."Amount (LCY)" := Amt;
        JnlLine."Bal. Account Type" := JnlLine."Bal. Account Type"::"G/L Account";
        JnlLine."Bal. Account No." := BalAcc;
        JnlLine."Applies-to Doc. Type" := JnlLine."Applies-to Doc. Type"::Invoice;
        JnlLine."Applies-to Doc. No." := Invoice;
        JnlLine.Insert(true);
    end;


    // procedure Additinalchargescashreceipt()
    // var
    //     GenJnlLine: Record "Gen. Journal Line";
    //     finalcalculation: Record "Final Calculation";
    //     TerminationCharges: Record "Termination Charges Sub";
    //     AdditionalChargesSub: Record "Additional Charges Sub";
    //     GenJnlTemplate: Record "Gen. Journal Template";
    //     GenJnlBatch: Record "Gen. Journal Batch";
    //     TenancyContract: Record "Tenancy Contract";
    //     SelectedTemplate: Code[10];
    //     SelectedBatch: Code[10];
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
    //     TotalAdditionalChargesSubAmount: Decimal;
    //     SecurityDepositAccount: Code[20];
    //     ChillerDepositAccount: Code[20];
    //     OtherDepositAccount: Code[20];
    // begin
    //     if not FindCashReceiptTemplate(SelectedTemplate, SelectedBatch) then
    //         Error('No suitable journal template and batch found.');

    //     PostingDate := Today();
    //     DocumentNo := 'REFUND-' + Format(Rec."Contract ID");

    //     finalcalculation.SetRange("Contract ID", Rec."Contract ID");
    //     if not finalcalculation.FindFirst() then
    //         Error('Final Calculation not found for Contract ID %1', Rec."Contract ID");

    //     Tenantid := finalcalculation."Tenant ID";
    //     Tenantname := finalcalculation."Tenant Name";
    //     securitydeposit := finalcalculation."Net Balance";
    //     chillerdeposit := finalcalculation."Chiller Deposit";
    //     otherdeposit := finalcalculation."Other Deposit";

    //     TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
    //     if not TerminationCharges.FindFirst() then
    //         Error('Termination Charges not found for Contract ID %1', Rec."Contract ID");

    //     InvoiceNo := TerminationCharges."Posted Invoice ID";

    //     // Read from Additional Charges Sub table
    //     AdditionalChargesSub.SetRange("Contract ID", Rec."Contract ID");
    //     if AdditionalChargesSub.FindSet() then begin
    //         repeat
    //             TotalAdditionalChargesSubAmount += AdditionalChargesSub."Total Amount";
    //         until AdditionalChargesSub.Next() = 0;
    //     end;

    //     RemainingCharges := TotalAdditionalChargesSubAmount;

    //     GenJnlLine.Reset();
    //     GenJnlLine.SetRange("Journal Template Name", SelectedTemplate);
    //     GenJnlLine.SetRange("Journal Batch Name", SelectedBatch);
    //     if GenJnlLine.FindLast() then
    //         LastLineNo := GenJnlLine."Line No." + 10000
    //     else
    //         LastLineNo := 10000;

    //     TenancyContract.SetRange("Contract ID", Rec."Contract ID");
    //     if not TenancyContract.FindFirst() then
    //         Error('Tenancy Contract not found for Contract ID %1', Rec."Contract ID");

    //     // Set default and classification-based accounts
    //     SecurityDepositAccount := '4502'; // default
    //     ChillerDepositAccount := '4508';
    //     OtherDepositAccount := '4508';

    //     if HasResidentialClassification(TenancyContract) then
    //         SecurityDepositAccount := '1501'
    //     else if HasCommercialClassification(TenancyContract) then
    //         SecurityDepositAccount := '1506';

    //     // === Apply to Security Deposit ===
    //         if RemainingCharges > 0 then begin
    //             if RemainingCharges < securitydeposit then
    //                 AppliedAmount := RemainingCharges
    //             else
    //                 AppliedAmount := securitydeposit;

    //             if AppliedAmount > 0 then begin
    //                 InsertJournalLine(LastLineNo, PostingDate, DocumentNo, Tenantname + ' Security Deposit',
    //                                   Tenantid, -AppliedAmount, SecurityDepositAccount, InvoiceNo, SelectedTemplate, SelectedBatch);
    //                 RemainingCharges -= AppliedAmount;
    //                 LastLineNo += 10000;
    //             end;
    //         end;

    //     // === Apply to Chiller Deposit ===
    //     if RemainingCharges > 0 then begin
    //         // Chiller Deposit
    //         if RemainingCharges < chillerdeposit then
    //             AppliedAmount := RemainingCharges
    //         else
    //             AppliedAmount := chillerdeposit;
    //         if AppliedAmount > 0 then begin
    //             InsertJournalLine(LastLineNo, PostingDate, DocumentNo, Tenantname + ' Chiller Deposit',
    //                               Tenantid, -AppliedAmount, ChillerDepositAccount, InvoiceNo, SelectedTemplate, SelectedBatch);
    //             RemainingCharges -= AppliedAmount;
    //             LastLineNo += 10000;
    //         end;
    //     end;

    //     // === Apply to Other Deposit ===
    //     if RemainingCharges > 0 then begin
    //         // Other Deposit
    //         if RemainingCharges < otherdeposit then
    //             AppliedAmount := RemainingCharges
    //         else
    //             AppliedAmount := otherdeposit;
    //         if AppliedAmount > 0 then begin
    //             InsertJournalLine(LastLineNo, PostingDate, DocumentNo, Tenantname + ' Other Deposit',
    //                               Tenantid, -AppliedAmount, OtherDepositAccount, InvoiceNo, SelectedTemplate, SelectedBatch);
    //             RemainingCharges -= AppliedAmount;
    //             LastLineNo += 10000;
    //         end;
    //     end;

    //     Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
    //     Message('Journal entries created and posted successfully.');
    // end;

    // local procedure FindCashReceiptTemplate(var TemplateName: Code[10]; var BatchName: Code[10]): Boolean
    // var
    //     GenJnlTemplate: Record "Gen. Journal Template";
    //     GenJnlBatch: Record "Gen. Journal Batch";
    // begin
    //     GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::"Cash Receipts");
    //     if GenJnlTemplate.FindFirst() then begin
    //         TemplateName := GenJnlTemplate.Name;
    //         GenJnlBatch.SetRange("Journal Template Name", TemplateName);
    //         if GenJnlBatch.FindFirst() then begin
    //             BatchName := GenJnlBatch.Name;
    //             exit(true);
    //         end;
    //     end;

    //     GenJnlTemplate.Reset();
    //     if GenJnlTemplate.FindFirst() then begin
    //         TemplateName := GenJnlTemplate.Name;
    //         GenJnlBatch.SetRange("Journal Template Name", TemplateName);
    //         if GenJnlBatch.FindFirst() then begin
    //             BatchName := GenJnlBatch.Name;
    //             exit(true);
    //         end;
    //     end;

    //     exit(false);
    // end;

    // local procedure HasResidentialClassification(TenancyContract: Record "Tenancy Contract"): Boolean
    // begin
    //     exit((Format(TenancyContract."Property Classification") = 'Residential') or
    //          (Format(TenancyContract."Property Classification") = '0'));
    // end;

    // local procedure HasCommercialClassification(TenancyContract: Record "Tenancy Contract"): Boolean
    // begin
    //     exit((Format(TenancyContract."Property Classification") = 'Commercial') or
    //          (Format(TenancyContract."Property Classification") = '1'));
    // end;

    // local procedure InsertJournalLine(LineNo: Integer; PostDate: Date; DocNo: Code[20]; Desc: Text[100]; AccNo: Code[20];
    //                                   Amt: Decimal; BalAcc: Code[20]; Invoice: Code[20];
    //                                   Template: Code[10]; Batch: Code[10])
    // var
    //     JnlLine: Record "Gen. Journal Line";
    // begin
    //     Clear(JnlLine);
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
    //     JnlLine."Bal. Account Type" := JnlLine."Bal. Account Type"::"G/L Account";
    //     JnlLine."Bal. Account No." := BalAcc;
    //     JnlLine."External Document No." := Invoice;
    //     JnlLine.Insert(true);
    // end;




    // procedure Additinalchargescashreceipt()
    // var
    //     GenJnlLine: Record "Gen. Journal Line";
    //     SalesInvoice: Record "Sales Invoice Header";
    //     finalcalculation: Record "Final Calculation";
    //     GenJnlTemplate: Code[10];
    //     GenJnlBatch: Code[10];
    //     PostingDate: Date;
    //     DocumentNo: Code[20];
    //     AccountNo: Code[20];
    //     InvoiceNo: Code[20];
    //     GenJournalLine: Record "Gen. Journal Line";
    //     LastLineNo: Integer;
    //     GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    //     TerminationCharges: Record "Termination Charges Sub";
    //     TotalRefundableDeposit: Decimal;
    //     // TerminationChargesub: Record "Additional Charges Sub";
    //     Tenantid: Code[20];
    //     Tenantname: Text[100];
    //     securitydeposit: Decimal;
    //     chillerdeposit: Decimal;
    //     otherdeposit: Decimal;
    //     totalotherdeposit: Decimal;
    //     Totaladdtionalcharges: Decimal;
    //     AppliedAmount: Decimal;
    // begin
    //     GenJnlTemplate := 'CASH RECE';
    //     GenJnlBatch := 'DEFAULT';
    //     PostingDate := Today(); // You can replace with actual Posting Date
    //     DocumentNo := 'REFUND-' + Format(Rec."Contract ID"); // Customize as needed

    //     finalcalculation.SetRange("Contract ID", Rec."Contract ID");
    //     if finalcalculation.FindSet() then begin
    //         Tenantid := finalcalculation."Tenant ID";
    //         Tenantname := finalcalculation."Tenant Name";

    //         securitydeposit := finalcalculation."Net Balance";
    //         chillerdeposit := finalcalculation."Chiller Deposit";
    //         otherdeposit := finalcalculation."Other Deposit";

    //         totalotherdeposit := chillerdeposit + otherdeposit;
    //     end else
    //         Error('Invoice not found for Contract ID %1', finalcalculation."Contract ID");
    //     // 1. Determine G/L Account based on Property Classification
    //     case UpperCase(finalcalculation."Unit Type") of
    //         'RESIDENTIAL':
    //             AccountNo := '1501';
    //         'COMMERCIAL':
    //             AccountNo := '1506';

    //         else
    //             Error('Unsupported Unit Type: %1', finalcalculation."Unit Type");
    //     end;
    //     // 2. Find Invoice No. based on Contract ID
    //     TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
    //     if TerminationCharges.FindSet() then begin
    //         InvoiceNo := TerminationCharges."Posted Invoice ID";

    //     end else
    //         Error('Invoice not found for Contract ID %1', finalcalculation."Contract ID");

    //     TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
    //     if TerminationCharges.FindSet() then begin
    //         repeat
    //             Totaladdtionalcharges += TerminationCharges."Amount Including VAT";
    //         until TerminationCharges.Next() = 0;
    //     end else
    //         Error('Amount not found for Contract ID %1', Rec."Contract ID");


    //     // === 1. Apply against Security Deposit ===
    //     if (Totaladdtionalcharges > 0) and (securitydeposit > 0) then begin
    //         if Totaladdtionalcharges >= securitydeposit then begin
    //             // Full security deposit consumed
    //             AppliedAmount := securitydeposit;
    //         end else begin
    //             // Only part of security deposit needed
    //             AppliedAmount := Totaladdtionalcharges;
    //         end;

    //         GenJournalLine.Reset();
    //         GenJournalLine.SetRange("Journal Template Name", GenJnlTemplate);
    //         GenJournalLine.SetRange("Journal Batch Name", GenJnlBatch);
    //         if GenJournalLine.FindLast() then
    //             LastLineNo := GenJournalLine."Line No." + 1// Always increment by a safe step (standard NAV step is 10000)
    //         else
    //             LastLineNo := 1;
    //         // 3. Insert Gen. Journal Line
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
    //         GenJnlLine.Amount := -TotalRefundableDeposit;
    //         GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
    //         GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
    //         GenJnlLine."Bal. Account No." := AccountNo;
    //         GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
    //         GenJnlLine."Applies-to Doc. No." := InvoiceNo;
    //         GenJnlLine.Insert(true);

    //         // GenJnlPostLine.RunWithCheck(GenJnlLine);

    //         // Optional: Delete all posted lines in the batch
    //         // GenJournalLine.Reset();
    //         // GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
    //         // GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
    //         // if GenJournalLine.FindSet() then
    //         //     GenJournalLine.DeleteAll();

    //         Message('Cash Receipt journal entries created successfully.');
    //     end;
    // end;

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
    begin
        GenJnlTemplate := 'CASH RECE';
        GenJnlBatch := 'DEFAULT';
        PostingDate := Today(); // You can replace with actual Posting Date
        DocumentNo := 'RECEIVE-' + Format(Rec."Contract ID"); // Customize as needed

        finalcalculation.SetRange("Contract ID", Rec."Contract ID");
        if finalcalculation.FindSet() then begin
            Tenantid := finalcalculation."Tenant ID";
            Tenantname := finalcalculation."Tenant Name";
        end else
            Error('Invoice not found for Contract ID %1', finalcalculation."Contract ID");
        // 1. Determine G/L Account based on Property Classification
        case UpperCase(finalcalculation."Unit Type") of
            'RESIDENTIAL':
                AccountNo := '1501';
            'COMMERCIAL':
                AccountNo := '1506';
            else
                Error('Unsupported Unit Type: %1', finalcalculation."Unit Type");
        end;
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

        // TerminationCharges.SetRange("Contract ID", Rec."Contract ID");
        // if TerminationCharges.FindSet() then begin
        //     repeat
        //         TotalRefundableDeposit += TerminationCharges."Amount Including VAT";
        //     until TerminationCharges.Next() = 0;
        // end else
        //     Error('Amount not found for Contract ID %1', Rec."Contract ID");

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

        // GenJnlPostLine.RunWithCheck(GenJnlLine);

        // Optional: Delete all posted lines in the batch
        // GenJournalLine.Reset();
        // GenJournalLine.SetRange("Journal Template Name", 'CASH RECE');
        // GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        // if GenJournalLine.FindSet() then
        //     GenJournalLine.DeleteAll();

        Message('Cash Receipt journal entries created successfully.');
    end;

}
