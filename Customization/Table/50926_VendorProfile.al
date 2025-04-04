table 50926 "Vendor Profile"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Vendor ID";
    fields
    {
        field(50100; "Vendor ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor ID';
            AutoIncrement = true;
            Editable = false;
        }

        field(50101; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name';
        }
        field(50102; "Vendor Contact No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Contact No.';
        }
        field(50103; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date';
        }
        field(50104; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }
        field(50105; "Calculation Method"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Calculation Method';
            OptionMembers = " ","Percentage Method","Fixed Amount";
        }

        field(50106; "Percentage Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Percentage Type';
            OptionMembers = " ","Fixed","Variable";
        }
        field(50107; "Base Amount"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Base Amount';
            OptionMembers = " ","Revenue","Collection","Annual Rent","Monthly Rent";
        }
        field(50108; "Frequency Of Payment"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Frequency Of Payment';
            OptionMembers = " ","Monthly","Quaterly","Half Yearly","Yearly";
        }

        field(50109; "Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Status';
            OptionMembers = " ","Active","Terminate";
        }
        field(50110; "Contract Document Upload"; Text[2000])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Document Upload';
            InitValue = 'Contract Upload';
        }
    }


    keys
    {
        key(PK; "Vendor ID", "Vendor Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Vendor ID", "Vendor Name")
        {

        }
    }

}
