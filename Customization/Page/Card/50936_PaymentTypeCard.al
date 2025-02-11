page 50936 "Payment Type Card"
{
    PageType = Card;
    SourceTable = "Payment Type";
    ApplicationArea = All;
    Caption = 'Payment Type Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Payment Type Details';
                field("Payment ID"; Rec."Payment ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Method';
                    ToolTip = 'Enter the Payment Method.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
            }
        }
    }


}



