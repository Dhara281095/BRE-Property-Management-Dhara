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
        field(13; "Total Invoiced Amount"; Decimal)
        {
            Caption = 'Total Invoiced Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Final Billing Calculation Grid"."InvoicedAmount" where("Contract ID" = field("Contract ID")));

        }
        field(14; "Total Invoiced VAT"; Decimal)
        {
            Caption = 'Total Invoiced VAT';
            FieldClass = FlowField;
            CalcFormula = sum("Final Billing Calculation Grid"."InvoicedVAT" where("Contract ID" = field("Contract ID")));

        }
        field(15; "Total Invoiced AmountIncl. VAT"; Decimal)
        {
            Caption = 'Total Invoiced Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Final Billing Calculation Grid"."InvoicedAmountInclVAT" where("Contract ID" = field("Contract ID")));

        }
        field(16; "Total Revised Amount"; Decimal)
        {
            Caption = 'Total Revised Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Final Billing Calculation Grid"."RevisedAmount" where("Contract ID" = field("Contract ID")));

        }
        field(17; "Total Revised VAT"; Decimal)
        {
            Caption = 'Total Invoiced Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Final Billing Calculation Grid"."RevisedVAT" where("Contract ID" = field("Contract ID")));

        }
        field(18; "Total Revised AmountIncl. VAT"; Decimal)
        {
            Caption = 'Total Revised Amount Incl. VAT';
            FieldClass = FlowField;
            CalcFormula = sum("Final Billing Calculation Grid"."RevisedAmountInclVAT" where("Contract ID" = field("Contract ID")));

        }
        field(19; "Total Differnece Amount"; Decimal)
        {
            Caption = 'Total Difference Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Final Billing Calculation Grid"."DifferenceAmount" where("Contract ID" = field("Contract ID")));

        }
        field(20; "Total Difference VAT"; Decimal)
        {
            Caption = 'Total Invoiced Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Final Billing Calculation Grid"."DifferenceVAT" where("Contract ID" = field("Contract ID")));

        }
        field(21; "Total DifferenceAmountIncl.VAT"; Decimal)
        {
            Caption = 'Total Difference Amount Incl. VAT';
            FieldClass = FlowField;
            CalcFormula = sum("Final Billing Calculation Grid"."DifferenceAmountInclVAT" where("Contract ID" = field("Contract ID")));

        }
        field(22; "Termination Date"; Date)
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