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
            OptionMembers = " ","Payment Reminder","Invoice","90 days before Mail are send to tenant","100 days before mail send to lease manager";
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





