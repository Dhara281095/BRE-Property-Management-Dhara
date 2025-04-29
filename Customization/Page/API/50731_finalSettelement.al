namespace BREPropertyManagemenMeghatMaster.BREPropertyManagemenMeghatMaster;

page 50731 finalSettelement
{
    APIGroup = 'finalcal';
    APIPublisher = 'RealeststeDev';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'finalSettelement';
    DelayedInsert = true;
    EntityName = 'finalSettlement';
    EntitySetName = 'finalSettlements';
    PageType = API;
    SourceTable = FinalSettlement;
    ODataKeyFields = SystemId;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(contractId; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                }
                field(ReceivablecontractId; Rec."Contract ID")
                {
                    Caption = 'Receivable Contract ID';
                }
                field(depositBank; Rec."Deposit Bank")
                {
                    Caption = 'Deposit Bank';
                }
                field(depositStatus; Rec."Deposit Status")
                {
                    Caption = 'Deposit Status';
                }
                // field(dueDate; Rec."Refund Due Date")
                // {
                //     Caption = 'Due Date';
                // }
                // field(entryNo; Rec."Entry No.")
                // {
                //     Caption = 'Entry No.';
                // }
                // field(from; Rec."From.")
                // {
                //     Caption = 'From.';
                // }
                // field(paymentStatus; Rec."Receivable Payment Status")
                // {
                //     Caption = 'Payment Status';
                // }
                // field(paymentMode; Rec."Receivable Payment mode")
                // {
                //     Caption = 'Payment mode';
                // }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
                field(ReceivabletenantID; Rec."Tenant ID")
                {
                    Caption = 'Receivable Tenant ID';
                }
                // field("to"; Rec."To.")
                // {
                //     Caption = 'To.';
                // }
                // field(totalAmount; Rec."Receivable Total Amount")
                // {
                //     Caption = 'Total Amount';
                // }
                // field("RefundContractID"; Rec."Refund Contract ID")
                // {
                //     Caption = 'Refund Contract ID';
                // }
                // field("RefundTotalAmount"; Rec."Refund Total Amount")
                // {
                //     Caption = 'Refund Total Amount';
                // }
                // field("RefundDueDate"; Rec."Refund Due Date")
                // {
                //     Caption = 'Refund Due Date';
                // }
                // field("RefundPaymentmode"; Rec."Refund Payment mode")
                // {
                //     Caption = 'Refund Payment mode';
                // }
                // field("RefundPaymentStatus"; Rec."Refund Payment Status")
                // {
                //     Caption = 'Refund Payment Status';
                // }
                // field("RefundChequeNo"; Rec."Refund Cheque No.")
                // {
                //     Caption = 'Refund Cheque No.';
                // }
                field("ReceivableTotalAmount"; Rec."Receivable Total Amount")
                {
                    Caption = 'Receivable Total Amount';
                }
                field("ReceivableDueDate"; Rec."Receivable Due Date")
                {
                    Caption = 'Receivable Due Date';
                }
                field("ReceivablePaymentmode"; Rec."Receivable Payment mode")
                {
                    Caption = 'Receivable Payment mode';
                }
                field("ReceivablePaymentStatus"; Rec."Receivable Payment Status")
                {
                    Caption = 'Receivable Payment Status';
                }
                field("ReceivableChequeNo"; Rec."Receivable Cheque No.")
                {
                    Caption = 'Receivable Cheque No.';
                }
                // field("RefundTenantID"; Rec."Refund Tenant ID")
                // {
                //     Caption = 'Refund Tenant ID';
                // }
                field("ReceivablefromtheTenant"; Rec."Receivable from the Tenant")
                {
                    Caption = 'Receivable from the Tenant';
                }
                field("PaymentProcessed"; Rec."Payment Processed")
                {
                    Caption = 'Payment Processed';
                }
                field("BalanceReceivable"; Rec."Balance Receivable")
                {
                    Caption = 'Balance Receivable';
                }
                field(PaymentStatusmode; Rec.PaymentStatus)
                {
                    Caption = 'Payment Status mode';
                }
                // field("NetRefundtotheTenant"; Rec."Net Refund to the Tenant")
                // {
                //     Caption = 'Net Refund to the Tenant';
                // }
                // field("RefundProcessed"; Rec."Refund Processed")
                // {
                //     Caption = 'Refund Processed';
                // }
                // field("BalanceRefundable"; Rec."Balance Refundable")
                // {
                //     Caption = 'Balance Refundable';
                // }
                // field("RefundStatus"; Rec."Refund Status")
                // {
                //     Caption = 'Refund Status';
                // }
                field("paymentreceipt"; Rec."Payment Receipt")
                {
                    Caption = 'Payment Receipt';
                }
                // field("paymentreceiptproof"; Rec."Payment Receipt/Proof")
                // {
                //     Caption = 'payment receipt/proof';
                // }
                field("paymentreceiptdocumentuRL"; Rec."Payment Receipt document URL")
                {
                    Caption = 'Payment Receipt document URL';
                }
                // field("payreceiptproofdocumentuRL"; Rec."Pay Receipt/Proof document URL")
                // {
                //     Caption = 'Pay Receipt/Proof document URL';
                // }

            }
        }
    }
}
