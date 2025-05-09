page 50975 "Revenue Item Breakdown Card"
{
    PageType = Card;
    SourceTable = "Revenue Item Breakdown";
    ApplicationArea = All;
    Caption = 'Revenue Item Breakdown';

    layout
    {
        area(content)
        {
            group("General")
            {
                field("RI_No."; Rec."RI_No.")
                {
                    Editable = false;
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                }
            }
            group("Revenue Item Breakdown")
            {
                Caption = 'Revenue Item Breakdown Details';
                part("Revenue Item Breakdown Details"; "Revenue Item Breakdown Sub")
                {
                    SubPageLink = "RI_No." = field("RI_No.");
                }

            }
        }
    }
}
