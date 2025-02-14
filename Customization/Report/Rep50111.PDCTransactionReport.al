namespace BREPropertyManagementMargi.BREPropertyManagementMargi;

report 50111 "PDC Transaction Report"
{
    ApplicationArea = All;
    Caption = 'PDC Transaction Report';
    UsageCategory = ReportsAndAnalysis;
    ExcelLayout = 'PDC Transaction Report.xlsx';
    DefaultLayout = Excel;
    dataset
    {
        dataitem(PDCTransaction; "Payment Mode2")
        {
            DataItemTableView = where("Payment Mode" = const('Cheque'));
            column(Report_Period; CustomDateRangeText)
            {
            }
            // column(PDC_ID; "PDC ID")
            // {
            // }
            column(payment_Series; "payment Series")
            {
            }
            column(Contract_ID; "Contract ID")
            {
            }
            column(Tenant_Id; "Tenant Id")
            {
            }
            column(Tenant_Name; "Tenant Name")
            {
            }
            // column(Bank_Name; "Bank Name")
            // {
            // }
            column(Cheque_Number; "Cheque Number")
            {
            }
            column(Cheque_Date; "Due Date")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Old_Cheque_; "Old Cheque #")
            {
            }
            column(Cheque_Status; "Cheque Status")
            {
            }
            column(Approval_Status; "Approval Status")
            {
            }
            column(Payment_Status; "Payment Status")
            {
            }
            trigger OnAfterGetRecord()
            var
                StartDateIsInRange: Boolean;
                EndDateIsInRange: Boolean;
            begin
                // Set the custom date range text
                CustomDateRangeText :=
                    Format(CustomStartDate, 0, '<Day,2>/<Month,2>/<Year4>') + ' - ' +
                    Format(CustomEndDate, 0, '<Day,2>/<Month,2>/<Year4>');

                // Check if Contract Start Date or Contract End Date is in the specified range
                StartDateIsInRange := ("Due Date" >= CustomStartDate) and ("Due Date" <= CustomEndDate);
                EndDateIsInRange := ("Due Date" >= CustomStartDate) and ("Due Date" <= CustomEndDate);

                if not (StartDateIsInRange or EndDateIsInRange) then
                    CurrReport.SKIP(); // Skip record if neither date is in range
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
}
