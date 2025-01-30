page 50921 "Payment Schedule Card"
{
    PageType = Card;
    SourceTable = "Payment Schedule";
    ApplicationArea = All;
    Caption = 'Payment Schedule Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                }

                //Caption = 'Primary Item Details';
                // field("Proposal ID"; Rec."Proposal ID")
                // {
                //     ApplicationArea = All;
                //     Editable = false; // The ID is not editable since it's auto-incrementing
                //     Lookup = true;
                // }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                }
                // field("Total Amount Including VAT"; Rec."Total Amount Including VAT")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Total Amount Including VAT';

                // }

            }

            group("Payment Schedule")
            {
                part("PaymentSchedule"; "Payment Schedule Card2")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                  "Tenant ID" = FIELD("Tenant ID");
                    //    "PS ID" = field("PS Id"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }


            group(TotalAmountCalculation)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    Caption = 'Total VAT Amount';
                    Editable = false;
                }
                field("Total Amount Including VAT"; Rec."Total Amount Including VAT")
                {
                    Caption = 'Total Amount Including VAT';
                    Editable = false;
                }
            }

        }
    }


    // trigger OnAfterGetRecord()
    // begin

    //     CurrPage."PaymentSchedule".Page.SetProposalId(Rec."Proposal ID");
    //     CurrPage."PaymentSchedule".Page.SetTenantID(Rec."Tenant ID");
    //     CurrPage.PaymentSchedule.Page.SetPSID(Rec."PS Id");




    // end;

    // trigger OnModifyRecord(): Boolean
    // begin
    //     CurrPage."PaymentSchedule".Page.SetProposalId(Rec."Proposal ID");
    //     //CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
    //     CurrPage."PaymentSchedule".Page.SetTenantID(Rec."Tenant ID");
    //     CurrPage.PaymentSchedule.Page.SetPSID(Rec."PS Id");




    // end;

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     // CurrPage."PaymentSchedule".Page.SetProposalId(Rec."Proposal ID");
    //     // // CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
    //     // CurrPage."PaymentSchedule".Page.SetTenantID(Rec."Tenant ID");
    //     // CurrPage.PaymentSchedule.Page.SetPSID(Rec."PS Id");


    // end;





    // trigger OnAfterGetCurrRecord()
    // var
    // begin
    //     UpdatePaymentSchedule2();
    // end;







}



