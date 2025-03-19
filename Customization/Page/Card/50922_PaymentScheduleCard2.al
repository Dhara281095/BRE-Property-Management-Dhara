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
                    Visible = false;
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
                    Visible = false;
                    Caption = 'Contract ID';
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                    Editable = InvoicedField;

                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    //Editable = false;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    //  Editable = false;

                }
                field("Overdue Invoice"; Rec."Overdue Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Invoice';
                    //Editable = false;
                }

                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnValidate()
                    begin

                        UpdateBalanceAmountOnPaymentReceived();

                    end;




                }
                field("Payment Received Date"; Rec."Payment Recieved Date")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Received Date';
                    Editable = false;
                }
                field("Property Classification"; Rec."Property Classification")
                {
                    ApplicationArea = All;
                    Caption = 'Property Classification';
                    Editable = false;
                    Visible = false;
                }

                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Mode';
                    Editable = false;

                }

                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    Caption = 'Cheque Number';
                    Editable = false;

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
        PaymentSchedule: Record "Payment Schedule";
    begin
        InvoicedField := NotAccessInvoicedFieldFinanceManager();
        // UpdateBalanceAmountOnPaymentReceived();



        // if PaymentSchedule.Get(Rec."Contract ID")
        //   then begin
        //     Rec."Contract Status" := PaymentSchedule."Contract Status";
        //     Rec.Modify();
        // end;
    end;




    var
        InvoicedField: Boolean;



    local procedure UpdateBalanceAmountOnPaymentReceived()
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        TenancyContractRec: Record "Tenancy Contract";
    begin
        // Filter records where 'Secondary Item Type' is 'Security Deposit Amount' and 'Payment Status' is 'Received'
        PaymentScheduleRec.SetRange("Secondary Item Type", 'Security Deposit Amount');
        PaymentScheduleRec.SetRange("Payment Status", 'Received');

        if PaymentScheduleRec.FindSet() then begin
            repeat
                // Filter Tenancy Contract records based on Contract ID
                TenancyContractRec.SetRange("Contract ID", PaymentScheduleRec."Contract ID");

                if TenancyContractRec.FindSet() then begin
                    repeat
                        // If Balance Amount has a value, update it
                        if TenancyContractRec."Balance Amount" <> 0 then begin
                            TenancyContractRec."Balance Amount" += PaymentScheduleRec."Amount Including VAT";
                            // TenancyContractRec."Security Balanced Amount" += PaymentScheduleRec."Amount Including VAT";
                        end
                        else begin
                            // If Balance Amount is 0, set it to Amount Including VAT
                            TenancyContractRec."Balance Amount" := PaymentScheduleRec."Amount Including VAT";
                            // TenancyContractRec."Security Balanced Amount" := PaymentScheduleRec."Amount Including VAT";
                        end;

                        // Modify the record to save changes
                        TenancyContractRec.Modify();
                    until TenancyContractRec.Next() = 0;
                end;
            until PaymentScheduleRec.Next() = 0;
        end;
    end;

}






