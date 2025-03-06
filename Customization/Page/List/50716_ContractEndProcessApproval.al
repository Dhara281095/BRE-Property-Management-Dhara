page 50719 "Contract End Process Approval"
{
    PageType = List;
    SourceTable = ContractEndProcessApproval;
    ApplicationArea = All;
    Caption = 'Contract End Process Approval';
    UsageCategory = Lists;
    InsertAllowed = false;
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
                field("Property_M Status"; Rec."Property_M Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lease_M Status"; Rec."Lease_M Status")
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
                field("Contract Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lease Manager Remark"; Rec."Lease Manager Remark")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Property Manager Remark"; Rec."Property Manager Remark")
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
            // Approve Action for Property_M Status
            action(ApproveProperty)
            {
                Caption = 'Approve Property';
                ApplicationArea = All;
                Image = Approve;

                trigger OnAction()
                var
                    SelectedRecs: Record "ContractEndProcessApproval";
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
                            if SelectedRecs."Property_M Status" = 'Pending' then begin
                                SelectedRecs."Property_M Status" := 'Approved';
                                SelectedRecs.Modify();
                                ApproveCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) approved for Property. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);
                end;
            }

            // Approve Action for Lease_M Status
            action(ApproveLease)
            {
                Caption = 'Approve Lease';
                ApplicationArea = All;
                Image = Approve;

                trigger OnAction()
                var
                    SelectedRecs: Record "ContractEndProcessApproval";
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
                            if SelectedRecs."Lease_M Status" = 'Pending' then begin
                                SelectedRecs."Lease_M Status" := 'Approved';
                                SelectedRecs.Modify();
                                ApproveCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) approved for Lease. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);
                end;
            }

            // Decline Action for Property_M Status
            action(DeclineProperty)
            {
                Caption = 'Decline Property';
                ApplicationArea = All;
                Image = Cancel;

                trigger OnAction()
                var
                    SelectedRecs: Record "ContractEndProcessApproval";
                    DeclineCount: Integer;
                    ErrorCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for decline.');
                        exit;
                    end;

                    DeclineCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."Property_M Status" = 'Pending' then begin
                                SelectedRecs."Property_M Status" := 'Declined';
                                SelectedRecs.Modify();
                                DeclineCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) declined for Property. %2 record(s) were not in "Pending" status.', DeclineCount, ErrorCount);
                end;
            }

            // Decline Action for Lease_M Status
            action(DeclineLease)
            {
                Caption = 'Decline Lease';
                ApplicationArea = All;
                Image = Cancel;

                trigger OnAction()
                var
                    SelectedRecs: Record "ContractEndProcessApproval";
                    DeclineCount: Integer;
                    ErrorCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for decline.');
                        exit;
                    end;

                    DeclineCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."Lease_M Status" = 'Pending' then begin
                                SelectedRecs."Lease_M Status" := 'Declined';
                                SelectedRecs.Modify();
                                DeclineCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) declined for Lease. %2 record(s) were not in "Pending" status.', DeclineCount, ErrorCount);
                end;
            }
        }
    }
}


