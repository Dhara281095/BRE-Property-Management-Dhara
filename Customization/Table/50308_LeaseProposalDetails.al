table 50308 "Lease Proposal Details"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Proposal ID";

    fields
    {
        // Property Information Group
        field(50100; "Proposal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(50101; "Unit Address"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item"."Unit Address";
        }

        field(50102; "Property ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property ID';
            TableRelation = "Property Registration"."Property ID";


            trigger OnValidate()
            var
                PropertyRec: Record "Property Registration";
            begin
                // Attempt to retrieve the property record based on the selected Property ID
                PropertyRec.SetRange("Property ID", Rec."Property ID");
                if PropertyRec.FindFirst() then begin
                    "Property Name" := PropertyRec."Property Name";
                    "Makani Number" := PropertyRec."Makani Number";
                    Emirate := PropertyRec.Emirate;
                    Community := PropertyRec.Community;
                    "DEWA Number" := PropertyRec."DEWA Number";
                    "Property Size" := PropertyRec."Property Size";

                end else begin
                    // Clear the field if no record is found
                    "Property Name" := '';
                end;
            end;
            // trigger OnValidate()
            // var
            //     PropertyRegRec: Record "Property Registration";
            // begin
            //     // Auto-populate the Property Name field based on the selected Property ID
            //     if PropertyRegRec.Get("Property ID") then
            //         "Property Name" := PropertyRegRec."Property Name"
            //     else
            //         "Property Name" := ''; // Clear the Property Name field if no record is found
            // end;
        }

        field(50103; "Property Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Name';
            TableRelation = "Property Registration"."Property Name";
        }


        field(50104; "Unit ID"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Single Unit ID';
            TableRelation = Item."No."
        where("Property ID" = field("Property ID"), "Unit Status" = const('Free'), "MergeSplitOption" = const(Single));// Filter by Property ID, Unit Status, and Merging/Splitting
            trigger OnValidate()
            var
                LeaseProposalRec: Record "Lease Proposal Details";
                ItemRec: Record Item;
            begin

                // Ensure only one field is selected at a time
                if "Merge Unit ID" <> '' then begin
                    Error('You can only select either Single Unit ID or Merge Unit ID, not both.');
                end;


                // Show a confirmation dialog when the user selects a Unit ID
                if "Unit ID" <> '' then begin
                    if not Confirm('Once you select this Single Unit ID, the status of the associated units will change from "Free" to "Selected". Do you wish to proceed?', false) then begin
                        // If the user selects "No", clear the field and exit
                        Validate("Unit ID", ''); // Clear the value
                        exit;
                    end;
                end;

                // Check if this Property ID and Unit ID combination is already used in another proposal
                LeaseProposalRec.Reset();
                LeaseProposalRec.SetRange("Property ID", "Property ID");
                LeaseProposalRec.SetRange("Unit ID", "Unit ID");
                LeaseProposalRec.SetFilter("Proposal ID", '<>%1', "Proposal ID"); // Exclude the current record

                // if LeaseProposalRec.FindFirst() then
                //     Error('This property and unit combination is already used in another proposal.');
                if LeaseProposalRec.FindSet() then begin
                    repeat
                        if LeaseProposalRec."Proposal Status" = LeaseProposalRec."Proposal Status"::Approved then
                            Error('This property and unit combination is already used in another proposal with an approved status.');
                    until LeaseProposalRec.Next() = 0;
                end;




                // Fetch and auto-populate fields based on the selected Unit ID
                if ItemRec.Get("Unit ID") then begin
                    // "Property Name" := ItemRec."Property Name";
                    "Base Unit of Measure" := ItemRec."Base Unit of Measure";
                    "Unit Number" := ItemRec."Unit Number";
                    "Usage Type" := ItemRec."Usage Type";
                    "Unit Type" := ItemRec."Unit Type";
                    "Unit Size" := ItemRec."Unit Size";
                    "Unit Address" := ItemRec."Unit Address";
                    "Unit Name" := ItemRec."Unit Name";
                    "UnitID" := ItemRec."UnitID";
                    "Market Rate per Sq. Ft." := ItemRec."Market Rate per Sq. Ft.";
                    // "Property Name" := ItemRec."Property Name";
                    // "Rent Amount" := ItemRec.Amount;

                    // Determine VAT percentage based on Usage Type
                    // Determine VAT percentage based on Usage Type
                    case ItemRec."Usage Type" of
                        'Commercial':
                            Validate("Rent Amount VAT %", "Rent Amount VAT %"::"5%");
                        else
                            Validate("Rent Amount VAT %", "Rent Amount VAT %"::"0%");
                    end;

                    ItemRec."Unit Status" := 'Selected';

                    ItemRec.Modify();
                end;
            end;
        }

        field(50105; "Unit Number"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."Unit Number";
        }
        field(50106; "Usage Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Usage Type';
            TableRelation = "Item"."Usage Type";
            NotBlank = true;
        }
        // Property Type (related to Property Type table)
        field(50107; "Unit Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Type';
            // Filter the Property Type values based on the selected Primary Classification
            TableRelation = "Item"."Unit Type";
        }
        field(50108; "Unit Size"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Size';
            TableRelation = "Item"."Unit Size";
        }
        field(50109; "Facilities/Amenities"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        // Tenant Details Group
        field(50110; "Tenant Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer.Name;


        }

        field(50111; "Tenant ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer"."No." WHERE("Approve" = const(true));
            ValidateTableRelation = true;
            trigger OnValidate()
            var
                TenantRec: Record "Customer";
            begin
                // Attempt to retrieve the tenant record based on the selected Tenant ID
                TenantRec.SetRange("No.", Rec."Tenant ID");
                if TenantRec.FindSet() then begin
                    "Tenant Full Name" := TenantRec."Name";
                    "Tenant Contact Phone" := TenantRec."Phone No."; // Convert Integer to Text
                    "Tenant Contact Email" := TenantRec."E-Mail";
                    "Emirates ID" := "TenantRec"."Emirates ID";
                    "License No." := "TenantRec"."License No.";
                    "Licensing Authority" := TenantRec."Licensing Authority";
                end else begin // Clear the fields if no record is found
                    "Tenant Full Name" := '';
                    "Tenant Contact Phone" := '';
                    "Tenant Contact Email" := '';
                    "Emirates ID" := '';
                    "License No." := '';
                    "Licensing Authority" := '';
                end;
            end;
        }
        field(50112; "Tenant Contact Phone"; Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."Phone No.";
        }
        field(50113; "Tenant Contact Email"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."E-Mail";

        }
        field(50114; "Trade License"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50115; "Legal Representative"; Text[100])
        {
            DataClassification = ToBeClassified;
            // trigger OnValidate()
            // var
            //     emailrec: Codeunit "Send Proposal Email";
            // begin
            //     emailrec.SendEmail(Rec);
            // end;
        }

        // Lease Terms Group
        field(50116; "Lease Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculateLeaseDuration();

            end;
        }

        field(50117; "Lease End Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                docAttach: Page "Revenue Item Subpage Card";
            begin
                CalculateLeaseDuration();
                docAttach.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
            end;
        }

        field(50118; "Lease Duration"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Lease Duration';
        }
        field(50119; "Rent Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = ' Annual Rent Amount';

        }
        field(50120; "Payment Frequency"; Option)
        {
            OptionMembers = " ",Monthly,Quarterly,"Half-Yearly",Yearly;
            DataClassification = ToBeClassified;
        }

        field(50121; "Payment Method"; Option)
        {
            OptionMembers = " ",Cash,"Bank Transfers","Credit Card",Cheque;
            DataClassification = ToBeClassified;
        }
        // field(50122; "Grace Period"; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Grace Period (Days)';
        // }

        // Deposit and Fees Group
        field(50123; "Security Deposit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50124; "Other Fees"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Other Fees ';
        }
        field(50125; "Refund Conditions"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }

        // Responsibilities Group
        field(50126; "Maintenance Responsibilities"; Option)
        {
            OptionMembers = Tenant,Landlord;
            DataClassification = ToBeClassified;
        }
        field(50127; "Utility Bills Responsibility"; Option)
        {
            OptionMembers = Tenant,Landlord;
            DataClassification = ToBeClassified;
        }
        field(50128; "Insurance Requirements"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        // Conditions for Renewal Group

        field(50129; "Rent Escalation Clause"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }

        // Special Conditions Group
        field(50130; "Early Termination Conditions"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50131; "Restrictions"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50132; "Legal Jurisdiction"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Jurisdiction (e.g., Dubai Courts)';
        }
        field(50133; "Proposal Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Proposal Status';
            OptionMembers = "    ",ProposalSharedtoTenant,Approved,Declined;
            OptionCaption = '   ,Proposal Shared to Tenant,  Approved,  Declined';


            // trigger OnValidate()
            // var
            //     ItemRec: Record Item;
            //     emailrec: Codeunit "Send Proposal Email"; // Custom codeunit for email
            //     MergeUnitRec: Record "Merged Units";
            // begin
            //     // Message('OnValidate Trigger Fired');
            //     if "Unit ID" <> '' then begin
            //         // Message('Unit ID Found: %1', "Unit ID");
            //         if ItemRec.Get("Unit ID") then begin
            //             case "Proposal Status" of
            //                 "Proposal Status"::ProposalSharedtoTenant:
            //                     begin
            //                         // ItemRec."Unit Status" := 'Selected';
            //                         // ItemRec.Modify();
            //                         Message('Sending Email for Approval');
            //                         emailrec.SendEmail(Rec); // Call your email codeunit
            //                     end;
            //                 "Proposal Status"::Approved:
            //                     begin
            //                         ItemRec."Unit Status" := 'Selected';
            //                         ItemRec.Modify();
            //                     end;
            //                 "Proposal Status"::Declined:
            //                     begin
            //                         ItemRec."Unit Status" := 'Free';
            //                         ItemRec.Modify();
            //                     end;
            //             end;
            //         end else
            //             Message('Unit ID not found in Item Record');
            //     end else

            // end;

            trigger OnValidate()
            var
                ItemRec: Record Item;
                emailrec: Codeunit "Send Proposal Email"; // Custom codeunit for email
                MergeUnitRec: Record "Merged Units";
                MergeUnitLeaseGrid: Record "Sub Lease Merged Units";
                ProposalID: Code[20];
            begin
                ProposalID := Format(Rec."Proposal ID");

                // Handle logic for Single Unit ID
                if "Unit ID" <> '' then begin
                    if ItemRec.Get("Unit ID") then begin
                        case "Proposal Status" of
                            "Proposal Status"::ProposalSharedtoTenant:
                                begin
                                    Message('Sending Email for Approval');
                                    emailrec.SendEmail(Rec); // Call your email codeunit
                                end;
                            "Proposal Status"::Approved:
                                begin
                                    ItemRec."Unit Status" := 'Selected';
                                    ItemRec.Modify();
                                end;
                            "Proposal Status"::Declined:
                                begin
                                    ItemRec."Unit Status" := 'Free';
                                    ItemRec.Modify();
                                end;
                        end;
                    end else
                        Message('Unit ID not found in Item Record');
                end;

                // Handle logic for Merge Unit ID
                if "Merge Unit ID" <> '' then begin
                    if MergeUnitRec.Get("Merge Unit ID") then begin
                        case "Proposal Status" of
                            "Proposal Status"::ProposalSharedtoTenant:
                                begin
                                    Message('Sending Email for Merge Unit Approval');
                                    emailrec.SendEmail(Rec); // Call your email codeunit
                                end;
                            "Proposal Status"::Approved:
                                begin
                                    MergeUnitRec."Status" := MergeUnitRec."Status"::Selected;
                                    MergeUnitRec.Modify();

                                    ItemRec.Reset();
                                    ItemRec.SetRange("Merged Unit ID", MergeUnitRec."Merged Unit ID");
                                    if ItemRec.FindSet() then begin
                                        repeat
                                            ItemRec."Unit Status" := 'Selected'; // Set Unit Status to Selected
                                            ItemRec.Modify();
                                        until ItemRec.Next() = 0;
                                    end;
                                end;
                            "Proposal Status"::Declined:
                                begin
                                    // Set Merge Unit Status to Free
                                    MergeUnitRec."Status" := MergeUnitRec."Status"::Free;
                                    MergeUnitRec.Modify();

                                    // Delete associated records from Sub Lease Merged Units table
                                    MergeUnitLeaseGrid."Merge Unit ID" := FORMAT(MergeUnitRec."Merged Unit ID");

                                    if MergeUnitLeaseGrid.FindSet() then
                                        repeat
                                            MergeUnitLeaseGrid.Delete();
                                        until MergeUnitLeaseGrid.Next() = 0;

                                    // Update all associated Unit IDs in the Item table
                                    ItemRec.Reset();
                                    ItemRec.SetRange("Merged Unit ID", MergeUnitRec."Merged Unit ID");
                                    if ItemRec.FindSet() then begin
                                        repeat
                                            ItemRec."Unit Status" := 'Free'; // Set Unit Status to Free
                                            ItemRec.Modify();
                                        until ItemRec.Next() = 0;
                                    end;
                                end;
                        end;
                    end else
                        Message('Merge Unit ID not found in Merge Unit Record');
                end;
            end;



            // trigger OnValidate()
            // var
            //     ItemRec: Record Item;
            // begin
            //     // Check if the Unit ID is filled
            //     if "Unit ID" <> '' then begin
            //         // Retrieve the item record based on the Unit ID
            //         if ItemRec.Get("Unit ID") then begin
            //             case "Proposal Status" of
            //                 "Proposal Status"::Approved:
            //                     ItemRec."Unit Status" := 'Selected';
            //                 "Proposal Status"::Declined:
            //                     ItemRec."Unit Status" := 'Free';
            //             end;
            //             ItemRec.Modify();
            //         end;
            //     end;
            // end;
        }
        // trigger OnValidate()
        // var
        //     emailrec: Codeunit "Send Proposal Email";
        // begin
        //     emailrec.SendEmail(Rec);
        // end;

        field(50134; "Emirates ID"; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Emirates ID';
        }

        field(50135; "Unit Name"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Name';

        }

        field(50136; "UnitID"; code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'UnitID';

        }

        field(50137; "Base Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Base Unit of Measure';
        }

        field(50138; "Merge Unit ID"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Merge Unit ID';
            TableRelation = "Merged Units"."Merged Unit ID"
    where("Property ID" = field("Property ID"), "Status" = const(Free)); // Filter only "Free" status records

            trigger OnValidate()
            var
                MergedUnitRec: Record "Merged Units";
                MergeUnitGrid: Record "Sub Merged Units";
                MergeUnitLeaseGrid: Record "Sub Lease Merged Units";
                ItemRec: Record Item;
                PerDayRent: Record "Per Day Rent for Revenue";
                SelectedUnits: Text[1024];
                mergeUnitId: Integer;

            begin
                // Ensure only one field is selected at a time
                if "Unit ID" <> '' then begin
                    Error('You can only select either Merge Unit ID or Unit ID, not both.');
                end;

                // Show a confirmation dialog when the user selects a Merge Unit ID
                if "Merge Unit ID" <> '' then begin
                    if not Confirm('Once you select this Merge Unit ID, the status of the associated units will change from "Free" to "Selected". Do you wish to proceed?', false) then begin
                        // If the user selects "No", clear the field and exit
                        Validate("Merge Unit ID", ''); // Clear the value
                        exit;
                    end;

                    // Retrieve and populate the fields if the user confirmed
                    if MergedUnitRec.Get("Merge Unit ID") then begin
                        "Property Name" := MergedUnitRec."Property Name";
                        "Unit Name" := MergedUnitRec."Merged Unit Name";
                        "Base Unit of Measure" := MergedUnitRec."Base Unit of Measure";
                        "Usage Type" := MergedUnitRec."Property Type";
                        "Unit Size" := MergedUnitRec."Unit Size";
                        "Rent Amount" := MergedUnitRec."Amount";
                        "Market Rate per Sq. Ft." := MergedUnitRec."Market Rate per Square";
                        "Single Unit Name" := MergedUnitRec."Single Unit Name";
                        "Unit Number" := MergedUnitRec."Unit Number";

                        // Update the Merge Unit Status to 'Selected' in the Merged Units table
                        if MergedUnitRec."Status" = MergedUnitRec."Status"::Free then begin
                            MergedUnitRec."Status" := MergedUnitRec."Status"::Selected; // Set to Selected status
                            MergedUnitRec.Modify();
                        end;

                        // Retrieve and update each individual unit associated with this merged unit
                        SelectedUnits := MergedUnitRec."Unit ID"; // Contains list of unit IDs as a filter
                        ItemRec.SetFilter("No.", SelectedUnits); // Set filter to selected units
                        if ItemRec.FindSet() then begin
                            repeat
                                ItemRec."Unit Status" := 'Selected';
                                ItemRec.Modify();
                            until ItemRec.Next() = 0;
                        end;
                    end else begin
                        // Clear fields if no record is found
                        "Property Name" := '';
                        "Unit Name" := '';
                        "Base Unit of Measure" := '';
                        "Unit Size" := 0;
                        "Rent Amount" := 0;
                    end;
                end else begin
                    // Clear fields if Merge Unit ID is cleared
                    "Property Name" := '';
                    "Unit Name" := '';
                    "Base Unit of Measure" := '';
                    "Unit Size" := 0;
                    "Rent Amount" := 0;
                end;

                // PerDayRent.Init();
                // PerDayRent."Proposal Id" := Rec."Proposal ID"; // Insert Proposal ID in Per Day Rent
                // PerDayRent.Insert();

                Evaluate(mergeUnitId, Rec."Merge Unit ID");

                // Delete old records for the selected Merge Unit ID
                MergeUnitLeaseGrid.SetRange("Merge Unit ID", FORMAT(mergeUnitId));
                if MergeUnitLeaseGrid.FindSet() then
                    repeat
                        MergeUnitLeaseGrid.Delete();
                    until MergeUnitLeaseGrid.Next() = 0;

                // Insert new records for the selected Merge Unit ID
                MergeUnitGrid.SetRange("Merged Unit ID", mergeUnitId);
                if MergeUnitGrid.FindSet() then
                    repeat
                        MergeUnitLeaseGrid.Init();
                        MergeUnitLeaseGrid."Merge Unit ID" := FORMAT(MergeUnitGrid."Merged Unit ID");
                        MergeUnitLeaseGrid."Proposal ID" := Rec."Proposal ID";
                        MergeUnitLeaseGrid."Single Unit Name" := MergeUnitGrid."Single Unit Name";
                        MergeUnitLeaseGrid."Unit ID" := MergeUnitGrid."Unit ID";
                        MergeUnitLeaseGrid."Base Unit of Measure" := MergeUnitGrid."Base Unit of Measure";
                        MergeUnitLeaseGrid."Unit Size" := MergeUnitGrid."Unit Size";
                        MergeUnitLeaseGrid."Unit Name" := MergeUnitGrid."Unit Name";
                        MergeUnitLeaseGrid."Market Rate per Square" := MergeUnitGrid."Market Rate per Square";
                        MergeUnitLeaseGrid.Amount := MergeUnitGrid.Amount;
                        MergeUnitLeaseGrid.Insert();
                    until MergeUnitGrid.Next() = 0;



            end;

        }
        field(50139; "Annual Rent Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Amount ';
            Editable = false;
            // trigger OnValidate()
            // begin
            //     CalcVATAndTotalValue();
            // end;


        }

        field(50140; "Praposal Type Selected"; Option)
        {
            OptionMembers = " ","Single Unit","Merge Unit";
            DataClassification = ToBeClassified;

        }

        field(50141; "Chiller Deposit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Chiller Deposit Amount';
        }


        field(50142; "Electricity Deposit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Electricity Deposit Amount';
        }

        field(50143; "Renewal Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Renewal Amount';

            // trigger OnValidate()
            // begin
            //     CalcVATAndTotalValue();
            // end;

        }

        field(50144; "Rera Fees"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Rera Fees';
        }

        field(50145; "Ejari Processing Fees"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ejari Processing Fees';

            //     trigger OnValidate()
            //     begin
            //         CalcVATAndTotalValue();
            //     end;
        }

        field(50146; "Renewal Amount VAT %"; Option)
        {
            OptionMembers = "0%","5%";
            Caption = 'Renewal Amount VAT %';
            Editable = false;

            // trigger OnValidate()
            // begin
            //     CalcVATAndTotalValue();
            // end;

        }

        field(50147; "Renewal Amount Including VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Renewal Amount Including VAT';

            trigger OnValidate()
            begin
                "Renewal Amount Including VAT" := "Renewal Amount" + "Renewal VAT Amount";
            end;
        }

        field(50148; "Rent Amount VAT %"; Option)
        {
            OptionMembers = "0%","5%";
            Caption = 'Contract Amount VAT %';
            Editable = false;

            // trigger OnValidate()
            // begin
            //     CalcVATAndTotalValue();
            // end;

        }

        field(50149; "Rent Amount Including VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Amount Including VAT';
            Editable = false;
            // trigger OnValidate()
            // begin
            //     "Rent Amount Including VAT" := "Annual Rent Amount" + "Rent VAT Amount";
            // end;

        }

        field(50150; "Ejari Fees VAT %"; Option)
        {
            OptionMembers = "0%","5%";
            Caption = 'Ejari Fees VAT %';
            Editable = false;

            // trigger OnValidate()
            // begin
            //     CalcVATAndTotalValue();
            // end;

        }

        field(50151; "Ejari Fees Including VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ejari Fees Including VAT';
            trigger OnValidate()
            begin
                "Ejari Fees Including VAT" := "Ejari Processing Fees" + "Ejari VAT Amount";
            end;

        }

        field(50152; "Ejari VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ejari VAT Amount';

            trigger OnValidate()
            begin
                "Ejari VAT Amount" := "Ejari Processing Fees" * ("Ejari Fees VAT %" / 100);
            end;
        }

        field(50153; "Rent VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract VAT Amount';
            Editable = false;

            // trigger OnValidate()
            // begin
            //     "Rent VAT Amount" := "Annual Rent Amount" * ("Rent Amount VAT %" / 100);
            // end;
        }

        field(50154; "Renewal VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Renewal VAT Amount';

            trigger OnValidate()
            begin
                "Renewal VAT Amount" := "Renewal Amount" * ("Renewal Amount VAT %" / 100);
            end;
        }


        field(50155; "License No."; Code[20])
        {
            Caption = 'License No.';
            DataClassification = ToBeClassified;
        }

        field(50156; "Licensing Authority"; Text[100])
        {
            Caption = 'Licensing Authority';
            DataClassification = ToBeClassified;
        }

        field(50157; "Makani Number"; Text[50])
        {
            Caption = 'Makani Number';
            DataClassification = ToBeClassified;

        }
        field(50158; "Emirate"; Text[100])
        {
            Caption = 'Emirate';
            DataClassification = ToBeClassified;

        }
        field(50159; "Community"; Text[100])
        {
            Caption = 'Community';
            DataClassification = ToBeClassified;
        }
        field(50160; "DEWA Number"; Text[50])
        {
            Caption = 'DEWA Number';
            DataClassification = ToBeClassified;
        }
        field(50161; "Property Size"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Size';
        }
        field(50162; "No of Installments"; Integer)
        {
            Caption = 'No of Installments';
            Editable = false; // Automatically calculated based on Frequency of Payment
        }


        // field(50163; "Rent Calculation"; Enum "Rent Calculation Enum")
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Select Rent Calculation Type';

        //    trigger OnLookup()
        //     var
        //         OptionSelection: Enum "Rent Calculation Enum";
        //     begin
        //         if "Unit ID" <> '' then begin
        //             // Open the dropdown with only "Single Unit with square feet rate"
        //             OptionSelection := Enum::"Rent Calculation Enum"::"Single Unit with square feet rate";
        //         end else if "Merge Unit ID" <> '' then begin
        //             // Show only options related to merged units
        //             OptionSelection := Enum::"Rent Calculation Enum"::"Merged Unit with same square feet";
        //         end else begin
        //             // Do not provide options if neither Unit ID nor Merge Unit ID is filled
        //             Error('Please fill either Unit ID or Merge Unit ID before selecting a Rent Calculation type.');
        //         end;

        //         // Display the available option(s) to the user
        //         OptionSelection.LookupValue();
        //     end;

        //     // trigger OnValidate()
        //     // begin
        //     //     // Prevent invalid combinations
        //     //     if "Unit ID" <> '' and "Rent Calculation" <> Enum::"Rent Calculation Enum"::"Single Unit with square feet rate" then
        //     //         "Rent Calculation" := Enum::"Rent Calculation Enum"::"Single Unit with square feet rate"
        //     //     else if "Merge Unit ID" <> '' and "Rent Calculation" = Enum::"Rent Calculation Enum"::"Single Unit with square feet rate" then
        //     //         "Rent Calculation" := Enum::"Rent Calculation Enum"::"Merged Unit with same square feet";
        //     // end;

        // }

        field(50163; "Single Rent Calculation"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Single Unit Rent Calculation Type';
            OptionMembers = " ","Single Unit with square feet rate","Single Unit with lumpsum square feet rate";

            trigger OnValidate()

            var
                LeaseProposal: Record "Lease Proposal Details"; // Replace with actual table name
                SingleSameSquare: Record "Single Unit Rent SubPage"; // Target table
                SingleLumSquare: Record "Single Lum_AnnualAmnt SubPage"; // Target table
                PeriodStartDate: Date;
                PeriodEndDate: Date;
                LeaseEndDate: Date;
                TotalDays: Integer;
                DaysToAdd: Integer;
                LeapDays: Integer;
                CurrentYear: Integer;
                YearCounter: Integer;
                LineNoCounter: Integer;


            begin

                if "Single Rent Calculation" = "Single Rent Calculation"::"Single Unit with square feet rate" then begin
                    SingleSameSquare.SetRange("Proposal ID", Rec."Proposal ID");
                    if SingleSameSquare.FindSet() then
                        repeat
                            SingleSameSquare.Delete();
                        until SingleSameSquare.Next() = 0;

                    // Initialize variables
                    PeriodStartDate := Rec."Lease Start Date";
                    LeaseEndDate := Rec."Lease End Date";
                    YearCounter := 1;
                    LineNoCounter := 1;

                    // Loop to divide the period into yearly chunks and create records
                    while PeriodStartDate <= LeaseEndDate do begin
                        SingleSameSquare.Init();
                        SingleSameSquare."Proposal ID" := Rec."Proposal ID";
                        SingleSameSquare."Line No." := LineNoCounter;
                        SingleSameSquare.Year := YearCounter;
                        SingleSameSquare."Start Date" := PeriodStartDate;

                        // Calculate the End Date (365 days after Start Date, adjusted for leap years)
                        DaysToAdd := 365; // Default to 365 days
                        LeapDays := 0;

                        // Check for leap years in the range from Start Date to Start Date + 364 days
                        for CurrentYear := Date2DMY(PeriodStartDate, 3) to Date2DMY(PeriodStartDate + 364, 3) do begin
                            if IsLeapYear(CurrentYear) then begin
                                // Ensure the leap day (Feb 29) falls within the range
                                if (DMY2Date(29, 2, CurrentYear) >= PeriodStartDate) and
                                   (DMY2Date(29, 2, CurrentYear) <= PeriodStartDate + DaysToAdd - 1) then
                                    LeapDays += 1;
                            end;
                        end;

                        // Adjust DaysToAdd to account for any leap days
                        DaysToAdd := DaysToAdd + LeapDays;

                        // Calculate the PeriodEndDate
                        PeriodEndDate := PeriodStartDate + DaysToAdd - 1;

                        // Ensure the End Date does not exceed the Lease End Date
                        if PeriodEndDate > LeaseEndDate then
                            PeriodEndDate := LeaseEndDate;

                        SingleSameSquare."End Date" := PeriodEndDate;

                        // Calculate the number of days for this chunk
                        TotalDays := PeriodEndDate - PeriodStartDate + 1;
                        SingleSameSquare."Number of Days" := TotalDays;

                        // Populate other fields
                        SingleSameSquare."Unit ID" := Rec."Unit Name";
                        SingleSameSquare."Unit Sq Ft" := Rec."Unit Size";

                        // Set default values for Rate per Sq.Ft and Annual Amount (to be manually entered)
                        SingleSameSquare."Rate per Sq.Ft" := 0; // Initialize as 0; users will manually enter this
                        SingleSameSquare."Annual Amount" := 0; // Calculated after manual input

                        // Set Final Annual Amount to match Annual Amount
                        SingleSameSquare."Final Annual Amount" := SingleSameSquare."Annual Amount";

                        // Calculate Per Day Rent
                        SingleSameSquare."Per Day Rent" := 0; // Will be calculated after manual input

                        SingleSameSquare.Insert();

                        // Move to the next period
                        PeriodStartDate := PeriodEndDate + 1;
                        YearCounter += 1;
                        LineNoCounter += 1;
                    end;
                end
                else if "Single Rent Calculation" = "Single Rent Calculation"::"Single Unit with lumpsum square feet rate" then begin

                    if Rec."Proposal ID" = 0 then
                        Error('Proposal ID is missing or not assigned.');

                    LeaseProposal.Reset();
                    LeaseProposal.SetRange("Proposal ID", Rec."Proposal ID");

                    if not LeaseProposal.FindFirst() then
                        Error('No record found for Proposal ID %1.', Rec."Proposal ID");

                    // Delete existing records to avoid duplication
                    SingleLumSquare.SetRange("Proposal ID", LeaseProposal."Proposal ID");
                    if SingleLumSquare.FindSet() then
                        repeat
                            SingleLumSquare.Delete();
                        until SingleLumSquare.Next() = 0;

                    PeriodStartDate := LeaseProposal."Lease Start Date";
                    YearCounter := 1;
                    LineNoCounter := 1;

                    // Loop to divide the period into yearly chunks and create records
                    while PeriodStartDate <= LeaseProposal."Lease End Date" do begin
                        SingleLumSquare.Init();
                        SingleLumSquare."Proposal ID" := LeaseProposal."Proposal ID";
                        SingleLumSquare."SL_Line No." := LineNoCounter;
                        SingleLumSquare.SL_Year := YearCounter;
                        SingleLumSquare."SL_Start Date" := PeriodStartDate;

                        // Calculate the End Date (365 days after Start Date, adjusted for leap years)
                        DaysToAdd := 365; // Default to 365 days
                        LeapDays := 0;

                        // Check for leap years in the range from Start Date to Start Date + 364 days
                        for CurrentYear := Date2DMY(PeriodStartDate, 3) to Date2DMY(PeriodStartDate + 364, 3) do begin
                            if IsLeapYear(CurrentYear) then begin
                                // Ensure the leap day (Feb 29) falls within the range
                                if (DMY2Date(29, 2, CurrentYear) >= PeriodStartDate) and
                                   (DMY2Date(29, 2, CurrentYear) <= PeriodStartDate + DaysToAdd - 1) then
                                    LeapDays += 1;
                            end;
                        end;

                        // Adjust DaysToAdd to account for any leap days
                        DaysToAdd := DaysToAdd + LeapDays;

                        // Calculate the PeriodEndDate
                        PeriodEndDate := PeriodStartDate + DaysToAdd - 1;

                        // Ensure the end date does not exceed the Lease End Date
                        if PeriodEndDate > LeaseProposal."Lease End Date" then
                            PeriodEndDate := LeaseProposal."Lease End Date";

                        SingleLumSquare."SL_End Date" := PeriodEndDate;

                        // Calculate the number of days
                        TotalDays := PeriodEndDate - PeriodStartDate + 1;
                        SingleLumSquare."SL_Number of Days" := TotalDays;

                        // Populate other fields
                        SingleLumSquare."SL_Unit ID" := LeaseProposal."Unit Name";
                        SingleLumSquare."SL_Unit Sq Ft" := LeaseProposal."Unit Size";

                        // For the first year, initialize the Annual Amount and Final Annual Amount
                        if YearCounter = 1 then begin
                            SingleLumSquare."SL_Annual Amount" := 0; // User will enter manually
                            SingleLumSquare."SL_Final Annual Amount" := 0;
                        end;

                        // Calculate Per Day Rent
                        if TotalDays > 0 then
                            SingleLumSquare."SL_Per Day Rent" := SingleLumSquare."SL_Final Annual Amount" / TotalDays
                        else
                            SingleLumSquare."SL_Per Day Rent" := 0;

                        SingleLumSquare.Insert();

                        // Update for the next year
                        PeriodStartDate := PeriodEndDate + 1;
                        YearCounter += 1;
                        LineNoCounter += 1;
                    end;
                end;

            end;

        }
        field(50169; "Merge Rent Calculation"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Merge Unit Rent Calculation Type';
            OptionMembers = " ","Merged Unit with same square feet","Merged Unit with differential square feet rate","Merged Unit with lumpsum annual amount";
            //    OptionCaption = ' ', 'Single Unit with square feet rate', 'Merged Unit with same square feet',
            //              'Merged Unit with differential square feet rate', 'Merged Unit with lumpsum annual amount';

            trigger OnValidate()

            var


                LeaseProposal: Record "Lease Proposal Details"; // Replace with actual table name
                MergeSameSquare: Record "Merge SameSqure SubPage"; // Target table
                MergeDiffSquare: Record "Merge DifferentSqure SubPage"; // Target table
                MergeLumSquare: Record "Merge Lum_AnnualAmount SubPage";
                SubLeaseMergeRec: Record "Sub Lease Merged Units";
                // Target table
                PeriodStartDate: Date;
                PeriodEndDate: Date;
                LeaseEndDate: Date;
                TotalDays: Integer;
                DaysToAdd: Integer;
                LeapDays: Integer;
                CurrentYear: Integer;
                YearCounter: Integer;
                LineNoCounter: Integer;


            begin

                if "Merge Rent Calculation" = "Merge Rent Calculation"::"Merged Unit with same square feet" then begin
                    MergeSameSquare.SetRange("Proposal ID", Rec."Proposal ID");
                    if MergeSameSquare.FindSet() then
                        repeat
                            MergeSameSquare.Delete();
                        until MergeSameSquare.Next() = 0;

                    // Initialize variables
                    PeriodStartDate := Rec."Lease Start Date";
                    LeaseEndDate := Rec."Lease End Date";
                    YearCounter := 1;
                    LineNoCounter := 1;

                    // Loop to divide the period into yearly chunks and create records
                    while PeriodStartDate <= LeaseEndDate do begin
                        MergeSameSquare.Init();
                        MergeSameSquare."Proposal ID" := Rec."Proposal ID";
                        MergeSameSquare."MS_Line No." := LineNoCounter;
                        MergeSameSquare.MS_Year := YearCounter;
                        MergeSameSquare."MS_Start Date" := PeriodStartDate;

                        // Calculate the End Date (365 days after Start Date, adjusted for leap years)
                        DaysToAdd := 365; // Default to 365 days
                        LeapDays := 0;

                        // Check for leap years in the range from Start Date to Start Date + 364 days
                        for CurrentYear := Date2DMY(PeriodStartDate, 3) to Date2DMY(PeriodStartDate + 364, 3) do begin
                            if IsLeapYear(CurrentYear) then begin
                                // Ensure the leap day (Feb 29) falls within the range
                                if (DMY2Date(29, 2, CurrentYear) >= PeriodStartDate) and
                                   (DMY2Date(29, 2, CurrentYear) <= PeriodStartDate + DaysToAdd - 1) then
                                    LeapDays += 1;
                            end;
                        end;

                        // Adjust DaysToAdd to account for any leap days
                        DaysToAdd := DaysToAdd + LeapDays;

                        // Calculate the PeriodEndDate
                        PeriodEndDate := PeriodStartDate + DaysToAdd - 1;

                        // Ensure the End Date does not exceed the Lease End Date
                        if PeriodEndDate > LeaseEndDate then
                            PeriodEndDate := LeaseEndDate;

                        MergeSameSquare."MS_End Date" := PeriodEndDate;

                        // Calculate the number of days for this chunk
                        TotalDays := PeriodEndDate - PeriodStartDate + 1;
                        MergeSameSquare."MS_Number of Days" := TotalDays;

                        // Populate other fields
                        MergeSameSquare."MS_Merged Unit ID" := Rec."Unit Name";
                        MergeSameSquare."MS_Unit Sq Ft" := Rec."Unit Size";

                        // Set default values for Rate per Sq.Ft and Annual Amount (to be manually entered)
                        MergeSameSquare."MS_Rate per Sq.Ft" := 0; // Initialize as 0; users will manually enter this
                        MergeSameSquare."MS_Annual Amount" := 0; // Calculated after manual input

                        // Set Final Annual Amount to match Annual Amount
                        MergeSameSquare."MS_Final Annual Amount" := MergeSameSquare."MS_Annual Amount";

                        // Calculate Per Day Rent
                        MergeSameSquare."MS_Per Day Rent" := 0; // Will be calculated after manual input

                        MergeSameSquare.Insert();

                        // Move to the next period
                        PeriodStartDate := PeriodEndDate + 1;
                        YearCounter += 1;
                        LineNoCounter += 1;
                    end;
                end
                else if "Merge Rent Calculation" = "Merge Rent Calculation"::"Merged Unit with lumpsum annual amount" then begin

                    if Rec."Proposal ID" = 0 then
                        Error('Proposal ID is missing or not assigned.');

                    LeaseProposal.Reset();
                    LeaseProposal.SetRange("Proposal ID", Rec."Proposal ID");

                    if not LeaseProposal.FindFirst() then
                        Error('No record found for Proposal ID %1.', Rec."Proposal ID");

                    // Delete existing records to avoid duplication
                    MergeLumSquare.SetRange("Proposal ID", LeaseProposal."Proposal ID");
                    if MergeLumSquare.FindSet() then
                        repeat
                            MergeLumSquare.Delete();
                        until MergeLumSquare.Next() = 0;

                    PeriodStartDate := LeaseProposal."Lease Start Date";
                    YearCounter := 1;
                    LineNoCounter := 1;

                    // Loop to divide the period into yearly chunks and create records
                    while PeriodStartDate <= LeaseProposal."Lease End Date" do begin
                        MergeLumSquare.Init();
                        MergeLumSquare."Proposal ID" := LeaseProposal."Proposal ID";
                        MergeLumSquare."ML_Line No." := LineNoCounter;
                        MergeLumSquare.ML_Year := YearCounter;
                        MergeLumSquare."ML_Start Date" := PeriodStartDate;

                        // Calculate the End Date (365 days after Start Date, adjusted for leap years)
                        DaysToAdd := 365; // Default to 365 days
                        LeapDays := 0;

                        // Check for leap years in the range from Start Date to Start Date + 364 days
                        for CurrentYear := Date2DMY(PeriodStartDate, 3) to Date2DMY(PeriodStartDate + 364, 3) do begin
                            if IsLeapYear(CurrentYear) then begin
                                // Ensure the leap day (Feb 29) falls within the range
                                if (DMY2Date(29, 2, CurrentYear) >= PeriodStartDate) and
                                   (DMY2Date(29, 2, CurrentYear) <= PeriodStartDate + DaysToAdd - 1) then
                                    LeapDays += 1;
                            end;
                        end;

                        // Adjust DaysToAdd to account for any leap days
                        DaysToAdd := DaysToAdd + LeapDays;

                        // Calculate the PeriodEndDate
                        PeriodEndDate := PeriodStartDate + DaysToAdd - 1;

                        // Ensure the end date does not exceed the Lease End Date
                        if PeriodEndDate > LeaseProposal."Lease End Date" then
                            PeriodEndDate := LeaseProposal."Lease End Date";

                        MergeLumSquare."ML_End Date" := PeriodEndDate;

                        // Calculate the number of days
                        TotalDays := PeriodEndDate - PeriodStartDate + 1;
                        MergeLumSquare."ML_Number of Days" := TotalDays;

                        // Populate other fields
                        MergeLumSquare."ML_Merged Unit ID" := LeaseProposal."Unit Name";
                        MergeLumSquare."ML_Unit Sq Ft" := LeaseProposal."Unit Size";

                        // For the first year, initialize the Annual Amount and Final Annual Amount
                        if YearCounter = 1 then begin
                            MergeLumSquare."ML_Annual Amount" := 0; // User will enter manually
                            MergeLumSquare."ML_Final Annual Amount" := 0;
                        end;

                        // Calculate Per Day Rent
                        if TotalDays > 0 then
                            MergeLumSquare."ML_Per Day Rent" := MergeLumSquare."ML_Final Annual Amount" / TotalDays
                        else
                            MergeLumSquare."ML_Per Day Rent" := 0;

                        MergeLumSquare.Insert();

                        // Update for the next year
                        PeriodStartDate := PeriodEndDate + 1;
                        YearCounter += 1;
                        LineNoCounter += 1;
                    end;
                end

                else if "Merge Rent Calculation" = "Merge Rent Calculation"::"Merged Unit with differential square feet rate" then begin

                    MergeDiffSquare.SetRange("Proposal ID", Rec."Proposal ID");
                    if MergeDiffSquare.FindSet() then
                        repeat
                            MergeDiffSquare.Delete();
                        until MergeDiffSquare.Next() = 0;

                    // Initialize variables
                    PeriodStartDate := Rec."Lease Start Date";
                    LeaseEndDate := Rec."Lease End Date";
                    YearCounter := 1;
                    LineNoCounter := 1;

                    // Fetch data from the Sub Lease Merged Units table based on Proposal ID
                    SubLeaseMergeRec.SetRange("Proposal ID", Rec."Proposal ID");

                    // Loop through the Sub Lease Merged Units and fetch relevant data
                    if SubLeaseMergeRec.FindSet() then begin
                        repeat
                            // Loop through each year and create records
                            YearCounter := 1;
                            PeriodStartDate := Rec."Lease Start Date";
                            LeaseEndDate := Rec."Lease End Date";

                            // Loop to divide the period into yearly chunks and create records for each unit
                            while PeriodStartDate <= LeaseEndDate do begin
                                MergeDiffSquare.Init();
                                MergeDiffSquare."Proposal ID" := Rec."Proposal ID";
                                MergeDiffSquare."MD_Line No." := LineNoCounter;
                                MergeDiffSquare.MD_Year := YearCounter;
                                MergeDiffSquare."MD_Start Date" := PeriodStartDate;

                                // Calculate the End Date (365 days after Start Date, adjusted for leap years)
                                DaysToAdd := 365; // Default to 365 days
                                LeapDays := 0;

                                // Check for leap years in the range from Start Date to Start Date + 364 days
                                for CurrentYear := Date2DMY(PeriodStartDate, 3) to Date2DMY(PeriodStartDate + 364, 3) do begin
                                    if IsLeapYear(CurrentYear) then begin
                                        // Ensure the leap day (Feb 29) falls within the range
                                        if (DMY2Date(29, 2, CurrentYear) >= PeriodStartDate) and
                                           (DMY2Date(29, 2, CurrentYear) <= PeriodStartDate + DaysToAdd - 1) then
                                            LeapDays += 1;
                                    end;
                                end;

                                // Adjust DaysToAdd to account for any leap days
                                DaysToAdd := DaysToAdd + LeapDays;

                                // Calculate the PeriodEndDate
                                PeriodEndDate := PeriodStartDate + DaysToAdd - 1;

                                // Ensure the End Date does not exceed the Lease End Date
                                if PeriodEndDate > LeaseEndDate then
                                    PeriodEndDate := LeaseEndDate;

                                MergeDiffSquare."MD_End Date" := PeriodEndDate;

                                // Calculate the number of days for this chunk
                                TotalDays := PeriodEndDate - PeriodStartDate + 1;
                                MergeDiffSquare."MD_Number of Days" := TotalDays;

                                // Populate other fields based on the Sub Lease Merged Units data
                                MergeDiffSquare."MD_Merged Unit ID" := Rec."Unit Name";
                                MergeDiffSquare."MD_Unit Sq Ft" := SubLeaseMergeRec."Unit Size"; // From Sub Lease Merged Units
                                MergeDiffSquare."MD_Unit ID" := SubLeaseMergeRec."Single Unit Name"; // From Sub Lease Merged Units

                                // Set default values for Rate per Sq.Ft and Annual Amount (to be manually entered)
                                MergeDiffSquare."MD_Rate per Sq.Ft" := 0; // Initialize as 0; users will manually enter this
                                MergeDiffSquare."MD_Annual Amount" := 0; // Calculated after manual input

                                // Set Final Annual Amount to match Annual Amount
                                MergeDiffSquare."MD_Final Annual Amount" := MergeSameSquare."MS_Annual Amount";

                                // Calculate Per Day Rent
                                MergeDiffSquare."MD_Per Day Rent" := 0;
                                // Will be calculated after manual input

                                MergeDiffSquare.Insert();

                                // Move to the next period
                                PeriodStartDate := PeriodEndDate + 1;
                                YearCounter += 1;
                                LineNoCounter += 1;
                            end;

                        until SubLeaseMergeRec.Next() = 0;
                    end
                    else
                        Error('No matching records found in Sub Lease Merged Units for the given Proposal ID.');

                end;

            end;

        }



        field(50164; "Market Rate per Sq. Ft."; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Market Rate per Sq. Ft. ';
        }

        field(50165; "Single Unit Name"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'Single Unit Names';
        }

        field(50166; "TotalFinalAmount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50167; "TotalAnnualAmount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50168; "TotalRoundOff"; Decimal)
        {
            DataClassification = ToBeClassified;

        }

        field(50170; "Update Data"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Update Data';
            InitValue = 'Update Data';

        }

    }

    keys
    {
        key(PK; "Proposal ID", "Merge Unit ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Proposal ID", "Unit Name", "Property Name", "Tenant Full Name", "Tenant ID", "Unit Number")
        {

        }
    }


    //-------------Calculate Lease Duration--------------//
    procedure CalculateLeaseDuration()
    var
        LeaseStartDate: Date;
        LeaseEndDate: Date;
        Years: Integer;
        Months: Integer;
        Days: Integer;
        DurationText: Text[50];
        TempStartDate: Date;
    begin
        LeaseStartDate := "Lease Start Date";
        LeaseEndDate := "Lease End Date";

        if (LeaseStartDate <> 0D) and (LeaseEndDate <> 0D) then begin
            if LeaseEndDate >= LeaseStartDate then begin
                TempStartDate := LeaseStartDate;

                // Calculate the years
                Years := 0;
                while CALCDATE('<+1Y>', TempStartDate) <= LeaseEndDate do begin
                    TempStartDate := CALCDATE('<+1Y>', TempStartDate);
                    Years := Years + 1;
                end;

                // Calculate the months
                Months := 0;
                while CALCDATE('<+1M>', TempStartDate) <= LeaseEndDate do begin
                    TempStartDate := CALCDATE('<+1M>', TempStartDate);
                    Months := Months + 1;
                end;

                // Calculate the remaining days
                Days := LeaseEndDate - TempStartDate + 1;

                // Build the duration text
                DurationText := '';
                if Years > 0 then
                    DurationText := Format(Years) + ' year(s) ';

                if Months > 0 then
                    DurationText := DurationText + Format(Months) + ' month(s) ';

                if Days > 0 then
                    DurationText := DurationText + Format(Days) + ' day(s)';

                "Lease Duration" := DelChr(DurationText, '<>', ' '); // Remove leading and trailing spaces
            end else
                "Lease Duration" := ''; // Clear if the end date is before the start date
        end else
            "Lease Duration" := ''; // Clear if either date is not set
    end;
    //-------------Calculate Lease Duration--------------//

    //-------------When Record is Delete Subgrid record also Delete--------------//

    trigger OnDelete()
    var
    begin
        DeleteSingleUnitSameRate();
        DeleteMergeUnitSameRate();
        DeletePerDayRevenueUnitSameRate();
        DeleteLeaseMergeAllUnitDetails();
        DeleteMergeUnitDiffRate();
        DeleteSingleUnitLumpsumRate();
        DeleteMergeUnitLumpsumRate();

    end;

    procedure DeleteSingleUnitSameRate()
    var
        deleteSingleUnitRecords: Record "Single Unit Rent SubPage";

    begin
        deleteSingleUnitRecords.SetRange("Proposal Id", Rec."Proposal ID");

        if deleteSingleUnitRecords.FindSet() then begin
            deleteSingleUnitRecords.DeleteAll();
        end

    end;

    procedure DeleteMergeUnitSameRate()
    var
        deleteMergeUnitRecords: Record "Merge SameSqure SubPage";

    begin
        deleteMergeUnitRecords.SetRange("Proposal Id", Rec."Proposal ID");

        if deleteMergeUnitRecords.FindSet() then begin
            deleteMergeUnitRecords.DeleteAll();
        end

    end;

    procedure DeletePerDayRevenueUnitSameRate()
    var
        deletePerDayRevenueUnitRecords: Record "Per Day Rent for Revenue";

    begin
        deletePerDayRevenueUnitRecords.SetRange("Proposal Id", Rec."Proposal ID");

        if deletePerDayRevenueUnitRecords.FindSet() then begin
            deletePerDayRevenueUnitRecords.DeleteAll();
        end

    end;

    procedure DeleteLeaseMergeAllUnitDetails()
    var
        deleteAllUnitRecords: Record "Sub Lease Merged Units";

    begin
        deleteAllUnitRecords.SetRange("Proposal Id", Rec."Proposal ID");

        if deleteAllUnitRecords.FindSet() then begin
            deleteAllUnitRecords.DeleteAll();
        end

    end;

    procedure DeleteMergeUnitDiffRate()
    var
        deleteMergeUnitDiffRecords: Record "Merge DifferentSqure SubPage";

    begin
        deleteMergeUnitDiffRecords.SetRange("Proposal Id", Rec."Proposal ID");

        if deleteMergeUnitDiffRecords.FindSet() then begin
            deleteMergeUnitDiffRecords.DeleteAll();
        end

    end;

    procedure DeleteMergeUnitLumpsumRate()
    var
        deleteMergeUnitLumpsumRecords: Record "Merge Lum_AnnualAmount SubPage";

    begin
        deleteMergeUnitLumpsumRecords.SetRange("Proposal Id", Rec."Proposal ID");

        if deleteMergeUnitLumpsumRecords.FindSet() then begin
            deleteMergeUnitLumpsumRecords.DeleteAll();
        end

    end;

    procedure DeleteSingleUnitLumpsumRate()
    var
        deleteSingleUnitLumpsumRecords: Record "Single Lum_AnnualAmnt SubPage";

    begin
        deleteSingleUnitLumpsumRecords.SetRange("Proposal Id", Rec."Proposal ID");

        if deleteSingleUnitLumpsumRecords.FindSet() then begin
            deleteSingleUnitLumpsumRecords.DeleteAll();
        end

    end;

    //-------------When Record is Delete Subgrid record also Delete--------------//





    //-------------Record Insert--------------//
    trigger OnInsert()
    var
        docAttach: Page "Revenue Item Subpage Card";
    begin
        docAttach.SetProposalID(Rec."Proposal ID");
    end;

    //-------------Record Insert--------------//

    // local procedure CalcVATAndTotalValue()
    // begin
    //     // "VAT Amount" := Amount * ("VAT %" / 100);
    //     // "Amount Including VAT" := Amount + "VAT Amount";
    //     "Rent VAT Amount" := "Annual Rent Amount" * ("Rent Amount VAT %" / 100);
    //     "Renewal VAT Amount" := "Renewal Amount" * ("Renewal Amount VAT %" / 100);
    //     "Ejari VAT Amount" := "Ejari Processing Fees" * ("Ejari Fees VAT %" / 100);
    //     // "Renewal Amount Including VAT" := "Renewal Amount" + "Renewal VAT Amount";
    //     // "Rent Amount Including VAT" := "Annual Rent Amount" + "Rent VAT Amount";
    //     // "Ejari Fees Including VAT" := "Ejari Processing Fees" + "Ejari VAT Amount";
    // end;

    //-------------Leap year Counting--------------//
    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    //-------------Leap year Counting--------------//


}

