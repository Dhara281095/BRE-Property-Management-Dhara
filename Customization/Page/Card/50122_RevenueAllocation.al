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
    procedure FetchContracts()
    var
        FilterHeader: Record "Revenue Allocation Details";
        ContractRec: Record "Tenancy Contract";
        FilteredContractRec: Record "Revenue Allocation SubGrid";
        SelectedMonthStart: Date;
        SelectedMonthEnd: Date;
        MonthNo: Integer;
        FinancialYear: Integer;
    begin
        MonthNo := Rec.Month;
        FinancialYear := Rec."Financial Year";

        Message('Month: %1, Year: %2', Rec.Month, Rec."Financial Year");


        SelectedMonthStart := DMY2Date(01, MonthNo, FinancialYear); // First day of the month
        SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart); // Last day of the month


        // Loop through all contracts

        if ContractRec.FindSet() then begin
            repeat
                // Include contracts that:
                // 1. Start before or during the selected month and end after or during it
                // 2. Fully start and end within the selected month
                if ((ContractRec."Contract Start Date" <= SelectedMonthEnd) and
                    (ContractRec."Contract End Date" >= SelectedMonthStart)) then begin
                    // Add matching contracts to the temporary table
                    FilteredContractRec.Init();
                    FilteredContractRec."Contract Id" := ContractRec."Contract ID";
                    FilteredContractRec."Contract Start Date" := ContractRec."Contract Start Date";
                    FilteredContractRec."Contract End Date" := ContractRec."Contract End Date";
                    FilteredContractRec.Insert();
                    Clear(FilteredContractRec);
                end;
            until ContractRec.Next() = 0;
        end;



        // if ContractRec.FindSet() then begin
        //     repeat
        //         // Compare contract dates with the selected month range
        //         if ((ContractRec."Contract Start Date" <= SelectedMonthStart) and
        //             (ContractRec."Contract End Date" >= SelectedMonthEnd)) then begin
        //             // Add matching contracts to the temporary table
        //             FilteredContractRec."Contract Id" := ContractRec."Contract ID";
        //             FilteredContractRec."Contract Start Date" := ContractRec."Contract Start Date";
        //             FilteredContractRec."Contract End Date" := ContractRec."Contract End Date";
        //             FilteredContractRec.Insert();
        //             Clear(FilteredContractRec);
        //         end;
        //     until ContractRec.Next() = 0;
        // end;

    end;
}
