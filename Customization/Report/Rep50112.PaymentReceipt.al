namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
report 50112 PaymentReceipt
{
    ApplicationArea = All;
    Caption = 'Payment Receipt';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "PaymentReceipt.docx";
    dataset
    {
        dataitem("Payment Schedule2"; "Payment Schedule2")
        {
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPostcode; CompanyInfo."Post Code")
            {
            }
            column(CompanyCountry; CompanyInfo."Country/Region Code")
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))  // Add a column to hold the current date
            {
            }
            column(Contract_ID; "Contract ID")
            {
            }
            column(Pay_S; "Payment Series")
            {
            }
            column(Invoice_ID; "Invoice ID")
            {
            }
            // column(Payment_Mode; "Payment Mode")
            // {
            // }
            // column(Che_N; "Cheque Number")
            // {
            // }
            column(Secondary_Item_Type; "Secondary Item Type")
            {
            }
            column(Amount; Amount)
            {
            }
            column(T_A; "VAT Amount")
            {
            }
            column(AIV; "Amount Including VAT")
            {
            }
            // dataitem("Payment Mode2"; "Payment Mode2")
            // {
            //     DataItemLink = "Payment Series" = field("Payment Series");
            //     column(Payment_Mode; "Payment Mode")
            //     {
            //     }
            //     column(Che_N; "Cheque Number")
            //     {
            //     }
            // }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Tenant Id");
                column(Name; Name)
                {
                }
                column(Address; Address)
                {
                }
                column(Phone_No_; "Phone No.")
                {
                }
                column(E_Mail; "E-Mail")
                {
                }
            }
            dataitem("Tenancy Contract"; "Tenancy Contract")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                column(Property_Name; "Property Name")
                {
                }
                column(Unit_Name; "Unit Name")
                {
                }
                column(Contract_Tenor; "Contract Tenor")
                {
                }
            }
        }


    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
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
    rendering
    {
        layout("PaymentReceipt.docx")
        {
            Type = Word;
            LayoutFile = './PaymentReceipt.docx';
            Caption = 'PaymentReceipt (Word)';
            Summary = 'The PaymentReceipt (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }
    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then begin
            Error('Company Information not found.');
        end else begin
            // CompanyAddress := CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
            CompanyInfo.CalcFields(Picture);
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        TotalAmount: Decimal;  // New variable to store the total amount
}
