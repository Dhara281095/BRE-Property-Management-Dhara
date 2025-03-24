page 50938 "FinalSettlemtCard"
{
    PageType = ListPart;
    SourceTable = "FinalSettlement";
    ApplicationArea = All;
    Caption = 'Final Settlement Details';
    //UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                }

                field("From."; Rec."From.")
                {
                    ApplicationArea = All;

                    // trigger OnValidate()
                    // var
                    //     finalCalculation: Record "Final Calculation";
                    // begin
                    //     finalCalculation.SetRange("Contract ID", Rec."Contract ID");
                    //     // Check if the contract status is either "Terminated" or "Renewed"
                    //     if (Rec."From." = Rec."From."::"Company") and
                    //        (Rec."To." = Rec."To."::"Tenant") then
                    //         IsVisible := true  // Link should be visible
                    //     // else
                    //     //     IsVisible := false; // Link should be hidden
                    // end;
                }

                field("To."; Rec."To.")
                {
                    ApplicationArea = All;

                    // trigger OnValidate()
                    // var
                    //     finalCalculation: Record "Final Calculation";
                    // begin
                    //     finalCalculation.SetRange("Contract ID", Rec."Contract ID");
                    //     // Check if the contract status is either "Terminated" or "Renewed"
                    //     if (Rec."From." = Rec."From."::"Company") and
                    //        (Rec."To." = Rec."To."::"Tenant") then
                    //         IsVisible := true  // Link should be visible
                    //     // else
                    //     //     IsVisible := false; // Link should be hidden
                    // end;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }

                field("Payment mode"; Rec."Payment mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    // Visible = IsVisible;
                }

                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }

                field("Deposit Status"; Rec."Deposit Status")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    //  Visible = IsVisible;
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                }

            }

        }

    }

    trigger OnModifyRecord(): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin
        // If the field is blank, assign '-'
        if Rec."Cheque No." = '' then
            Rec."Cheque No." := '-';

        // Check if the Payment mode is empty (not set)
        if Rec."Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Tenant ID");
        if Rec."Payment Status" = PaymentStatus::" " then
            // Set the first enum option as the default value
            Rec."Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value
    end;

    trigger OnAfterGetRecord()
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin
        // If the field is blank, assign '-'
        if Rec."Cheque No." = '' then
            Rec."Cheque No." := '-';

        // Check if the Payment mode is empty (not set)
        if Rec."Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Tenant ID");
        if Rec."Payment Status" = PaymentStatus::" " then
            // Set the first enum option as the default value
            Rec."Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        PaymentStatus: Enum "Payment Status";
    begin
        // If the field is blank, assign '-'
        if Rec."Cheque No." = '' then
            Rec."Cheque No." := '-';

        // Check if the Payment mode is empty (not set)
        if Rec."Payment mode" = '' then begin
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default
        end;

        finalCalculationgrid.SetRange("Contract ID", Rec."Contract ID");
        finalCalculationgrid.SetRange("Tenant ID", Rec."Tenant ID");
        if Rec."Payment Status" = PaymentStatus::" " then
            // Set the first enum option as the default value
            Rec."Payment Status" := PaymentStatus::Scheduled; // Replace with actual first enum value
    end;


    var
        IsVisible: Boolean;
}