page 50516 "Payment Transaction Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Transaction";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("PT Id"; Rec."PT Id")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Tenant Id"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                }
                field("Contract Id"; Rec."Contract Id")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
            }
            group("Payment Series Grid")
            {
                part("Payment series"; "Payment Series Grid")
                {
                    SubPageLink = "Contract Id" = FIELD("Contract Id"),
                    "Payment Transaction Id" = FIELD("PT Id");
                    // "Tenant Id" = FIELD("Tenant Id");


                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}