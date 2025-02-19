table 50704 "ContractEndProcessApproval"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = SystemId, "ID";

    fields
    {
        field(50101; "ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ID';
            Editable = false;
            AutoIncrement = true;
        }
        field(50102; "Status"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
            Editable = false;
        }
        field(50103; "Contract Id"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Id';
            Editable = false;
        }
        field(50104; "Tenant Id"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Id';
            Editable = false;
        }
        field(50105; "Tenant Name"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Name';
            Editable = false;
        }
        field(50106; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Start Date';
            Editable = false;
        }
        field(50107; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract End Date';
            Editable = false;
        }
        field(50108; "Requested Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Requested Date';
            Editable = false;
        }
        field(50109; "Description"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
            Editable = false;
        }

    }
    keys
    {
        key(PrimaryKey; "ID")
        {
            Clustered = false;
        }
        key(PK; SystemId)
        {
            Clustered = true;
        }
    }
}