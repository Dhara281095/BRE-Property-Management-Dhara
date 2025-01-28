page 50948 "Rent Calculation List"
{
    PageType = List;
    SourceTable = "Rent Calculation";
    ApplicationArea = All;
    Caption = 'Rent Calculation List';
    UsageCategory = Lists;
    CardPageId = 50945;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                }
                field("RC_ID"; Rec."RC ID")
                {
                    ApplicationArea = All;
                    Caption = 'RC_ID';
                }
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                }

                field("Number of Installments"; Rec."Number of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                }

            }
        }
    }

}
