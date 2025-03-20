page 50927 "Payment Mode Card"
{
    PageType = Card;
    SourceTable = "Payment Mode";
    ApplicationArea = All;
    Caption = 'Payment mode Details';
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

                    ShowMandatory = true;
                    NotBlank = true;
                    Editable = IsFieldEditable;

                    //Editable = false; // The ID is not editable since it's auto-incrementing
                }

                // field("PS ID"; Rec."PS ID")
                // {
                //     ApplicationArea = All;
                //     // Editable = false; // The ID is not editable since it's auto-incrementing
                // }

                //Caption = 'Primary Item Details';
                // field("Proposal ID"; Rec."Proposal ID")
                // {
                //     ApplicationArea = All;
                //     // Editable = false; // The ID is not editable since it's auto-incrementing
                //     Lookup = true;


                // }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;


                }

                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager AND IsFieldEditable;
                    // trigger OnValidate()
                    // begin
                    //     // Scenario 1: Update all payment grid records to "Approved" when card status changes
                    //     if Rec."Approval Status" = Rec."Approval Status"::Approved then begin
                    //         UpdateAllPaymentGridApprovalStatus(Rec."Contract ID", Rec."Approval Status");
                    //     end;
                    // end;

                }
                field("On-hold"; Rec."On-hold")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    // trigger OnValidate()
                    // var
                    //     paymentModeRec: Record "Payment Mode";
                    //     paymentSeriesRec: Record "Payment Mode2";
                    //     approvalPending: Boolean;
                    //     sendRejectionToLeaseTeam: Codeunit 50511;
                    // begin
                    //     if Rec."On-hold" = Rec."On-hold"::"True" then begin
                    //         approvalPending := false;
                    //         paymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                    //         paymentSeriesRec.SetRange("Tenant Id", Rec."Tenant Id");
                    //         if paymentSeriesRec.FindSet() then begin
                    //             repeat
                    //                 if paymentSeriesRec."Approval Status" = paymentSeriesRec."Approval Status"::Pending then begin
                    //                     approvalPending := true;
                    //                     break;
                    //                 end;
                    //             until paymentSeriesRec.Next() = 0;
                    //         end;

                    //         // Exit if there are any "Pending" approval statuses
                    //         if ApprovalPending then
                    //             exit;

                    //         if approvalPending = false then begin
                    //             sendRejectionToLeaseTeam.SendPaymentRejectionToLeaseManager(paymentSeriesRec."Contract ID", paymentSeriesRec."Tenant Id", paymentSeriesRec."Contract ID");
                    //         end;

                    //     end;
                    // end;
                }
                field(Isupdated; Rec.Isupdated)
                {
                    ApplicationArea = All;
                    Visible = false;
                }


            }



            group("Payment Mode")
            {
                part("PaymentMode"; "Payment Mode Card2")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    // Visible = isVisible;
                }
            }


            group("CombinePaymentLog")
            {
                Visible = IsCombineVisible;
                Caption = 'Combine Payment Log';
                part("CombinePaymentsLog"; "CombinePaymentLogCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }

            group("CombinePayment")
            {
                Visible = IsCombineVisible;
                Caption = 'Combine Payment';
                field("Combine Payment Series"; Rec."Combine Payment Series")
                {
                    ApplicationArea = All;
                }

                field("Combine Due Date"; Rec."Combine Due Date")
                {
                    ApplicationArea = All;
                }

                field("Combine Payment Mode"; Rec."Combine Payment Mode")
                {
                    ApplicationArea = All;
                }

                field("Combine Amount"; Rec."Combine Amount")
                {
                    ApplicationArea = All;
                }

                field("Combine VAT Amount"; Rec."Combine VAT Amount")
                {
                    ApplicationArea = All;
                }

                field("Combine Amount Including VAT"; Rec."Combine Amount Including VAT")
                {
                    ApplicationArea = All;
                }
            }


            group("SplitPaymentLog")
            {
                Visible = IsSplitVisible;
                Caption = 'Split Payment Log';
                part("SplitPaymentsLog"; "SplitPaymentLogCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }
            group("SplitPayment")
            {
                Visible = IsSplitVisible;
                Caption = 'Split Payment';
                part("SplitPayments"; "Split Payment Change Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }

            // group("SplitPayment")
            // {
            //     Visible = IsSplitVisible;
            //     Caption = 'Split Payment';
            //     field("Split Payment Series"; Rec."Split Payment Series")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Secondary Item Type"; Rec."Secondary Item Type")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split Due Date"; Rec."Split Due Date")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split Payment Mode"; Rec."Split Payment Mode")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split Amount"; Rec."Split Amount")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split VAT Amount"; Rec."Split VAT Amount")
            //     {
            //         ApplicationArea = All;
            //     }

            //     field("Split Amount Including VAT"; Rec."Split Amount Including VAT")
            //     {
            //         ApplicationArea = All;
            //     }
            // }

            group("PaymentModeChangeLog")
            {
                Visible = IsChangePaymodeVisible;
                Caption = 'Change Payment Mode Log';
                part("PaymentsModeChangeLog"; "PaymentModeChangeLogCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }

            group("ChangePaymentMode")
            {
                Visible = IsChangePaymodeVisible;
                Caption = 'Change Payment Mode';
                field("Change Payment Series"; Rec."Change Payment Series")
                {
                    ApplicationArea = All;
                }

                field("Change Payment Mode"; Rec."Change Payment Mode")
                {
                    ApplicationArea = All;
                }


            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(CombineData)
            {
                Caption = 'Combine Data';
                ApplicationArea = All;
                Image = NewDocument;

                trigger OnAction()
                var
                // Paymentmode: Record "Payment Mode";
                // Approvalpayment: Record "Approval Payment Request";
                begin
                    //IsVisible := NOT IsVisible;
                    IsCombineVisible := true;
                    IsSplitVisible := false;
                    IsChangePaymodeVisible := false;
                    RequestType := RequestType::Combine;
                    Status := Status::Manual;
                    Message('Combine Payment section is open.');
                end;
            }

            action(SplitData)
            {
                Caption = 'Split Data';
                ApplicationArea = All;
                Image = NewDocument;

                trigger OnAction()
                begin
                    // IsVisible := NOT IsVisible;
                    IsCombineVisible := false;
                    IsChangePaymodeVisible := false;
                    IsSplitVisible := true;
                    RequestType := RequestType::Split;
                    Status := Status::Manual;
                    Message('Split Payment section is open.');
                end;
            }


            action(Paymode)
            {
                Caption = 'Pay Mode Change';
                ApplicationArea = All;
                Image = NewDocument;

                trigger OnAction()
                begin
                    //IsVisible := NOT IsVisible;
                    IsCombineVisible := false;
                    IsSplitVisible := false;
                    IsChangePaymodeVisible := true;
                    RequestType := RequestType::"Payment Mode";
                    Status := Status::Manual;
                    Message('Paymode Payment section is open.');
                end;
            }


            action(RequestSend)
            {
                Caption = 'Request Send';
                ApplicationArea = All;
                Image = Send;


                trigger OnAction()
                var
                    Paymentmode: Record "Payment Mode";
                    // Approvalpayment: Record "ManualApprovalPaymentRequest";
                    Approvalpayment: Record "Approval Payment Request";
                    MaxID: Integer;
                    SplitPayChange: Record "Split Payment Change";
                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    // Find the highest ID and increment it
                    if Approvalpayment.FindLast() then
                        MaxID := Approvalpayment.ID + 1
                    else
                        MaxID := 1; // If no records exist, start from 1

                    // Create a new record
                    Approvalpayment.Init();
                    Approvalpayment.ID := MaxID; // Assign the new auto-incremented ID
                    Approvalpayment."Contract ID" := Rec."Contract ID";
                    Approvalpayment."Tenant ID" := Rec."Tenant ID";
                    Approvalpayment."Status" := 'Pending';
                    Approvalpayment."Request Type" := Format(RequestType);
                    Approvalpayment."Manual/Auto Status" := Format(Status);

                    if IsCombineVisible then begin
                        Approvalpayment."Payment Series" := Rec."Combine Payment Series";
                        Approvalpayment."Due Date" := Rec."Combine Due Date";
                        Approvalpayment."Payment Mode" := Rec."Combine Payment Mode";
                        Approvalpayment."Amount" := Rec."Combine Amount";
                        Approvalpayment."VAT Amount" := Rec."Combine VAT Amount";
                        Approvalpayment."Change Amount" := Rec."Combine Amount Including VAT";
                    end
                    else if IsSplitVisible then begin
                        Approvalpayment."Payment Series" := SplitPayChange."Split Payment Series";
                        Approvalpayment."Due Date" := SplitPayChange."Split Due Date";
                        Approvalpayment."Payment Mode" := SplitPayChange."Split Payment Mode";
                        Approvalpayment."Amount" := SplitPayChange."Split Amount";
                        Approvalpayment.Items := SplitPayChange."Secondary Item Type";
                        Approvalpayment."VAT Amount" := SplitPayChange."Split VAT Amount";
                        Approvalpayment."Change Amount" := SplitPayChange."Split Amount Including VAT";
                    end
                    else if IsChangePaymodeVisible then begin
                        Approvalpayment."Payment Series" := Rec."Change Payment Series";
                        Approvalpayment."Payment Mode" := Rec."Change Payment Mode";
                    end;
                    Approvalpayment.Insert();
                    Message('Approval Request Sent successfully!');

                    // Clear relevant fields after sending request
                    Clear(SplitPayChange."Split Payment Series");
                    Clear(SplitPayChange."Split Due Date");
                    Clear(SplitPayChange."Split Payment Mode");
                    Clear(SplitPayChange."Split Amount");
                    Clear(SplitPayChange."Secondary Item Type");
                    Clear(SplitPayChange."Split VAT Amount");
                    Clear(SplitPayChange."Split Amount Including VAT");

                    Clear(Rec."Combine Payment Series");
                    Clear(Rec."Combine Due Date");
                    Clear(Rec."Combine Payment Mode");
                    Clear(Rec."Combine Amount");
                    Clear(Rec."Combine VAT Amount");
                    Clear(Rec."Combine Amount Including VAT");

                    Clear(Rec."Change Payment Series");
                    Clear(Rec."Change Payment Mode");

                    // Modify and update the record
                    Rec.Modify();
                end;
            }
        }
    }




    trigger OnAfterGetRecord()
    begin
        // Fields are editable only if Approval Status is not "Approved"
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        // CurrPage."PaymentMode".Page.SetProposalID(Rec."Proposal ID");
        CurrPage."PaymentMode".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."Contract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."Tenant Name", Rec."Tenant Email");

    end;


    trigger OnModifyRecord(): Boolean
    begin
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        //CurrPage."PaymentMode".Page.SetProposalID(Rec."Proposal ID");
        //CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."PaymentMode".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."Contract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."Tenant Name", Rec."Tenant Email");

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        // CurrPage."PaymentMode".Page.SetProposalID(Rec."Proposal ID");
        // CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."PaymentMode".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."Contract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."Tenant Name", Rec."Tenant Email");

    end;

    // procedure UpdateAllPaymentGridApprovalStatus(ContractID: Integer; NewStatus: Enum "Approval Status Enum")
    // var
    //     PaymentGridRec: Record "Payment Mode2";
    // begin
    //     PaymentGridRec.SetRange("Contract ID", PaymentGridRec."Contract ID");
    //     if PaymentGridRec.FindSet() then
    //         repeat
    //             PaymentGridRec."Approval Status" := NewStatus;
    //             PaymentGridRec.Modify();
    //         until PaymentGridRec.Next() = 0;

    //     // Check if all are approved
    //     CheckAndUpdateCardApprovalStatus(ContractID);
    // end;

    // procedure CheckAndUpdateCardApprovalStatus(ContractID: Integer)
    // var
    //     PaymentGridRec: Record "Payment Mode2";
    //     AllApproved: Boolean;
    // begin
    //     AllApproved := true;
    //     PaymentGridRec.SetRange("Contract ID", ContractID);
    //     if PaymentGridRec.FindSet() then
    //         repeat
    //             if PaymentGridRec."Approval Status" <> PaymentGridRec."Approval Status"::Approved then
    //                 AllApproved := false;
    //         until (PaymentGridRec.Next() = 0) or not AllApproved;

    //     if AllApproved then begin
    //         Rec."Approval Status" := Rec."Approval Status"::Approved;
    //         Rec.Modify();
    //     end;
    // end;
    var
        IsFinanceManager: Boolean;
        IsFieldEditable: Boolean;
        IsVisible: Boolean;
        IsCombineVisible: Boolean;
        IsSplitVisible: Boolean;

        IsChangePaymodeVisible: Boolean;
        RequestType: Option Combine,Split,"Payment Mode";

        Status: Option Manual,Frontend;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE_MANAGER');
        if PermissionSet.FindSet() then begin
            if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                IsFinanceManager := true;
        end;


    end;

}



