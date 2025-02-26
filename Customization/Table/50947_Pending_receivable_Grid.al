table 50947 "Pending Receviable Grid"
{
    DataClassification = ToBeClassified;
    Caption = 'Pending Receviable Grid';

    fields
    {
        field(1; RevenueDescription; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revenue Description';
        }
        field(2; RevisedAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised Amount';
        }
        field(3; RevisedVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised VAT';
        }
        field(4; RevisedAmountInclVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised Amount Incl. VAT';
        }
        field(5; ReceiptsAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receipts Amount';
        }
        field(6; ReceiptsVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receipts VAT';
        }
        field(7; ReceiptsAmountInclVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receipts Amount Incl. VAT';
        }
        field(8; DifferenceAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Difference Amount';
        }
        field(9; DifferenceVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Difference VAT';
        }
        field(10; DifferenceAmountInclVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Difference Amount Incl. VAT';
        }
        field(11; "Contract ID"; Integer)
        {
            Caption = 'Contract ID';
            DataClassification = ToBeClassified;
        }
        field(12; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(PK; "Contract ID", "Entry No")
        {
            Clustered = true;
        }
    }

}