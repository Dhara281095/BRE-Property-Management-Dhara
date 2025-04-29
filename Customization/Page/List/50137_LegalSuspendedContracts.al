page 50137 "Legal Suspended Contracts" // Use an appropriate page number
{
    PageType = List;
    SourceTable = SuspendReasonTable;
    ApplicationArea = All;
    Caption = 'Legally Suspended Contracts';
    UsageCategory = Lists;

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                }
                field(TenantID; Rec.TenantID)
                {
                    ApplicationArea = All;
                }
                field(TenantName; Rec.TenantName)
                {
                    ApplicationArea = All;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }
                field(SuspensionEffectiveDate; Rec.SuspensionEffectiveDate) // Adjust field name as needed
                {
                    ApplicationArea = All;
                    StyleExpr = 'Attention';
                }
                field(SuspensionEndDate; Rec.SuspensionEndDate) // Adjust field name as needed
                {
                    ApplicationArea = All;
                }
                field(Reason; Rec.Reason) // Adjust field name as needed
                {
                    ApplicationArea = All;
                }
                field("Tenant Contract Status"; Rec."Tenant Contract Status") // Adjust field name as needed
                {
                    ApplicationArea = All;
                }
                // Add other relevant fields here
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Tenant Contract Status", Rec."Tenant Contract Status"::Suspended);
        Rec.SetRange(Reason, Rec.Reason::"Legal Reason"); // Adjust field name and value as needed
        Rec.SetFilter(SuspensionEndDate, '%1', 0D); // Filter for empty date
    end;
}