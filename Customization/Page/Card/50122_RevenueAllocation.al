page 50122 "Revenue Allocation Card"
{
    PageType = Card;
    SourceTable = "Revenue Allocation Details";
    ApplicationArea = All;
    Caption = 'Revenue Allocation Details';
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Revenue Allocation Details';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    trigger OnValidate()
                    begin
                        if xRec."No." <> Rec."No." then
                            ClearSubgridData();
                    end;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                    Caption = 'Month';

                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                    Caption = 'Financial Year';
                }
            }
            group("Revenue Allocation Report Details")
            {
                Caption = 'Revenue Allocation Report Details';
                part("Revenue Allocation Details"; "Revenue Allocation SubGrid")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FilterSubgrid)
            {

                trigger OnAction()
                begin
                    FetchContracts();
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearSubgridData();
    end;

    procedure ClearSubgridData()
    var
        FilteredContractRec: Record "Revenue Allocation SubGrid";
    begin
        FilteredContractRec.Reset();
        FilteredContractRec.DeleteAll();
    end;

    procedure FetchContracts()
    var
        FilterHeader: Record "Revenue Allocation Details";
        ContractRec: Record "Tenancy Contract";
        FilteredContractRec: Record "Revenue Allocation SubGrid";
        SuspensionRec: Record SuspendReasonTable;
        SelectedMonthStart: Date;
        SelectedMonthEnd: Date;
        MonthNo: Integer;
        FinancialYear: Integer;
    begin
        MonthNo := Rec.Month + 1;
        FinancialYear := Rec."Financial Year";

        Message('Month: %1, Year: %2', Rec.Month, Rec."Financial Year");


        SelectedMonthStart := DMY2Date(01, MonthNo, FinancialYear); // First day of the month
        SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart); // Last day of the month



        // Loop through all contracts
        if ContractRec.FindSet() then begin
            repeat
                if ((ContractRec."Contract Start Date" <= SelectedMonthEnd) and
                    (ContractRec."Contract End Date" >= SelectedMonthStart)) then begin
                    // Add matching contracts to the temporary table
                    FilteredContractRec.Init();
                    FilteredContractRec."Property Name" := ContractRec."Property Name";
                    FilteredContractRec."Contract Id" := ContractRec."Contract ID";
                    FilteredContractRec."Contract Tenure" := ContractRec."Contract Tenor";
                    FilteredContractRec."Customer Name" := ContractRec."Customer Name";
                    FilteredContractRec."Contract Start Date" := ContractRec."Contract Start Date";
                    FilteredContractRec."Contract End Date" := ContractRec."Contract End Date";
                    FilteredContractRec."Grace Days" := ContractRec."Grace Period";
                    // Look up suspension dates from Suspension Reason table
                    SuspensionRec.Reset();
                    SuspensionRec.SetRange("Contract ID", ContractRec."Contract ID");
                    if SuspensionRec.FindFirst() then begin
                        FilteredContractRec."Suspension Start Date" := SuspensionRec.DateEffective;
                        FilteredContractRec."Suspension End Date" := SuspensionRec.SuspensionEndDate;
                    end;
                    FilteredContractRec."Multi Year Start Date" := ContractRec."Contract Start Date";
                    FilteredContractRec."Multi Year End Date" := ContractRec."Contract End Date";
                    FilteredContractRec."Contract Amount" := ContractRec."Annual Rent Amount";
                    FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
                    FilteredContractRec."Posting Month" := MonthNo - 1;
                    FilteredContractRec."Posting Year" := FinancialYear;
                    FilteredContractRec."Posting Period" := Format(FilteredContractRec."Posting Month") + ' ' + Format(FilteredContractRec."Posting Year") + ' ' + '-' + ' ' + Format(FilteredContractRec."Posting Month") + ' ' + Format(FilteredContractRec."Posting Year");
                    // FilteredContractRec."No Of Days" := ContractRec.;
                    // FilteredContractRec."Per Day Rent" := ContractRec.;
                    // FilteredContractRec."Total Value" := ContractRec.;
                    FilteredContractRec."Owner Name" := ContractRec."Owner's Name";
                    // FilteredContractRec."Owner Share" := ContractRec."Owner's Name";
                    FilteredContractRec.Insert();
                    Clear(FilteredContractRec);
                end;
            until ContractRec.Next() = 0;
        end;

    end;
}
