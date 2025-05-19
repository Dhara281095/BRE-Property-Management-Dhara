page 50940 "FinalSettlemtRefundCard"
{
    PageType = ListPart;
    SourceTable = "FinalSettlementRefund";
    ApplicationArea = All;
    Caption = 'Final Settlement Details';
    //UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(RefundDetails)
            {
                Caption = 'Refund Details';

                field("Net Refund to the Tenant";
                Rec."Net Refund to the Tenant")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Refund Processed"; Rec."Refund Processed")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Balance Refundable"; Rec."Balance Refundable")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Refund Status"; Rec."Refund Status")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Adjust Security Deposit"; Rec."Adjust Security Deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Adjust Chiller Deposit"; Rec."Adjust Chiller Deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Adjust other deposit"; Rec."Adjust other deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }

            repeater(RefundPaymentDetails)
            {
                Caption = 'Refund Payment Details';
                Editable = (Rec."Refund Payment Status" <> Rec."Refund Payment Status"::Paid);

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
                    Caption = 'Refund Contract ID';
                }
                field("Refund Total Amount"; Rec."Refund Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Refund Due Date"; Rec."Refund Due Date")
                {
                    ApplicationArea = All;
                }

                field("Refund Payment mode"; Rec."Refund Payment mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Refund Payment Status"; Rec."Refund Payment Status")
                {
                    ApplicationArea = All;
                    // Editable = false;

                    trigger OnValidate()
                    var
                        PaymentStatus: Enum "Payment Status";
                        RefundPostingMgt: Codeunit "Refund Settlement Posting Mgt.";
                    begin
                        // Check if Receivable Payment Status is 'Received'
                        if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then begin
                            // Set Rec."Refund Payment Status" to 'Received' as well
                            Rec."Refund Status" := Rec."Refund Status"::Paid;
                            Rec.Modify();  // Save changes to the current record
                        end;

                        if Rec."Refund Payment Status" <> Rec."Refund Payment Status"::Paid then begin
                            // Set PaymentStatus to 'Received' as well
                            Rec."Refund Status" := Rec."Refund Status"::Pending;
                            Rec.Modify();  // Save changes to the current record
                        end;

                        if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then begin
                            RefundPostingMgt.PostRefundJournalLines(Rec);
                            // RefundPostingMgt.refundcashrecipt();
                        end;
                    end;
                }

                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = Rec."Refund Payment Mode" <> 'Cash';
                    // Editable = (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
                }
                field("Refund Cheque No."; Rec."Refund Cheque No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        paymentmode: Record "Payment Type";
                    begin
                        if Rec."Refund Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;
                }

                field("Payment Receipt/Proof"; Rec."Payment Receipt/Proof")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt/Proof';
                    Editable = false;
                    DrillDown = true;
                }
                field("Pay Receipt/Proof document URL"; Rec."Pay Receipt/Proof document URL")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt/Proof document URL';
                    // Visible = false;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                // field("Entry No."; Rec."Entry No.")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     // Visible = false;
                // }
            }
        }
    }


    trigger OnModifyRecord(): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin

        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';
        if Rec."Refund Payment mode" = '' then begin
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method";
        end;

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindSet() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Net Refund to the Tenant" := finalCalculationgrid."Amount Refundable";
            Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
            Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";
            //   finalCalculationgrid.SetRange("Tenant ID", Rec."Refund Tenant ID");
            // if Rec."Refund Payment Status" = PaymentStatus::" " then //begin
            //     Rec."Refund Payment Status" := PaymentStatus::Scheduled;

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then begin
                Rec."Refund Status" := Rec."Refund Status"::Paid;
                Rec."Balance Refundable" := 0;
                Rec."Refund Processed" := Rec."Net Refund to the Tenant";
                Rec.Modify();
            end;

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then
                exit;

            if Rec."Refund Due Date" = Today() then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Due;
            end
            else if Rec."Refund Due Date" > Today() then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled;
            end
            else if Rec."Refund Due Date" = 0D then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled;
            end
            else if Rec."Refund Due Date" < Today() then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Overdue;
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

        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';
        if Rec."Refund Payment mode" = '' then begin
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method";
        end;

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindSet() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Net Refund to the Tenant" := finalCalculationgrid."Amount Refundable";
            Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
            Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";
            // if Rec."Refund Payment Status" = ' ' then //begin
            //     Rec."Refund Payment Status" := PaymentStatus::Scheduled;

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then begin
                Rec."Refund Status" := Rec."Refund Status"::Paid;
                Rec."Balance Refundable" := 0;
                Rec."Refund Processed" := Rec."Net Refund to the Tenant";
                Rec.Modify();
            end;

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then
                exit;

            if Rec."Refund Due Date" = Today() then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Due;
            end
            else if Rec."Refund Due Date" > Today() then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled;
            end
            else if Rec."Refund Due Date" = 0D then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled;
            end
            else if Rec."Refund Due Date" < Today() then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Overdue;
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


        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';
        if Rec."Refund Payment mode" = '' then begin
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method";
        end;

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindSet() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Net Refund to the Tenant" := finalCalculationgrid."Amount Refundable";
            Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
            Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";
            // if Rec."Refund Payment Status" = PaymentStatus::" " then
            //     Rec."Refund Payment Status" := PaymentStatus::Scheduled;

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then begin
                Rec."Refund Status" := Rec."Refund Status"::Paid;
                Rec."Balance Refundable" := 0;
                Rec."Refund Processed" := Rec."Net Refund to the Tenant";
                Rec.Modify();
            end;

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then
                exit;

            if Rec."Refund Due Date" = Today() then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Due;
            end
            else if Rec."Refund Due Date" > Today() then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled;
            end
            else if Rec."Refund Due Date" = 0D then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled;
            end
            else if Rec."Refund Due Date" < Today() then begin
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Overdue;
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
    //         Rec."Net Refund to the Tenant" := finalcalculationcard."Amount Refundable";
    //         Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
    //         Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";

    //         if Rec."Refund Payment Status" = PaymentStatus::Received then begin
    //             Rec."Refund Status" := Rec."Refund Status"::Paid;
    //             Rec."Balance Refundable" := 0;
    //             Rec."Refund Processed" := Rec."Net Refund to the Tenant";
    //             Rec.Modify();
    //         end;

    //         if Rec."Refund Payment Status" <> PaymentStatus::Received then begin
    //             Rec."Refund Status" := Rec."Refund Status"::Pending;
    //             Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
    //             Rec."Refund Processed" := 0;
    //             Rec.Modify();
    //         end;

    //         // if finalcalculationcard."Amount Refundable" <> 0 then
    //         //     IsRefundable := true
    //         // else
    //         //     IsRefundable := false;
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
    //         Rec."Net Refund to the Tenant" := finalcalculationcard1."Amount Refundable";
    //         Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
    //         Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";


    //         if Rec."Refund Payment Status" = PaymentStatus::Received then begin
    //             Rec."Refund Status" := Rec."Refund Status"::Paid;
    //             Rec."Balance Refundable" := 0;
    //             Rec."Refund Processed" := Rec."Net Refund to the Tenant";
    //             Rec.Modify();
    //         end;

    //         if Rec."Refund Payment Status" <> PaymentStatus::Received then begin
    //             Rec."Refund Status" := Rec."Refund Status"::Pending;
    //             Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
    //             Rec."Refund Processed" := 0;
    //             Rec.Modify();
    //         end;

    //         // if finalcalculationcard1."Amount Refundable" <> 0 then
    //         //     IsRefundable := true
    //         // else
    //         //     IsRefundable := false;
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
        PaymentStatus: Enum "Payment Status";
}