tableextension 50101 CustomerExtension extends Customer
{
    // DataCaptionFields = "Tenant ID";


    fields
    {
        // field(50100; "Tenant ID"; code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Tenant ID';
        //     Editable = false;
        //     // AutoIncrement = true;
        //     // Optional: Set as Primary Key
        // }

        field(50101; "Username"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Username';
            // Additional properties can be added here if needed
        }

        field(50102; "Password"; Code[30])
        {
            DataClassification = ToBeClassified; // Marking as sensitive for security
            Caption = 'Password';
            // To ensure password handling is secure, this field should be masked or encrypted if supported.
        }

        field(50103; "Date Of Birth"; Date)
        {
            DataClassification = ToBeClassified; // Marking as sensitive for security
            Caption = 'Date Of Birth';
        }

        field(50104; "Nationality"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Nationality';
        }

        field(50105; "Emirates ID"; Code[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'Emirates ID Number';
        }

        field(50106; "Emirates ID Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Emirates ID Expiry Date';
        }

        field(50107; "License No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Trade License No.';
        }

        field(50108; "Licensing Authority"; Text[100])
        {
            Caption = 'Licensing Authority';
            DataClassification = ToBeClassified;
        }

        field(50109; "Code Area"; Enum "UAE Phone Code Area") // Using the enum here
        {
            DataClassification = ToBeClassified;
            Caption = 'Code Area';
        }

        field(50110; "Occupation"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Occupation';
        }
        field(50111; "Passport Number"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Passport Number';
        }

        field(50112; "Passport Issue Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Passport Issue Date';
        }

        field(50113; "Passport Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Passport Expiry Date';
        }

        field(50114; "Country of Passport"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country of Passport';
        }

        field(50115; "Approve"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Approve" = true then
                    "Decline" := false; // Automatically turn off Decline when Approve is selected
            end;
        }
        field(50116; "Decline"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Decline" = true then
                    "Approve" := false; // Automatically turn off Decline when Approve is selected
            end;
        }

        field(50117; "Customer Type"; Enum "Customer Type Enum")
        {
            Caption = 'Customer Type';
            DataClassification = ToBeClassified;
        }
        field(50118; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
        }
        field(50119; "P.O.Box"; Code[50])
        {
            Caption = 'P.O.Box';
        }

    }

    trigger OnInsert()
    var
        BusinessUnit: Record "Business Unit";
    begin
        if BusinessUnit.Get('PM') then
            "Business Unit" := 'PM'; // Assign Property Management
        if BusinessUnit.Get('PS') then
            "Business Unit" := 'PS'; // Assign Property Sales
    end;

    var
        myInt: Integer;


    // trigger OnInsert()
    // var
    //     NoSeriesMgt: Codeunit "No. Series";

    // begin
    //     if "Tenant ID" = '' then begin
    //         "Tenant ID" := NoSeriesMgt.GetNextNo('TENANTID', Today(), true);
    //     end;
    // end;
}