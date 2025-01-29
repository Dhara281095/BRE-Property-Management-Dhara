tableextension 50502 SalesInvoiceHeaderExt extends "Sales Header"
{
    fields
    {
        field(50101; "Contract ID"; Integer)
        {
            Caption = 'Contract ID';
            // trigger OnValidate()
            // var
            //     tenancyContract: Record "Tenancy Contract";
            // begin
            //     tenancyContract.SetRange("Contract ID", Rec."Contract ID");
            //     if tenancyContract.FindFirst() then begin
            //         "Property Name" := tenancyContract."Property Name";
            //         "Unit Name" := tenancyContract."Unit Name";
            //         "Contract Tenure" := tenancyContract."Contract Tenor";
            //     end else begin
            //         "Property Name" := '';
            //         "Unit Name" := '';
            //         "Contract Tenure" := '';
            //     end;

            // end;

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
            trigger OnValidate()
            var
                emailrecord: Codeunit SendInvoiceToTenant;
            begin
                if "Approval Status" = "Approval Status"::Approved then begin
                    emailrecord.SendInvoice(Rec); // Pass the current record if needed
                end;
            end;
        }

    }



}