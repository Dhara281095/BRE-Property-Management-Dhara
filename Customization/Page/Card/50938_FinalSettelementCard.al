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
                //  Editable = (Rec."Receivable Payment Status" <> PaymentStatus::Received);
                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    // Visible = false;
                    Caption = 'FC ID';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    // Visible = false;
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
                    Editable = false;
                    DrillDown = true;
                }
                field("Payment Receipt document URL"; Rec."Payment Receipt document URL")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt document URL';
                    // Visible = false;
                }
                field("View Invoice"; Rec."View Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'View Invoice';
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."Invoice URL";


                        if FileURL = '' then
                            Error('No document is available to view.');


                        OpenFileInBrowser(FileURL);
                    end;

                }
                field("Invoice URL"; Rec."Invoice URL")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice URL';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //  Visible = false;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    newsalesHeader: Record "Sales Header";
                    salesReciveable: Record "Sales & Receivables Setup";
                    noseries: Codeunit "No. Series";
                    salesline: Record "Sales Line";
                    customer: Integer;
                    itemNo: Code[20];
                    finalsettlementpage: Record FinalSettlement;

                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if not Rec.FindFirst() then
                        Error('No record');

                    finalsettlementpage.Reset();
                    finalsettlementpage.SetRange("FC ID", Rec."FC ID");
                    if finalsettlementpage.FindSet() then begin
                        if finalsettlementpage.Invoiced = true then begin
                            Message('Already created invoice for the contract');
                        end else begin
                            newsalesHeader := psalesheader(Rec."Contract ID", Rec."Tenant ID", Rec."Receivable Due Date", Rec."FC ID");
                            psalesline(newsalesHeader, Rec);
                            Rec.Invoiced := true;
                            Rec."Invoice ID" := newsalesHeader."No.";
                            Rec.Modify(true);
                        end;
                    end;

                end;
            }
        }
    }
    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    /////////////////////////// SALES INVOICE //////////////////////////////////////
    procedure psalesheader(pcontractid: Integer; pTenantID: Code[20]; pDuedate: Date; pfcid: Integer): Record "Sales Header"
    var
        salesHeader: Record "Sales Header";
        SalesHeader1: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
    begin
        salesHeader.Init();
        if salesReciveable.FindSet() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Invoice Nos.", Today, true);
        salesHeader."Document Type" := SalesHeader1."Document Type"::Invoice;
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader.Validate("Contract ID", pcontractid);
        salesHeader.Validate("Due Date", pDuedate);
        salesHeader."FC ID" := pfcid;
        salesHeader.Insert(true);
        exit(salesHeader);
    end;

    procedure psalesline(saleheadeline: Record "Sales Header"; finalsettlment: Record FinalSettlement)
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        itemNo: Code[20];
    begin
        itemNo := '92';
        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::Invoice;

        newSaleslines.SetRange("Document No.", saleheadeline."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::Invoice);
        newSaleslines.SetRange("Contract ID", saleheadeline."Contract ID");
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then begin
            saleline."Line No." := newSaleslines."Line No." + 1000;
        end
        else begin
            saleline."Line No." := 1000;
        end;
        saleline."Document No." := saleheadeline."No.";
        saleline."Contract ID" := saleheadeline."Contract ID";
        saleline.Validate(Type, saleline.Type::Item);
        saleline.Validate("Sell-to Customer No.", saleline."Sell-to Customer No.");
        saleline.Validate("No.", itemNo);
        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate("Unit Price", finalsettlment."Receivable Total Amount");
        saleline."FC ID" := saleheadeline."FC ID";
        saleline.Insert(true);
        Clear(saleline);
    end;

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
                Rec.Modify();
            end;

            if Rec."Receivable Payment Status" <> PaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Pending;
                Rec."Balance Receivable" := Rec."Receivable from the Tenant";
                Rec."Payment Processed" := 0;
                Rec.Modify();
            end;

            if Rec."Receivable Due Date" = Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Due;
            end
            // else if Rec."Receivable Due Date" < Today() then begin
            //     Rec."Receivable Payment Status" := PaymentStatus::Scheduled;
            // end
            else if Rec."Receivable Due Date" > Today() then begin
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
                Rec.Modify();
            end;

            if Rec."Receivable Payment Status" <> PaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Pending;
                Rec."Balance Receivable" := Rec."Receivable from the Tenant";
                Rec."Payment Processed" := 0;
                Rec.Modify();
            end;

            if Rec."Receivable Due Date" = Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Due;
            end
            // else if Rec."Receivable Due Date" < Today() then begin
            //     Rec."Receivable Payment Status" := PaymentStatus::Scheduled;
            // end
            else if Rec."Receivable Due Date" > Today() then begin
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
                Rec.Modify();
            end;

            if Rec."Receivable Payment Status" <> PaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Pending;
                Rec."Balance Receivable" := Rec."Receivable from the Tenant";
                Rec."Payment Processed" := 0;
                Rec.Modify();
            end;

            if Rec."Receivable Due Date" = Today() then begin
                Rec."Receivable Payment Status" := PaymentStatus::Due;
            end
            // else if Rec."Receivable Due Date" < Today() then begin
            //     Rec."Receivable Payment Status" := PaymentStatus::Scheduled;
            // end
            else if Rec."Receivable Due Date" > Today() then begin
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


}