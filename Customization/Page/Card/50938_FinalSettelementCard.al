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
                // Visible = IsRefundable;

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
            }

            repeater(RefundPaymentDetails)
            {
                Caption = 'Refund Payment Details';
                // Visible = IsRefundable;

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
                    Editable = false;
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

            }

            group(ReceivableDetails)
            {
                Caption = 'Receivable Details';
                // Visible = not IsRefundable;

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
                // Visible = not IsRefundable;
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
                    Editable = false;
                }
                field("Receivable Cheque No."; Rec."Receivable Cheque No.")
                {
                    ApplicationArea = All;
                }

                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    // Visible = IsVisible;
                }

                field("Deposit Status"; Rec."Deposit Status")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    //  Visible = IsVisible;
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

            }




        }

    }

    trigger OnModifyRecord(): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin
        // If the field is blank, assign '-'
        if Rec."Receivable Cheque No." = '' then
            Rec."Receivable Cheque No." := '-';

        // Check if the Payment mode is empty (not set)
        if Rec."Receivable Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Receivable Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';

        // Check if the Payment mode is empty (not set)
        if Rec."Refund Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Refund Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Refund Tenant ID");
        if Rec."Refund Payment Status" = PaymentStatus::" " then begin
            // Set the first enum option as the default value
            Rec."Refund Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value
            // if finalCalculationgrid."Amount Refundable" <> 0 then
            //     IsRefundable := true
            // else
            //     IsRefundable := false;
        end;

        // Set the first enum option as the default value
        //  Rec."Refund Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value

        finalCalculationgrid.SetRange("Contract ID", Rec."Receivable Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Receivable Tenant ID");
        if Rec."Receivable Payment Status" = PaymentStatus::" " then
            // Set the first enum option as the default value
            Rec."Receivable Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value
    end;

    trigger OnAfterGetRecord()
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin
        // If the field is blank, assign '-'
        if Rec."Receivable Cheque No." = '' then
            Rec."Receivable Cheque No." := '-';

        // Check if the Payment mode is empty (not set)
        if Rec."Receivable Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Receivable Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';

        // Check if the Payment mode is empty (not set)
        if Rec."Refund Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Refund Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Refund Tenant ID");
        if Rec."Refund Payment Status" = PaymentStatus::" " then begin
            // Set the first enum option as the default value
            Rec."Refund Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value
            // if finalCalculationgrid."Amount Refundable" <> 0 then
            //     IsRefundable := true
            // else
            //     IsRefundable := false;
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Receivable Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Receivable Tenant ID");
        if Rec."Receivable Payment Status" = PaymentStatus::" " then
            // Set the first enum option as the default value
            Rec."Receivable Payment Status" := PaymentStatus::Scheduled;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin
        // If the field is blank, assign '-'
        if Rec."Receivable Cheque No." = '' then
            Rec."Receivable Cheque No." := '-';

        // Check if the Payment mode is empty (not set)
        if Rec."Receivable Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Receivable Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';

        // Check if the Payment mode is empty (not set)
        if Rec."Refund Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Refund Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Refund Tenant ID");
        if Rec."Refund Payment Status" = PaymentStatus::" " then begin
            // Set the first enum option as the default value
            Rec."Refund Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value
            // if finalCalculationgrid."Amount Refundable" <> 0 then
            //     IsRefundable := true
            // else
            //     IsRefundable := false;
        end;
        // // Set the first enum option as the default value
        // Rec."Refund Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value

        finalCalculationgrid.SetRange("Contract ID", Rec."Receivable Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Receivable Tenant ID");
        if Rec."Receivable Payment Status" = PaymentStatus::" " then
            // Set the first enum option as the default value
            Rec."Receivable Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value
    end;


    var
        IsRefundable: Boolean;
}