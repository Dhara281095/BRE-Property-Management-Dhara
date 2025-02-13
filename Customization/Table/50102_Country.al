table 50102 "Country"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = ID;

    fields
    {
        field(50100; "ID"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true; // Automatically increment the ID
            Editable = false; // Make it read-only for the user
            NotBlank = false;
        }
        field(50101; "Sl No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sl No.';
            Editable = false;
        }
        field(50102; "Country Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country Code';
        }
        field(50103; "Country Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country Name';
        }
    }

    keys
    {
        key(PK; "ID", "Country Code", "Country Name")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Sl No.", ID, "Country Name", "Country Code")
        {

        }
    }

    //-------------Record Delete--------------//
    trigger OnDelete()
    var
        CountryRec: Record "Country";
    begin
        // Find all records where 'Sl No.' is greater than the deleted record's 'Sl No.'
        // Set a filter to retrieve records where "Sl No." is greater than the current record's "Sl No."
        CountryRec.SetRange("Sl No.", "Sl No." + 1, 2147483647); // Set filter to find records with 'Sl No.' greater than the current record

        // Process each of those records and adjust 'Sl No.'
        if CountryRec.FindSet() then begin
            repeat
                // Decrease 'Sl No.' by 1 for each record
                CountryRec."Sl No." := CountryRec."Sl No." - 1;
                CountryRec.Modify; // Save the modified record
            until CountryRec.Next = 0; // Move to the next record
        end;
    end;

    //-------------Record Delete--------------//

    //-------------Record Insert--------------//

    trigger OnInsert()
    var
        CountryRec: Record "Country";
    begin
        if (Rec."Country Name" = '') then
            Error('Country Name is required.');

        // Check if 'Sl No.' is 0 (indicating it's a new record)
        if "Sl No." = 0 then begin
            // If there are existing records, find the last one and increment
            if CountryRec.FindLast then
                "Sl No." := CountryRec."Sl No." + 1
            else
                "Sl No." := 1; // Start from 1 if no records exist
        end;
    end;
    //-------------Record Insert--------------//

    trigger OnModify()
    begin
        if (Rec."Country Name" = '') then
            Error('Country Name is required.');
    end;

}
