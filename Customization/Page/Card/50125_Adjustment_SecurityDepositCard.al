page 50125 "Adjustment Security Deposit"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Adjustment Security Deposit";
    Caption = 'Adjustment Security Deposit';

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                }

                field("Security Deposit"; Rec."Security Deposit")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }

                field("Security Amount Status"; Rec."Security Amount Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
            }
            group(Adjust_Installment)
            {
                Visible = ShowAdjustInstallment;
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        ShowAdjustInstallment: Boolean;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility();
    end;

    local procedure SetControlVisibility()
    begin
        ShowAdjustInstallment := Rec."Security Amount Status" = Rec."Security Amount Status"::"Adjust Installment";
    end;
}
