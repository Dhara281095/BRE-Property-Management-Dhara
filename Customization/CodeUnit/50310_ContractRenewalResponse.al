codeunit 50310 "Contract Renewal Response"
{
    procedure SyncToTenancyContractRenewal(ContractStatusRec: Record "Approval Contract Status")
    var
        TenancyContract: Record "Contract Renewal";
    begin
        // Find Tenancy Contract by Contract ID
        TenancyContract.Reset();
        TenancyContract.SetRange(Id, ContractStatusRec."Renewal Contract ID");

        if not TenancyContract.FindFirst() then begin
            Message('No Tenancy Contract found for Contract ID %1', ContractStatusRec."Renewal Contract ID");
            exit;
        end;

        // Handle Approved
        if ContractStatusRec.Status = 'Approve' then begin
            case ContractStatusRec."Tenancy Contract Status" of
                'Contract Renewal':
                    TenancyContract."Renewal Contract Status" := TenancyContract."Renewal Contract Status"::"Renewal of Original Contract ID";

                else
                    Message('Unsupported Tenancy Contract Status: %1', ContractStatusRec."Tenancy Contract Status");
            end;

            TenancyContract."Approval For Renewal" := TenancyContract."Approval For Renewal"::" ";
            TenancyContract."Original Contract ID" := Format(TenancyContract."Contract ID");


            TenancyContract.Modify();
        end;

        // Handle Rejected
        if ContractStatusRec.Status = 'Declined' then begin
            TenancyContract."Approval For Renewal" := TenancyContract."Approval For Renewal"::" ";
            TenancyContract.Modify();
        end;
    end;
}
