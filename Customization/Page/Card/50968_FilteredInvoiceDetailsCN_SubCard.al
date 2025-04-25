page 50968 "Filtered Invoice Detail Card"
{
    PageType = ListPart;
    SourceTable = "Filtered Invoice Detail";
    ApplicationArea = All;
    Caption = 'Filtered Invoice Detail Card';
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
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GenerateCreditNote)
            {
                ApplicationArea = All;
                Caption = 'Generate Credit Note';
                Image = PostDocument;

                trigger OnAction()
                var

                begin
                    Message('Generate Credit Note');
                end;
            }

        }
    }
}