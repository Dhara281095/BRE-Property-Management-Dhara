page 50952 "Pending Recevieable Grid"
{
    PageType = ListPart;
    SourceTable = "Pending Receviable Grid";
    ApplicationArea = All;
    Caption = 'Pending Receivable/Payable List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID") { ApplicationArea = All; Caption = 'Contract ID'; Editable = false; }
                field("Entry No"; Rec."Entry No") { Caption = 'Entry No.'; ApplicationArea = All; Editable = false; }

                field(RevenueDescription; Rec.RevenueDescription) { ApplicationArea = All; Caption = 'Revenue Description'; Editable = false; }
                field(RevisedAmount; Rec.RevisedAmount) { ApplicationArea = All; Caption = 'Revised Amount'; Editable = false; }
                field(RevisedVAT; Rec.RevisedVAT) { ApplicationArea = All; Caption = 'Revised VAT'; Editable = false; }
                field(RevisedAmountInclVAT; Rec.RevisedAmountInclVAT) { ApplicationArea = All; Caption = 'Revised Amount Incl. VAT'; Editable = false; }
                field(ReceiptsAmount; Rec.ReceiptsAmount) { ApplicationArea = All; Caption = 'Receipts Amount'; Editable = false; }
                field(ReceiptsVAT; Rec.ReceiptsVAT) { ApplicationArea = All; Caption = 'Receipts VAT'; Editable = false; }
                field(ReceiptsAmountInclVAT; Rec.ReceiptsAmountInclVAT) { ApplicationArea = All; Caption = 'Receipts Amount Incl. VAT'; Editable = false; }
                field(DifferenceAmount; Rec.DifferenceAmount) { ApplicationArea = All; Caption = 'Difference Amount'; Editable = false; }
                field(DifferenceVAT; Rec.DifferenceVAT) { ApplicationArea = All; Caption = 'Difference VAT'; Editable = false; }
                field(DifferenceAmountInclVAT; Rec.DifferenceAmountInclVAT) { ApplicationArea = All; Caption = 'Difference Amount Incl. VAT'; Editable = false; }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    Editable = false;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    Editable = false;

                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced ID';
                }

            }
            group(" ")
            {
                grid(SummaryGrid)
                {
                    GridLayout = Columns;

                    group("Revised Values")
                    {
                        field("Total Revised Amount"; Rec."Total Revised Amount")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Revised VAT"; Rec."Total Revised VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Revised AmountIncl. VAT"; Rec."Total Revised AmountIncl. VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                    group("Receipts Values")
                    {
                        field("Total Receipts Amount"; Rec."Total Receipts Amount")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receipts VAT"; Rec."Total Receipts VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receipts AmountIncl. VAT"; Rec."Total Receipts AmountIncl. VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                    group("Difference & Summary")
                    {
                        field("Total Difference Amount"; Rec."Total Difference Amount")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Difference VAT"; Rec."Total Difference VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Refundable"; Rec."Total Refundable")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receivable"; Rec."Total Receivable")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }



            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Invoice)
            {
                ApplicationArea = All;
                Caption = 'Generate Invoice';
                Image = NewInvoice;
                trigger OnAction()
                var
                    newsalesheader: Record "Sales Header";
                    salesheader1card: Record "Sales Header";
                    receivableGrid: Record "Pending Receviable Grid";
                    customercard: Record Customer;
                    pendingrecevieable: Record "Pending Receviable Grid";

                begin
                    if Rec.Invoiced = false then begin

                        newsalesheader := CreateSalesHeader(Rec."Contract ID", Rec."Tenant ID", Rec."Unit Type");
                        customercard.SetRange("No.", newsalesheader."Sell-to Customer No.");
                        if customercard.FindSet() then begin
                            if newsalesheader."Property Classification" <> '' then begin
                                customercard.Validate("Gen. Bus. Posting Group", newsalesheader."Property Classification");
                                customercard.Validate("Customer Posting Group", newsalesheader."Property Classification");
                                customercard.Modify();
                            end
                        end;
                        if newsalesheader."Property Classification" <> '' then begin
                            newsalesheader."Gen. Bus. Posting Group" := newsalesheader."Property Classification";
                            newsalesheader."Customer Posting Group" := newsalesheader."Property Classification";
                            newsalesheader.Modify();
                        end;

                        receivableGrid.SetRange("Contract ID", Rec."Contract ID");
                        if receivableGrid.FindSet() then
                            repeat
                                Saleslinecreate(newsalesheader, receivableGrid);
                                receivableGrid.Invoiced := true;
                                receivableGrid.Modify();
                            until receivableGrid.Next() = 0;

                    end else begin
                        Message('Already Create invoice for the contract id');
                    end;

                end;
            }
        }
    }

    procedure CreateSalesHeader(pContractID: Integer; pTenantID: Code[50]; pUnitType: Text[50]): Record "Sales Header";
    var
        salesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
        customercard: Record Customer;
    begin
        salesHeader.Init();
        if salesReciveable.FindSet() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Invoice Nos.", Today, true);
        salesHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("Contract ID", pcontractid);
        //   salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."Property Classification" := pUnitType;
        salesHeader.Insert();
        exit(salesHeader);
    end;


    procedure Saleslinecreate(salesheader1: Record "Sales Header"; reciveablegridline: Record "Pending Receviable Grid")
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
    begin

        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::Invoice;

        newSaleslines.SetRange("Document No.", salesheader1."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::Invoice);
        //newSaleslines.SetRange("Contract ID", salesheader1."Contract ID");
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
        item.SetRange(Description, reciveablegridline.RevenueDescription);
        if item.FindSet() then begin

            saleline.Validate("No.", item."No.");
        end;
        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(reciveablegridline.DifferenceAmount));
        saleline.Insert();
        Clear(saleline);
    end;

    trigger OnAfterGetRecord()
    var
    begin
        FetchDataFromRevenueCalcGrid();
        Recvieableamountfrompaymentscheule();
        DifferenceAmountCalculation();
        GetpositiveAmount();
    end;

    procedure FetchDataFromRevenueCalcGrid()
    var
        RevenueGrid: Record "Final Revenue Calculation Grid";
    begin
        RevenueGrid.SetRange("Contract ID", Rec."Contract ID");
        RevenueGrid.SetRange("Revenue Description", Rec.RevenueDescription);
        if RevenueGrid.FindSet() then
            repeat
                Rec.RevisedAmount := RevenueGrid."Revised Amount";
                Rec.RevisedVAT := RevenueGrid."Revised VAT";
                Rec.RevisedAmountInclVAT := RevenueGrid."Revised Amount Incl.";
                Rec.Modify();
            until RevenueGrid.Next() = 0;

    end;

    procedure Recvieableamountfrompaymentscheule()
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        Totalamount: Decimal;
        VATAmount: Decimal;
        AmountIncVAT: Decimal;
    begin
        Totalamount := 0;
        PaymentScheduleRec.Reset();
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
        PaymentScheduleRec.SetFilter("Due Date", '<%1', Rec."Termination Date");
        PaymentScheduleRec.SetRange("Payment Status", 'Received');
        PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
        if PaymentScheduleRec.FindSet() then begin
            repeat
                Totalamount += PaymentScheduleRec.Amount;
                VATAmount += PaymentScheduleRec."VAT Amount";
                AmountIncVAT += PaymentScheduleRec."Amount Including VAT";

            until PaymentScheduleRec.Next() = 0;
        end;
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
        PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
        if PaymentScheduleRec.FindSet() then
            repeat
                Rec.ReceiptsAmount := Totalamount;
                Rec.ReceiptsVAT := VATAmount;
                Rec.ReceiptsAmountInclVAT := AmountIncVAT;
                Rec.Modify();
            until PaymentScheduleRec.Next() = 0;
    end;


    procedure DifferenceAmountCalculation()
    var

    begin

        Rec."DifferenceAmount" := Rec.RevisedAmount - Rec.ReceiptsAmount;
        Rec."DifferenceVAT" := Rec.RevisedVAT - Rec.ReceiptsVAT;
        Rec.DifferenceAmountInclVAT := Rec.RevisedAmountInclVAT - Rec.ReceiptsAmountInclVAT;
        Rec.Modify();

    end;

    procedure GetpositiveAmount()
    begin
        if Rec."Total DifferenceAmountIncl.VAT" < 0 then begin
            Rec."Total Refundable" := Abs(Rec."Total DifferenceAmountIncl.VAT");
            Rec.Modify();
        end else begin
            Rec."Total Receivable" := Rec."Total DifferenceAmountIncl.VAT";
            Rec.Modify();
        end;
    end;
}