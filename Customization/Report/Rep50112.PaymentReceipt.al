namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Foundation.Company;
report 50112 PaymentReceipt
{
    ApplicationArea = All;
    Caption = 'Payment Receipt';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "PaymentReceipt.docx";
    dataset
    {
        dataitem(GenJournalLine; "Gen. Journal Line")
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
            column(Customer_Id; "Customer Id")
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
}
