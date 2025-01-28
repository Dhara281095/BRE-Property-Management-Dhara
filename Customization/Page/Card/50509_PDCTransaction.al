page 50509 "PDC Transaction"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PDC Transaction";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("PDC ID"; Rec."PDC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("payment Series"; Rec."payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant Name"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                }
                field("Tenant"; Rec."Tenant Name Display")
                {
                    ApplicationArea = All;

                }

                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Cheque Status")
                {
                    ApplicationArea = All;
                    Editable = IsLeaseManager;
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment mode2";
                    begin
                        // Check if the Cheque Status is set to 'Cleared'
                        if Rec."Cheque Status" = Rec."Cheque Status"::Cleared then begin
                            // Ensure the related Payment Series record exists

                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                // Update the Payment Status field in the Payment Series record
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Received; // Update to your specific value
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Cleared;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::Y;
                                PaymentSeriesRec.Modify(); // Save the changes
                            end else
                                Error('The related Payment Series record was not found.');
                        end

                        else if Rec."Cheque Status" = Rec."Cheque Status"::Deposited then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                // Update the Payment Status field in the Payment Series record

                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Deposited;
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Due;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::Y;
                                PaymentSeriesRec.Modify(); // Save the changes
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::"Cheque Received" then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");

                            if PaymentSeriesRec.FindSet() then begin
                                // Update the Payment Status field in the Payment Series record

                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Cheque Received";
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                PaymentSeriesRec.Modify(); // Save the changes
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::"Due cheque not deposited" then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Due cheque not deposited";
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                PaymentSeriesRec.Modify();
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received" then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Replaced & Received";
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                PaymentSeriesRec.Modify();
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::Retrieved then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Retrieved;
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                            end else
                                Error('The related Payment Series record was not found.');
                        end
                        else if Rec."Cheque Status" = Rec."Cheque Status"::Returned then begin
                            PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                            if PaymentSeriesRec.FindSet() then begin
                                PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Returned;
                                PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                            end else
                                Error('The related Payment Series record was not found.');
                        end;
                    end;


                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                }
                field(View; Rec.View)
                {
                    ApplicationArea = All;
                }

                group(HideFields)
                {
                    ShowCaption = false;
                    Visible = Isvisible;
                    field("Replacement PDC ID"; Rec."Replacement PDC ID")
                    {
                        ApplicationArea = All;
                        // Visible = Isvisible;
                    }

                    field("Reason"; Rec."Reason")
                    {
                        ApplicationArea = All;
                        // Visible = Isvisible;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateStatus)
            {
                Caption = 'Update Cheque Status';
                ApplicationArea = All;
                trigger OnAction()
                var
                // ChequeStatusHandler: Codeunit "Cheque Status Handler";
                begin
                    // ChequeStatusHandler.UpdateChequeStatus(Rec);
                end;
            }


        }
    }

    var
        myInt: Integer;
        IsLeaseManager: Boolean;
        Isvisible: Boolean;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsLeaseManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE_MANAGER');
        if PermissionSet.FindSet() then begin
            if PermissionSet."Profile ID" = 'LEASE_MANAGER' then
                IsLeaseManager := true;
        end;


    end;


}