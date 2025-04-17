page 50134 "Expiring Contract List"
{
    PageType = List;
    SourceTable = "Tenancy Contract";
    ApplicationArea = All;
    Caption = 'Contracts Expiring Soon';
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
                    Caption = 'Contract ID';
                }
                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Proposal ID';
                }
                field("Renewal Proposal ID"; Rec."Renewal Proposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Renewal Proposal ID';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                }
                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Single Unit ID';
                }
                field("Merge Unit ID"; Rec."Merge Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merge Unit ID';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Customer ID';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
                field("Annual Rent Amount"; Rec."Annual Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                }
                field("Tenant Contract Status"; Rec."Tenant Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Contract Status';
                }
                field("Remaining Days"; CalcRemainingDays())
                {
                    ApplicationArea = All;
                    Caption = 'Remaining Days';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CurrentDate: Date;
        OneMonthLater: Date;
    begin
        CurrentDate := TODAY;
        OneMonthLater := CALCDATE('<+1M>', CurrentDate);

        Rec.SetRange("Tenant Contract Status", Rec."Tenant Contract Status"::Active);
        Rec.SetFilter("Contract End Date", '%1..%2', CurrentDate, OneMonthLater);
    end;

    local procedure CalcRemainingDays(): Integer
    begin
        if Rec."Contract End Date" = 0D then
            exit(0);

        exit(Rec."Contract End Date" - TODAY);
    end;
}