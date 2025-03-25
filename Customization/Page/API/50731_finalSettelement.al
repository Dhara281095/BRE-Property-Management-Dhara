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
                field(chequeNo; Rec."Receivable Cheque No.")
                {
                    Caption = 'Cheque No.';
                }
                field(contractID; Rec."Receivable Contract ID")
                {
                    Caption = 'Contract ID';
                }
                field(depositBank; Rec."Deposit Bank")
                {
                    Caption = 'Deposit Bank';
                }
                field(depositStatus; Rec."Deposit Status")
                {
                    Caption = 'Deposit Status';
                }
                field(dueDate; Rec."Refund Due Date")
                {
                    Caption = 'Due Date';
                }
                // field(entryNo; Rec."Entry No.")
                // {
                //     Caption = 'Entry No.';
                // }
                // field(from; Rec."From.")
                // {
                //     Caption = 'From.';
                // }
                field(paymentStatus; Rec."Receivable Payment Status")
                {
                    Caption = 'Payment Status';
                }
                field(paymentMode; Rec."Receivable Payment mode")
                {
                    Caption = 'Payment mode';
                }
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
                field(tenantID; Rec."Receivable Tenant ID")
                {
                    Caption = 'Tenant ID';
                }
                // field("to"; Rec."To.")
                // {
                //     Caption = 'To.';
                // }
                field(totalAmount; Rec."Receivable Total Amount")
                {
                    Caption = 'Total Amount';
                }
            }
        }
    }
}
