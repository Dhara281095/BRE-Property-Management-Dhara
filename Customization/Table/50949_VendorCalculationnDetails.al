table 50949 "Vendor Calculation Details"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Vendor ID";

    fields
    {
        field(50100; "Vendor ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor ID';
            Editable = false;
        }
        field(50101; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name';
            Editable = false;
        }

        // field(50102; "Property Name"; Text[100])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Property Name';
        // }

        // field(50103; "Property Type"; Text[100])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Property Type';
        // }

        field(50104; "Calculation Method"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Calculation Method';
            OptionMembers = " ","Percentage Method","Fixed Amount";
        }

        field(50105; "Percentage Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Percentage Type';
            OptionMembers = " ","Fixed","Variable";
        }

        field(50106; "Percentage Amount"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Percentage Amount';
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

        field(50109; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date';
            Editable = false;
        }
        field(50110; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
            Editable = false;
        }

        field(50111; "Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Status';
            OptionMembers = " ","Active","Terminate";
        }

        field(50112; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
        }

    }
    keys
    {
        key(PK; "Entry No.", "Vendor ID")
        {
            Clustered = true;
        }
    }
}
