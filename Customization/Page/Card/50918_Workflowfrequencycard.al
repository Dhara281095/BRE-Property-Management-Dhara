page 50918 "Workflow Frequency Card"
{
    PageType = ListPart;
    SourceTable = "Workflow Frequency";
    ApplicationArea = All;
    Caption = 'Workflow Frequency Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Company ID"; Rec."Company ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing

                }

                field("Workflow"; Rec."Workflow")
                {
                    ApplicationArea = All;
                }
                field("frequncy Status"; Rec."frequncy Status")
                {
                    ApplicationArea = All;
                    Caption = 'frequncy Status';
                }

                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                }

            }
        }
    }

    var
        IsApproved: Boolean;

    // trigger OnModifyRecord(): Boolean
    // begin
    //     IsApproved := (Rec."frequncy Status" <> Rec."frequncy Status"::Property);
    // end;


    trigger OnModifyRecord(): Boolean
    begin
        if Rec."frequncy Status" = Rec."frequncy Status"::Company then begin
            if Rec."No. of Days" <= 0 then
                Message('Please enter a valid number of days when Frequency Status is set to Company.');
            IsApproved := true;
        end else begin
            Rec."No. of Days" := 0; // Auto-set to 0
            IsApproved := (Rec."frequncy Status" <> Rec."frequncy Status"::Property);
            if Rec."frequncy Status" = Rec."frequncy Status"::Property then
                Message('Since Frequency Status is set to Property, the number of days is automatically set to 0.')
            else
                Message('Please select "Company" as the Frequency Status before entering the number of days.');
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec."frequncy Status" = Rec."frequncy Status"::Company then begin
            if Rec."No. of Days" <= 0 then
                Message('Please enter a valid number of days when Frequency Status is set to Company.');
            IsApproved := true;
        end else begin
            Rec."No. of Days" := 0; // Auto-set to 0
            IsApproved := (Rec."frequncy Status" <> Rec."frequncy Status"::Property);
            if Rec."frequncy Status" = Rec."frequncy Status"::Property then
                Message('Since Frequency Status is set to Property, the number of days is automatically set to 0.')
            else
                Message('Please select "Company" as the Frequency Status before entering the number of days.');
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."frequncy Status" = Rec."frequncy Status"::Company then begin
            if Rec."No. of Days" <= 0 then
                Message('Please enter a valid number of days when Frequency Status is set to Company.');
            IsApproved := true;
        end else begin
            Rec."No. of Days" := 0; // Auto-set to 0
            IsApproved := (Rec."frequncy Status" <> Rec."frequncy Status"::Property);
            if Rec."frequncy Status" = Rec."frequncy Status"::Property then
                Message('Since Frequency Status is set to Property, the number of days is automatically set to 0.')
            else
                Message('Please select "Company" as the Frequency Status before entering the number of days.');
        end;
    end;

}