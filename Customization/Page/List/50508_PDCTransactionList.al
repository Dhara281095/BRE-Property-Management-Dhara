page 50508 "PDC Transactions"
{
    PageType = List;
    SourceTable = "PDC Transaction";
    ApplicationArea = All;
    Caption = 'PDC Transactions List';
    UsageCategory = Lists;
    CardPageId = 50509;
    layout
    {
        area(content)
        {

            // Filter group for user inputs
            group("Filters")
            {
                field("Tenant Filter"; TenantFilter)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Filter PDCs by Tenant Name.';
                    trigger OnValidate()
                    begin
                        if TenantFilter <> '' then
                            Rec.SETFILTER("Tenant Name Display", '&&' + TenantFilter + '*')
                        else
                            Rec.RESET;

                        CurrPage.UPDATE(false);
                    end;
                }
                field("Status Filter"; StatusFilter)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Filter PDCs by Status.';
                    trigger OnValidate()
                    begin
                        if StatusFilter <> StatusFilter::" " then
                            Rec.SETRANGE(Rec."Cheque Status", StatusFilter)
                        else
                            Rec.RESET;

                        CurrPage.UPDATE(false);
                    end;
                }
                field("Cheque No"; ChequeNo)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specify the start date for the filter.';
                    trigger OnValidate()
                    begin
                        if ChequeNo <> '' then
                            Rec.SETFILTER("Cheque Number", '&&' + ChequeNo + '*')
                        else
                            Rec.RESET;

                        CurrPage.UPDATE(false);
                    end;
                }
                field("Date To"; DateToFilter)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specify the end date for the filter.';
                    trigger OnValidate()
                    begin
                        if DateToFilter <> 0D then
                            Rec.SETFILTER("Cheque Date", '<=%1', DateToFilter)
                        else
                            Rec.RESET;

                        CurrPage.UPDATE(false);
                    end;
                }
            }
            repeater(Group)
            {
                field("PDC ID"; Rec."PDC ID") { }
                field("payment Series"; Rec."payment Series") { }
                field("Tenant Name"; Rec."Tenant Name Display") { }
                field("Bank Name"; Rec."Bank Name") { }
                field("Cheque Number"; Rec."Cheque Number") { }
                field("Cheque Date"; Rec."Cheque Date") { }
                field("Amount"; Rec.Amount) { }
                field("Status"; Rec."Cheque Status") { }
                field("Approval Status"; Rec."Approval Status") { }

                field("Selected"; Rec."Selected") { }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Apply Filters")
            {
                ApplicationArea = All;
                Caption = 'Apply Filters';
                ToolTip = 'Apply the selected filter criteria.';
                trigger OnAction()
                begin
                    if TenantFilter <> '' then
                        Rec.SETFILTER("Tenant Name Display", '&&' + TenantFilter + '*');

                    if StatusFilter <> StatusFilter::" " then
                        Rec.SETRANGE(Rec."Cheque Status", StatusFilter);

                    if ChequeNo <> '' then
                        Rec.SETFILTER("Cheque Number", '&&' + ChequeNo + '*');

                    if DateToFilter <> 0D then
                        Rec.SETFILTER("Cheque Date", '<=%1', DateToFilter);

                    CurrPage.UPDATE(false);
                end;
            }

            action("Clear Filters")
            {
                ApplicationArea = All;
                Caption = 'Clear Filters';
                ToolTip = 'Clear all applied filters.';
                trigger OnAction()
                begin
                    Rec.RESET;
                    TenantFilter := '';
                    StatusFilter := StatusFilter::" ";
                    ChequeNo := '';
                    DateToFilter := 0D;

                    CurrPage.UPDATE(false);
                end;
            }


            action(BulkChangeStatus)
            {
                Caption = 'Change Status';
                Image = Action;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UnitRec: Record "PDC Transaction";
                    PDCStatusEnum: Enum "PDC Status Type Enum";
                    PaymentSeriesRec: Record "Payment Mode2";

                begin
                    // Filter for selected records
                    UnitRec.SetRange(Selected, true);

                    if UnitRec.FindSet() then begin

                        repeat
                            UnitRec."Cheque Status" := PDCStatusEnum::Deposited; // Set the desired status
                            UnitRec.Selected := false;    // Clear the selection
                            UnitRec.Modify();
                            PaymentSeriesRec.SetRange("Payment Series", UnitRec."payment Series");
                            PaymentSeriesRec.SetRange("Contract ID", UnitRec."Contract ID");

                            if PaymentSeriesRec.FindSet() then begin
                                repeat
                                    PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Deposited;
                                    PaymentSeriesRec.Modify();
                                until PaymentSeriesRec.Next() = 0;
                            end else
                                Error('The related Payment Series record was not found.');
                        until UnitRec.Next() = 0;

                        Message('Status updated for selected units.');
                    end else
                        Message('No units selected.');
                end;
            }

            // action(BulkUpdateChequeStatus)
            // {
            //     Caption = 'Bulk Update Cheque Status';
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     ToolTip = 'Update the Cheque Status to Deposited for selected records.';
            //     Image = Checkmark;

            //     trigger OnAction()
            //     begin
            //         UpdateChequeStatus();
            //     end;
            // }
        }
    }


    // procedure UpdateChequeStatus()
    // var
    //     Confirmation: Boolean;
    //     SelectedRecords: Record "PDC Transaction";
    //     PDCStatusEnum: Enum "PDC Status Type Enum";
    //     UpdatedCount: Integer;
    // begin
    //     // Ask for confirmation
    //     Confirmation := Confirm('Do you want to update the Cheque Status to Deposited for the selected records?');
    //     if not Confirmation then
    //         exit;

    //     UpdatedCount := 0;

    //     // Filter records that are selected
    //     Rec.Reset();
    //     Rec.SetRange(Selected, true);

    //     if Rec.FindSet() then begin
    //         repeat
    //             // Update the Cheque Status field to Deposited
    //             Rec.Validate("Cheque Status", PDCStatusEnum::Deposited); // Validate the new status
    //             Rec.Modify(true); // Save the changes
    //             UpdatedCount += 1;
    //         until Rec.Next() = 0;

    //         // Display success message
    //         Message('Cheque Status updated to Deposited for %1 record(s).', UpdatedCount);
    //     end else begin
    //         // Display message if no records are selected
    //         Message('No records selected for update.');
    //     end;
    // end;

    // procedure UpdateChequeStatus()
    // var
    //     Confirmation: Boolean;
    //     SelectedRecords: Record "PDC Transaction";
    //     PDCStatusEnum: Enum "PDC Status Type Enum";
    // begin
    //     // Ask for confirmation
    //     Confirmation := Confirm('Do you want to update the Cheque Status to Deposited for the selected records?');
    //     if not Confirmation then
    //         exit;

    //     // Ensure that records are selected
    //     if Rec.FindSet() then begin
    //         repeat
    //             // Update the Cheque Status field to Deposited
    //             SelectedRecords.Get(Rec."PDC ID"); // Retrieve the current record by PDC ID
    //             SelectedRecords.Validate("Cheque Status", PDCStatusEnum::Deposited); // Validate the new status
    //             SelectedRecords.Modify(true); // Save the changes
    //         until Rec.Next() = 0;

    //         // Display success message
    //         Message('Cheque Status updated to Deposited for the selected records.');
    //     end
    //     else begin
    //         Message('No records selected for update.');
    //     end;
    // end;

    var

        TenantFilter: Text[100]; // Filter for Tenant Name

        StatusFilter: Enum "PDC Status Type Enum"; // Filter for Cheque Status
        ChequeNo: Text[20]; // Filter start date
        DateToFilter: Date; // Filter end date



}


