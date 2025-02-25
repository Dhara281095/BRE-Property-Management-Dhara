page 50521 "Security Deposit Ledger List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Security Deposite Ledger";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Ledger ID"; Rec."Ledger ID") { ApplicationArea = All; }
                field("Contract ID"; Rec."Contract ID") { ApplicationArea = All; }
                field("Tenant ID"; Rec."Tenant ID") { ApplicationArea = All; }
                field("Property ID"; Rec."Property ID") { ApplicationArea = All; }
                field("Transaction Date"; Rec."Transaction Date") { ApplicationArea = All; }
                field("Transaction Type"; Rec."Transaction Type") { ApplicationArea = All; }
                field("Initial Deposit Amount"; Rec."Initial Deposit Amount") { ApplicationArea = All; }
                field("Unpaid Rent Deduction"; Rec."Unpaid Rent Deduction") { ApplicationArea = All; }
                field("Damage Charges Deduction"; Rec."Damage Charges Deduction") { ApplicationArea = All; }
                field("Penalty Deduction"; Rec."Penalty Deduction") { ApplicationArea = All; }
                field("Service Charges Deduction"; Rec."Service Charges Deduction") { ApplicationArea = All; }
                field("Other Deductions"; Rec."Other Deductions") { ApplicationArea = All; }
                field("Total Deductions"; Rec."Total Deductions") { ApplicationArea = All; Editable = false; }
                field("Refundable Amount"; Rec."Refundable Amount") { ApplicationArea = All; Editable = false; }
                field("Approval Status"; Rec."Approval Status") { ApplicationArea = All; }
                field("Processed By"; Rec."Processed By") { ApplicationArea = All; }
                field("Final Settlement Date"; Rec."Final Settlement Date") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ApproveRefund)
            {
                Caption = 'Approve Refund';
                ApplicationArea = All;
                trigger OnAction()
                var
                    LedgerEntry: Record "Security Deposite Ledger";
                begin
                    LedgerEntry.Get(Rec."Ledger ID");
                    if LedgerEntry."Approval Status" <> LedgerEntry."Approval Status"::Pending then
                        Error('Only pending refunds can be approved.');

                    LedgerEntry."Approval Status" := LedgerEntry."Approval Status"::Approved;
                    LedgerEntry."Final Settlement Date" := CurrentDateTime;
                    LedgerEntry."Processed By" := UserId.ToUpper();
                    LedgerEntry.Modify();
                end;
            }
        }
    }

    var
        myInt: Integer;
}