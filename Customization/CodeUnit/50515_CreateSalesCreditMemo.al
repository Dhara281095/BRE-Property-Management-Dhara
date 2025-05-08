codeunit 50515 "Create Sales Credit Memo"
{
    Subtype = Normal;
    trigger OnRun()
    begin
    end;

    procedure CreateSalesCreditMemo(creditMemoRec: Record "Credit Note Approval")
    var
        myInt: Integer;
        NewSalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        GLAccount: Record "G/L Account";
        SalesPost: Codeunit "Sales-Post";
        contractrec: Record "Tenancy Contract";
    begin
        Customer.SetRange("No.", creditMemoRec."Tenant ID");
        if not Customer.FindFirst() then
            Error('Customer not found for the given Sales Credit Memo.');
        contractrec.SetRange("Contract ID", creditMemoRec."Contract ID");
        if not contractrec.FindFirst() then
            Error('Contract not found for the given Sales Credit Memo.');

        NewSalesHeader := CreateSalesHeader(creditMemoRec."Contract ID", creditMemoRec."Tenant ID", contractrec."Property Classification");

        Customer.SetRange("No.", NewSalesHeader."Sell-to Customer No.");
        if Customer.FindSet() then begin
            if NewSalesHeader."Property Classification" <> '' then begin
                Customer.Validate("Gen. Bus. Posting Group", NewSalesHeader."Property Classification");
                Customer.Validate("Customer Posting Group", NewSalesHeader."Property Classification");
                Customer.Modify();
            end
        end;
        if NewSalesHeader."Property Classification" <> '' then begin
            NewSalesHeader."Gen. Bus. Posting Group" := NewSalesHeader."Property Classification";
            NewSalesHeader."Customer Posting Group" := NewSalesHeader."Property Classification";
            NewSalesHeader.Modify();
        end;

        Saleslinecreate(NewSalesHeader, creditMemoRec);

        SalesPost.Run(NewSalesHeader);
        Message('Sales Credit Memo created successfully with No. %1', NewSalesHeader."No.");
        // SalesHeader.Init();
        // Customer.SetRange("No.", creditMemoRec."Tenant ID");
        // if Customer.FindSet() then begin
        //     if SalesHeader."Property Classification" <> '' then begin
        //         Customer.Validate("Gen. Bus. Posting Group", contractrec."Property Classification");
        //         Customer.Validate("Customer Posting Group", contractrec."Property Classification");
        //         Customer.Modify();
        //     end;
        // end;

        // if SalesHeader."Property Classification" <> '' then begin
        //     SalesHeader."Gen. Bus. Posting Group" := contractrec."Property Classification";
        //     SalesHeader."Customer Posting Group" := contractrec."Property Classification";
        //     SalesHeader.Modify();
        // end;


        // SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        // SalesHeader."No." := '';
        // SalesHeader."Sell-to Customer No." := Customer."No.";
        // SalesHeader."Bill-to Customer No." := Customer."No.";
        // SalesHeader."Property Classification" := contractrec."Property Classification";
        // SalesHeader.Insert(true);

        // SalesLine.Init();
        // SalesLine."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        // SalesLine."Document No." := SalesHeader."No.";
        // SalesLine.Type := SalesLine.Type::"G/L Account";
        // SalesLine."No." := '8504'; // Carry Forward Out Account
        // SalesLine.Quantity := 1;
        // SalesLine."Unit Price" := -creditMemoRec."Contract Amount"; // Set the unit price to 0 for the carry forward line
        // SalesLine.Insert(true);
        // Message('Sales Credit Memo created successfully with No. %1', SalesHeader."No.");
    end;

    procedure CreateSalesHeader(pContractID: Integer; pTenantID: Code[50]; pUnitType: Text[50]): Record "Sales Header";
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
        contractrec: Record "Tenancy Contract";
    begin
        salesHeader.Init();
        if salesReciveable.FindSet() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Credit Memo Nos.", Today, true);
        salesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";

        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("Contract ID", pcontractid);
        //   salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."Property Classification" := pUnitType;
        SalesHeader."Posting No. Series" := salesReciveable."Posted Credit Memo Nos.";
        SalesHeader."Approval Status for CreditNote" := SalesHeader."Approval Status for CreditNote"::Approved;
        SalesHeader."Terminated Credit Note" := true;
        salesHeader.Insert();
        exit(salesHeader);
    end;


    procedure Saleslinecreate(salesheader1: Record "Sales Header"; additionalchargessub: Record "Credit Note approval");
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
        COASetup: Record "COA Setup";
        CreditNoteRec: Record "Credit Note";
        BillingCalculationCNRec: Record "Billing Calculation CN";
        GenPostingSetup: Record "General Posting Setup";
    begin

        BillingCalculationCNRec.SetRange("Credit Note ID", additionalchargessub.ID);
        BillingCalculationCNRec.SetRange("Contract ID", additionalchargessub."Contract ID");
        BillingCalculationCNRec.SetRange("Tenant ID", additionalchargessub."Tenant ID");
        if BillingCalculationCNRec.FindSet() then begin
            repeat
                saleline.Init();
                saleline."Document Type" := saleline."Document Type"::"Credit Memo";

                newSaleslines.SetRange("Document No.", salesheader1."No.");
                newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::"Credit Memo");
                //newSaleslines.SetRange("Contract ID", salesheader1."Contract ID");
                newSaleslines.SetCurrentKey("Line No.");
                if newSaleslines.FindLast() then begin
                    saleline."Line No." := newSaleslines."Line No." + 1000;
                end
                else begin
                    saleline."Line No." := 1000;
                end;
                saleline."Document No." := salesheader1."No.";
                // saleline."Contract ID" := salesheader1."Contract ID";
                saleline.Type := saleline.Type::"G/L Account";
                saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
                item.SetRange(Description, BillingCalculationCNRec.Item);
                if item.FindSet() then begin
                    GenPostingSetup.SetRange("Gen. Prod. Posting Group", item."Gen. Prod. Posting Group");
                    GenPostingSetup.SetRange("Gen. Bus. Posting Group", salesheader1."Gen. Bus. Posting Group");
                    if GenPostingSetup.FindSet() then begin
                        saleline.Validate("No.", GenPostingSetup."Sales Account");
                    end;

                end;
                saleline.Validate("Quantity (Base)", 1);
                saleline.Validate(Quantity, 1);
                saleline.Validate("Unit Price", Abs(BillingCalculationCNRec.Amount));
                // saleline."Contract ID" := additionalchargessub."Contract ID";
                // saleline."FC ID" := salesheader1."FC ID";
                saleline.Insert();

            until BillingCalculationCNRec.Next() = 0;
        end;

    end;

}