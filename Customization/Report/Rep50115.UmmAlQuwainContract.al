namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Foundation.Company;
report 50115 UmmAlQuwainContract
{
    ApplicationArea = All;
    Caption = 'Umm Al Quwain Contract';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "UmmAlQuwainContract.docx";
    dataset
    {
        dataitem(TenancyContract; "Tenancy Contract")
        {
            column(Customer_Name; "Customer Name")
            {
            }
            column(Emirates_ID; "Emirates ID")
            {
            }
            column(Contact_Number; "Contact Number")
            {
            }
            column(Email_Address; "Email Address")
            {
            }
            column(Owner_s_Name; "Owner's Name")
            {
            }
            column(Lessor_s_Name; "Lessor's Name")
            {
            }
            column(Lessor_s_Emirates_ID; "Lessor's Emirates ID")
            {
            }
            column(Lessor_s_Phone; "Lessor's Phone")
            {
            }
            column(Lessor_s_Email; "Lessor's Email")
            {
            }
            column(Contract_Start_Date; "Contract Start Date")
            {
            }
            column(Contract_End_Date; "Contract End Date")
            {
            }
            column(Property_Size; "Property Size")
            {
            }
            column(Base_Unit_of_Measure; "Base Unit of Measure")
            {
            }
            column(Unit_Number; "Unit Number")
            {
            }
            column(Property_Type; "Property Type")
            {
            }
            column(Unit_Name; "Unit Name")
            {
            }
            column(Property_Name; "Property Name")
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
        layout("UmmAlQuwainContract.docx")
        {
            Type = Word;
            LayoutFile = './UmmAlQuwainContract.docx';
            Caption = 'UmmAlQuwainContract (Word)';
            Summary = 'The UmmAlQuwainContract (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
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
}
