table 50917 "CombinePaymentLog"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "ID";

    fields
    {
        field(50100; "ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ID';
            Editable = false;
        }
        field(50101; "Approval Status"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
        }
        field(50102; "Request Type"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Request Type';
        }
        field(50103; "Tenant ID"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
        }
        field(50104; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }

        field(50105; "New Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'New Amount';
        }
        field(50106; "New VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'New Vat Amount';
        }

        field(50107; "Change Amount Including VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'New Amount Including VAT';
        }

        field(50108; "Payment mode"; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment mode';
            TableRelation = "Payment Type"."Payment Method";
        }
        field(50109; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'New Due Date';
        }
        field(50110; "Payment Series"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Series';
        }

        field(50111; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "ID")
        {
            Clustered = true;
        }
    }


}

