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
            }
        }
    }
}