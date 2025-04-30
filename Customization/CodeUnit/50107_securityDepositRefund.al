codeunit 50107 "Security Deposit Posting Mgt."
{
    procedure PostSecurityDepositAmount(SecurityDeposit: Record "Security Deposit")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Code[10];
        GenJnlBatch: Code[10];
        Amount: Decimal;
        PropertyType: Text[30];
        TenantReceivableAccount: Code[20];
        CarryForwardOutAccount: Code[20];
        CarryForwardInAccount: Code[20];
        LineNo: Integer;
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        DocNo: Code[20];
    begin
        // Set Cash Receipt Journal Template and Batch
        GenJnlTemplate := 'CASH RECE';
        GenJnlBatch := 'DEFAULT';

        Amount := SecurityDeposit."New_Balance Amount";
        PropertyType := SecurityDeposit."Property Classification";

        if Amount = 0 then
            Error('Security Deposit Amount Received is zero. Cannot post.');

        // Set G/L Accounts based on Property Type
        case PropertyType of
            'Residential':
                TenantReceivableAccount := '1501';
            'Commercial':
                TenantReceivableAccount := '1506';
            else
                Error('Invalid Property Type. Must be Residential or Commercial.');
        end;

        CarryForwardOutAccount := '4504';
        CarryForwardInAccount := '4503';

        // Generate Document No
        DocNo := 'SD-' + Format(SecurityDeposit."Contract ID");

        // Find the next available Line No.
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate);
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch);
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 1
        else
            LineNo := 1;

        // 1st Line - Tenant Receivable (-Amount)
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
        GenJnlLine.Amount := -Amount;
        GenJnlLine.Insert();

        // 2nd Line - Carry Forward Out (+Amount)
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
        GenJnlLine."Account No." := CarryForwardOutAccount;
        GenJnlLine.Amount := Amount;
        GenJnlLine.Insert();

        // 3rd Line - Carry Forward In (-Amount)
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
        GenJnlLine."Account No." := CarryForwardInAccount;
        GenJnlLine.Amount := -Amount;
        GenJnlLine.Insert();

        // 4th Line - Tenant Receivable (+Amount)
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
        GenJnlLine."Account No." := TenantReceivableAccount;
        GenJnlLine.Amount := Amount;
        GenJnlLine.Insert();

        // Now Post the Journal
        GenJnlPost.Run(GenJnlLine);

        Message('Security Deposit posted successfully.');
    end;
}
