page 50973 "Revenue Recognition Item Sub"
{

    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Revenue Recognition Item";
    Caption = 'Revenue Item';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("RR_No."; Rec."RR_No.")  // Add this field
                {
                    ApplicationArea = All;
                    Visible = false;  // Usually kept hidden since it's just for linking
                }
                field("Item Charges"; Rec."Item Charges")
                {
                    ApplicationArea = All;
                    Caption = 'Item Charges';
                }
                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Editable = false;
                }

            }
        }
    }
}