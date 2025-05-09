page 50972 "Revenue Recognition Main"
{
    PageType = Card;
    SourceTable = "Revenue Recognition Main";
    ApplicationArea = All;
    Caption = 'Revenue Recognition Card';

    layout
    {
        area(content)
        {
            group("Revenue Allocation Details")
            {
                field("RR_No."; Rec."RR_No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                }
            }
            group("Revenue Recognition Item")
            {
                Caption = 'Revenue Item Details';
                part("Revenue Recognition Item Details"; "Revenue Recognition Item Sub")
                {
                    SubPageLink = "RR_No." = field("RR_No.");
                }
            }

            group("Revenue Recognition Detail")
            {
                Caption = 'Revenue Recognition Details';
                part("Revenue Recognition Details"; "Revenue Recognition Detail Sub")
                {
                    SubPageLink = "RR_No." = field("RR_No.");
                }
            }
        }
    }
}
