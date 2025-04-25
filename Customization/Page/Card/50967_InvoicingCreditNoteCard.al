page 50967 "Invoice-Credit Note Card"
{
    PageType = ListPart;
    SourceTable = "Invoice-Credit Note";
    ApplicationArea = All;
    Caption = 'Invoice-Credit Note Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater("Contract Details")
            {
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    Editable = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    Caption = 'Item Name';
                    Editable = false;
                }
                field("Item Amount"; Rec."Item Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Item Amount';
                    Editable = false;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
            }
            group(" ")
            {
                field("Remark"; Rec."Remark")
                {
                    ApplicationArea = All;
                    Caption = 'Remark';
                }
                field("Reference"; Rec."Reference")
                {
                    ApplicationArea = All;
                    Caption = 'Reference';
                }
            }
        }
    }
}
