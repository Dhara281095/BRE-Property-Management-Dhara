table 50930 "Vendor Category"
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
        }
        field(50101; "Vendor Category Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Category Type';

        }
    }

    keys
    {
        key(PK; "ID", "Vendor Category Type")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; ID, "Vendor Category Type")
        {

        }
    }



}
