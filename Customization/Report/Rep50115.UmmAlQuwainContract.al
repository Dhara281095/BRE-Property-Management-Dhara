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
