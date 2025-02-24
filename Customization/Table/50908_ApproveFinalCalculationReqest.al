table 50908 "Approval Final Calculation"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "ID";

    fields
    {
        field(50101; "ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ID';
            Editable = false;
            AutoIncrement = true;

        }
        field(50102; "Status"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
        }

        field(50107; "Tenant ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
        }

        field(50104; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }

        field(50111; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Start Date';
        }

        field(50103; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract End Date';
        }
        field(50109; "Termination Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Termination Date';
        }
        // field(50112; "change Payment series"; Text[300])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'changed Payment series';
        // }
        // field(50113; "Payment mode"; Text[300])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Payment mode';
        // }
        field(50114; "Contract Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Amount';
        }
        // field(50115; "Vat Amount"; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'New Vat Amount';
        // }

        // field(50117; "Due Date"; Date)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'New Due Date';
        // }
        // Field(50110; "Description"; Text[500])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Description';
        //     Editable = true;
        // }

        // field(50118; "Items"; Text[500])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Items';
        // }
    }

    keys
    {
        key(PK; "ID")
        {
            Clustered = false;
        }
    }



}

