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
                field(RevenueDescription; Rec.RevenueDescription) { Caption = 'Revenue Description'; ApplicationArea = All; Editable = false; }
                field("Contract ID"; Rec."Contract ID") { Caption = 'Contract ID'; ApplicationArea = All; Editable = false; }

                field("Entry No"; Rec."Entry No") { Caption = 'Entry No.'; ApplicationArea = All; Editable = false; }

                field(InvoicedAmount; Rec.InvoicedAmount) { Caption = 'Invoiced Amount'; ApplicationArea = All; Editable = false; }
                field(InvoicedVAT; Rec.InvoicedVAT) { Caption = 'Invoiced VAT'; ApplicationArea = All; Editable = false; }
                field(InvoicedAmountInclVAT; Rec.InvoicedAmountInclVAT) { Caption = 'Invoiced Amount Incl. VAT'; ApplicationArea = All; Editable = false; }
                field(RevisedAmount; Rec.RevisedAmount) { Caption = 'Revised Amount'; ApplicationArea = All; Editable = false; }
                field(RevisedVAT; Rec.RevisedVAT) { Caption = 'Revised VAT'; ApplicationArea = All; Editable = false; }
                field(RevisedAmountInclVAT; Rec.RevisedAmountInclVAT) { Caption = 'Revised Amount Incl. VAT'; ApplicationArea = All; Editable = false; }
                field(DifferenceAmount; Rec.DifferenceAmount) { Caption = 'Difference Amount'; ApplicationArea = All; Editable = false; }
                field(DifferenceVAT; Rec.DifferenceVAT) { Caption = 'Difference VAT'; ApplicationArea = All; Editable = false; }
                field(DifferenceAmountInclVAT; Rec.DifferenceAmountInclVAT) { Caption = 'Difference Amount Incl. VAT'; ApplicationArea = All; Editable = false; }
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
                field("Invoice To Be Raised"; Rec."Invoice To Be Raised")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Invoice To Be Raised';
                }
                field("Credit Note To Be Raised"; Rec."Credit Note To Be Raised")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Credit Note To Be Raised';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        FetchDataFromRevenueCalcGrid();
        Receiptamountfrompaymentscheule();
        DifferenceAmountCalculation();
        GetPositiveAmount();
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

    procedure Receiptamountfrompaymentscheule()
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        Totalamount: Decimal;
        VATAmount: Decimal;
        AmountIncVAT: Decimal;
    begin
        Totalamount := 0;
        PaymentScheduleRec.Reset();
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
        PaymentScheduleRec.SetFilter("Due Date", '<%1', Rec."Termination Date");
        PaymentScheduleRec.SetRange(Invoiced, true);
        PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
        if PaymentScheduleRec.FindSet() then begin
            repeat
                Totalamount += PaymentScheduleRec.Amount;
                VATAmount += PaymentScheduleRec."VAT Amount";
                AmountIncVAT += PaymentScheduleRec."Amount Including VAT";

            until PaymentScheduleRec.Next() = 0;
        end;
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
        PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
        if PaymentScheduleRec.FindSet() then
            repeat
                Rec.InvoicedAmount := Totalamount;
                Rec.InvoicedVAT := VATAmount;
                Rec.InvoicedAmountInclVAT := AmountIncVAT;
                Rec.Modify();
            until PaymentScheduleRec.Next() = 0;
    end;

    procedure GetPositiveAmount()
    var
    begin
        if Rec."Total DifferenceAmountIncl.VAT" < 0 then begin
            Rec."Invoice To Be Raised" := Abs(Rec."Total DifferenceAmountIncl.VAT");
            Rec.Modify();
        end else begin
            Rec."Credit Note To Be Raised" := Rec."Total DifferenceAmountIncl.VAT";
            Rec.Modify();

        end;
    end;
}
