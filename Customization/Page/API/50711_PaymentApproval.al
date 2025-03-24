namespace PropertyManagement.PropertyManagement;

page 50711 PaymentApproval
{
    APIGroup = 'payment';
    APIPublisher = 'RealeststeDev';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'paymentApproval';
    DelayedInsert = true;
    EntityName = 'paymentApproval';
    EntitySetName = 'paymentApprovals';
    PageType = API;
    ODataKeyFields = SystemId;
    SourceTable = "Approval Payment Request";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                // field(changedPaymentSeries; Rec."Changed Payment Series")
                // {
                //     Caption = 'Changed Payment Series';
                // }
                field(contractID; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                }
                field(id; Rec.ID)
                {
                    Caption = 'ID';
                }
                field(manualautoStatus; Rec."Manual/Auto Status")
                {
                    Caption = 'Manual/Auto Status';
                }
                field(proposalID; Rec."Proposal ID")
                {
                    Caption = 'Proposal ID';
                }
                field(requestType; Rec."Request Type")
                {
                    Caption = 'Request Type';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
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
                field(tenantID; Rec."Tenant ID")
                {
                    Caption = 'Tenant ID';
                }
                field("ChangeAmount"; Rec."Change Amount")
                {
                    Caption = 'Change Amount';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field("PaymentSeries"; Rec."Payment Series")
                {
                    Caption = 'Payment Series';
                }
                field("changePaymentseries"; Rec."change Payment series")
                {
                    Caption = 'change Payment series';
                }
                field("Paymentmode"; Rec."Payment mode")
                {
                    Caption = 'Payment mode';
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field("VatAmount"; Rec."Vat Amount")
                {
                    Caption = 'Vat Amount';
                }

                field("DueDate"; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(Items; Rec.Items)
                {
                    Caption = 'Items';
                }

            }
        }
    }
}
