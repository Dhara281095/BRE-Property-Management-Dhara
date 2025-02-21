namespace BREPropertyManagemenMeghatMaster.BREPropertyManagemenMeghatMaster;

page 50720 ContractEndApprovalProcess
{
    APIGroup = 'payment';
    APIPublisher = 'RealeststeDev';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'contractEndApprovalProcess';
    DelayedInsert = true;
    EntityName = 'contractendapproval';
    EntitySetName = 'contractendapprovals';
    PageType = API;
    ODataKeyFields = SystemId;
    SourceTable = ContractEndProcessApproval;

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
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(endDate; Rec."End Date")
                {
                    Caption = 'Contract End Date';
                }
                field(id; Rec.ID)
                {
                    Caption = 'ID';
                }
                field(requestedDate; Rec."Requested Date")
                {
                    Caption = 'Requested Date';
                }
                field(startDate; Rec."Start Date")
                {
                    Caption = 'Contract Start Date';
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
                field(tenantName; Rec."Tenant Name")
                {
                    Caption = 'Tenant Name';
                }
                field(Remark; Rec.Remark)
                {
                    Caption = 'Remark';
                }
                field("RequestType"; Rec."Request Type")
                {
                    Caption = 'Request Type';
                }
            }
        }
    }
}
