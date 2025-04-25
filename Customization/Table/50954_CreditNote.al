table 50954 "Credit Note"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50100; "ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ID';
            AutoIncrement = true;
            Editable = false;
        }
        field(50101; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }
        field(50102; "Tenant ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
        }

        field(50103; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Start Date';
        }

        field(50104; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract End Date';
        }

        field(50105; "Unit Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Type';
        }

        field(50106; "Contract Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Amount';

        }
        field(50107; "Tenant Email"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Email';
        }
        field(50116; "Tenant Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Name';
        }
        field(50117; "Credit Note Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Credit Note Type';
            OptionMembers = " ","Standard Credit Note","Termination Credit Note";
        }
        // field(50118; "TerminationCreditNoteType"; Option)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Credit Note Type';
        //     OptionMembers = "Termination Credit Note";
        // }
        field(50119; "Invoice ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice ID';
        }
        field(50120; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
        }
        field(50121; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
            OptionMembers = "Pending","Approve","Reject";
        }

    }


    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
    }
}
