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
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                }
                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        Revenueitembreakdown: Record "Revenue Item Breakdown";
                    begin
                        Revenueitembreakdown.SetRange("RI_No.", Rec.Link);
                        if Revenueitembreakdown.FindSet() then
                            PAGE.RunModal(PAGE::"Revenue Item Breakdown Card", Revenueitembreakdown)
                        else
                            Message('No Revenue Item Breakdown found using FindFirst either.');
                    end;
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

    procedure SetRIID(pRRID: Integer)
    begin
        RRID := pRRID;

    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."RR_No." := RRID;
    end;

    var
        RRID: Integer;

}
