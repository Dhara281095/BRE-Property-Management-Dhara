table 50307 "Tenancy Contract"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Contract ID";

    fields
    {

        // Adding the Owner / Lessor Information section fields
        field(50100; "Owner's Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner Name';
            TableRelation = "Owner Profile"."Full Name";
        }

        field(50101; "Lessor's Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Lessor Name';
        }

        field(50102; "Lessor's Emirates ID"; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Lessor Emirates ID';
        }

        field(50103; "License No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'License No.';
            // Note: You can add additional logic or relations if needed
        }

        field(50104; "Licensing Authority"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Licensing Authority';
        }

        field(50105; "Lessor's Email"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Lessor Email';
        }

        field(50106; "Lessor's Phone"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Lessor Phone';
        }
        field(50107; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
            AutoIncrement = true;
        }

        field(50108; "Proposal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Proposal ID';
            TableRelation = "Lease Proposal Details"."Proposal ID" WHERE("Proposal Status" = CONST(Approved));

            trigger OnValidate()
            var
                LeaseProposalRec: Record "Lease Proposal Details";
                TenantContractRec: Record "Tenancy Contract";
            begin
                // Check for existing Proposal ID
                TenantContractRec.Reset();
                TenantContractRec.SetRange("Proposal ID", "Proposal ID");

                if TenantContractRec.FindFirst() and (TenantContractRec."Contract ID" <> "Contract ID") then
                    Error('The selected Proposal ID is already used for another tenant contract.');

                // Fetch details if Proposal ID is valid
                LeaseProposalRec.SetRange("Proposal ID", "Proposal ID");
                if LeaseProposalRec.FindSet() then begin
                    "Tenant ID" := LeaseProposalRec."Tenant ID";
                    "Tenant_License No." := LeaseProposalRec."License No.";
                    "Tenant_Licensing Authority" := LeaseProposalRec."Licensing Authority";
                    "Customer Name" := LeaseProposalRec."Tenant Full Name";
                    "Email Address" := LeaseProposalRec."Tenant Contact Email";
                    "Emirates ID" := LeaseProposalRec."Emirates ID";
                    "Property ID" := LeaseProposalRec."Property ID";
                    "Payment Frequency" := LeaseProposalRec."Payment Frequency";
                    "Payment Method" := LeaseProposalRec."Payment Method";
                    "Base Unit of Measure" := LeaseProposalRec."Base Unit of Measure";
                    "Contact Number" := LeaseProposalRec."Tenant Contact Phone";
                    "Unit ID" := LeaseProposalRec."Unit ID";
                    "Merge Unit ID" := LeaseProposalRec."Merge Unit ID";
                    "Unit Name" := LeaseProposalRec."Unit Name";
                    "Unit Sq. Feet" := LeaseProposalRec."Unit Size";
                    "Annual Rent Amount" := LeaseProposalRec."Rent Amount";
                    "UnitID" := LeaseProposalRec."UnitID";
                    "Property Classification" := LeaseProposalRec."Usage Type";
                    "Property Type" := LeaseProposalRec."Unit Type";
                    "Property Name" := LeaseProposalRec."Property Name";
                    "Contract Start Date" := LeaseProposalRec."Lease Start Date";
                    "Contract End Date" := LeaseProposalRec."Lease End Date";
                    "Contract Tenor" := LeaseProposalRec."Lease Duration";
                    "Annual Rent Amount" := LeaseProposalRec."Annual Rent Amount";
                    "Rent Amount" := LeaseProposalRec."Rent Amount";
                    "Security Deposit Amount" := LeaseProposalRec."Security Deposit Amount";
                    "Unit Number" := LeaseProposalRec."Unit Number";
                    "Makani Number" := LeaseProposalRec."Makani Number";
                    Emirate := LeaseProposalRec.Emirate;
                    Community := LeaseProposalRec.Community;
                    "DEWA Number" := LeaseProposalRec."DEWA Number";
                    "Property Size" := LeaseProposalRec."Property Size";
                    "No of Installments" := LeaseProposalRec."No of Installments";
                    "praposal Type Selected" := LeaseProposalRec."praposal Type Selected";
                    "Unit Address" := LeaseProposalRec."Unit Address";
                    "Usage Type" := LeaseProposalRec."Usage Type";
                    "Unit Type" := LeaseProposalRec."Unit Type";
                    "Single Unit Name" := LeaseProposalRec."Single Unit Name";
                    "Market Rate per Sq. Ft." := LeaseProposalRec."Market Rate per Sq. Ft.";
                    "Facilities/Amenities" := LeaseProposalRec."Facilities/Amenities";
                    "Balance Amount" := LeaseProposalRec."Security Deposit Amount";
                    "Unit Number" := LeaseProposalRec."Unit Number";



                    // Do not set "Handover is Completed" automatically
                    // Allow manual setting of "Handover is Completed"
                end else begin
                    // Clear fields if no record is found
                    "Tenant ID" := '';
                    "Customer Name" := '';
                    "Property ID" := '';
                    "Unit ID" := '';
                    "Merge Unit ID" := '';
                    "Unit Name" := '';
                    "Unit Sq. Feet" := 0;
                    "Annual Rent Amount" := 0;
                    "Property Name" := '';
                    "Emirates ID" := '';
                    "Email Address" := '';
                    "Property Classification" := '';
                    "Property Type" := '';
                    "Property Name" := '';
                    "Unit Number" := '';
                end;

                UpdatePaymentSchedule2();
            end;
        }

        field(50109; "Property Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Name';
        }

        field(50110; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Name';
            TableRelation = Customer.Name;
        }

        field(50111; "Unit Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Name';
        }

        field(50112; "Ejari Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ejari Name';
        }

        field(50113; "Property Classification"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Classification';
            TableRelation = "Primary Classification"."Classification Name";
            NotBlank = true;
        }

        field(50114; "Property Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Type';
            TableRelation = "Secondary Classification"."Property Type"
                where("Classification Name" = field("Property Classification"));
        }

        field(50115; "Annual Rent Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Amount ';
        }

        field(50116; "Contract Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Date';
            NotBlank = true;
            // trigger OnValidate()
            // var
            //     emailrec: Codeunit "Send Contract Email";
            // begin
            //     emailrec.SendEmail(Rec);
            // end;
        }

        field(50117; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Start Date';
        }

        field(50118; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract End Date';

        }

        field(50119; "Contract Tenor"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Period (Months)';
        }
        field(50120; "Base Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Base Unit of Measure';

        }

        field(50121; "Unit Sq. Feet"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Size';
        }

        field(50122; "Grace Period"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Grace Period (Days)';
        }

        field(50123; "Grace Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Grace Start Date';
            trigger OnValidate()
            begin
                CalculateGracePeriod();
            end;
        }

        field(50124; "Grace End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Grace End Date';
            trigger OnValidate()
            begin
                CalculateGracePeriod();
            end;
        }

        field(50125; "Tenant ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
            TableRelation = Customer."No.";
        }

        field(50126; "Property ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property ID';
            TableRelation = "Property Registration"."Property ID";
        }

        field(50127; "Unit ID"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Single Unit ID';
            TableRelation = "Item"."No."
                where("Property ID" = field("Property ID"));
        }

        field(50128; "Emirates ID"; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Emirates ID';
        }

        field(50129; "Contact Number"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contact Number';
        }
        field(50130; "Email Address"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Email Address';
        }

        field(50131; "Payment Frequency"; Option)
        {
            OptionMembers = Monthly,Quarterly,Yearly;
            DataClassification = ToBeClassified;
        }
        field(50132; "Payment Method"; Option)
        {
            OptionMembers = Cash,"Bank Transfers","Credit Card",Cheque;
            DataClassification = ToBeClassified;
        }

        field(50133; "Update Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Update Contract Status';
            OptionMembers = " ","Initiate Activation Process","Initiate Suspension Process","Initiate Termination Process","Initiate Under Suspension-Unit Released";
        }
        // field(50134; "Tenant Contract Status"; Option)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Tenant Contract Status';
        //     OptionMembers = " ",Active,Terminated,Suspended;
        //     trigger OnValidate()
        //     var
        //         ItemRec: Record Item;
        //         MergeUnitRec: Record "Merged Units";
        //     begin
        //         // Check if the Unit ID is filled
        //         if "Unit ID" <> '' then begin
        //             // Retrieve the item record based on the Unit ID
        //             if ItemRec.Get("Unit ID") then begin
        //                 case "Tenant Contract Status" of
        //                     "Tenant Contract Status"::Active:
        //                         ItemRec."Unit Status" := 'Occupied';
        //                     "Tenant Contract Status"::Terminated:
        //                         ItemRec."Unit Status" := 'Free';
        //                     "Tenant Contract Status"::Suspended:
        //                         ItemRec."Unit Status" := 'Occupied';
        //                 end;
        //                 ItemRec.Modify();
        //             end;
        //         end;

        //         // Additional logic for contracts involving a Merge Unit ID
        //         if "Merge Unit ID" <> '' then begin
        //             if MergeUnitRec.Get("Merge Unit ID") then begin
        //                 case "Tenant Contract Status" of
        //                     "Tenant Contract Status"::Terminated:
        //                         // Set Merge Unit Status to 'Free' when the contract is terminated
        //                         MergeUnitRec."Status" := MergeUnitRec."Status"::Free;
        //                     "Tenant Contract Status"::Active:
        //                         MergeUnitRec."Status" := MergeUnitRec."Status"::Occupied;

        //                     "Tenant Contract Status"::Suspended:
        //                         MergeUnitRec."Status" := MergeUnitRec."Status"::Occupied;
        //                 end;
        //                 MergeUnitRec.Modify();
        //             end;
        //         end;
        //     end;
        // }

        field(50134; "Tenant Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Contract Status';
            OptionMembers = " ",Active,Terminated,Suspended,Inactive,"Under Suspension-Unit Released","Active-Contract Renewed","Contract Renewed";

            trigger OnValidate()
            var
                ItemRec: Record Item;
                MergeUnitRec: Record "Merged Units";
                emailrec: Codeunit "Send Contract Email";
            begin
                // Handle logic for Unit ID
                if "Unit ID" <> '' then begin
                    // Retrieve the item record based on the Unit ID
                    if ItemRec.Get("Unit ID") then begin
                        case "Tenant Contract Status" of
                            "Tenant Contract Status"::Active:
                                ItemRec."Unit Status" := 'Occupied';
                            "Tenant Contract Status"::Terminated:
                                ItemRec."Unit Status" := 'Free';
                            "Tenant Contract Status"::Suspended:
                                ItemRec."Unit Status" := 'Occupied';
                            "Tenant Contract Status"::"Under Suspension-Unit Released":
                                ItemRec."Unit Status" := 'Free';

                        end;
                        ItemRec.Modify();
                    end;
                end;

                // Handle logic for Merge Unit ID
                if "Merge Unit ID" <> '' then begin
                    if MergeUnitRec.Get("Merge Unit ID") then begin
                        case "Tenant Contract Status" of
                            "Tenant Contract Status"::Terminated:
                                MergeUnitRec."Status" := MergeUnitRec."Status"::Free;
                            "Tenant Contract Status"::"Under Suspension-Unit Released":
                                MergeUnitRec."Status" := MergeUnitRec."Status"::Free;
                            "Tenant Contract Status"::Active:
                                MergeUnitRec."Status" := MergeUnitRec."Status"::Occupied;
                            "Tenant Contract Status"::Suspended:
                                MergeUnitRec."Status" := MergeUnitRec."Status"::Occupied;

                        end;

                        // Additional logic for Spliting Status in Merge Units table
                        case "Tenant Contract Status" of
                            "Tenant Contract Status"::Active:
                                MergeUnitRec."Spliting Status" := MergeUnitRec."Spliting Status"::Merge;
                            "Tenant Contract Status"::Terminated:
                                MergeUnitRec."Spliting Status" := MergeUnitRec."Spliting Status"::Merge;
                            "Tenant Contract Status"::Suspended:
                                MergeUnitRec."Spliting Status" := MergeUnitRec."Spliting Status"::Merge;
                            "Tenant Contract Status"::"Under Suspension-Unit Released":
                                MergeUnitRec."Spliting Status" := MergeUnitRec."Spliting Status"::Merge;

                        end;

                        MergeUnitRec.Modify();

                        // Update all associated Unit IDs in the Item table
                        if MergeUnitRec."Unit ID" <> '' then begin
                            ItemRec.SetRange("Merged Unit ID", MergeUnitRec."Merged Unit ID");
                            if ItemRec.FindSet() then begin
                                repeat
                                    case "Tenant Contract Status" of
                                        "Tenant Contract Status"::Active:
                                            ItemRec."Unit Status" := 'Occupied';
                                        "Tenant Contract Status"::Terminated:
                                            ItemRec."Unit Status" := 'Free';
                                        "Tenant Contract Status"::Suspended:
                                            ItemRec."Unit Status" := 'Occupied';
                                        "Tenant Contract Status"::"Under Suspension-Unit Released":
                                            ItemRec."Unit Status" := 'Free';
                                    end;
                                    ItemRec.Modify();
                                until ItemRec.Next() = 0;
                            end;
                        end;
                    end;
                end;

                if Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::Active then begin
                    emailrec.SendEmail(Rec);
                end;

            end;
        }

        field(50135; "UnitID"; code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Uniq Unit ID';

        }

        field(50136; "Created By"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Created By';
        }



        field(50137; "Handover is Completed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Handover is Completed';
        }

        field(50152; "Handover of PDC"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Handover of PDC';
        }

        field(50153; "Signed TC Document"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Signed TC Document';
        }

        field(50154; "Handover Unit"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Handover Unit';
        }

        field(50138; "Merge Unit ID"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Merge Unit ID';
            // TableRelation = "Merged Units"."Merged Unit ID"
            //      where("Property ID" = field("Property ID"));
        }

        field(50139; "Rent Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Annual Rent Amount ';
        }


        field(50140; "Tenant_License No."; Code[20])
        {
            Caption = 'Tenant Trade License No.';
            DataClassification = ToBeClassified;
        }

        field(50141; "Tenant_Licensing Authority"; Text[100])
        {
            Caption = 'Tenant_Licensing Authority';
            DataClassification = ToBeClassified;
        }

        field(50142; "Security Deposit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50143; "Unit Number"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50144; "Makani Number"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(50145; "Emirate"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(50146; "Community"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50147; "DEWA Number"; Text[50])
        {
            Caption = 'DEWA Number';
            DataClassification = ToBeClassified;
        }
        field(50148; "Property Size"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Size';
        }

        field(50149; "ID"; Integer)
        {
            Caption = 'Suspended Reason ID';
            DataClassification = ToBeClassified;

        }
        field(50150; "Suspended Reason list"; Text[250])
        {
            Caption = 'Suspended Reason list';
            DataClassification = ToBeClassified;

        }
        field(50151; "No of Installments"; Integer)
        {
            Caption = 'No of Installments';
            Editable = false;
        }

        field(50155; "Upload Document"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Upload Document';
        }
        field(50156; "view Document"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'view Document';
        }

        field(50157; "document URL"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Logo URL';
        }

        field(50158; "Renewal Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Renewal Contract Status';
            OptionMembers = "N/A","Notify Tenant For Renewal";
        }

        field(50159; "Contract Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Type';
            OptionMembers = " ","New Contract","Renewal Contract";
        }


        field(50160; "Renewal Proposal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Renewal Proposal ID';
            TableRelation = "Contract Renewal".Id WHERE("Final Status" = CONST(Approved));


            trigger OnValidate()
            var
                LeaseProposalRec: Record "Contract Renewal";
                TenantContractRec: Record "Tenancy Contract";
            begin
                // Check for existing Proposal ID
                TenantContractRec.Reset();
                TenantContractRec.SetRange("Proposal ID", "Proposal ID");

                // if TenantContractRec.FindFirst() and (TenantContractRec."Contract ID" <> "Contract ID") then
                //     Error('The selected Proposal ID is already used for another tenant contract.');

                // Fetch details if Proposal ID is valid
                LeaseProposalRec.SetRange(ID, "Renewal Proposal ID");
                if LeaseProposalRec.FindSet() then begin
                    "Tenant ID" := LeaseProposalRec."Tenant ID";
                    "Tenant_License No." := LeaseProposalRec."License No.";
                    "Tenant_Licensing Authority" := LeaseProposalRec."Licensing Authority";
                    "Customer Name" := LeaseProposalRec."Tenant Full Name";
                    "Email Address" := LeaseProposalRec."Email Address";
                    "Emirates ID" := LeaseProposalRec."Emirates ID";
                    "Property ID" := LeaseProposalRec."Property ID";
                    "Payment Frequency" := LeaseProposalRec."Payment Frequency";
                    "Payment Method" := LeaseProposalRec."Payment Method";
                    "Base Unit of Measure" := LeaseProposalRec."Base Unit of Measure";
                    "Contact Number" := LeaseProposalRec."Contact Number";
                    "Unit ID" := LeaseProposalRec."Unit ID";
                    "Merge Unit ID" := LeaseProposalRec."Merge Unit ID";
                    "Unit Name" := LeaseProposalRec."Unit Name";
                    "Unit Sq. Feet" := LeaseProposalRec."Unit Sq. Feet";
                    "Annual Rent Amount" := LeaseProposalRec."Rent Amount";
                    "UnitID" := LeaseProposalRec."UnitID";
                    "Property Classification" := LeaseProposalRec."Property Classification";
                    "Property Type" := LeaseProposalRec."Property Type";
                    "Property Name" := LeaseProposalRec."Property Name";
                    "Contract Start Date" := LeaseProposalRec."Contract Start Date";
                    "Contract End Date" := LeaseProposalRec."Contract End Date";
                    "Contract Tenor" := LeaseProposalRec."Contract Tenor";
                    "Annual Rent Amount" := LeaseProposalRec."Annual Rent Amount";
                    "Rent Amount" := LeaseProposalRec."Rent Amount";
                    "Security Deposit Amount" := LeaseProposalRec."Security Deposit Amount";
                    "Unit Number" := LeaseProposalRec."Unit Number";
                    "Makani Number" := LeaseProposalRec."Makani Number";
                    Emirate := LeaseProposalRec.Emirate;
                    Community := LeaseProposalRec.Community;
                    "DEWA Number" := LeaseProposalRec."DEWA Number";
                    "Property Size" := LeaseProposalRec."Property Size";
                    "No of Installments" := LeaseProposalRec."No of Installments";
                    "Balance Amount" := LeaseProposalRec."Security Deposit Amount";



                end else begin
                    // Clear fields if no record is found
                    "Tenant ID" := '';
                    "Customer Name" := '';
                    "Property ID" := '';
                    "Unit ID" := '';
                    "Merge Unit ID" := '';
                    "Unit Name" := '';
                    "Unit Sq. Feet" := 0;
                    "Annual Rent Amount" := 0;
                    "Property Name" := '';
                    "Emirates ID" := '';
                    "Email Address" := '';
                    "Property Classification" := '';
                    "Property Type" := '';
                    "Property Name" := '';
                    "Unit Number" := '';
                end;


                Updateotherpayment();
            end;
        }

        field(50161; "Yes/No"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Yes/No';
        }

        field(50162; "Praposal Type Selected"; Option)
        {
            OptionMembers = " ","Single Unit","Merge Unit";
            DataClassification = ToBeClassified;

        }
        field(50163; "Unit Address"; Text[100])
        {
            DataClassification = ToBeClassified;

        }




        field(50164; "Usage Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Usage Type';

            NotBlank = true;
        }


        field(50165; "Unit Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Type';
            // Filter the Property Type values based on the selected Primary Classification

        }

        field(50166; "Single Unit Name"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'Single Unit Names';
        }

        field(50167; "Market Rate per Sq. Ft."; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Market Rate per Sq. Ft. ';
        }

        field(50168; "Facilities/Amenities"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50169; "Balance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "Proposal ID", "Contract ID")
        {
            Clustered = true;
        }

        key(PK1; SystemId)
        {
            Clustered = false;
        }
    }




    procedure UpdatePaymentSchedule2()
    var
        RevenueSubpage: Record "Revenue Item Subpage";
        PaymentSchedule2: Record "Tenancy Contract Subpage";

    begin

        PaymentSchedule2.SetRange("ContractID", Rec."Contract ID");
        if PaymentSchedule2.FindSet() then begin
            PaymentSchedule2.DeleteAll();
        end;
        RevenueSubpage.SetRange("ProposalID", Rec."Proposal ID");
        //RevenueSubpage.SetRange("Payment Type", 1);
        if RevenueSubpage.FindSet() then
            repeat

                // PaymentSchedule2.SetRange("PS ID", Rec."PS Id");

                PaymentSchedule2.Init();
                // PaymentSchedule2."PS ID" := Rec."PS Id";
                PaymentSchedule2."ContractID" := Rec."Contract ID";
                PaymentSchedule2."TenantID" := rec."Tenant Id";
                PaymentSchedule2."Secondary Item Type" := RevenueSubpage."Secondary Item Type";
                PaymentSchedule2.Amount := RevenueSubpage.Amount;
                PaymentSchedule2."VAT Amount" := RevenueSubpage."VAT Amount";
                PaymentSchedule2."VAT %" := RevenueSubpage."VAT %";
                PaymentSchedule2."Amount Including VAT" := RevenueSubpage."Amount Including VAT";
                PaymentSchedule2."Start Date" := RevenueSubpage."Start Date";
                PaymentSchedule2."End Date" := RevenueSubpage."End Date";
                PaymentSchedule2."Payment Type" := RevenueSubpage."Payment Type";
                PaymentSchedule2.Insert();
                Clear(PaymentSchedule2);
            until RevenueSubpage.Next() = 0;


    end;

    procedure Updateotherpayment()
    var
        RevenueSubpage: Record "Contract Renewal Subpage";
        PaymentSchedule2: Record "Tenancy Contract Subpage";

    begin

        PaymentSchedule2.SetRange("ContractID", Rec."Contract ID");
        if PaymentSchedule2.FindSet() then begin
            PaymentSchedule2.DeleteAll();
        end;
        //RevenueSubpage.SetRange("Id", Rec."Id");
        RevenueSubpage.SetRange(ID, "Renewal Proposal ID");
        //RevenueSubpage.SetRange("Payment Type", 1);
        if RevenueSubpage.FindSet() then
            repeat

                // PaymentSchedule2.SetRange("PS ID", Rec."PS Id");

                PaymentSchedule2.Init();
                // PaymentSchedule2."PS ID" := Rec."PS Id";
                PaymentSchedule2."ContractID" := Rec."Contract ID";
                PaymentSchedule2."TenantID" := rec."Tenant Id";
                PaymentSchedule2."Secondary Item Type" := RevenueSubpage."Secondary Item Type";
                PaymentSchedule2.Amount := RevenueSubpage.Amount;
                PaymentSchedule2."VAT Amount" := RevenueSubpage."VAT Amount";
                PaymentSchedule2."VAT %" := RevenueSubpage."VAT %";
                PaymentSchedule2."Amount Including VAT" := RevenueSubpage."Amount Including VAT";
                PaymentSchedule2."Start Date" := RevenueSubpage."Start Date";
                PaymentSchedule2."End Date" := RevenueSubpage."End Date";
                PaymentSchedule2."Payment Type" := RevenueSubpage."Payment Type";
                PaymentSchedule2.Insert();
                Clear(PaymentSchedule2);
            until RevenueSubpage.Next() = 0;


    end;

    // Procedure to calculate the grace period based on start and end dates
    // Procedure to calculate the contract tenor in months
    // procedure CalculateContractTenor()
    // var
    //     StartDate, EndDate : Date;
    //     YearDiff, MonthDiff, TotalMonths : Integer;
    // begin
    //     StartDate := "Contract Start Date";
    //     EndDate := "Contract End Date";

    //     if (StartDate <> 0D) and (EndDate <> 0D) then begin
    //         YearDiff := Date2DMY(EndDate, 3) - Date2DMY(StartDate, 3);
    //         MonthDiff := Date2DMY(EndDate, 2) - Date2DMY(StartDate, 2);
    //         TotalMonths := (YearDiff * 12) + MonthDiff;

    //         "Contract Tenor" := TotalMonths;
    //     end else
    //         "Contract Tenor" := 0; // Clear if either date is not set
    // end;
    // Procedure to calculate the grace period in days

    // procedure UpdateStatusesOnContractEnd()
    // var
    //     RenewalRec: Record "Contract Renewal"; // Reference to the Contract Renewal table

    // begin
    //     // Check if the record's current status is "Active-Contract Renewed" and the contract end date has passed
    //     if ("Tenant Contract Status" = "Tenant Contract Status"::"Active-Contract Renewed") and
    //        ("Contract End Date" <= Today()) then begin

    //         // Update the Tenant Contract Status to "Contract Renewed"
    //         "Tenant Contract Status" := "Tenant Contract Status"::"Contract Renewed";
    //         Modify();

    //         // Update the corresponding Contract Renewal records' status to Active
    //         RenewalRec.SetRange("Contract ID", "Contract ID"); // Filter by the current record's Contract ID
    //         if RenewalRec.FindSet() then begin
    //             repeat
    //                 RenewalRec."Contract Status" := RenewalRec."Contract Status"::Active;
    //                 RenewalRec.Modify();
    //             until RenewalRec.Next() = 0; // Process all matching records
    //         end;
    //     end;
    // end;


    //-------------Update Tenancy Contract Status on Contract End Date--------------//

    procedure UpdateStatusesOnContractEnd()
    var
        RenewalRec: Record "Contract Renewal"; // Reference to the Contract Renewal table
        TenancyRec: Record "Tenancy Contract"; // Reference to the Tenancy Contract table
    begin
        // Check if the record's current status is "Active-Contract Renewed" and the contract end date has passed
        if ("Tenant Contract Status" = "Tenant Contract Status"::"Active-Contract Renewed") and
           ("Contract End Date" <= Today()) then begin

            // Update the Tenant Contract Status to "Contract Renewed"
            "Tenant Contract Status" := "Tenant Contract Status"::"Contract Renewed";
            Modify();

            // Update the corresponding Contract Renewal records' status to Active
            RenewalRec.SetRange("Contract ID", "Contract ID"); // Filter by the current record's Contract ID
            if RenewalRec.FindSet() then begin
                repeat
                    RenewalRec."Contract Status" := RenewalRec."Contract Status"::Active;
                    RenewalRec.Modify();

                    // If Contract Renewal Status is Active, update Tenancy Contract Status
                    TenancyRec.SetRange("Renewal Proposal ID", RenewalRec."Id"); // Match by Renewal Proposal ID
                    if TenancyRec.FindSet() then begin
                        repeat
                            TenancyRec."Tenant Contract Status" := TenancyRec."Tenant Contract Status"::Active;
                            TenancyRec.Modify();
                        until TenancyRec.Next() = 0; // Process all matching records
                    end;
                until RenewalRec.Next() = 0; // Process all matching Contract Renewal records
            end;
        end;
    end;

    //-------------Update Tenancy Contract Status on Contract End Date--------------//

    //-------------Update Tenancy Contract Status on Contract End Date--------------//
    trigger OnModify()
    begin
        UpdateStatusesOnContractEnd();
    end;
    //-------------Update Tenancy Contract Status on Contract End Date--------------//

    trigger OnInsert()
    begin
        // Set the Created By field to the login user ID
        "Created By" := UserId;
    end;


    //-------------Calculate Grace Period--------------//

    procedure CalculateGracePeriod()
    var
        StartDate, EndDate : Date;
        DaysBetween: Integer;
    begin
        StartDate := "Grace Start Date";
        EndDate := "Grace End Date";

        if (StartDate <> 0D) and (EndDate <> 0D) then begin
            if EndDate >= StartDate then
                DaysBetween := EndDate - StartDate
            else
                DaysBetween := 0;

            "Grace Period" := DaysBetween;
        end else
            "Grace Period" := 0; // Clear if either date is not set
    end;

    //-------------Calculate Grace Period--------------//
}
