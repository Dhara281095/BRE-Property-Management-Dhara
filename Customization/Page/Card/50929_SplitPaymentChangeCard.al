page 50929 "Split Payment Change Card"
{
    PageType = ListPart;
    SourceTable = "Split Payment Change";
    ApplicationArea = All;
    //UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                }

                field("Split Payment Series"; Rec."Split Payment Series")
                {
                    ApplicationArea = All;
                    Caption = 'Split Payment Series';
                    Editable = false;
                }
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Secondary Item Type';
                }
                field("Split Due Date"; Rec."Split Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Due Date';
                }
                field("Split Payment Mode"; Rec."Split Payment Mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Payment Mode';
                }

                field("Split Amount"; Rec."Split Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Amount';
                }

                field("Split VAT Amount"; Rec."Split VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split VAT Amount';
                }

                field("Split Amount Including VAT"; Rec."Split Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Amount Including VAT';
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    Caption = 'Tenant ID';

                }

            }

        }

    }
}