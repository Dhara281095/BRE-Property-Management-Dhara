table 50912 "Workflow Frequency PR"
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
            AutoIncrement = true;
            Editable = false;
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

        field(50105; "Property ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Property Registration"."Property ID";
        }

    }



    keys
    {
        key(Key1; "Entry No.", "Company ID")
        {
            Clustered = true;
        }
    }

}





