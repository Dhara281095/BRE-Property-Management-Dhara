page 50113 "Country Card"
{
    PageType = Card;
    SourceTable = Country;
    ApplicationArea = All;
    Caption = 'Country Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Country Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
                field("Sl No."; Rec."Sl No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sl No.';
                    Editable = false;
                }
                field("Country Name"; Rec."Country Name")
                {
                    ApplicationArea = All;
                    Caption = 'Country Name';
                    ShowMandatory = true;
                    NotBlank = true;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country Code';
                }

            }
        }

    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        IsNewUnmodified: Boolean;
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
        // Get record references
        RecRef.GetTable(Rec);
        xRecRef.GetTable(xRec);

        // Check if this is a new unmodified record by comparing current and previous state
        IsNewUnmodified := (RecRef.Count = 0) or (Format(Rec) = Format(xRec));

        // If it's a new unmodified record and user is trying to close/cancel
        if IsNewUnmodified and (CloseAction = ACTION::Cancel) then
            exit(true); // Allow closing without validation

        // For all other cases (modified records or OK action)
        if CloseAction = ACTION::OK then begin
            if not IsNewUnmodified then  // Only validate if the record has been modified
                Rec.TestField("Country Name");
        end;

        exit(true);
    end;


}



