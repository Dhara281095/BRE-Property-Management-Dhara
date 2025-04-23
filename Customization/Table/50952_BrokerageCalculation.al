table 50952 "Brokerage Calculation"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(50100; "Owner ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner ID';
            TableRelation = "Owner Profile"."Owner ID";

            // trigger OnValidate()
            // var
            //     Customer: Record "Customer";
            // begin
            //     // When a Deposit Bank is selected (i.e., a Bank Account No. is provided)
            //     if "Owner Name" <> '' then begin
            //         // Attempt to find the Bank Account using the No. from the Deposit Bank
            //         if Customer.Get("Owner Name") then
            //             "Owner Name" := Customer."Name"; // Populating the Name field from the Bank Account table
            //     end;
            // end;
        }

        field(50101; "Property ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property ID';
            TableRelation = "Property Registration"."Property ID";
        }

        field(50102; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date';
        }

        field(50103; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }
        field(50104; "ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ID';
            AutoIncrement = true;
            Editable = false;
        }

    }


    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
        key(Secondary; "Owner ID", "Property ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Property ID", "Owner ID")
        {

        }
    }

}
