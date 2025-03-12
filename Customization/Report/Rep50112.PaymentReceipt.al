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
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))  // Add a column to hold the current date
            {
            }
            column(Customer_Id; "Customer Id")
            {

            }
            column(Description; Description)
            {

            }
            column(Account_No_; "Account No.")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(ApptoDocNo; "Applies-to Doc. No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Document_Type; "Document Type")
            {

            }
            column(ApptoDocType; "Applies-to Doc. Type")
            {

            }
            column(Amount; -Amount)
            {

            }

            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Account No.");
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
            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemLink = "No." = field("Applies-to Doc. No.");
                column(Posting_Date_sales; "Posting Date")
                {

                }
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Applies-to Doc. No." = field("Document No.");
                column(DesEntry; Description)
                {

                }
                column(Amountentry; "Amount to Apply")
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
}
