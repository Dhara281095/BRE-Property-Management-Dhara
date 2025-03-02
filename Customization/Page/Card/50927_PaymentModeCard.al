page 50927 "Payment Mode Card"
{
    PageType = Card;
    SourceTable = "Payment Mode";
    ApplicationArea = All;
    Caption = 'Payment Details Card';
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

        }
    }


    // actions
    // {
    //     area(Processing)
    //     {
    //         action(UpdatePaymentModes)
    //         {
    //             Caption = 'Process Combine Request';
    //             ApplicationArea = All;
    //             trigger OnAction()
    //             begin
    //                 ProcessCombineRequest();
    //             end;
    //         }
    //     }
    // }

    // procedure ProcessCombineRequest()
    // var
    //     PaymentChangeReqTable: Record "Approval Payment Request"; // Replace with your actual table name
    //     PaymentModeTable: Record "Payment Mode2"; // Replace with your actual table name
    //     payseries: Text[100];
    // begin
    //     // Ensure the current record is properly copied
    //     // if Rec.IsEmpty() then begin
    //     //     Message('No record selected.');
    //     //     exit;
    //     // end;

    //     // Debug: Log current record IDs
    //     Message('Processing Record for: Contract ID: %1, Tenant ID: %2, Proposal ID: %3',
    //         Rec."Contract ID", Rec."Tenant ID", Rec."Proposal ID");

    //     // Filter PaymentChangeReqTable based on the current record's IDs
    //     PaymentChangeReqTable.Reset();
    //     PaymentChangeReqTable.SetRange("Contract ID", Rec."Contract ID");
    //     PaymentChangeReqTable.SetRange("Tenant ID", Rec."Tenant ID");
    //     PaymentChangeReqTable.SetRange("Proposal ID", Rec."Proposal ID");
    //     PaymentChangeReqTable.SetRange(Status, 'Approve');
    //     PaymentChangeReqTable.SetRange("Request Type", 'Combine');

    //     // Debug: Check if filtered records exist
    //     if not PaymentChangeReqTable.FindSet() then begin
    //         Message('No matching records found for Contract ID: %1, Tenant ID: %2, Proposal ID: %3',
    //             Rec."Contract ID", Rec."Tenant ID");
    //         exit;
    //     end
    //     else begin

    //         // Process the filtered records
    //         repeat
    //             // Debug: Log each record being processed
    //             Message('Processing Record: Contract ID: %1, Tenant ID: %2, Proposal ID: %3, Changed Payment Series: %4',
    //                 PaymentChangeReqTable."Contract ID",
    //                 PaymentChangeReqTable."Tenant ID",
    //                 PaymentChangeReqTable."Proposal ID",
    //                 PaymentChangeReqTable."Changed Payment Series");

    //             // Fetch the last payment series if any
    //             PaymentModeTable.Reset(); // Reset to clear filters
    //             if PaymentModeTable.FindLast() then
    //                 payseries := PaymentModeTable."Payment Series";

    //             Clear(PaymentModeTable);

    //             // Insert new record in Payment Mode table
    //             PaymentModeTable.Init();
    //             PaymentModeTable."Contract ID" := PaymentChangeReqTable."Contract ID";
    //             PaymentModeTable."Tenant ID" := PaymentChangeReqTable."Tenant ID";
    //             PaymentModeTable."Proposal ID" := PaymentChangeReqTable."Proposal ID";
    //             PaymentModeTable."Payment Series" := PaymentChangeReqTable."Changed Payment Series"; // Example field
    //             PaymentModeTable.Insert(true);
    //             Clear(PaymentModeTable);
    //         until PaymentChangeReqTable.Next() = 0;
    //     end;

    //     Message('Processing complete.');
    // end;


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



