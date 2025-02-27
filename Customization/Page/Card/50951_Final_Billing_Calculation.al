page 50951 "Final Billing Calculation"
{
    PageType = ListPart;
    ApplicationArea = All;
    Caption = 'Final Billing Calculation Grid';
    SourceTable = "Final Billing Calculation Grid";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RevenueDescription; Rec.RevenueDescription) { Caption = 'Revenue Description'; ApplicationArea = All; }
                field("Contract ID"; Rec."Contract ID") { Caption = 'Contract ID'; ApplicationArea = All; }

                field("Entry No"; Rec."Entry No") { Caption = 'Entry No.'; ApplicationArea = All; Editable = false; }

                field(InvoicedAmount; Rec.InvoicedAmount) { Caption = 'Invoiced Amount'; ApplicationArea = All; }
                field(InvoicedVAT; Rec.InvoicedVAT) { Caption = 'Invoiced VAT'; ApplicationArea = All; }
                field(InvoicedAmountInclVAT; Rec.InvoicedAmountInclVAT) { Caption = 'Invoiced Amount Incl. VAT'; ApplicationArea = All; }
                field(RevisedAmount; Rec.RevisedAmount) { Caption = 'Revised Amount'; ApplicationArea = All; }
                field(RevisedVAT; Rec.RevisedVAT) { Caption = 'Revised VAT'; ApplicationArea = All; }
                field(RevisedAmountInclVAT; Rec.RevisedAmountInclVAT) { Caption = 'Revised Amount Incl. VAT'; ApplicationArea = All; }
                field(DifferenceAmount; Rec.DifferenceAmount) { Caption = 'Difference Amount'; ApplicationArea = All; }
                field(DifferenceVAT; Rec.DifferenceVAT) { Caption = 'Difference VAT'; ApplicationArea = All; }
                field(DifferenceAmountInclVAT; Rec.DifferenceAmountInclVAT) { Caption = 'Difference Amount Incl. VAT'; ApplicationArea = All; }
                field("Termination Date"; Rec."Termination Date")
                {
                    Caption = 'Termination Date';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(" ")
            {
                field("Total Invoiced Amount"; Rec."Total Invoiced Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Invoiced Amount';
                }
                field("Total Invoiced VAT"; Rec."Total Invoiced VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Invoiced VAT';
                }
                field("Total Invoiced AmountIncl. VAT"; Rec."Total Invoiced AmountIncl. VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Invoiced Amount Incl. VAT';
                }
                field("Total Revised Amount"; Rec."Total Revised Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Revised Amount';
                }
                field("Total Revised VAT"; Rec."Total Revised VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Revised VAT';
                }
                field("Total Revised AmountIncl. VAT"; Rec."Total Revised AmountIncl. VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Revised AmountIncl. VAT';
                }
                field("Total Differnece Amount"; Rec."Total Differnece Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Differnece Amount';
                }
                field("Total Difference VAT"; Rec."Total Difference VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Difference VAT';
                }
                field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Difference Amount Incl. VAT';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        FetchDataFromRevenueCalcGrid();
        DifferenceAmountCalculation();
    end;

    procedure FetchDataFromRevenueCalcGrid()
    var
        RevenueGrid: Record "Final Revenue Calculation Grid";
    begin
        RevenueGrid.SetRange("Contract ID", Rec."Contract ID");
        RevenueGrid.SetRange("Revenue Description", Rec.RevenueDescription);
        if RevenueGrid.FindSet() then
            repeat
                Rec.RevisedAmount := RevenueGrid."Revised Amount";
                Rec.RevisedVAT := RevenueGrid."Revised VAT";
                Rec.RevisedAmountInclVAT := RevenueGrid."Revised Amount Incl.";
                Rec.Modify();
            until RevenueGrid.Next() = 0;

    end;

    procedure DifferenceAmountCalculation()
    var

    begin

        Rec."DifferenceAmount" := Rec.InvoicedAmount - Rec.RevisedAmount;
        Rec."DifferenceVAT" := Rec.InvoicedVAT - Rec.RevisedVAT;
        Rec.DifferenceAmountInclVAT := Rec.InvoicedAmountInclVAT - Rec.RevisedAmountInclVAT;
        Rec.Modify();

    end;
}