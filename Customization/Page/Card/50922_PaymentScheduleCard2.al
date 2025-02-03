page 50922 "Payment Schedule Card2"
{
    PageType = ListPart;
    SourceTable = "Payment Schedule2";
    ApplicationArea = All;
    Caption = 'Payment Schedule Details';
    // UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                // Caption = 'Primary Item Details';
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Types';
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Installment Start Date"; Rec."Installment Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Installment End Date"; Rec."Installment End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Installment No."; Rec."Installment No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }




                // field("Proposal ID"; Rec."Proposal ID")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     Visible = false;
                //     // Editable = false; // The ID is not editable since it's auto-incrementing


                // }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = true;

                }
                // field("PS ID"; Rec."PS ID")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;

                }

            }

        }

    }




}




