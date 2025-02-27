namespace BREPropertyManagemenMeghatMaster.BREPropertyManagemenMeghatMaster;

page 50721 FinalCalculationApproval
{
    APIGroup = 'Finance';
    APIPublisher = 'RealeststeDev';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'FinalCalculationApprovalProcess';
    DelayedInsert = true;
    EntityName = 'finalcalculationapproval';
    EntitySetName = 'finalcalculationapprovals';
    PageType = API;
    ODataKeyFields = SystemId;
    SourceTable = FinalCalculationApproval;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(contractId; Rec."Contract Id")
                {
                    Caption = 'Contract Id';
                }
                field(id; Rec.ID)
                {
                    Caption = 'ID';
                }
                field(startDate; Rec."Contract Start Date")
                {
                    Caption = 'Contract Start Date';
                }

                field(endDate; Rec."Contract End Date")
                {
                    Caption = 'Contract End Date';
                }

                field(terminationDate; Rec."Termination Date")
                {
                    Caption = 'Termination Date';
                }

                field(contractAmount; Rec."Contract Amount")
                {
                    Caption = 'Contract Amount';
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
                field(tenantId; Rec."Tenant Id")
                {
                    Caption = 'Tenant Id';
                }
            }
        }
    }
}
