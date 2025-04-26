tableextension 50506 "Posted Sales Credit Memo" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50101; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }

        field(50102; "Property Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Name';

        }
        field(50103; "Unit Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Name';
        }
        field(50104; "Contract Tenure"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Tenure';
        }
        field(50105; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Approved,Rejected;
            Caption = 'Approval Status';
        }
        field(50111; "View Invoice"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'View Invoice';
        }
        field(50112; "View Document URL"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'View Document URL';
        }

    }
}
