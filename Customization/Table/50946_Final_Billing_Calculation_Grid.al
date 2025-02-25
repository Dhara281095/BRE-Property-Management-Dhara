table 50946 "Final Billing Calculation Grid"
{
    DataClassification = ToBeClassified;
    Caption = 'Final Billing Calculation Grid';

    fields
    {
        field(1; RevenueDescription; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revenue Description';
        }

        field(2; InvoicedAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoiced Amount';
        }

        field(3; InvoicedVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoiced VAT';
        }

        field(4; InvoicedAmountInclVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoiced Amount Incl. VAT';
        }

        field(5; RevisedAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised Amount';
        }

        field(6; RevisedVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised VAT';
        }

        field(7; RevisedAmountInclVAT; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised Amount Incl. VAT';
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