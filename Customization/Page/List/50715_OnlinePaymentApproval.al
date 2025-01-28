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

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
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
            action(Receive)
            {
                Caption = 'Receive';
                ApplicationArea = All;
                Image = Receive;

                trigger OnAction()
                var
                    SelectedRecs: Record "Approval Payment Request";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
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
                                SelectedRecs.Status := 'Receive';
                                SelectedRecs.Modify();
                                ApproveCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) approved. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);




                end;
            }
            action(NotReceive)
            {
                Caption = 'NotReceive';
                ApplicationArea = All;
                Image = NotReceive;

                trigger OnAction()
                var
                    SelectedRecs: Record "Approval Payment Request";
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
                                SelectedRecs.Status := 'NotReceive'; // Set status to "Declined"
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