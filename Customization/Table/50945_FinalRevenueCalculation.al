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
        field(13; "Actual Contract Tenure"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Actual Contract Tenure';
        }
        field(14; "Per Day Rent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Per Day Rent';
        }
        field(15; "Revised VAT %"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Revised VAT %';
        }
        field(16; "ContractYear(Termination Date)"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Year On Termination Date';

        }
        field(17; "Annual Rent Amount TermiYear"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Annual Rent Amount of Termination Year';
        }
        field(18; "Total No. Of Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total No. Of Days(Termination Year)';

        }
        field(19; "Total Original Amount"; Decimal)
        {
            Caption = 'Total Original Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Final Revenue Calculation Grid"."Original Amount" where("Contract ID" = field("Contract ID")));
        }
        field(20; "Total Original VAT"; Decimal)
        {
            Caption = 'Total Original VAT';
            FieldClass = FlowField;
            CalcFormula = sum("Final Revenue Calculation Grid"."Original VAT" where("Contract ID" = field("Contract ID")));

        }
        field(21; "Total Orgininal AmountIncl.VAT"; Decimal)
        {
            Caption = 'Total Orgininal Amount Incl. VAT';
            FieldClass = FlowField;
            DecimalPlaces = 2 : 2;
            CalcFormula = sum("Final Revenue Calculation Grid"."Original Amount Incl." where("Contract ID" = field("Contract ID")));
        }

        field(22; "Total Revised Amount"; Decimal)
        {
            Caption = 'Total Revised Amount';
            FieldClass = FlowField;
            DecimalPlaces = 2 : 2;
            CalcFormula = sum("Final Revenue Calculation Grid"."Revised Amount" where("Contract ID" = field("Contract ID")));
        }
        field(23; "Total Revised VAT"; Decimal)
        {
            Caption = 'Total Revised VAT';
            FieldClass = FlowField;
            DecimalPlaces = 2 : 2;
            CalcFormula = sum("Final Revenue Calculation Grid"."Revised VAT" where("Contract ID" = field("Contract ID")));

        }
        field(24; "Total Revised AmountIncl.VAT"; Decimal)
        {
            Caption = 'Total Revised Amount Incl. VAT';
            FieldClass = FlowField;
            DecimalPlaces = 2 : 2;
            CalcFormula = sum("Final Revenue Calculation Grid"."Revised Amount Incl." where("Contract ID" = field("Contract ID")));
        }
        field(25; "Total Difference Amount"; Decimal)
        {
            Caption = 'Total Difference Amount';
            FieldClass = FlowField;
            DecimalPlaces = 2 : 2;
            CalcFormula = sum("Final Revenue Calculation Grid"."Difference Amount" where("Contract ID" = field("Contract ID")));
        }
        field(26; "Total Difference VAT"; Decimal)
        {
            Caption = 'Total Difference VAT';
            FieldClass = FlowField;
            DecimalPlaces = 2 : 2;
            CalcFormula = sum("Final Revenue Calculation Grid"."Difference VAT" where("Contract ID" = field("Contract ID")));

        }
        field(27; "Total DifferenceAmountIncl.VAT"; Decimal)
        {
            Caption = 'Total Difference Amount Incl. VAT"';
            FieldClass = FlowField;
            DecimalPlaces = 2 : 2;
            CalcFormula = sum("Final Revenue Calculation Grid"."Difference Amount Incl." where("Contract ID" = field("Contract ID")));

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