page 50966 "Credit Note Card"
{
    PageType = Card;
    SourceTable = "Credit Note";
    ApplicationArea = All;
    Caption = 'Credit Note Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Contract Details")
            {
                field("Credit Note Type"; Rec."Credit Note Type")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note Type';
                    ToolTip = 'Enter the Credit Note Type.';
                    Editable = false;
                }
                // field("TerminationCreditNoteType"; Rec."TerminationCreditNoteType")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Credit Note Type';
                //     ToolTip = 'Enter the Credit Note Type.';
                //     Editable = false;
                //     Visible = ShowTermination;
                // }

                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Credit Note No."; Rec."Credit Note No.")
                {
                    ApplicationArea = All;
                }
                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    TableRelation = "Final Calculation"."Contract ID";

                    trigger OnValidate()
                    var
                        TenancyContract: Record "Final Calculation";
                    begin
                        TenancyContract.SetRange("Contract ID", Rec."Contract ID");
                        if TenancyContract.FindSet() then begin
                            Rec."Credit Note Type" := Rec."Credit Note Type"::"Termination Credit Note";
                            Rec."Contract Start Date" := TenancyContract."Contract Start Date";
                            Rec."Contract End Date" := TenancyContract."Contract End Date"; // Convert Integer to Text
                            Rec."Unit Type" := TenancyContract."Unit Type";
                            Rec."Contract Amount" := TenancyContract."Contract Amount";
                            Rec."Tenant ID" := TenancyContract."Tenant ID";
                            Rec."Tenant Name" := TenancyContract."Tenant Name";
                            Rec."Tenant Email" := TenancyContract."Tenant Email"; // Convert Integer to Text
                            Rec."FC ID" := TenancyContract."FC ID";
                            BillingCalculationSub();
                        end else begin // Clear the fields if no record is found
                            Rec."Credit Note Type" := Rec."Credit Note Type"::"Termination Credit Note";
                            Rec."Contract Start Date" := 0D;
                            Rec."Contract End Date" := 0D; // Convert Integer to Text
                            Rec."Unit Type" := '';
                            Rec."Contract Amount" := 0;
                            Rec."Tenant ID" := '';
                            Rec."Tenant Name" := '';
                            Rec."Tenant Email" := ''; // Convert Integer to Text
                            Rec."FC ID" := 0;
                        end;

                    end;
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                    Editable = false;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                    Editable = false;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type';
                    ToolTip = 'Enter the Unit Type.';
                    Editable = false;
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    ToolTip = 'Enter the Contract Amount.';
                    Editable = false;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
            group("Customer Details")
            {
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Email';
                    Editable = false;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false;
                }
            }
            field("Reason for Rejection"; Rec."Reason for Rejection")
            {
                Caption = 'Reason for Rejection';
                Editable = false;
            }
            group("Billing-Calculation")
            {
                part("Billing-Calculations"; "Billing Calculation CN Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }

            }
            // group("Invoice Details")
            // {
            //     // Visible = IsStandardCreditNoteType;
            //     field("Invoice ID"; Rec."Invoice ID")
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Invoice ID';
            //     }
            //     field("Amount"; Rec."Amount")
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Credit Note Amount';
            //     }
            // }
            // group("Credit-Note Details")
            // {
            //     // Visible = IsStandardCreditNoteType;
            //     part("Invoice-CreditNote"; "Invoice-Credit Note Card")
            //     {
            //         SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
            //         ApplicationArea = All;
            //         // Visible = isVisible;
            //     }
            // }
            // group("Generate Credit-Note Details")
            // {
            //     // Visible = IsStandardCreditNoteType;
            //     part("Final Invoice-CreditNote"; "Filtered Invoice Detail Card")
            //     {
            //         SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
            //         ApplicationArea = All;
            //         // Visible = isVisible;
            //     }
            // }
        }
    }


    actions
    {
        area(Processing)
        {
            action(CreditNote)
            {
                ApplicationArea = All;
                Caption = 'Credit Note Approval';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = Rec.Status = Rec.Status::Pending;


                trigger OnAction()
                var
                    ApprovalCreditNote: Record "Credit Note Approval";
                    CreditNote: Record "Credit Note";
                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    // Get the actual Credit Note record
                    if not CreditNote.Get(Rec."ID") then
                        Error('Credit Note record not found.');

                    ApprovalCreditNote.SetRange("Contract ID", Rec."Contract ID");

                    if ApprovalCreditNote.FindSet() then begin
                        // Modify existing approval record
                        ApprovalCreditNote."ID" := CreditNote."ID";
                        ApprovalCreditNote."FC ID" := CreditNote."FC ID";
                        ApprovalCreditNote."Contract ID" := CreditNote."Contract ID";
                        ApprovalCreditNote."Tenant ID" := CreditNote."Tenant ID";
                        ApprovalCreditNote."Status" := CreditNote."Status";
                        ApprovalCreditNote."Contract Start Date" := CreditNote."Contract Start Date";
                        ApprovalCreditNote."Contract End Date" := CreditNote."Contract End Date";
                        ApprovalCreditNote."Tenant Name" := CreditNote."Tenant Name";
                        ApprovalCreditNote."Contract Amount" := CreditNote."Contract Amount";
                        ApprovalCreditNote."Credit Note Type" := CreditNote."Credit Note Type";
                        ApprovalCreditNote.Modify();
                        Message('Approval Request Modified successfully!');
                    end else begin
                        // Insert new approval record
                        ApprovalCreditNote.Init();
                        ApprovalCreditNote."ID" := CreditNote."ID";
                        ApprovalCreditNote."FC ID" := CreditNote."FC ID";
                        ApprovalCreditNote."Contract ID" := CreditNote."Contract ID";
                        ApprovalCreditNote."Tenant ID" := CreditNote."Tenant ID";
                        ApprovalCreditNote."Status" := CreditNote."Status";
                        ApprovalCreditNote."Contract Start Date" := CreditNote."Contract Start Date";
                        ApprovalCreditNote."Contract End Date" := CreditNote."Contract End Date";
                        ApprovalCreditNote."Tenant Name" := CreditNote."Tenant Name";
                        ApprovalCreditNote."Contract Amount" := CreditNote."Contract Amount";
                        ApprovalCreditNote."Credit Note Type" := CreditNote."Credit Note Type";
                        ApprovalCreditNote.Insert(true);
                        Message('Approval Request Sent successfully!');
                    end;
                end;

            }

            action("Create Credit Note")
            {
                Caption = 'Create Credit Note';
                ApplicationArea = All;
                Image = NewDocument; // Use an appropriate icon for the action
                Promoted = true; // Make the action visible in the header
                PromotedCategory = Process; // Place it in the "Process" category
                PromotedIsBig = true; // Make it a prominent action

                trigger OnAction()
                var
                    CreditNotetable: Record "Credit Note";
                    CreditNote: Report "Terminated Credit Note";
                begin
                    // Filter the Sales Header record based on the current record
                    CreditNotetable.SetRange("Contract ID", Rec."Contract ID");

                    // Set the filtered Sales Header as the data source for the Credit Note report
                    CreditNote.SetTableView(CreditNotetable);

                    // Run the Credit Note report
                    CreditNote.RunModal();
                end;
            }
        }
    }

    // var
    //     IsStandardCreditNoteType: Boolean;

    // trigger OnAfterGetRecord()
    // begin
    //     if Rec."Credit Note Type" = Rec."Credit Note Type"::"Standard Credit Note" then begin
    //         IsStandardCreditNoteType := true;
    //     end else begin
    //         IsStandardCreditNoteType := false;
    //     end;
    // end;



    procedure BillingCalculationSub()
    var
        BillingCalculationSubCN: Record "Billing Calculation CN";
        BillingCalculationSubFC: Record "Final Billing Calculation Grid";
    begin


        BillingCalculationSubCN.SetRange("Contract ID", Rec."Contract ID");
        if BillingCalculationSubCN.FindSet() then begin
            BillingCalculationSubCN.DeleteAll();
        end;

        // TenancyContractLine.Reset();
        BillingCalculationSubFC.SetRange("Contract ID", Rec."Contract ID");
        if BillingCalculationSubFC.FindSet() then begin
            repeat
                if BillingCalculationSubFC."DifferenceAmount" > 0 then begin
                    BillingCalculationSubCN.Init();
                    // BillingCalculationSubCN."ID" := Rec."ID";
                    BillingCalculationSubCN."Contract ID" := Rec."Contract ID";
                    BillingCalculationSubCN."Tenant ID" := Rec."Tenant ID";
                    BillingCalculationSubCN."Item" := BillingCalculationSubFC."RevenueDescription";
                    BillingCalculationSubCN."Amount" := BillingCalculationSubFC."DifferenceAmount";
                    BillingCalculationSubCN."VAT Amount" := BillingCalculationSubFC."DifferenceVAT";
                    BillingCalculationSubCN."Amount Including VAT" := BillingCalculationSubFC."DifferenceAmountInclVAT";
                    BillingCalculationSubCN.Insert();
                    Clear(BillingCalculationSubCN);
                end;
            until BillingCalculationSubFC.Next() = 0;
        end;

    end;
}



