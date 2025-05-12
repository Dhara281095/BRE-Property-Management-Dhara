page 50933 "Revenue Recognition Card2"
{
    PageType = ListPart;
    SourceTable = "Revenue Recognition Subpage";
    ApplicationArea = All;
    Caption = 'Revenue Recognition-Rent';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // field("RR Id"; Rec."RR Id")
                // {
                //     ApplicationArea = All;
                // }

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

    // procedure SetRR_ID(pRRIDs: Integer)
    // begin
    //     RRIDs := pRRIDs;

    // end;


    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin

    //     Rec."RR Id" := RRIDs;
    // end;

    // var
    //     RRIDs: Integer;
}



