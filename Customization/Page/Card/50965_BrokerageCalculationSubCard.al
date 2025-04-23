page 50965 "Brokerage Calculation Sub Card"
{
    PageType = ListPart;
    SourceTable = "Brokerage Calculation Sub";
    ApplicationArea = All;
    Caption = 'Brokerage Calculation Sub Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Brokerage Calculation Details';
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                }
                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Brokerage Percentage"; Rec."Brokerage Percentage")
                {
                    ApplicationArea = All;
                }
                field("Calculation Amount"; Rec."Calculation Amount")
                {
                    ApplicationArea = All;
                }
                field("Paid By"; Rec."Paid By")
                {
                    ApplicationArea = All;
                }
                field("Remark"; Rec."Remark")
                {
                    ApplicationArea = All;
                }
                field("Action Date"; Rec."Action Date")
                {
                    ApplicationArea = All;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                }
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


}



