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

            group(RefundDetails)
            {
                Caption = 'Refund Details';
                Visible = IsRefundable;

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
                    // Editable = false; // The ID is not editable since it's auto-incrementing
                }
            }

            repeater(RefundPaymentDetails)
            {
                Caption = 'Refund Payment Details';
                Visible = IsRefundable;

                field("Refund Contract ID"; Rec."Refund Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                }
                field("Refund Total Amount"; Rec."Refund Total Amount")
                {
                    ApplicationArea = All;
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
                }
                field("Refund Cheque No."; Rec."Refund Cheque No.")
                {
                    ApplicationArea = All;
                }

                // field("Entry No."; Rec."Entry No.")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     Visible = false;
                // }
                field("Refund Tenant ID"; Rec."Refund Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
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
                    Visible = false;
                }
            }

            group(ReceivableDetails)
            {
                Caption = 'Receivable Details';
                Visible = IsReceivable;

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
                    // Editable = false; // The ID is not editable since it's auto-incrementing
                }
            }


            repeater(ReceivablePaymentDetails)
            {
                Caption = 'Receivable Payment Details';
                Visible = IsReceivable;
                field("Receivable Contract ID"; Rec."Receivable Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                }
                field("Receivable Total Amount"; Rec."Receivable Total Amount")
                {
                    ApplicationArea = All;
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
                    end;
                }
                field("Receivable Cheque No."; Rec."Receivable Cheque No.")
                {
                    ApplicationArea = All;
                }

                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Deposit Status"; Rec."Deposit Status")
                {
                    ApplicationArea = All;
                }

                // field("Entry No."; Rec."Entry No.")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     Visible = false;
                // }
                field("Receivable Tenant ID"; Rec."Receivable Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
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
                    Visible = false;
                }
            }

        }

    }


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

        finalCalculationgrid.SetRange("Contract ID", Rec."Receivable Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Receivable Tenant ID");
        if Rec."Receivable Payment Status" = PaymentStatus::" " then
            Rec."Receivable Payment Status" := PaymentStatus::Scheduled;

        if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
            Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
            Rec.Modify();
        end;

        // if finalCalculationgrid."Net Receivable From The Tenant" <> 0 then
        //     IsReceivable := true
        // else
        //     IsReceivable := false;
        // Rec.Modify();
        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';
        if Rec."Refund Payment mode" = '' then begin
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method";
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Refund Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Refund Tenant ID");
        if Rec."Refund Payment Status" = PaymentStatus::" " then //begin
            Rec."Refund Payment Status" := PaymentStatus::Scheduled;
        // if finalCalculationgrid."Amount Refundable" <> 0 then
        //     IsRefundable := true
        // else
        //     IsRefundable := false;
        //  end;

        if Rec."Refund Payment Status" = PaymentStatus::Received then begin
            Rec."Refund Status" := Rec."Refund Status"::Received;
            Rec.Modify();
        end;

        // if finalCalculationgrid."Amount Refundable" <> 0 then
        //     IsRefundable := true
        // else
        //     IsRefundable := false;
        // Rec.Modify();

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

        finalCalculationgrid.SetRange("Contract ID", Rec."Receivable Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Receivable Tenant ID");
        if Rec."Receivable Payment Status" = PaymentStatus::" " then
            Rec."Receivable Payment Status" := PaymentStatus::Scheduled;

        if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
            Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
            Rec.Modify();
        end;

        // if finalCalculationgrid."Net Receivable From The Tenant" <> 0 then
        //     IsReceivable := true
        // else
        //     IsReceivable := false;
        // Rec.Modify();
        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';
        if Rec."Refund Payment mode" = '' then begin
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method";
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Refund Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Refund Tenant ID");
        if Rec."Refund Payment Status" = PaymentStatus::" " then //begin
            Rec."Refund Payment Status" := PaymentStatus::Scheduled;
        //     if finalCalculationgrid."Amount Refundable" <> 0 then
        //         IsRefundable := true
        //     else
        //         IsRefundable := false;
        // end;

        if Rec."Refund Payment Status" = PaymentStatus::Received then begin
            Rec."Refund Status" := Rec."Refund Status"::Received;
            Rec.Modify();
        end;

        // if finalCalculationgrid."Amount Refundable" <> 0 then
        //     IsRefundable := true
        // else
        //     IsRefundable := false;
        // Rec.Modify();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
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

        finalCalculationgrid.SetRange("Contract ID", Rec."Receivable Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Receivable Tenant ID");
        if Rec."Receivable Payment Status" = PaymentStatus::" " then
            Rec."Receivable Payment Status" := PaymentStatus::Scheduled;

        if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
            Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
            Rec.Modify();
        end;

        // if finalCalculationgrid."Net Receivable From The Tenant" <> 0 then
        //     IsReceivable := true
        // else
        //     IsReceivable := false;
        // Rec.Modify();
        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';
        if Rec."Refund Payment mode" = '' then begin
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method";
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Refund Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Refund Tenant ID");
        if Rec."Refund Payment Status" = PaymentStatus::" " then // begin
            Rec."Refund Payment Status" := PaymentStatus::Scheduled;
        //     if finalCalculationgrid."Amount Refundable" <> 0 then
        //         IsRefundable := true
        //     else
        //         IsRefundable := false;
        // end;

        if Rec."Refund Payment Status" = PaymentStatus::Received then begin
            Rec."Refund Status" := Rec."Refund Status"::Received;
            Rec.Modify();
        end;

        // if finalCalculationgrid."Amount Refundable" <> 0 then
        //     IsRefundable := true
        // else
        //     IsRefundable := false;
        // Rec.Modify();
    end;




    trigger OnAfterGetCurrRecord()
    var
        finalcalculationcard: Record "Final Calculation";
        PaymentStatus: Enum "Payment Status";

    begin
        finalcalculationcard.SetRange("Contract ID", Rec."Refund Contract ID");
        if finalcalculationcard.FindSet() then begin
            Rec."Net Refund to the Tenant" := finalcalculationcard."Amount Refundable";
            Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
            Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";

            if Rec."Refund Payment Status" = PaymentStatus::Received then begin
                Rec."Refund Status" := Rec."Refund Status"::Received;
                Rec."Balance Refundable" := 0;
                Rec."Refund Processed" := Rec."Net Refund to the Tenant";
                Rec.Modify();
            end;

            if finalcalculationcard."Amount Refundable" <> 0 then
                IsRefundable := true
            else
                IsRefundable := false;
            Rec.Modify();
        end;

        finalcalculationcard.SetRange("Contract ID", Rec."Receivable Contract ID");
        if finalcalculationcard.FindSet() then begin
            Rec."Receivable from the Tenant" := finalcalculationcard."Net Receivable From The Tenant";
            Rec."Balance Receivable" := Rec."Receivable from the Tenant";
            Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";


            if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                Rec."Balance Receivable" := 0;
                Rec."Payment Processed" := Rec."Receivable from the Tenant";
                Rec.Modify();
            end;

            if finalcalculationcard."Net Receivable From The Tenant" <> 0 then
                IsReceivable := true
            else
                IsReceivable := false;
            Rec.Modify();
        end;
    end;

    trigger OnOpenPage()
    var
        finalcalculationcard1: Record "Final Calculation";
        PaymentStatus: Enum "Payment Status";


    begin
        finalcalculationcard1.SetRange("Contract ID", Rec."Refund Contract ID");
        if finalcalculationcard1.FindSet() then begin
            Rec."Net Refund to the Tenant" := finalcalculationcard1."Amount Refundable";
            Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
            Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";


            if Rec."Refund Payment Status" = PaymentStatus::Received then begin
                Rec."Refund Status" := Rec."Refund Status"::Received;
                Rec."Balance Refundable" := 0;
                Rec."Refund Processed" := Rec."Net Refund to the Tenant";
                Rec.Modify();
            end;

            if finalcalculationcard1."Amount Refundable" <> 0 then
                IsRefundable := true
            else
                IsRefundable := false;
            Rec.Modify();
        end;

        finalcalculationcard1.SetRange("Contract ID", Rec."Receivable Contract ID");
        if finalcalculationcard1.FindSet() then begin
            Rec."Receivable from the Tenant" := finalcalculationcard1."Net Receivable From The Tenant";
            Rec."Balance Receivable" := Rec."Receivable from the Tenant";
            Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";


            if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                Rec."Balance Receivable" := 0;
                Rec."Payment Processed" := Rec."Receivable from the Tenant";
                Rec.Modify();
            end;

            if finalcalculationcard1."Net Receivable From The Tenant" <> 0 then
                IsReceivable := true
            else
                IsReceivable := false;
            Rec.Modify();
        end;
    end;



    var
        IsRefundable: Boolean;
        IsReceivable: Boolean;
}