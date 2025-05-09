page 50971 "RevenueRecognition Othercharge"
{
    PageType = ListPart;
    SourceTable = "RevenueRecognition Othercharge";
    ApplicationArea = All;
    Caption = 'Revenue Recognition Other Charges';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("RS Id"; Rec."RS Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Month"; Rec."Month")
                {
                    ApplicationArea = All;
                }

                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                }

                field("RR - Method 1 (Day)"; Rec."RR - Method 1 (Day)")
                {
                    ApplicationArea = All;
                }

                field("RR - Method 2 (Month)"; Rec."RR - Method 2 (Month)")
                {
                    ApplicationArea = All;

                }
            }

            group(TotalAmountCalculation)
            {
                field("Total Amount(Day)"; Rec."Total Amount(Day)")
                {
                    Caption = 'Total Amount(Day)';
                }
                field("Total Amount(Month)"; Rec."Total Amount(Month)")
                {
                    Caption = 'Total Amount(Month)';
                }

            }
        }
    }

}



