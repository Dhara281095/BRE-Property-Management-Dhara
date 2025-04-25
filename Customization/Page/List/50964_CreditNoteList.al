page 50964 "Credit Note List"
{
    PageType = List;
    SourceTable = "Credit Note";
    ApplicationArea = All;
    Caption = 'Credit Note List';
    UsageCategory = Lists;
    CardPageId = 50966;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    Editable = false;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract End Date"; Rec."Contract End Date")
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
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false;
                }
                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Email';
                    Editable = false;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                }
            }
        }
    }

}
