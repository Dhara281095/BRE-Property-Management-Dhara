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
                field("Contract ID"; Rec."Contract ID") { ApplicationArea = All; Caption = 'Contract ID'; }
                field("Entry No"; Rec."Entry No") { Caption = 'Entry No.'; ApplicationArea = All; Editable = false; }

                field(RevenueDescription; Rec.RevenueDescription) { ApplicationArea = All; Caption = 'Revenue Description'; }
                field(RevisedAmount; Rec.RevisedAmount) { ApplicationArea = All; Caption = 'Revised Amount'; }
                field(RevisedVAT; Rec.RevisedVAT) { ApplicationArea = All; Caption = 'Revised VAT'; }
                field(RevisedAmountInclVAT; Rec.RevisedAmountInclVAT) { ApplicationArea = All; Caption = 'Revised Amount Incl. VAT'; }
                field(ReceiptsAmount; Rec.ReceiptsAmount) { ApplicationArea = All; Caption = 'Receipts Amount'; }
                field(ReceiptsVAT; Rec.ReceiptsVAT) { ApplicationArea = All; Caption = 'Receipts VAT'; }
                field(ReceiptsAmountInclVAT; Rec.ReceiptsAmountInclVAT) { ApplicationArea = All; Caption = 'Receipts Amount Incl. VAT'; }
                field(DifferenceAmount; Rec.DifferenceAmount) { ApplicationArea = All; Caption = 'Difference Amount'; }
                field(DifferenceVAT; Rec.DifferenceVAT) { ApplicationArea = All; Caption = 'Difference VAT'; }
                field(DifferenceAmountInclVAT; Rec.DifferenceAmountInclVAT) { ApplicationArea = All; Caption = 'Difference Amount Incl. VAT'; }
            }
        }
    }
}