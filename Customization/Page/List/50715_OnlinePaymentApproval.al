page 50715 "Online Payment Request"
{
    PageType = List;
    SourceTable = OnlinePaymentApproval;
    ApplicationArea = All;
    Caption = 'Payment receive Approval';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;

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
                    Editable = true;
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
                field("Payment transaction ID"; Rec."Payment transaction ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment mode"; Rec."Payment mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
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
            action(Received)
            {
                Caption = 'Received';
                ApplicationArea = All;
                Image = Approve;

                trigger OnAction()
                var
                    SelectedRecs: Record "OnlinePaymentApproval";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    PaymentRec: Record "Payment Mode2";
                    PaymentStatus: Enum "Payment Status";
                    PaymentScheduleRec: Record "Payment Schedule2";
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
                                SelectedRecs.Status := 'Received';
                                SelectedRecs.Modify();

                                PaymentRec.SetRange(PaymentRec."Contract ID", SelectedRecs."Contract ID");
                                PaymentRec.SetRange(PaymentRec."Tenant ID", SelectedRecs."Tenant ID");
                                PaymentRec.SetRange(PaymentRec."Payment Series", SelectedRecs."Payment Series");

                                if PaymentRec.FindSet() then begin
                                    // Update the status of OnlinePaymentApproval record
                                    PaymentRec."Approve/Decline Status" := 'Received';
                                    // PaymentRec."Payment Status" := PaymentStatus::Received;
                                    PaymentRec.Validate("Payment Status", PaymentStatus::Received);
                                    PaymentRec."Payment Received Date" := Today;
                                    PaymentRec.Modify(true);
                                end;

                                PaymentScheduleRec.SetRange(PaymentScheduleRec."Contract ID", PaymentRec."Contract ID");
                                PaymentScheduleRec.SetRange(PaymentScheduleRec."Tenant ID", PaymentRec."Tenant ID");
                                PaymentScheduleRec.SetRange(PaymentScheduleRec."Payment Series", PaymentRec."Payment Series");

                                // Loop through the Payment Schedule records to find matching Payment Series
                                if PaymentScheduleRec.FindSet() then begin
                                    repeat
                                        // Update Payment Schedule status to "Received" for the matching Payment Series
                                        PaymentScheduleRec."Payment Status" := 'Received';
                                        PaymentScheduleRec."Payment Recieved Date" := PaymentRec."Payment Received Date";
                                        PaymentScheduleRec.Modify; // Save the updated record
                                    until PaymentScheduleRec.Next() = 0; // Continue until all matching records are processed
                                end;

                                ApproveCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) approved. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);




                end;
            }
            action(NotReceived)
            {
                Caption = 'Not Received';
                ApplicationArea = All;
                Image = Reject;

                trigger OnAction()
                var
                    SelectedRecs: Record "OnlinePaymentApproval";
                    RejectCount: Integer;
                    ErrorCount: Integer;
                    PaymentRec: Record "Payment Mode2";
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
                                SelectedRecs.Status := 'Not Received'; // Set status to "Declined"
                                SelectedRecs.Modify();

                                PaymentRec.SetRange(PaymentRec."Contract ID", SelectedRecs."Contract ID");
                                PaymentRec.SetRange(PaymentRec."Tenant ID", SelectedRecs."Tenant ID");
                                PaymentRec.SetRange(PaymentRec."Payment Series", SelectedRecs."Payment Series");

                                if PaymentRec.FindSet() then begin
                                    // Update the status of OnlinePaymentApproval record
                                    PaymentRec."Approve/Decline Status" := 'Not Received';
                                    PaymentRec.Modify(true);
                                end;

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