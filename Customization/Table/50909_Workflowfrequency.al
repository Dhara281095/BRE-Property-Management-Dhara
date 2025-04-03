table 50909 "Workflow Frequency"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50100; "Company ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Company ID';
            TableRelation = "testData"."Company ID";

        }

        field(50101; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true; // Automatically increment the ID
            Editable = false; // Make it read-only for the user
        }

        field(50102; "Workflow"; Option)
        {
            OptionMembers = " ","Payment Reminder","Invoice","Renewal Notification to Tenant","Tenant Loyalty Check Reminder";
            Caption = 'Workflow';
        }

        field(50103; "frequncy Status"; Option)
        {
            OptionMembers = " ","Company","Property";
            Caption = 'frequncy Status';
        }

        field(50104; "No. of Days"; Integer)
        {
            DataClassification = ToBeClassified;

            // trigger OnValidate()
            // var
            //     RenewalDays: Integer;
            //     LoyaltyCheckDays: Integer;
            // begin
            //     // Store "No of Days" when Workflow is "Renewal Notification to Tenant"
            //     if Rec."Workflow" = Rec."Workflow"::"Renewal Notification to Tenant" then
            //         RenewalDays := Rec."No. of Days";

            //     // Store "No of Days" when Workflow is "Tenant Loyalty Check Reminder"
            //     if Rec."Workflow" = Rec."Workflow"::"Tenant Loyalty Check Reminder" then
            //         LoyaltyCheckDays := Rec."No. of Days";

            //     // Compare the values and show an error if condition is not met
            //     if (RenewalDays > LoyaltyCheckDays) then
            //         Error('Renewal Notification to Tenant must have fewer days than Tenant Loyalty Check Reminder.');
            // end;
        }

    }



    keys
    {
        key(Key1; "Entry No.", "Company ID")
        {
            Clustered = true;
        }
    }


    // fieldgroups
    // {
    //     fieldgroup(DropDown; "ID")
    //     {

    //     }
    // }

}





