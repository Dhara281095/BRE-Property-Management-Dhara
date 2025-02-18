table 50934 "Payment Schedule2"
{
    DataClassification = ToBeClassified;


    fields
    {




        field(50100; "Secondary Item Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Secondary Item Type';

        }


        field(50101; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';

        }


        field(50102; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Amount';

        }



        field(50103; "Amount Including VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Including VAT';

        }

        field(50104; "Installment Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Installment Start Date';

        }

        field(50105; "Installment End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Installment End Date';

        }



        field(50106; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';

        }

        field(50107; "Installment No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Installment No.';

        }



        field(50116; "Payment Series"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Series';

        }

        field(50108; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }


        field(50110; "Tenant ID"; Code[20])
        {

            Caption = 'Tenant ID';

        }
        field(50111; "Tenant Name"; Text[100])
        {

            Caption = 'Tenant Name';

        }
        field(50915; "Invoiced"; Boolean)
        {
            Caption = 'Invoiced';
        }


        field(50914; "Contract ID"; Integer)
        {
            Caption = 'Contract ID';
        }

        field(50916; "Payment Status"; Text[100])
        {
            Caption = 'Payment Status';
        }
        // field(50916; "Tenant Name"; Text[100])
        // {
        //     Caption = 'Tenant Name';
        // }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }


    }


}
