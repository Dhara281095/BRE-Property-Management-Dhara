codeunit 50106 GenerateConsolidatedInvoices
{

    procedure GenerateConsolidatedInvoicesDirectly()
    var
        paymentScheudle2: Record "Payment Schedule2";
        SalesHeader: Record "Sales Header";
        newsalesheader: Record "Sales Header";
        todaydate: Date;
    begin
        todaydate := 20251129D;
        // todaydate := 20281128D;
        paymentScheudle2.SetRange("Due Date", todaydate);

        if paymentScheudle2.FindSet() then
            repeat
                if paymentScheudle2.Invoiced = false then begin
                    //   SalesHeader.SetRange("Sell-to Customer No.", paymentScheudle2."Tenant ID");
                    SalesHeader.SetRange("Contract ID", paymentScheudle2."Contract ID");
                    SalesHeader.SetRange("Due Date", paymentScheudle2."Due Date");
                    SalesHeader.SetRange("Document Type", Enum::"Sales Document Type"::Invoice);
                    if SalesHeader.FindSet() then begin

                        createSalesLines(SalesHeader, paymentScheudle2);
                    end
                    else begin
                        newsalesheader := CreateSalesInvoice(paymentScheudle2."Tenant ID", paymentScheudle2."Due Date", paymentScheudle2."Contract ID", paymentScheudle2."Tenant Name");
                        createSalesLines(newsalesheader, paymentScheudle2);
                    end;
                    paymentScheudle2.Invoiced := true;
                    paymentScheudle2.Modify();

                end;
            until paymentScheudle2.Next() = 0;
    end;

    procedure CreateSalesInvoice(TenantID: Code[20]; DueDate: Date; ContractID: Integer; TenantName: Text[100]): Record "Sales Header"
    var
        salesHeader: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
    begin
        salesHeader.Init();
        if salesReciveable.FindSet() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Invoice Nos.", Today, true);
        salesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        salesHeader."Sell-to Customer No." := TenantID;
        salesHeader."Bill-to Customer No." := TenantID;
        salesHeader."Bill-to Name" := TenantName;
        salesHeader."Sell-to Customer Name" := TenantName;
        salesHeader."Due Date" := DueDate;
        salesHeader."Contract ID" := ContractID;
        salesHeader."Tenant Name" := TenantName;
        salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Shipment Date" := Today;

        salesHeader.Insert();

        exit(salesHeader);

    end;

    procedure createSalesLines(salesheader1: Record "Sales Header"; newpaymentschedule2: Record "Payment Schedule2")
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
        salesTaxCalculate: Codeunit "Sales Tax Calculate";
        currency: Record Currency;
        vatpostingsetup: Record "VAT Posting Setup";
    begin


        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::Invoice;

        newSaleslines.SetRange("Document No.", salesheader1."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::Invoice);
        newSaleslines.SetRange("Contract ID", salesheader1."Contract ID");
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then begin
            saleline."Line No." := newSaleslines."Line No." + 1000;
        end
        else begin
            saleline."Line No." := 1000;
        end;
        saleline."Document No." := salesheader1."No.";
        saleline."Contract ID" := salesheader1."Contract ID";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, newpaymentschedule2."Secondary Item Type");
        if item.FindSet() then begin
            if newpaymentschedule2."Property Classification" <> '' then begin
                item.SetRange(Description, newpaymentschedule2."Secondary Item Type");
                item.SetRange("Primary Classification Type", newpaymentschedule2."Property Classification");
                if item.FindSet() then begin
                    saleline."No." := item."No.";
                    saleline.Description := item.Description;
                    saleline."Gen. Prod. Posting Group" := item."Gen. Prod. Posting Group";
                    saleline."VAT Prod. Posting Group" := item."VAT Prod. Posting Group";
                    saleline."Unit of Measure Code" := item."Base Unit of Measure";
                end;
            end else begin
                saleline."No." := item."No.";
                saleline.Description := item.Description;
                saleline."Gen. Prod. Posting Group" := item."Gen. Prod. Posting Group";
                saleline."VAT Prod. Posting Group" := item."VAT Prod. Posting Group";
                saleline."Unit of Measure Code" := item."Base Unit of Measure";
            end;

        end;
        saleline."Quantity (Base)" := 1;
        saleline.Quantity := 1;
        saleline."Unit Price" := newpaymentschedule2."Amount";
        saleline."Line Amount" := saleline.Quantity * saleline."Unit Price";
        saleline.Amount := saleline.Quantity * saleline."Unit Price";
        saleline."Qty. to Invoice" := 1;
        saleline."Qty. to Ship" := 1;
        saleline."Qty. to Invoice" := 1;
        saleline."Qty. to Invoice (Base)" := 1;
        saleline."Outstanding Qty. (Base)" := 1;
        saleline."Outstanding Quantity" := 1;
        saleline."VAT Base Amount" := newpaymentschedule2."VAT Amount";
        saleline."Amount Including VAT" := saleline."Line Amount" + newpaymentschedule2."VAT Amount";
        saleline."Outstanding Amount" := saleline.Quantity * saleline."Unit Price";
        saleline."Outstanding Amount (LCY)" := saleline.Quantity * saleline."Unit Price";


        saleline.Insert();

        Clear(saleline);
    end;




}