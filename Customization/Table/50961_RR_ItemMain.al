table 50961 "Revenue Recognition Item"
{

    DataClassification = ToBeClassified;

    fields
    {
        field(50100; "RR_No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
            Editable = false;
        }

        field(50101; "Item Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item Type';
            TableRelation = "Secondary Item"."Secondary Item Type" WHERE("Charges Status" = CONST("Regular Charges"));
        }
        field(50102; "Link"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Link';
        }
        field(50103; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }

    }

}
