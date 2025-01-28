table 50507 "PDC Transaction"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = SystemId, "PDC ID";
    fields
    {
        field(50501; "PDC ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50502; "Tenant Id"; Text[100])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }

        // Add this field to display the Customer Name
        field(50509; "Tenant Name Display"; Text[100])
        {

            // DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Tenant Id"))); // Displays Customer Name
        }

        field(50504; "Cheque Number"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(50505; "Cheque Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50506; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(50507; "Cheque Status"; Enum "PDC Status Type Enum")
        {
            DataClassification = ToBeClassified;

        }
        field(50508; "Contract ID"; Integer)
        {
            TableRelation = "Tenancy Contract";
        }

        field(50510; "Reason"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50511; "Replacement PDC ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PDC Transaction";
        }

        field(50512; "Bank Name"; Text[20])
        {
            DataClassification = ToBeClassified;
        }

        field(50513; "Approval Status"; Enum "Approval Status Enum")
        {
            DataClassification = ToBeClassified;
        }

        field(50514; View; text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50515; Selected; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50516; "payment Series"; Text[20])
        {
            DataClassification = ToBeClassified;
        }

        // // Add FlowField to check permissions
        // field(50512; "Can Edit Status"; Boolean)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = Exist(
        //         "User Permission Set" WHERE(
        //             "User Security ID" = USERSECURITYID AND
        //             "Permission Set ID" = CONST('LEASE_MANAGER')));
        // }


    }
    keys
    {
        key(PK; "PDC ID")
        {
            Clustered = true;
        }
    }

    //--------------Record Insertion-----------------//
    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";

    begin
        if "PDC ID" = '' then begin
            "PDC ID" := NoSeriesMgt.GetNextNo('PDCTRANID', Today(), true);
        end;

    end;



    //--------------Record Insertion-----------------//

}