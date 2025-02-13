tableextension 50502 SalesInvoiceHeaderExt extends "Sales Header"
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
            trigger OnValidate()
            var
                emailrecord: Codeunit SendInvoiceToTenant;
                Rejectionmail: Codeunit RejectSalesInvoice;
                ShowDialogBox: Codeunit ShowDialogboxRejctionInvoice;
            begin
                if "Approval Status" = "Approval Status"::Approved then begin
                    emailrecord.SendInvoice(Rec); // Pass the current record if needed
                end else
                    if "Approval Status" = "Approval Status"::Rejected then begin
                        ShowDialogBox.DialogboxForRejection(Rec);
                        Rejectionmail.SendInvoiceToLeaseManager(Rec);
                    end;
            end;
        }
        field(50106; "Tenant Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Name';
        }
        field(50107; "Customer P.O"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer P.O';
        }
        field(50108; "Customer P.O Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer P.O Date';
        }
        field(50109; "Contract Period"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Period';
        }
        field(50110; "Reason for Rejection"; Text[1000])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reason for Rejection';
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



