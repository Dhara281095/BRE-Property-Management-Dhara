table 50945 "Final Revenue Calculation Grid"
{
    DataClassification = ToBeClassified;
    Caption = 'Final Revenue Calculation Grid';

    fields
    {
        field(1; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }
        field(2; "Revenue Description"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revenue Description';
        }
        field(3; "Original Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
        }
        field(4; "Original VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT';
            DecimalPlaces = 2 : 2;
        }
        field(5; "Original Amount Incl."; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount incl.';
            DecimalPlaces = 2 : 2;
        }
        field(6; "Revised Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised Amount';
            DecimalPlaces = 2 : 2;
        }
        field(7; "Revised VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised VAT';
            DecimalPlaces = 2 : 2;
        }
        field(8; "Revised Amount Incl."; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised Amount Incl.';
            DecimalPlaces = 2 : 2;
        }
        field(9; "Difference Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Difference Amount';
            DecimalPlaces = 2 : 2;
        }
        field(10; "Difference VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Difference VAT';
            DecimalPlaces = 2 : 2;
        }
        field(11; "Difference Amount Incl."; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Difference Amount Incl.';
            DecimalPlaces = 2 : 2;
        }

        field(12; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(PK; "Contract ID", "Entry No.")
        {
            Clustered = true;
        }
    }
}