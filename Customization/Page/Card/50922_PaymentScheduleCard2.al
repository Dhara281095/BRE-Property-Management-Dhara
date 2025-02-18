page 50922 "Payment Schedule Card2"
{
    PageType = ListPart;
    SourceTable = "Payment Schedule2";
    ApplicationArea = All;
    Caption = 'Payment Schedule Details';
    //UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

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
                    Caption = 'Amount';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VAT Amount';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount Including VAT';
                }

                field("Installment Start Date"; Rec."Installment Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Installment Start Date';
                }

                field("Installment End Date"; Rec."Installment End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Installment End Date';
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Due Date';
                }

                field("Installment No."; Rec."Installment No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Installment No.';
                }


                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                    Caption = 'Payment Series';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Tenant Name';
                }


                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    Caption = 'Tenant ID';

                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                    Caption = 'Contract ID';
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                    Editable = InvoicedField;

                }

                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                }

            }

        }

    }


    procedure NotAccessInvoicedFieldFinanceManager(): Boolean
    var
        UserPersonalization1: Record "User Personalization";
    begin

        if UserPersonalization1.Get(UserSecurityId()) then begin

            case UserPersonalization1."Profile ID" of
                'PROPERTY MANAGER':
                    exit(true);
                'LEASE_MANAGER':
                    exit(true);
                'finance manager':
                    exit(false);
            end;
        end;

        exit(false);
    end;

    trigger OnAfterGetRecord()
    var
    begin
        InvoicedField := NotAccessInvoicedFieldFinanceManager();
    end;

    var
        InvoicedField: Boolean;
}




