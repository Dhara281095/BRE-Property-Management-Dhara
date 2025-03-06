page 50952 "Pending Recevieable Grid"
{
    PageType = ListPart;
    SourceTable = "Pending Receviable Grid";
    ApplicationArea = All;
    Caption = 'Pending Receivable/Payable List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID") { ApplicationArea = All; Caption = 'Contract ID'; Editable = false; }
                field("Entry No"; Rec."Entry No") { Caption = 'Entry No.'; ApplicationArea = All; Editable = false; }

                field(RevenueDescription; Rec.RevenueDescription) { ApplicationArea = All; Caption = 'Revenue Description'; Editable = false; }
                field(RevisedAmount; Rec.RevisedAmount) { ApplicationArea = All; Caption = 'Revised Amount'; Editable = false; }
                field(RevisedVAT; Rec.RevisedVAT) { ApplicationArea = All; Caption = 'Revised VAT'; Editable = false; }
                field(RevisedAmountInclVAT; Rec.RevisedAmountInclVAT) { ApplicationArea = All; Caption = 'Revised Amount Incl. VAT'; Editable = false; }
                field(ReceiptsAmount; Rec.ReceiptsAmount) { ApplicationArea = All; Caption = 'Receipts Amount'; Editable = false; }
                field(ReceiptsVAT; Rec.ReceiptsVAT) { ApplicationArea = All; Caption = 'Receipts VAT'; Editable = false; }
                field(ReceiptsAmountInclVAT; Rec.ReceiptsAmountInclVAT) { ApplicationArea = All; Caption = 'Receipts Amount Incl. VAT'; Editable = false; }
                field(DifferenceAmount; Rec.DifferenceAmount) { ApplicationArea = All; Caption = 'Difference Amount'; Editable = false; }
                field(DifferenceVAT; Rec.DifferenceVAT) { ApplicationArea = All; Caption = 'Difference VAT'; Editable = false; }
                field(DifferenceAmountInclVAT; Rec.DifferenceAmountInclVAT) { ApplicationArea = All; Caption = 'Difference Amount Incl. VAT'; Editable = false; }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    Editable = false;
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

        Rec."DifferenceAmount" := Rec.RevisedAmount - Rec.ReceiptsAmount;
        Rec."DifferenceVAT" := Rec.RevisedVAT - Rec.ReceiptsVAT;
        Rec.DifferenceAmountInclVAT := Rec.RevisedAmountInclVAT - Rec.ReceiptsAmountInclVAT;
        Rec.Modify();

    end;
}