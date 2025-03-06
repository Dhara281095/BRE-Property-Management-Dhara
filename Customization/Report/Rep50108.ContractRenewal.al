namespace PropertyManagement.PropertyManagement;
using Microsoft.Foundation.Company;
report 50108 "Contract Renewal"
{
    ApplicationArea = All;
    Caption = 'Contract Renewal';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "ContractRenewalTemplate.docx";
    dataset
    {
        dataitem(ContractRenewal; "Contract Renewal")
        {
            column(Contract_Date; "Contract Date")
            {
            }
            column(Property_Name; "Property Name")
            {
            }
            column(Unit_Number; "Unit Number")
            {
            }
            column(Tenant_Full_Name; "Tenant Full Name")
            {
            }
            column(Annual_Rent_Amount; "Annual Rent Amount")
            {
            }
            column(Contract_Amount; "Contract Amount")
            {
            }
            column(Rera; Rera)
            {
            }
            column(Ejari_Processing_Charges; "Ejari Processing Charges")
            {
            }
            column(Renewal_Charges; "Renewal Charges")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(Community; Community)
            {
            }
            column(Contract_End_Date; Format("Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))  // Add a column to hold the current date
            {
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
        layout("ContractRenewalTemplate.docx")
        {
            Type = Word;
            LayoutFile = './ContractRenewalTemplate.docx';
            Caption = 'ContractRenewalTemplate (Word)';
            Summary = 'The ContractRenewalTemplate (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }

    trigger OnInitReport()
    var
        CurrentDate: Date;
    begin
        if not CompanyInfo.Get() then begin
            Error('Company Information not found.');
        end else begin
            // CompanyAddress := CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
            CompanyInfo.CalcFields(Picture);
        end;

        CurrentDate := Today;

    end;

    var
        CompanyInfo: Record "Company Information";
}
