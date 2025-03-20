table 50922 "FinalSettlement"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50100; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }

        field(50101; "From."; Option)
        {
            OptionMembers = " ",Company,Tenant;
        }

        field(50102; "To."; Option)
        {
            OptionMembers = " ",Company,Tenant;
        }
        field(50103; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Amount';
        }
        field(50104; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';
        }
        field(50105; "Payment mode"; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment mode';
            TableRelation = "Payment Type"."Payment Method";
        }
        field(50106; "Payment Status"; Enum "Payment Status")
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Status';
        }

        field(50107; "Deposit Bank"; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Deposit Bank';
            TableRelation = "Bank Account";
        }

        field(50108; "Cheque No."; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cheque No.';
        }

        field(50109; "Deposit Status"; Option)
        {
            Caption = 'Deposit Status';
            OptionMembers = "-","N","Y";
        }

        field(50110; "Tenant ID"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
        }

        field(50111; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Contract ID")
        {
            Clustered = true;
        }
    }

}

