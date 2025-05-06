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
                    Editable = true;
                }
                field("Property_M Status"; Rec."Property_M Status")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Lease_M Status"; Rec."Lease_M Status")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Contract Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Contract End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Editable = true;
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
                field("Value"; Rec."Value")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = false;
                }

                field("Renewal Notification to Tenant"; Rec."Renewal Notification to Tenant")
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


            // action(ApproveProperty)
            // {
            //     Caption = 'Approve';
            //     ApplicationArea = All;
            //     Image = Approve;
            //     Visible = IsPropertyManager;

            //     trigger OnAction()
            //     var
            //         SelectedRecs: Record "ContractEndProcessApproval";
            //         ApproveCount: Integer;
            //         ErrorCount: Integer;
            //         LeaseNotApprovedCount: Integer;
            //     begin
            //         CurrPage.SetSelectionFilter(SelectedRecs);

            //         if SelectedRecs.IsEmpty() then begin
            //             Message('No records selected for approval.');
            //             exit;
            //         end;

            //         ApproveCount := 0;
            //         ErrorCount := 0;
            //         LeaseNotApprovedCount := 0;

            //         if SelectedRecs.FindSet() then
            //             repeat
            //                 if SelectedRecs."Lease_M Status" = 'Approved' then begin
            //                     if SelectedRecs."Property_M Status" = 'Pending' then begin
            //                         SelectedRecs."Property_M Status" := 'Approved';
            //                         SelectedRecs.Modify();
            //                         ApproveCount += 1;
            //                     end else
            //                         ErrorCount += 1;
            //                 end else
            //                     LeaseNotApprovedCount += 1;
            //             until SelectedRecs.Next() = 0;

            //         Commit();
            //         CurrPage.Update(false);

            //         Message('%1 record(s) approved for Property. %2 record(s) were not in "Pending" status. %3 record(s) were skipped as Lease_M Status was not "Approved".',
            //             ApproveCount, ErrorCount, LeaseNotApprovedCount);
            //     end;
            // }

            action(ApproveProperty)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                Visible = IsPropertyManager;

                trigger OnAction()
                var
                    SelectedRecs: Record "ContractEndProcessApproval";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    LeaseNotApprovedCount: Integer;
                    TodayDate: Date;
                    DaysRemaining: Integer;
                    SendTenantMail: Codeunit "SendTenantMail";
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for approval.');
                        exit;
                    end;

                    ApproveCount := 0;
                    ErrorCount := 0;
                    LeaseNotApprovedCount := 0;
                    TodayDate := Today;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."Lease_M Status" = 'Approved' then begin
                                if SelectedRecs."Property_M Status" = 'Pending' then begin
                                    SelectedRecs."Property_M Status" := 'Approved';

                                    // Calculate remaining days until contract end date
                                    DaysRemaining := SelectedRecs."End Date" - TodayDate;

                                    if DaysRemaining <= SelectedRecs."Renewal Notification to Tenant" then begin

                                        SelectedRecs."Value" := 'true'; // Set Value to text 'true'
                                        SendTenantMail.SendEmailToTenant(SelectedRecs); // Send email to tenant
                                    end else
                                        SelectedRecs."Value" := 'False'; // Set Value to text 'false'


                                    SelectedRecs.Modify();
                                    ApproveCount += 1;
                                end else
                                    ErrorCount += 1;
                            end else
                                LeaseNotApprovedCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) approved for Property. %2 record(s) were not in "Pending" status. %3 record(s) were skipped as Lease_M Status was not "Approved".',
                        ApproveCount, ErrorCount, LeaseNotApprovedCount);
                end;
            }


            action(ApproveLease)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                Visible = IsLeaseManager;

                trigger OnAction()
                var
                    SelectedRecs: Record "ContractEndProcessApproval";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    EmailSender: Codeunit 50302;
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

                                // Send Email After Approval
                                EmailSender.SendEmail(SelectedRecs);
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
                Caption = 'Decline';
                ApplicationArea = All;
                Image = Cancel;
                Visible = IsPropertyManager; // Button visible only for Property Manager

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
                Caption = 'Decline';
                ApplicationArea = All;
                Image = Cancel;
                Visible = IsLeaseManager; // Button visible only for Lease Manager

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


    trigger OnOpenPage()
    begin
        IsPropertyManager := CheckUserRole();
        IsLeaseManager := CheckUserRole1();
    end;

    procedure CheckUserRole(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then begin
            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(true);  // Only property managers can approve/reject
                else
                    exit(false);
            end;
        end;
        exit(false);
    end;

    procedure CheckUserRole1(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then begin
            case UserPersonalization."Profile ID" of
                'LEASE_MANAGER':
                    exit(true);  // Only property managers can approve/reject
                else
                    exit(false);
            end;
        end;
        exit(false);
    end;

    var
        IsPropertyManager: Boolean;
        IsLeaseManager: Boolean;

}






