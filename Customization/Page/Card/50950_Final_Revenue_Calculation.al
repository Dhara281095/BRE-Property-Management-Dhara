page 50950 "Final Revenue Calculation Grid"
{
    PageType = ListPart;
    ApplicationArea = All;
    Caption = 'Final Revenue Calculation Grid';
    SourceTable = "Final Revenue Calculation Grid";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Revenue Description"; Rec."Revenue Description")
                {
                    ApplicationArea = All;
                    Caption = 'Revenue Description';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Editable = false;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount';
                    ToolTip = 'Specifies the original amount';
                }
                field("Original VAT"; Rec."Original VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Original VAT';
                    ToolTip = 'Specifies the original VAT amount';
                }
                field("Original Amount Incl."; Rec."Original Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount Incl.';
                    ToolTip = 'Specifies the original amount including VAT';
                }
                field("Revised Amount"; Rec."Revised Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Revised Amount';
                    ToolTip = 'Specifies the revised amount after recalculation';
                }
                field("Revised VAT"; Rec."Revised VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Revised VAT';
                    ToolTip = 'Specifies the revised VAT amount';
                }
                field("Revised Amount Incl."; Rec."Revised Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Revised Amount Incl.';
                    ToolTip = 'Specifies the revised amount including VAT';
                }
                field("Difference Amount"; Rec."Difference Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Difference Amount';
                    ToolTip = 'Specifies the difference in amount';
                }
                field("Difference VAT"; Rec."Difference VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Difference VAT';
                    ToolTip = 'Specifies the difference in VAT';
                }
                field("Difference Amount Incl."; Rec."Difference Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Difference Amount Incl.';
                    ToolTip = 'Specifies the difference in amount including VAT';
                }
                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Contract Tenure';
                    Editable = false;

                }
                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                }
                field("Revised VAT %"; Rec."Revised VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'Reviseed VAT %';
                    Editable = false;
                }
                field("ContractYear(Termination Date)"; Rec."ContractYear(Termination Date)")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Year On Termination Date';
                }
                field("Annual Rent Amount TermiYear"; Rec."Annual Rent Amount TermiYear")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount of Termination Year';
                    Editable = false;
                }
                field("Total No. Of Days"; Rec."Total No. Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Total No. Of Days(Termination Year)';
                    ToolTip = 'Enter the Total No. Of Days.';
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        OneTimePaymentTypeRevisedRecalculatedAmount();
        GetRentAmountFromRentCalculation();
    end;

    procedure OneTimePaymentTypeRevisedRecalculatedAmount()
    var
        TenancyContractsubpage: Record "Tenancy Contract Subpage";
        FinalRevenueCalculation: Record "Final Revenue Calculation Grid";
    begin
        TenancyContractsubpage.SetRange(ContractID, Rec."Contract ID");
        TenancyContractsubpage.SetRange("Payment Type", 1);
        TenancyContractsubpage.SetRange("Secondary Item Type", Rec."Revenue Description");
        if TenancyContractsubpage.FindSet() then
            repeat
                Rec."Revised Amount" := TenancyContractsubpage.Amount;
                Rec."Revised VAT" := Round(TenancyContractsubpage.Amount *
                                                       TenancyContractsubpage."VAT %" / 100,
                                                       0.01);
                Rec."Revised Amount Incl." := TenancyContractsubpage."Amount Including VAT";
                Rec.Modify();
            //  Clear(FinalRevenueCalculation);
            until TenancyContractsubpage.Next() = 0;

    end;

    procedure GetRentAmountFromRentCalculation()
    var
        RentCalculation: Record "Rent Calculation Subpage";
        Totalamount: Decimal;
        RentCalculation1: Record "Rent Calculation Subpage";
        TotalVATAmount: Decimal;
        calculateteminationamount: Decimal;
        FinalReviseAmount: Decimal;

    begin
        Totalamount := 0;
        RentCalculation.Reset();
        RentCalculation.SetRange("Contract ID", Rec."Contract ID");
        RentCalculation.SetFilter(Year, '1..%1', Rec."ContractYear(Termination Date)");

        if RentCalculation.FindSet() then begin
            repeat
                // Sum up Final Annual Amount values
                TotalAmount += RentCalculation."Final Annual Amount";
                TotalVATAmount += RentCalculation."VAT Amount"
            until RentCalculation.Next() = 0;
        end;
        RentCalculation1.SetRange("Contract ID", Rec."Contract ID");
        RentCalculation1.SetRange("Secondary Item Type", Rec."Revenue Description");
        if RentCalculation1.FindSet() then
            repeat
                FinalReviseAmount := Totalamount - Rec."Annual Rent Amount TermiYear";
                calculateteminationamount := Rec."Per Day Rent" * Rec."Total No. Of Days"; // 3rd year 365 days - termination 71 days = 294 so calculate 294 * per day rent 122.67 = FinalReviseAmount variable 
                Rec."Revised Amount" := FinalReviseAmount + calculateteminationamount;
                Rec."Revised VAT %" := 5;
                TotalVATAmount := Rec."Revised Amount" - (Rec."Revised Amount" / (1 + (Rec."Revised VAT %" / 100)));
                TotalVATAmount := Round(TotalVATAmount, 0.01);

                Rec."Revised VAT" := TotalVATAmount;
                Rec."Revised Amount Incl." := Rec."Revised Amount" + Rec."Revised VAT";
                Rec.Modify();
            until RentCalculation1.Next() = 0;
    end;
}