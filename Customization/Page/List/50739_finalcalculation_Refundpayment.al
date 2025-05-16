page 50739 "finalcalculation_Refundpayment"
{
    PageType = List;
    SourceTable = finalcalculation_refunApproval;
    ApplicationArea = All;
    Caption = 'Final Calculation Refund Approval';
    UsageCategory = Lists;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(fcID; Rec.fcID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Branch Address"; Rec."Branch Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account Holder Name"; Rec."Account Holder Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account Number"; Rec."Account Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Swift Code"; Rec."Swift Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("IBAN number"; Rec."IBAN number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(paid)
            {
                Caption = 'paid';
                ApplicationArea = All;
                Image = paid;

                trigger OnAction()
                var
                    SelectedRecs: Record "finalcalculation_refunApproval";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    // Finalsettlement: Record "FinalSettlement";
                    // PaymentStatus: Enum "Payment Status";
                    FinalsettlementRefund: Record "FinalSettlementRefund";
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for approval.');
                        exit;
                    end;

                    ApproveCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs.Status = 'Pending' then begin
                                SelectedRecs.Status := 'paid';
                                SelectedRecs.Modify();

                                FinalsettlementRefund.SetRange("Contract ID", SelectedRecs."Contract ID");

                                if FinalsettlementRefund.FindSet() then begin
                                    FinalsettlementRefund."Refund Payment Status" := FinalsettlementRefund."Refund Payment Status"::Paid;
                                    FinalsettlementRefund.Modify(true);
                                end;

                                // Finalsettlement.SetRange("Contract ID", SelectedRecs."Contract ID");
                                // if Finalsettlement.FindSet() then begin
                                //     // Update the status of OnlinePaymentApproval record
                                //     Finalsettlement."Receivable Payment Status" := PaymentStatus::Received;
                                //     Finalsettlement.Modify(true);
                                // end;
                                ApproveCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);
                    Message('%1 record(s) approved. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);
                end;
            }
            action(NotPaid)
            {
                Caption = 'Not Paid';
                ApplicationArea = All;
                Image = "Not Paid";

                trigger OnAction()
                var
                    SelectedRecs: Record "finalcalculation_refunApproval";
                    RejectCount: Integer;
                    ErrorCount: Integer;
                begin
                    // Store selected records
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for rejection.');
                        exit;
                    end;

                    RejectCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs.Status = 'Pending' then begin
                                SelectedRecs.Status := 'Not Paid'; // Set status to "Declined"
                                SelectedRecs.Modify();
                                RejectCount += 1;
                            end else
                                ErrorCount += 1; // Count records that are not in "Pending" status
                        until SelectedRecs.Next() = 0;
                    Commit(); // Commit changes
                    CurrPage.Update(false); // Refresh page
                    // Display result messages
                    Message('%1 record(s) rejected. %2 record(s) were not in "Pending" status.', RejectCount, ErrorCount);
                end;
            }
        }
    }
}