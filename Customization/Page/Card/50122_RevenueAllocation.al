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
                    SubPageLink = "Header No." = field("No.");
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
        FilteredContractRec.SetRange("Header No.", Rec."No.");
        FilteredContractRec.DeleteAll();
    end;

    // Helper procedure to insert allocation line
    procedure InsertAllocationLine(
    ContractRec: Record "Tenancy Contract";
    LineNo: Integer;
    MonthNo: Integer;
    FinancialYear: Integer)
    var
        FilteredContractRec: Record "Revenue Allocation SubGrid";
        SuspensionRec: Record SuspendReasonTable;
        DaysInDecember: Integer;
        StartDateForDays: Date;
        EndDateForDays: Date;
    begin
        FilteredContractRec.Init();
        FilteredContractRec."Line No." := LineNo;
        FilteredContractRec."Header No." := Rec."No.";
        FilteredContractRec."Property Name" := ContractRec."Property Name";
        FilteredContractRec."Contract Id" := ContractRec."Contract ID";
        FilteredContractRec."Contract Tenure" := ContractRec."Contract Tenor";
        FilteredContractRec."Customer Name" := ContractRec."Customer Name";
        FilteredContractRec."Contract Start Date" := ContractRec."Contract Start Date";
        FilteredContractRec."Contract End Date" := ContractRec."Contract End Date";
        FilteredContractRec."Grace Days" := ContractRec."Grace Period";

        // Look up suspension dates
        SuspensionRec.Reset();
        SuspensionRec.SetRange("Contract ID", ContractRec."Contract ID");
        if SuspensionRec.FindFirst() then begin
            FilteredContractRec."Suspension Start Date" := SuspensionRec.DateEffective;
            FilteredContractRec."Suspension End Date" := SuspensionRec.SuspensionEndDate;
        end;

        FilteredContractRec."Contract Amount" := ContractRec."Annual Rent Amount";
        FilteredContractRec."Annual Amount" := ContractRec."Rent Amount";
        FilteredContractRec."Posting Month" := MonthNo - 1;
        FilteredContractRec."Posting Year" := FinancialYear;
        FilteredContractRec."Posting Period" := Format(FilteredContractRec."Posting Month") +
            ' ' + Format(FilteredContractRec."Posting Year") + ' ' + '-' + ' ' +
            Format(FilteredContractRec."Posting Month") + ' ' + Format(FilteredContractRec."Posting Year");
        FilteredContractRec."Owner Name" := ContractRec."Owner's Name";

        // Calculate No. of Days for December
        if (MonthNo = 12) and (FinancialYear = DATE2DMY(ContractRec."Contract Start Date", 3)) then begin
            StartDateForDays := Max(DMY2Date(1, 12, FinancialYear), ContractRec."Contract Start Date");
            EndDateForDays := Min(DMY2Date(31, 12, FinancialYear), ContractRec."Contract End Date");
            DaysInDecember := EndDateForDays - StartDateForDays + 1;
            FilteredContractRec."No Of Days" := DaysInDecember;
        end;

        FilteredContractRec.Insert();
    end;


    procedure FetchContracts()
    var
        ContractRec: Record "Tenancy Contract";
        SelectedMonthStart: Date;
        SelectedMonthEnd: Date;
        MonthNo: Integer;
        FinancialYear: Integer;
        NextLineNo: Integer;
    begin
        ClearSubgridData();

        MonthNo := Rec.Month + 1;
        FinancialYear := Rec."Financial Year";
        NextLineNo := 1;

        // Calculate selected month's date range
        SelectedMonthStart := DMY2Date(01, MonthNo, FinancialYear);
        SelectedMonthEnd := CALCDATE('<+1M-1D>', SelectedMonthStart);
        if ContractRec.FindSet() then begin
            repeat
                // Check if contract is valid for selected month
                if ((ContractRec."Contract Start Date" <= SelectedMonthEnd) and
                    (ContractRec."Contract End Date" >= SelectedMonthStart)) then begin

                    InsertAllocationLine(
                        ContractRec,
                        NextLineNo,
                        MonthNo,
                        FinancialYear);
                    NextLineNo += 1;
                end;
            until ContractRec.Next() = 0;
        end;
    end;
    // Helper function to get the maximum of two dates
    local procedure Max(Value1: Date; Value2: Date): Date
    begin
        if Value1 > Value2 then
            exit(Value1)
        else
            exit(Value2);
    end;
    // Helper function to get the minimum of two dates
    local procedure Min(Value1: Date; Value2: Date): Date
    begin
        if Value1 < Value2 then
            exit(Value1)
        else
            exit(Value2);
    end;

}
