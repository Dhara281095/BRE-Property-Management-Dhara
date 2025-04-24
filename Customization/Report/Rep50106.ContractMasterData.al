namespace PropertyManagement.PropertyManagement;
using System.Utilities;

report 50106 ContractMasterData
{
    ApplicationArea = All;
    Caption = 'ContractMasterData';
    UsageCategory = ReportsAndAnalysis;
    ExcelLayout = 'Contract MasterData.xlsx';
    DefaultLayout = Excel;

    dataset
    {
        dataitem(TenancyContract; "Tenancy Contract")
        {
            column(Report_Period; CustomDateRangeText)
            {
            }
            column(Contract_ID; "Contract ID")
            {
            }
            column(Owner_s_Name; "Owner's Name")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Contract_Start_Date; ContractStartDateText)
            {
            }
            column(Contract_End_Date; ContractEndDateText)
            {
            }
            column(Contract_Type; ContractTypeFormatted)
            {
            }
            column(Proposal_ID; ProposalInfoText)
            {
            }
            column(Contract_Tenor; "Contract Tenor")
            {
            }
            column(Tenant_Contract_Status; TenantStatusFormatted)
            {
            }
            column(Contract_Amount; "Annual Rent Amount")
            {

            }
            column(Annual_Rent_Amount; "Rent Amount")
            {
            }
            column(Security_Deposit_Amount; "Security Deposit Amount")
            {
            }
            column(Property_Name; "Property Name")
            {
            }
            column(Unit_Name; "Unit Name")
            {
            }
            column(UnitID; UnitIDFormatted)
            {
            }
            column(Unit_Number; "Unit Number")
            {
            }
            column(UnitArea_Sq_Feet; "Unit Sq. Feet")
            {
            }
            column(Unit_Usage_Type; "Usage Type")
            {
            }
            column(Suspension_Date; SuspensionDateText)
            {
            }
            column(Suspended_Reason_list; SuspensionReasonText)
            {
            }
            column(Termination_Date; TerminationDateText)
            {
            }
            column(Grace_Start_Date; GraceStartDateText)
            {
            }
            column(Grace_End_Date; GraceEndDateText)
            {
            }
            column(Grace_Period; "Grace Period")
            {
            }
            dataitem("Final Calculation"; "Final Calculation")
            {
                DataItemLink = "Contract ID" = field("Contract ID"); // Link Final Calculation with Tenancy Contract using Contract ID

                trigger OnAfterGetRecord()
                begin
                    // Check if Termination Date is null or 0D and set the display value accordingly
                    if "Termination Date" = 0D then
                        TerminationDateText := '-'
                    else
                        TerminationDateText := Format("Termination Date", 0, '<Day,2>/<Month,2>/<Year4>');
                end;

                trigger OnPreDataItem()
                begin
                    // If there are no records, this will ensure the termination date is properly set
                    if IsEmpty then
                        TerminationDateText := '-';
                end;
            }

            trigger OnAfterGetRecord()
            var
                StartDateIsInRange: Boolean;
                EndDateIsInRange: Boolean;
                SuspensionReasonRec: Record SuspendReasonTable;
                FinalCalc: Record "Final Calculation";
            begin
                TerminationDateText := '-';
                // Set the custom date range text
                CustomDateRangeText :=
                    Format(CustomStartDate, 0, '<Day,2>/<Month,2>/<Year4>') + ' - ' +
                    Format(CustomEndDate, 0, '<Day,2>/<Month,2>/<Year4>');

                // Check if Contract Start Date or Contract End Date is in the specified range
                StartDateIsInRange := ("Contract Start Date" >= CustomStartDate) and ("Contract Start Date" <= CustomEndDate);
                EndDateIsInRange := ("Contract End Date" >= CustomStartDate) and ("Contract End Date" <= CustomEndDate);

                if not (StartDateIsInRange or EndDateIsInRange) then
                    CurrReport.SKIP(); // Skip record if neither date is in range

                // Check if there's a termination date directly, in case the nested dataitem doesn't run
                FinalCalc.Reset();
                FinalCalc.SetRange("Contract ID", "Contract ID");
                if FinalCalc.FindFirst() then begin
                    if FinalCalc."Termination Date" = 0D then
                        TerminationDateText := '-'
                    else
                        TerminationDateText := Format(FinalCalc."Termination Date", 0, '<Day,2>/<Month,2>/<Year4>');
                end;

                // Reset suspension start date before searching
                SuspensionStartDate := 0D;
                SuspensionReasonText := '';

                // Find suspension date for the current contract
                SuspensionReasonRec.Reset();
                SuspensionReasonRec.SetRange("Contract ID", "Contract ID");
                if SuspensionReasonRec.FindFirst() then begin
                    SuspensionStartDate := SuspensionReasonRec.DateEffective;
                    SuspensionReasonText := Format(SuspensionReasonRec.Reason);
                end;

                // Combine Proposal ID and Renewal Proposal ID after converting them to Text
                // ProposalInfoText := 'Proposal ID: ' + Format("Proposal ID") + ' / ' + 'ContractRenewal ID: ' + Format("Renewal Proposal ID");

                case "Contract Type" of
                    "Contract Type"::"New Contract":
                        ProposalInfoText := 'Proposal ID: ' + Format("Proposal ID");
                    "Contract Type"::"Renewal Contract":
                        ProposalInfoText := 'ContractRenewal ID: ' + Format("Renewal Proposal ID");
                    else
                        ProposalInfoText := '-';
                end;

                // Replace NULL values with a default '-'
                if Format("Contract ID") = '' then
                    "Contract ID" := '-';

                if Format("Owner's Name") = '' then
                    "Owner's Name" := '-';

                if Format("Customer Name") = '' then
                    "Customer Name" := '-';

                if "Contract Start Date" = 0D then
                    ContractStartDateText := '-'
                else
                    ContractStartDateText := Format("Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>');

                if "Contract End Date" = 0D then
                    ContractEndDateText := '-'
                else
                    ContractEndDateText := Format("Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>');

                if "Contract Type" = "Contract Type"::" " then
                    ContractTypeFormatted := '-'
                else
                    ContractTypeFormatted := Format("Contract Type");

                if Format("Contract Tenor") = '' then
                    "Contract Tenor" := '-';

                if "Tenant Contract Status" = "Tenant Contract Status"::" " then
                    TenantStatusFormatted := '-'
                else
                    TenantStatusFormatted := Format("Tenant Contract Status");

                // if "Annual Rent Amount" = 0 then
                //     AnnualRentAmountText := '0.00'
                // else
                //     AnnualRentAmountText := Format("Annual Rent Amount", 0, '<Precision,2:2><Standard Format,0>');

                // if "Rent Amount" = 0 then
                //     RentAmountText := '0.00'
                // else
                //     RentAmountText := Format("Rent Amount", 0, '<Precision,2:2><Standard Format,0>');

                // if "Security Deposit Amount" = 0 then
                //     SecurityDepositAmountText := '0.00'
                // else
                //     SecurityDepositAmountText := Format("Security Deposit Amount", 0, '<Precision,2:2><Standard Format,0>');

                if "Annual Rent Amount" = 0 then
                    "Annual Rent Amount" := 0;

                if "Rent Amount" = 0 then
                    "Rent Amount" := 0;

                if "Security Deposit Amount" = 0 then
                    "Security Deposit Amount" := 0;

                if Format("Property Name") = '' then
                    "Property Name" := '-';

                if Format("Unit Name") = '' then
                    "Unit Name" := '-';

                if "Unit ID" = '' then
                    UnitIDFormatted := '-'
                else
                    UnitIDFormatted := "Unit ID";

                if Format("Unit Number") = '' then
                    "Unit Number" := '-';

                if Format("Unit Sq. Feet") = '' then
                    "Unit Sq. Feet" := '-';

                if Format("Usage Type") = '' then
                    "Usage Type" := '-';

                if SuspensionStartDate = 0D then
                    SuspensionDateText := '-'
                else
                    SuspensionDateText := Format(SuspensionStartDate, 0, '<Day,2>/<Month,2>/<Year4>');

                if SuspensionReasonText = '' then
                    SuspensionReasonText := '-';

                if "Grace Start Date" = 0D then
                    GraceStartDateText := '-'
                else
                    GraceStartDateText := Format("Grace Start Date", 0, '<Day,2>/<Month,2>/<Year4>');

                if "Grace End Date" = 0D then
                    GraceEndDateText := '-'
                else
                    GraceEndDateText := Format("Grace End Date", 0, '<Day,2>/<Month,2>/<Year4>');

                if "Grace Period" = 0 then
                    "Grace Period" := 0;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(DateFilter)
                {
                    field(CustomStartDate; CustomStartDate)
                    {
                        ApplicationArea = All;
                        // Caption = 'Custom Start Date';
                    }
                    field(CustomEndDate; CustomEndDate)
                    {
                        ApplicationArea = All;
                        // Caption = 'Custom End Date';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }

    }
    var
        CustomStartDate: Date;
        CustomEndDate: Date;
        CustomDateRangeText: Text;
        ProposalInfoText: Text;
        SuspensionStartDate: Date;
        ContractTypeFormatted: Text;
        TenantStatusFormatted: Text;
        UnitIDFormatted: Text;
        ContractStartDateText: Text;
        ContractEndDateText: Text;
        GraceStartDateText: Text;
        GraceEndDateText: Text;
        SuspensionDateText: Text;
        SuspensionReasonText: Text;
        TerminationDateText: Text; // Variable to store formatted Termination Date

    // AnnualRentAmountText: Text;
    // RentAmountText: Text;
    // SecurityDepositAmountText: Text;
    // GracePeriodText: Text;
}
