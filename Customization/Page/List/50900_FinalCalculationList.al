page 50900 "Final Calculation List"
{
    PageType = List;
    SourceTable = "Final Calculation";
    ApplicationArea = All;
    Caption = 'Final Calculation List';
    UsageCategory = Lists;
    CardPageId = 50903;


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
                field("FC_ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                }

                field("Initmation Date"; Rec."Intimation Date")
                {
                    ApplicationArea = All;
                }

                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                }

                field("Original Contract Tenure"; Rec."Original Contract Tenure")
                {
                    ApplicationArea = All;
                }


                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

}
