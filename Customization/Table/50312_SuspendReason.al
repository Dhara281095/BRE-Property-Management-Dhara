table 50312 SuspendReasonTable
{
    DataClassification = ToBeClassified;
    DataCaptionFields = ID;

    fields
    {
        field(50100; ID; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ID';
            AutoIncrement = true;
        }
        // field(50101; TenancyID; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Tenancy Contract ID';
        //     // Lookup = true;
        //     TableRelation = "Tenancy Contract"."Contract ID";
        // }

        field(50101; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
            TableRelation = "Tenancy Contract"."Contract ID";

            trigger OnValidate()
            var
                TenancyContractRec: Record "Tenancy Contract";
            begin
                // Set a filter for the selected Contract ID
                TenancyContractRec.SetRange("Contract ID", Rec."Contract ID");

                // Attempt to find the first matching record
                if TenancyContractRec.FindFirst() then begin
                    // Fetch details if Contract ID is valid
                    Rec.TenantID := TenancyContractRec."Tenant ID";
                    Rec.TenantName := TenancyContractRec."Customer Name";
                    Rec.EmiratesID := TenancyContractRec."Emirates ID";
                    Rec.ContactNumber := TenancyContractRec."Contact Number";
                    Rec.EmailAddress := TenancyContractRec."Email Address";
                    Rec.TradeLicenseNo := TenancyContractRec."Tenant_License No.";
                    Rec.LicensingAuthority := TenancyContractRec."Licensing Authority";
                end else begin
                    // Clear fields if no record is found
                    Rec.TenantID := '';
                    Rec.TenantName := '';
                    Rec.EmiratesID := '';
                    Rec.ContactNumber := '';
                    Rec.EmailAddress := '';
                    Rec.TradeLicenseNo := '';
                    Rec.LicensingAuthority := '';
                end;
            end;


        }

        field(50102; TenantID; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
        }
        field(50103; TenantName; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Name';
        }
        field(50104; EmiratesID; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Emirates ID';
        }
        field(50105; ContactNumber; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contact Number';
        }
        field(50106; EmailAddress; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Email Address';
        }
        field(50107; TradeLicenseNo; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Trade License No.';
        }
        field(50108; LicensingAuthority; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Licensing Authority';
        }
        field(50109; DateEffective; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Suspension Start Date';
        }
        field(50110; Reason; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reason';
            OptionMembers = " ","Legal Reason","Business Reason";
        }
        field(50111; Description; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(50112; ReleaseUnit; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Release Unit';
        }
        field(50113; ReleaseDate; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Release Date';
        }
        field(50114; SuspensionEffectiveDate; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Effective Date of Suspension to Active';
        }
        field(50115; IssueResolutionDescription; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Issue Resolution Description';
        }

        // field(50116; "Tenant Contract Status"; Option)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Tenant Contract Status';
        //     OptionMembers = " ",Suspended,Active;

        //     trigger OnValidate()
        //     var
        //         TenancyContract: Record "Tenancy Contract";
        //     begin
        //         if "Tenant Contract Status" = "Tenant Contract Status"::Suspended then begin
        //             // Validate that Proposal ID and Contract ID are set
        //             if ("Proposal ID" = 0) or ("Contract ID" = 0) then
        //                 Error('Proposal ID and Contract ID must be specified.');

        //             // Attempt to retrieve the record with both keys
        //             if TenancyContract.Get("Proposal ID", "Contract ID") then begin
        //                 // Update the field if the record exists
        //                 TenancyContract."Update Contract Status" := TenancyContract."Update Contract Status"::"Initiate Suspension Process";
        //                 // TenancyContract."ID" := Rec."ID";
        //                 TenancyContract.Modify();
        //             end else
        //                 Error('Tenancy Contract with Proposal ID %1 and Contract ID %2 not found.', "Proposal ID", "Contract ID");
        //         end;
        //     end;
        // }

        field(50116; "Tenant Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Contract Status';
            OptionMembers = " ",Suspended,Active,Terminate;

            trigger OnValidate()
            var
                TenancyContract: Record "Tenancy Contract";
            begin
                if "Tenant Contract Status" = "Tenant Contract Status"::Suspended then begin
                    // Validate that Proposal ID and Contract ID are set
                    if ("Proposal ID" = 0) or ("Contract ID" = 0) then
                        Error('Proposal ID and Contract ID must be specified.');

                    // Attempt to retrieve the record with both keys
                    if TenancyContract.Get("Proposal ID", "Contract ID") then begin
                        // Update the field if the record exists
                        TenancyContract."Update Contract Status" := TenancyContract."Update Contract Status"::"Initiate Suspension Process";
                        TenancyContract.Modify();
                    end else
                        Error('Tenancy Contract with Proposal ID %1 and Contract ID %2 not found.', "Proposal ID", "Contract ID");
                end else if "Tenant Contract Status" = "Tenant Contract Status"::Active then begin
                    // Validate that Proposal ID and Contract ID are set
                    if ("Proposal ID" = 0) or ("Contract ID" = 0) then
                        Error('Proposal ID and Contract ID must be specified.');


                    // Set SuspensionEndDate to today's date when status is set to Active
                    "SuspensionEndDate" := TODAY;

                    // Attempt to retrieve the record with both keys
                    if TenancyContract.Get("Proposal ID", "Contract ID") then begin
                        // Update the field if the record exists


                        TenancyContract."Update Contract Status" := TenancyContract."Update Contract Status"::"Initiate Activation Process";
                        TenancyContract.Modify();
                    end else
                        Error('Tenancy Contract with Proposal ID %1 and Contract ID %2 not found.', "Proposal ID", "Contract ID");
                end else if "Tenant Contract Status" = "Tenant Contract Status"::Terminate then begin
                    // Validate that Proposal ID and Contract ID are set
                    if ("Proposal ID" = 0) or ("Contract ID" = 0) then
                        Error('Proposal ID and Contract ID must be specified.');

                    // Attempt to retrieve the record with both keys
                    if TenancyContract.Get("Proposal ID", "Contract ID") then begin
                        // Update the field if the record exists
                        TenancyContract."Update Contract Status" := TenancyContract."Update Contract Status"::"Initiate Termination Process";
                        TenancyContract.Modify();
                    end else
                        Error('Tenancy Contract with Proposal ID %1 and Contract ID %2 not found.', "Proposal ID", "Contract ID");
                end;
            end;
        }




        field(50117; "Proposal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Proposal ID';
            TableRelation = "Tenancy Contract"."Proposal ID";



            trigger OnValidate()
            var
                TenancyContractRec: Record "Tenancy Contract";
            begin


                // Set a filter for the selected Proposal ID
                TenancyContractRec.SetRange("Proposal ID", Rec."Proposal ID");

                // Attempt to find the first matching record
                if TenancyContractRec.FindFirst() then begin
                    // Populate related fields from the retrieved record
                    Rec."Contract ID" := TenancyContractRec."Contract ID";
                    Rec.TenantID := TenancyContractRec."Tenant ID";
                    Rec.TenantName := TenancyContractRec."Customer Name";
                    Rec.EmiratesID := TenancyContractRec."Emirates ID";
                    Rec.ContactNumber := TenancyContractRec."Contact Number";
                    Rec.EmailAddress := TenancyContractRec."Email Address";
                    Rec.TradeLicenseNo := TenancyContractRec."Tenant_License No.";
                    Rec.LicensingAuthority := TenancyContractRec."Licensing Authority";
                end else begin
                    // Clear fields if no record is found
                    Rec."Contract ID" := 0;
                    Rec.TenantID := '';
                    Rec.TenantName := '';
                    Rec.EmiratesID := '';
                    Rec.ContactNumber := '';
                    Rec.EmailAddress := '';
                    Rec.TradeLicenseNo := '';
                    Rec.LicensingAuthority := '';
                end;
            end;
        }

        field(50120; "Renewal Proposal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Renewal ID';
            TableRelation = "Tenancy Contract"."Renewal Proposal ID";

            trigger OnValidate()
            var
                TenancyContractRec: Record "Tenancy Contract";
            begin
                // Set a filter for the selected Proposal ID
                TenancyContractRec.SetRange("Renewal Proposal ID", Rec."Renewal Proposal ID");

                // Attempt to find the first matching record
                if TenancyContractRec.FindFirst() then begin
                    // Populate related fields from the retrieved record
                    Rec."Contract ID" := TenancyContractRec."Contract ID";
                    Rec.TenantID := TenancyContractRec."Tenant ID";
                    Rec.TenantName := TenancyContractRec."Customer Name";
                    Rec.EmiratesID := TenancyContractRec."Emirates ID";
                    Rec.ContactNumber := TenancyContractRec."Contact Number";
                    Rec.EmailAddress := TenancyContractRec."Email Address";
                    Rec.TradeLicenseNo := TenancyContractRec."Tenant_License No.";
                    Rec.LicensingAuthority := TenancyContractRec."Licensing Authority";
                end else begin
                    // Clear fields if no record is found
                    Rec."Contract ID" := 0;
                    Rec.TenantID := '';
                    Rec.TenantName := '';
                    Rec.EmiratesID := '';
                    Rec.ContactNumber := '';
                    Rec.EmailAddress := '';
                    Rec.TradeLicenseNo := '';
                    Rec.LicensingAuthority := '';
                end;
            end;
        }

        field(50118; ReleaseUnits; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Release Units';
            OptionMembers = " ","Yes";


            trigger OnValidate()
            var
                TenancyContract: Record "Tenancy Contract";
            begin
                if ReleaseUnits = ReleaseUnits::"Yes" then begin
                    // Validate that Proposal ID and Contract ID are set
                    if ("Proposal ID" = 0) or ("Contract ID" = 0) then
                        Error('Proposal ID and Contract ID must be specified.');

                    // Attempt to retrieve the record with both keys
                    if TenancyContract.Get("Proposal ID", "Contract ID") then begin
                        // Update the field if the record exists
                        TenancyContract."Update Contract Status" := TenancyContract."Update Contract Status"::"Initiate Under Suspension-Unit Released";
                        TenancyContract.Modify();
                    end else
                        Error('Tenancy Contract with Proposal ID %1 and Contract ID %2 not found.', "Proposal ID", "Contract ID");
                end;
            end;
        }

        field(50119; SuspensionEndDate; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Suspension End Date';
        }

        field(50121; "Contract Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Type';
            OptionMembers = " ","New Contract","Renewal Contract";
        }



    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; TenantID, TenantName, "Contract ID", EmailAddress)
        {

        }
    }
}
