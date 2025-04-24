page 50135 "Upcoming Payments List" // Use an appropriate page number
{
    PageType = List;
    SourceTable = "Payment Mode2"; // Replace with your actual payment table
    ApplicationArea = All;
    Caption = 'Payments Due Within 10 Days';
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
                field("Tenant Id"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Style = Attention;
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Days Until Due"; CalcDaysUntilDue())
                {
                    ApplicationArea = All;
                    Caption = 'Days Until Due';
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CurrentDate: Date;
        TenDaysLater: Date;
    begin
        CurrentDate := TODAY;
        TenDaysLater := CALCDATE('<+10D>', CurrentDate);

        // Only filter by due date, don't check payment status
        Rec.SetFilter("Due Date", '%1..%2', CurrentDate, TenDaysLater);
    end;

    local procedure CalcDaysUntilDue(): Integer
    begin
        if Rec."Due Date" = 0D then
            exit(0);

        exit(Rec."Due Date" - TODAY);
    end;
}