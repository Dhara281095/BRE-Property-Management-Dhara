table 50947 "Pending Receviable Grid"
{
    DataClassification = ToBeClassified;
    Caption = 'Pending Receviable Grid';

    fields
    {
        field(50100; RevenueDescription; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revenue Description';
        }
        field(50101; RevisedAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised Amount';
        }
        field(50102; RevisedVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised VAT';
        }
        field(50103; RevisedAmountInclVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised Amount Incl. VAT';
        }
        field(50104; ReceiptsAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receipts Amount';
        }
        field(50105; ReceiptsVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receipts VAT';
        }
        field(50106; ReceiptsAmountInclVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receipts Amount Incl. VAT';
        }
        field(50107; DifferenceAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Difference Amount';
        }
        field(50108; DifferenceVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Difference VAT';
        }
        field(50109; DifferenceAmountInclVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Difference Amount Incl. VAT';
        }
        field(50111; "Contract ID"; Integer)
        {
            Caption = 'Contract ID';
            DataClassification = ToBeClassified;
        }
        field(50112; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(50113; "Termination Date"; Date)
        {
            Caption = 'Termination Date';
            DataClassification = ToBeClassified;

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