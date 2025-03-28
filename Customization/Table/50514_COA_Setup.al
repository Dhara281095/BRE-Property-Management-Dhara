table 50514 "COA Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50501; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(50502; Item; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50503; COA_Account; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}