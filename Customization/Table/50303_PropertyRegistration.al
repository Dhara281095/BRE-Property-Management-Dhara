table 50303 "Property Registration"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Property ID";

    fields
    {
        // Property ID field (Primary Key)
        field(50100; "Property ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property ID';
            // NotBlank = true;
            // AutoIncrement = true; // Automatically increment the ID
            // Editable = false; // Make it read-only for the user
        }

        field(50127; "Company ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Company ID';
            TableRelation = "testData"."Company ID";
        }

        // Property Description field
        field(50101; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

        // Property Name
        field(50102; "Property Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Name';
        }

        // Blocked field (Boolean toggle)
        field(50103; "Blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Blocked';
        }

        // Type field (Option type)
        field(50104; "Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
            OptionMembers = Inventory,"Non Inventory";
        }

        // Base Unit of Measure
        field(50105; "Base Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure"."Code";
        }

        // Market Rate per Sq. Ft.
        field(50106; "Market Rate per Sq. Ft."; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Market Rate per Sq.(Dirham)';

        }
        // Property Location
        field(50107; "Emirate"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Emirate';
            TableRelation = Emirate."Emirate Name";
            trigger OnValidate()
            begin
                "Community" := '';
            end;
        }

        field(50108; "Community"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Community';
            TableRelation = Community."Community Name"
                 where("Emirate Name" = field(Emirate));
        }

        // Number of Units
        field(50109; "Number of Units"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Number Of Units';
        }

        // Property Classification (related to Property Classification Table)
        field(50110; "Property Classification"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Classification';
            TableRelation = "Primary Classification"."Classification Name";
            // NotBlank = true;

            trigger OnValidate()
            begin
                // Clear the Property Type field when Property Classification is changed
                "Property Type" := '';
            end;
        }

        // Property Type (related to Property Type table)
        field(50111; "Property Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Type';
            // Filter the Property Type values based on the selected Primary Classification
            TableRelation = "Property Type"."Property Type"
                 where("Classification Name" = field("Property Classification"));

        }

        // Last Date Modified
        field(50112; "Registration Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Registration Date';
        }

        // GTIN (optional)
        field(50113; "GTIN"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'GTIN';
        }

        field(50114; "Owner ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner ID';
            TableRelation = "Owner Profile"."Owner ID";


            // Optional: Set as Primary Key

        }

        field(50115; "Ownership Documents"; Text[250])
        {
            Caption = 'Ownership Documents';
            DataClassification = ToBeClassified;
        }
        field(50116; "Compliance Certificates"; Text[250])
        {
            Caption = 'Compliance Certificates';
            DataClassification = ToBeClassified;
        }
        field(50117; "Legal Documents"; Text[250])
        {
            Caption = 'Legal Documents';
            DataClassification = ToBeClassified;
        }
        field(50118; "Property Size"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Size';
            // TableRelation = "Item"."Market Rate per Sq. Ft.";
        }

        field(50119; "Address"; Text[250])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;

        }
        field(50120; "Built-up Area"; Decimal)
        {
            Caption = 'Built-up Area (sq. ft)';
            DataClassification = ToBeClassified;

        }
        field(50121; "Makani Number"; Text[50])
        {
            Caption = 'Makani Number';
            DataClassification = ToBeClassified;

        }
        field(50122; "Municipality Number"; Text[50])
        {
            Caption = 'Municipality Number';
            DataClassification = ToBeClassified;

        }
        field(50123; "DEWA Number"; Text[50])
        {
            Caption = 'DEWA Number';
            DataClassification = ToBeClassified;
        }
        field(50124; "Number of Floors"; Integer)
        {
            Caption = 'Number of Floors';
            DataClassification = ToBeClassified;

        }
        field(50125; "Number of Lifts"; Integer)
        {
            Caption = 'Number of Lifts';
            DataClassification = ToBeClassified;

        }

        field(50126; "Business Unit Code"; Code[20])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit".Code;
        }

        field(50137; "Vendor ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor ID';
            TableRelation = "Vendor Profile"."Vendor ID";

            trigger OnValidate()
            var
                VendorDetails: Record "Vendor Profile";
            begin
                VendorDetails.SetRange("Vendor ID", Rec."Vendor ID");
                if VendorDetails.FindSet() then begin
                    "Vendor ID" := VendorDetails."Vendor ID";
                    "Vendor Name" := VendorDetails."Vendor Name"; // Convert Integer to Text
                    "Vendor Contact No." := VendorDetails."Vendor Contact No.";
                    "Start Date" := "VendorDetails"."Start Date";
                    "End Date" := "VendorDetails"."End Date";
                    "Contract Status" := VendorDetails."Contract Status";

                    ManagementFeeMasterDetailsFetch();
                end else begin // Clear the fields if no record is found
                    "Vendor ID" := '';
                    "Vendor Name" := '';
                    "Vendor Contact No." := '';
                    "Start Date" := 0D;
                    "End Date" := 0D;
                    "Contract Status" := "Contract Status"::" ";
                end;

            end;
        }

        field(50128; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name';
        }
        field(50129; "Vendor Contact No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Contact No.';
        }
        field(50130; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date';
        }
        field(50131; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }
        field(50136; "Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Status';
            OptionMembers = " ","Active","Terminate";
        }

    }



    keys
    {
        key(PK; "Property ID", "Property Classification", "Property Type", "Property Name", "Property Size")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Property ID", "Property Name", "Property Classification", "Property Type")
        {

        }
    }

    //-------------Record Insert--------------//

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        CompanyRec: Record "testData"; // Assuming "testData" stores company data

    begin
        if "Property ID" = '' then begin
            "Property ID" := NoSeriesMgt.GetNextNo('PROPERTYID', Today(), true);
        end;

        // Auto Populate Company ID (Example: Fetch from Default Company)
        if CompanyRec.FindFirst() then
            "Company ID" := CompanyRec."Company ID";

    end;

    //-------------Record Insert--------------//


    procedure ManagementFeeMasterDetailsFetch()
    var
        managementfee: Record "Management Fee MasterData";
    begin
        // Check if record already exists for same Vendor ID and Property ID to avoid duplicates (optional but good)
        managementfee.SetRange("Vendor ID", Rec."Vendor ID");
        managementfee.SetRange("Property ID", Rec."Property ID");

        if not managementfee.IsEmpty() then
            exit; // Record already exists, avoid duplicate insert

        // Now insert new record
        managementfee.Init();
        managementfee."Property ID" := Rec."Property ID";
        managementfee."Company ID" := Rec."Company ID";
        managementfee."Vendor ID" := Rec."Vendor ID";
        managementfee."Vendor Name" := Rec."Vendor Name";
        managementfee."Property Name" := Rec."Property Name";
        managementfee."Start Date" := Rec."Start Date";
        managementfee."End Date" := Rec."End Date";
        managementfee."Property Type" := Rec."Property Classification";
        // managementfee."Percentage/Amount" := Rec."Percentage/Amount"; // Uncomment if needed
        managementfee."Contract Status" := Rec."Contract Status";
        managementfee.Insert();
        Clear(managementfee);
    end;



    trigger OnDelete()
    var
    begin
        deleteWorkflowFrequencyPR();
    end;

    procedure deleteWorkflowFrequencyPR()
    var
        WorkflowFrequencyPR: Record "Workflow Frequency PR";

    begin
        WorkflowFrequencyPR.SetRange("Company Id", Rec."Company ID");
        WorkflowFrequencyPR.SetRange("Property ID", Rec."Property ID");
        if WorkflowFrequencyPR.FindSet() then begin
            WorkflowFrequencyPR.DeleteAll();
        end

    end;


}
