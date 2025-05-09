table 50963 "Revenue Item Breakdown"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50100; "RI_No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
            AutoIncrement = true;
        }

        field(50101; "Item Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item Type';
            TableRelation = "Secondary Item"."Secondary Item Type" WHERE("Charges Status" = CONST("Regular Charges"));
        }


    }

    keys
    {
        key(PK; "RI_No.") { Clustered = true; }
    }
}

