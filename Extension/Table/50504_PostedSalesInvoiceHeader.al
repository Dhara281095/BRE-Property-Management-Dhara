tableextension 50504 PostedSalesInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50101; "Contract ID"; Integer)
        {
            Caption = 'Contract ID';

        }

        field(50102; "Property Name"; Text[100])
        {
            Caption = 'Property Name';

        }
        field(50103; "Unit Name"; Text[100])
        {
            Caption = 'Unit Name';
        }
        field(50104; "Contract Tenure"; Text[50])
        {
            Caption = 'Contract Tenure';
        }
        field(50105; "Approval Status"; Option)
        {
            OptionMembers = " ",Approved,Rejected;
            Caption = 'Approval Status';

        }
        field(50106; "Tenant Name"; Text[100])
        {
            Caption = 'Tenant Name';
        }
        field(50107; "Customer P.O"; Code[100])
        {
            Caption = 'Customer P.O';
        }
        field(50108; "Customer P.O Date"; Date)
        {
            Caption = 'Customer P.O Date';
        }


    }
}