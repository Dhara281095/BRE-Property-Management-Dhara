namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Foundation.Company;
report 50110 "Other Payment Details"
{
    ApplicationArea = All;
    Caption = 'Other Payment Details';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "OtherPayment.docx";
    dataset
    {
        dataitem("Revenue Item Subpage"; "Revenue Item Subpage")
        {
            column(ProposalID; ProposalID)
            {
            }
            column(Property_Name; "Property Name")
            {
            }
            column(Unit_Name; "Unit Name")
            {
            }
            column(Unit_Size; "Unit Size")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Entry_No_; AutoEntryNo)
            {
            }
            column(Secondary_Item_Type; "Secondary Item Type")
            {
            }
            column(Amount; Amount)
            {
            }
            column(VAT_Amount; "VAT Amount")
            {
            }
            column(A_Including_VAT; "Amount Including VAT")
            {
            }
            column(Start_Date; "Start Date")
            {
            }
            column(End_Date; "End Date")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))  // Add a column to hold the current date
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            trigger OnAfterGetRecord()
            begin
                AutoEntryNo += 1;  // Auto-increment Entry No.
                                   // Store values in global variables
                PropertyNameStored := "Property Name";
                UnitNameStored := "Unit Name";
                UnitSizeStored := "Unit Size";
                CustomerNameStored := "Customer Name";
                // Accumulate values for each record
                TotalAmount += Amount;
                TotalVATAmount += "VAT Amount";
                TotalAmountIncludingVAT += "Amount Including VAT";
            end;
        }
        dataitem(TotalSection; System.Utilities.Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(T_Amount; TotalAmount)
            {
            }
            column(T_VAT_A; TotalVATAmount)
            {
            }
            column(TA_Incl_VAT; TotalAmountIncludingVAT)
            {
            }
        }

        dataitem("Lease Proposal Details"; "Lease Proposal Details")
        {
            DataItemLink = "Proposal ID" = field(ProposalID);
            DataItemLinkReference = "Revenue Item Subpage";
            column(ID; "Proposal ID")
            {
            }
            column(Rent_Amount; "Rent Amount")
            {
            }
            column(Annual_R_A; "Annual Rent Amount")
            {
            }
            column(Rent_VAT_A; "Rent VAT Amount")
            {
            }
            column(RA_Incl_VAT; "Rent Amount Including VAT")
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
        layout("OtherPayment.docx")
        {
            Type = Word;
            LayoutFile = './OtherPayment.docx';
            Caption = 'OtherPayment (Word)';
            Summary = 'The OtherPaymentDetails (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
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
        AutoEntryNo := 0;  // Initialize auto-increment variable
    end;

    var
        CompanyInfo: Record "Company Information";
        TotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountIncludingVAT: Decimal;
        PropertyNameStored: Text;
        UnitNameStored: Text;
        UnitSizeStored: Decimal;
        CustomerNameStored: Text[100];
        AutoEntryNo: Integer;  // New variable for auto-increment Entry No.
}

