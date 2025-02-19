page 50313 "Tenancy Contract Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Tenancy Contract";
    Caption = 'Tenancy Contract';

    layout
    {
        area(content)
        {
            // Group for General Information
            group("General Info")
            {
                Caption = 'General Information';


                field("Contract ID"; rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract Type"; rec."Contract Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        UpdateFieldsEnable();
                    end;
                }
                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Enabled = ProposalIDEnabled;
                }

                field("Renewal Proposal ID"; rec."Renewal Proposal ID")
                {
                    ApplicationArea = All;
                    Enabled = RenewalProposalIDEnabled;
                }
                field("Contract Date"; Rec."Contract Date")
                {
                    ApplicationArea = All;
                }
            }

            group("Owner / Lessor Information")
            {
                field("Owner's Name"; rec."Owner's Name")
                {
                    ApplicationArea = All;
                }

                field("Lessor's Name"; rec."Lessor's Name")
                {
                    ApplicationArea = All;
                }

                field("Lessor's Emirates ID"; rec."Lessor's Emirates ID")
                {
                    ApplicationArea = All;
                }

                field("License No."; rec."License No.")
                {
                    ApplicationArea = All;
                }

                field("Licensing Authority"; rec."Licensing Authority")
                {
                    ApplicationArea = All;
                }

                field("Lessor's Email"; rec."Lessor's Email")
                {
                    ApplicationArea = All;
                }

                field("Lessor's Phone"; rec."Lessor's Phone")
                {
                    ApplicationArea = All;
                }
            }

            // Group for Tenant and Customer Information
            group("Tenant & Customer Info")
            {
                Caption = 'Tenant & Customer Information';
                field("Tenant ID"; rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }
                field("Emirates ID"; rec."Emirates ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contact Number"; rec."Contact Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Email Address"; rec."Email Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tenant_License No."; Rec."Tenant_License No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tenant_Licensing Authority"; Rec."Tenant_Licensing Authority")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
            }

            // Group for Property Information
            group("Property Info")
            {
                Caption = 'Property Information';
                field("Property ID"; rec."Property ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Property Classification"; rec."Property Classification")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }
                field("Property Type"; rec."Property Type")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }

                field("Praposal Type Selected"; rec."Praposal Type Selected")
                {
                    ApplicationArea = All;
                    // Lookup = true; // Enable lookup for Property ID
                    Caption = 'Unit Category';
                    Editable = false;

                }
                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }

                field("Merge Unit ID"; Rec."Merge Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true; // Enable lookup for Unit ID
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Unit Address"; rec."Unit Address")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Unit Classification"; rec."Usage Type")
                {
                    ApplicationArea = All;

                    Editable = false;
                }
                field("Unit Type"; rec."Unit Type")
                {
                    ApplicationArea = All;
                    Editable = false;

                }



                field("Uniq Unit ID"; Rec.UnitID) // Auto-generated Unit ID
                {
                    ApplicationArea = All;
                    Caption = 'Uniq Unit ID';
                    Editable = false;
                }

                field("Single Unit Name"; Rec."Single Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                }

                field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Ejari Name"; Rec."Ejari Name")
                {
                    ApplicationArea = All;
                }
                field("Unit Sq. Feet"; Rec."Unit Sq. Feet")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Property Size"; Rec."Property Size")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Makani Number"; Rec."Makani Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Emirate; Rec.Emirate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Community; Rec.Community)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("DEWA Number"; Rec."DEWA Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Facilities/Amenities"; rec."Facilities/Amenities")
                {
                    ApplicationArea = All;
                }
            }

            // Group for Contract Information
            group("Contract Details")
            {
                Caption = 'Contract Details';
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Tenor"; Rec."Contract Tenor")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Rent Amount"; Rec."Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Caption = 'Contract Amount';
                }

                field("Contract VAT %"; Rec."Contract VAT %")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Caption = 'Contract Amount';
                }

                field("Contract VAT Amount"; Rec."Contract VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Caption = 'Contract Amount';
                }

                field("Contract Amount Including VAT"; Rec."Contract Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Caption = 'Contract Amount';
                }

                field("Annual Rent Amount"; Rec."Annual Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Payment Frequency"; rec."Payment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Frequency of payment';
                    Editable = false;
                }
                field("Payment Method"; rec."Payment Method")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Mode';
                    Editable = false;
                }
                field("No of Installments"; rec."No of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'No of Installments';
                    // Visible = false;
                }
            }
            group("Security Deposit")
            {
                field("Security Deposit Amount"; Rec."Security Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field("Balance Amount"; Rec."Balance Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Security Deposit Amount Received';

                    trigger OnValidate()
                    begin
                        UpdateSecurityAmountReceived();
                    end;
                }
                field("Security Amount Received"; Rec."Security Amount Received")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Security Deposit Amount Pending';

                    trigger OnValidate()
                    begin
                        UpdateSecurityAmountReceived();
                    end;
                }

                field("Security Balanced Amount"; Rec."Security Balanced Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Security Deposit Amount Balance';
                }
            }

            // Group for Grace Period Information
            group("Grace Period Info")
            {
                Caption = 'Grace Period Information';

                field("Grace Start Date"; Rec."Grace Start Date")
                {
                    ApplicationArea = All;
                }
                field("Grace End Date"; Rec."Grace End Date")
                {
                    ApplicationArea = All;
                }
                field("Grace Period"; Rec."Grace Period")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Handover is Completed"; rec."Handover is Completed")
                {
                    ApplicationArea = All;
                }

                field("Handover of PDC"; rec."Handover of PDC")
                {
                    ApplicationArea = All;
                }
                field("Signed TC Document"; rec."Signed TC Document")
                {
                    ApplicationArea = All;
                }
                field("Handover Unit"; rec."Handover Unit")
                {
                    ApplicationArea = All;
                }

                field("Single Rent Calculation"; Rec."Single Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Single Unit";

                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }

                field("Merge Rent Calculation"; Rec."Merge Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit";

                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }


                field("upload document"; rec."upload document")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        AzureBlobUploader: Codeunit "Azure Blob Management";
                        InStream: InStream;
                        FileName: Text;
                        SASUrlBase: Text;
                        SASUrlWithFileName: Text;
                        UploadResult: Text;
                        TempBlob: Codeunit "Temp Blob";
                        ValidFormats: List of [Text];
                        FileExtension: Text[10];
                        FileSize: Decimal;
                        ConfigRecord: Record AzureConfiguration;

                    begin
                        // Validate and retrieve the SAS URL from the configuration table
                        if not ConfigRecord.FindFirst() then
                            Error('Azure configuration is missing. Please set up the SAS URL in the Azure Configuration table.');

                        ValidFormats.Add('.pdf');
                        ValidFormats.Add('.docx');
                        ValidFormats.Add('.jpg');
                        ValidFormats.Add('.jpeg');
                        // Get the SAS base URL (without the file name)
                        SASUrlBase := ConfigRecord."SAS URL";

                        // Load the file to be uploaded into an InStream
                        if UploadIntoStream('Select a Document', '', '(*.pdf, *.docx,*.jpeg, *.jpg)|*.pdf;*.docx;*.jpeg;*.jpg', FileName, InStream) then begin

                            FileExtension := LowerCase(CopyStr(FileName, StrPos(FileName, '.'), StrLen(FileName) - StrPos(FileName, '.') + 1));
                            if not ValidFormats.Contains(FileExtension) then
                                Error('Unsupported file format. Please upload PDF, DOCX, JPEG or JPG.');

                            FileSize := InStream.Length / 1024 / 1024; // Convert to MB
                            if FileSize > 5 then
                                Error('File is too large. Maximum size allowed is 5MB.');
                            // Append the file name to the base SAS URL to create a full SAS URL
                            SASUrlWithFileName := StrSubstNo('%1/%2?%3', CopyStr(SASUrlBase, 1, StrPos(SASUrlBase, '?') - 1), FileName, CopyStr(SASUrlBase, StrPos(SASUrlBase, '?') + 1));


                            // Call the upload function with the modified SAS URL
                            UploadResult := documentattachment.UploadDocumentToBlobStorage(SASUrlWithFileName, FileName, InStream);
                            // Message('Upload Result: %1', UploadResult);

                            // Optionally, store metadata about the uploaded document in the table
                            Rec."Upload Document" := FileName;
                            Rec."view Document" := UploadResult;
                            // Rec."View Document URL" := UploadResult;
                            Rec.Modify();
                            Message('Document uploaded successfully: %1', FileName);
                        end else
                            Message('No document was selected` for upload.');
                    end;
                }

                field("view Document"; Rec."view Document")
                {
                    ApplicationArea = All;
                    Editable = true;
                    DrillDown = true;
                    Visible = false;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."view Document";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);
                    end;
                }
                field("Update Contract Status"; Rec."Update Contract Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        // Check if "Update Contract Status" has a value other than its default (e.g., <Blank>)
                        if Rec."Update Contract Status" <> Rec."Update Contract Status"::" " then
                            Rec."Yes/No" := true
                        else
                            Rec."Yes/No" := false;
                    end;
                }

                field("Yes/No"; rec."Yes/No")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Tenant Contract Status"; rec."Tenant Contract Status")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field("Renewal Contract Status"; rec."Renewal Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Created By"; rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Suspended Reason list"; Rec."Suspended Reason list")
                {
                    ApplicationArea = All;
                    ToolTip = 'Click to open the Suspended Reason List.';
                    Style = Strong; // Makes the field look like a hyperlink
                    StyleExpr = true;

                    trigger OnAssistEdit()
                    var
                        SuspendedReasonRec: Record "SuspendReasonTable";
                    begin
                        // Filter the Suspended Reason List page by the current Contract ID
                        SuspendedReasonRec.SetRange("Contract ID", Rec."Contract ID");
                        Page.Run(Page::"SuspendReasonList", SuspendedReasonRec);
                    end;
                }

                field("Update Data"; Rec."Update Data")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;


                    trigger OnDrillDown()
                    var
                        SingleUnitName: Text;
                        CommaPos: Integer;
                        RentRecord: Record "Rent Calculation";
                        Tenancycontract: Record "Tenancy Contract";
                        SU_samesquare: Record "TC Single Unit Rent SubPage";
                        SU_lumpsum: Record "TC Single LumAnnualAmnt SP";
                        MU_samesquare: Record "TC Merge SameSqure SubPage";
                        MU_differentsquare: Record "TC Merge DifferentSq SubPage";
                        MU_lumpsum: Record "TC Merge LumAnnualAmount SP";
                        RentSubpage: Record "Rent Calculation Subpage";
                        InstallmentAmount: Decimal;
                        TotalCalculatedAmount: Decimal;
                        LastInstallmentAmount: Decimal;
                        Lastyear: Integer;
                        InstallmentAmount2: Decimal;
                        Year: Integer;
                    begin
                        // Find the Tenancy Contract record
                        Tenancycontract.SetRange("Contract ID", Rec."Contract ID");
                        if Tenancycontract.FindFirst() then begin
                            // Initialize and insert new record with data from Tenancy Contract
                            RentRecord.Init();
                            RentRecord."Contract ID" := Tenancycontract."Contract ID";
                            RentRecord."Contract Start Date" := Tenancycontract."Contract Start Date";
                            RentRecord."Contract End Date" := Tenancycontract."Contract End Date";
                            RentRecord."Amount" := Round(Tenancycontract."Annual Rent Amount");
                            RentRecord."Tenant ID" := Tenancycontract."Tenant ID";
                            RentRecord."Secondary Item Type" := 'Rent';
                            RentRecord."VAT Amount" := Round(Tenancycontract."Contract VAT Amount");
                            RentRecord."Amount Including VAT" := Round(Tenancycontract."Contract Amount Including VAT");
                            RentRecord."Number of Installments" := Tenancycontract."No of Installments";
                            RentRecord."VAT %" := Tenancycontract."Contract VAT %";

                            // Handle rent calculation type assignment
                            if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with lumpsum square feet rate" then
                                RentRecord."Rent Calculation Type" := Format(Tenancycontract."Single Rent Calculation")
                            else if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with square feet rate" then
                                RentRecord."Rent Calculation Type" := Format(Tenancycontract."Single Rent Calculation")
                            else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with differential square feet rate" then
                                RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                            else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount" then
                                RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                            else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with same square feet" then
                                RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                            else
                                Error('No valid Rent Calculation Type found in Tenancy Contract.');

                            RentRecord.Insert();

                            // Update data in Revenue Structure Subpage for Single Rent Calculation
                            if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with lumpsum square feet rate" then begin
                                SU_lumpsum.SetRange("Contract Id", Tenancycontract."Contract Id");
                                if SU_lumpsum.FindSet() then begin
                                    repeat
                                        if not RentSubpage.Get(RentRecord."RC ID", SU_lumpsum.SL_Year) then begin
                                            RentSubpage.Init();
                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                            RentSubpage.Year := SU_lumpsum.SL_Year;
                                            RentSubpage."Period Start Date" := SU_lumpsum."SL_Start Date";
                                            RentSubpage."Period End Date" := SU_lumpsum."SL_End Date";
                                            RentSubpage."Number of Days" := SU_lumpsum."SL_Number of Days";


                                            RentSubpage.Insert();
                                            Clear(RentSubpage);


                                        end //else
                                            // Message('Skipping duplicate record for RC ID=%1, Year=%2.',
                                            //         RentRecord."RC ID", SU_lumpsum.SL_Year);
                                    until SU_lumpsum.Next() = 0;
                                end else
                                    Error('No data found in Single Unit with lumpsum square feet rate subpage for Contract ID %1.', Tenancycontract."Contract ID");
                            end
                            else if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with square feet rate" then begin
                                SU_samesquare.SetRange("Contract Id", Tenancycontract."Contract ID");
                                if SU_samesquare.FindSet() then begin
                                    repeat
                                        if not RentSubpage.Get(RentRecord."RC ID", SU_samesquare.Year) then begin
                                            RentSubpage.Init();
                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                            RentSubpage.Year := SU_samesquare.Year;
                                            RentSubpage."Period Start Date" := SU_samesquare."Start Date";
                                            RentSubpage."Period End Date" := SU_samesquare."End Date";
                                            RentSubpage."Number of Days" := SU_samesquare."Number of Days";

                                            RentSubpage.Insert();
                                            Clear(RentSubpage);
                                        end //else
                                            //Message('Skipping duplicate record for RC ID=%1, Year=%2.',
                                            //             RentRecord."RC ID", SU_samesquare.Year);
                                    until SU_samesquare.Next() = 0;
                                end else
                                    Error('No data found in Single Unit with square feet rate subpage for Contract ID %1.', Tenancycontract."Contract ID");
                            end

                            else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with differential square feet rate" then begin
                                // Find the Tenancy Contract record
                                Tenancycontract.SetRange("Contract Id", Rec."Contract Id");
                                if Tenancycontract.FindFirst() then begin
                                    // Extract the first unit name by trimming at the first comma
                                    begin
                                        SingleUnitName := Tenancycontract."Single Unit Name";
                                        CommaPos := StrPos(SingleUnitName, ','); // Find the position of the first comma
                                        if CommaPos > 0 then
                                            SingleUnitName := CopyStr(SingleUnitName, 1, CommaPos - 1) // Trim to the first name
                                        else
                                            SingleUnitName := SingleUnitName; // No comma, use the whole name

                                        // Find the first unit's details in Merge DifferentSquare table
                                        MU_differentsquare.SetRange("Contract ID", Tenancycontract."Contract ID");
                                        MU_differentsquare.SetRange("MD_Unit ID", SingleUnitName); // Filter by the first unit name
                                        if MU_differentsquare.FindSet() then begin
                                            repeat
                                                // Update Revenue Structure Subpage
                                                if not RentSubpage.Get(RentRecord."RC ID", MU_differentsquare.MD_Year) then begin
                                                    RentSubpage.Init();
                                                    RentSubpage."RC ID" := RentRecord."RC ID";
                                                    RentSubpage."Contract ID" := RentRecord."Contract ID";
                                                    RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                                    RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                                    RentSubpage."VAT %" := RentRecord."VAT %";
                                                    RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                                    RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                                    RentSubpage.Year := MU_differentsquare.MD_Year;
                                                    RentSubpage."Period Start Date" := MU_differentsquare."MD_Start Date";
                                                    RentSubpage."Period End Date" := MU_differentsquare."MD_End Date";
                                                    RentSubpage."Number of Days" := MU_differentsquare."MD_Number of Days";
                                                    RentSubpage.Insert();
                                                    Clear(RentSubpage);
                                                end // else
                                                    // Message('Skipping duplicate record for RC ID=%1, Year=%2.',
                                                    //         RentRecord."RC ID", MU_differentsquare.MD_Year);
                                            until MU_differentsquare.Next() = 0;

                                            // Message('Revenue data successfully updated for Unit Name: %1.', SingleUnitName);
                                        end else
                                            Error('No data found for Unit Name: %1 in Contract ID: %2.', SingleUnitName, Tenancycontract."Contract ID");
                                    end;
                                end else
                                    Error('Tenancy Contract not found for Contract ID: %1.', Rec."Contract ID");
                            end


                            else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount" then begin
                                MU_lumpsum.SetRange("Contract ID", Tenancycontract."Contract ID");
                                if MU_lumpsum.FindSet() then begin
                                    repeat
                                        if not RentSubpage.Get(RentRecord."RC ID", MU_lumpsum.ML_Year) then begin
                                            RentSubpage.Init();
                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                            RentSubpage.Year := MU_lumpsum.ML_Year;
                                            RentSubpage."Period Start Date" := MU_lumpsum."ML_Start Date";
                                            RentSubpage."Period End Date" := MU_lumpsum."ML_End Date";
                                            RentSubpage."Number of Days" := MU_lumpsum."ML_Number of Days";
                                            RentSubpage.Insert();
                                            Clear(RentSubpage);
                                        end // else
                                            // Message('Skipping duplicate record for RC ID=%1, Year=%2.',
                                            //         RentRecord."RC ID", MU_lumpsum.ML_Year);
                                    until MU_lumpsum.Next() = 0;
                                end else
                                    Error('No data found in Merged Unit with lumpsum annual amount subpage for Contract ID %1.', Tenancycontract."Contract ID");
                            end
                            else if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with same square feet" then begin
                                MU_samesquare.SetRange("Contract ID", Tenancycontract."Contract ID");
                                if MU_samesquare.FindSet() then begin
                                    repeat
                                        if not RentSubpage.Get(RentRecord."RC ID", MU_samesquare.MS_Year) then begin
                                            RentSubpage.Init();
                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                            RentSubpage.Year := MU_samesquare.MS_Year;
                                            RentSubpage."Period Start Date" := MU_samesquare."MS_Start Date";
                                            RentSubpage."Period End Date" := MU_samesquare."MS_End Date";
                                            RentSubpage."Number of Days" := MU_samesquare."MS_Number of Days";
                                            RentSubpage.Insert();
                                            Clear(RentSubpage);
                                        end // else
                                            // Message('Skipping duplicate record for RC ID=%1, Year=%2.',
                                            //         RentRecord."RC ID", MU_samesquare.MS_Year);
                                    until MU_samesquare.Next() = 0;
                                end else
                                    Error('No data found in Merged Unit with same square feet subpage for Contract ID %1.', Tenancycontract."Contract ID");
                            end;
                            RentSubpage.SetRange("RC ID", RentRecord."RC ID");
                            RentSubpage.SetRange("Contract ID", RentRecord."Contract ID");
                            RentSubpage.SetCurrentKey(Year);
                            if RentSubpage.FindLast() then begin
                                Lastyear := RentSubpage.Year;
                                Clear(RentSubpage);
                                RentSubpage.SetRange("RC ID", RentRecord."RC ID");
                                RentSubpage.SetRange("Contract ID", RentRecord."Contract ID");
                                if RentSubpage.FindSet() then
                                    repeat
                                        Year := RentSubpage.Year;
                                        RentSubpage."Yearly No. of Installment" := RentRecord."Number of Installments" / Lastyear;
                                        InstallmentAmount := Round(RentRecord.Amount / Lastyear);
                                        TotalCalculatedAmount := InstallmentAmount * Lastyear;  // 1666.67*3 = 5000.01
                                        LastInstallmentAmount := TotalCalculatedAmount - RentRecord.Amount; // 5000.01 - 5000 = 0.01
                                        InstallmentAmount2 := InstallmentAmount - LastInstallmentAmount;

                                        if Year = Lastyear then begin
                                            RentSubpage."Final Annual Amount" := InstallmentAmount2;
                                        end else begin
                                            RentSubpage."Final Annual Amount" := InstallmentAmount;
                                        end;
                                        // RentSubpage."VAT Amount" := RentRecord."VAT Amount" / RentRecord."Number of Installments";
                                        // RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT" / RentRecord."Number of Installments";
                                        RentSubpage.Modify(true);
                                    until RentSubpage.Next() = 0;
                            end;
                            Message('New record has been created in Rent Calculation and subpage updated successfully.');
                            // end else
                            //     Error('Tenancy Contract not found for Contract ID %1.', Rec."Contract ID");
                        end;
                    end;

                }




            }









            group("Lease Unit Details")
            {
                Caption = 'Unit Details';
                part("Unit all Details"; "Sub Lease Merged Units Card")
                {
                    SubPageLink = "Merge Unit ID" = FIELD("Merge Unit ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit"; // Visible when "Praposal Type Selected" is "Merge Unit"
                }
            }

            group("Single Unit with lumpsum square feet rate")
            {
                Caption = 'Single Unit with lumpsum square feet rate';
                Visible = ShowLegalReasonFields3;

                part("Single Unit lumpsum Rent (Renewal)"; "TC Single LumAnnualAmnt SP")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set
                    // Visible = isVisible;
                }
                part("Single Unit lumpsum Rent (Proposal)"; "TC Single LumAnnualAmnt SP")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty
                    // Visible = isVisible;
                }
            }


            group("Single Unit with square feet rate")
            {
                Caption = 'Single Unit With Square Feet Rate';
                Visible = ShowLegalReasonFields;

                // ✅ Part for Renewal Proposal ID
                part("Single Unit Rent (Renewal)"; "TC Single Unit Rent SubPage")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Uses Renewal Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set
                }

                // ✅ Part for Proposal ID (Fallback)
                part("Single Unit Rent (Proposal)"; "TC Single Unit Rent SubPage")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Uses Proposal ID if Renewal is empty
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty
                }
            }
            group("Merged Unit with same square feet")
            {
                Caption = 'Merged Unit With Same Square Feet';
                Visible = ShowBusinessReasonFields;
                part("Merge SameSqure Rent (Renewal)"; "TC Merge SameSqure SubPage")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set
                    // Visible = isVisible;
                }

                part("Merge SameSqure Rent (Proposal)"; "TC Merge SameSqure SubPage")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty
                    // Visible = isVisible;
                }
            }
            group("Merged Unit with differential square feet rate")
            {
                Caption = 'Merged Unit With Differential Square Feet Rate';
                Visible = ShowLegalReasonFields1;
                part("Merge DifferentSqure Rent (Renewal)"; "TC Merge DifferentSq SubPage")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0);
                    // Visible = isVisible;
                }

                part("Merge DifferentSqure Rent (Proposal)"; "TC Merge DifferentSq SubPage")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0);

                    // Visible = isVisible;
                }
            }
            group("Merged Unit with lumpsum annual amount")
            {
                Caption = 'Merged Unit With Lumpsum Annual Amount';
                Visible = ShowBusinessReasonFields2;
                part("Merge Lum_AnnualAmount Rent (Renewal)"; "TC Merge Lum_AnnualAmount SP")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0);
                    // Visible = isVisible;
                }

                part("Merge Lum_AnnualAmount Rent (Proposal)"; "TC Merge Lum_AnnualAmount SP")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0);
                    // Visible = isVisible;
                }
            }

            // group("Per Day Rent for Revenue Allocation")
            // {
            //     Caption = 'Per Day Rent for Revenue Allocation';
            //     part("Per Day Rent for Revenue"; "TC PerDayRent for Revenue Card")
            //     {
            //         SubPageLink = "Contract Renewal Id" = FIELD(Id); // Link to filter attachments for this owner only
            //         ApplicationArea = All;
            //         Visible = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit"; // Visible when "Praposal Type Selected" is "Merge Unit"
            //     }

            // }
            group("Per Day Rent for Revenue Allocation")
            {
                Caption = 'Per Day Rent for Revenue Allocation';

                // ✅ Show for Renewal Proposal if "Praposal Type Selected" = "Merge Unit"
                part("Per Day Rent (Renewal)"; "TC PerDayRent for Revenue Card")
                {
                    SubPageLink = "Contract Renewal Id" = FIELD("Renewal Proposal ID"); // Link to Renewal Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0) and
                  (Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit");
                }

                // ✅ Show for Normal Proposal if "Praposal Type Selected" = "Merge Unit"
                part("Per Day Rent (Proposal)"; "TC PerDayRent for Revenue Card")
                {
                    SubPageLink = "Proposal Id" = FIELD("Proposal ID"); // Link to Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0) and
                  (Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit");
                }
            }




            group("Other Payments")
            {
                part("Revenues"; "Tenancy Contract SubPage Card")
                {
                    SubPageLink = ContractID = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }


        }
    }
    actions
    {
        area(Reporting)
        {

            action("Run Report")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    TenancyContract: Record "Tenancy Contract";
                    ReportDubai: Report "Tenancy Contract";
                    ReportAbuDhabi: Report "AbuDhabi_Contract";
                begin
                    TenancyContract.SetRange("Contract ID", Rec."Contract ID");  // Set appropriate filters

                    if Rec.Emirate = 'Dubai' then begin
                        ReportDubai.SetTableView(TenancyContract);
                        ReportDubai.RunModal();
                    end else if Rec.Emirate = 'Abu Dhabi' then begin
                        ReportAbuDhabi.SetTableView(TenancyContract);
                        ReportAbuDhabi.RunModal();
                    end;
                end;
            }



        }
    }
    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    var
        unitId: code[20];
        documentattachment: Codeunit UploadAttachment;

    var
        ProposalIDEnabled: Boolean;
        RenewalProposalIDEnabled: Boolean;




    // trigger OnAfterGetRecord()
    // begin
    //     // EnableSingleUnit := true;
    //     // UpdateUnitEnableState();
    //     CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");
    //     // CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
    //     CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");

    // end;

    trigger OnAfterGetRecord()
    begin

        CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");
        // CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."Proposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        UpdateFieldsEnable();
        UpdateVisibility();
        UpdateSecurityAmountReceived();

    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");
        // CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."Proposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        UpdateVisibility();
        UpdateSecurityAmountReceived();



    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");
        //CurrPage."Revenue".Page.SetStartEndDate(Rec."Lease Start Date", Rec."Lease End Date");
        CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."Proposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        UpdateVisibility();

    end;



    local procedure UpdateFieldsEnable()
    begin
        ProposalIDEnabled := Rec."Contract Type" = Rec."Contract Type"::"New Contract";
        RenewalProposalIDEnabled := Rec."Contract Type" = Rec."Contract Type"::"Renewal Contract";

        CurrPage.Update(false);
    end;

    var
        ShowLegalReasonFields: Boolean;
        ShowBusinessReasonFields: Boolean;

        ShowLegalReasonFields1: Boolean;
        ShowBusinessReasonFields2: Boolean;
        ShowLegalReasonFields3: Boolean;

        ShowLegalReasonFields4: Boolean;

        ShowLegalReasonFields5: Boolean;


    // trigger OnAfterge
    // begin

    //     // SetRange("Merge Unit ID", Rec."Merge Unit ID");
    // end;

    // Procedure to update visibility dynamically
    procedure UpdateVisibility()
    begin
        ShowLegalReasonFields := (Rec."Single Rent Calculation" = Rec."Single Rent Calculation"::"Single Unit with square feet rate");
        ShowBusinessReasonFields := (Rec."Merge Rent Calculation" = Rec."Merge Rent Calculation"::"Merged Unit with same square feet");
        ShowLegalReasonFields1 := (Rec."Merge Rent Calculation" = Rec."Merge Rent Calculation"::"Merged Unit with differential square feet rate");
        ShowBusinessReasonFields2 := (Rec."Merge Rent Calculation" = Rec."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount");
        ShowLegalReasonFields3 := (Rec."Single Rent Calculation" = Rec."Single Rent Calculation"::"Single Unit with lumpsum square feet rate");
        ShowLegalReasonFields4 := (Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit");
    end;

    local procedure UpdateSecurityAmountReceived()
    begin
        if Rec."Security Deposit Amount" = Rec."Balance Amount" then
            Rec."Security Amount Received" := 0
        else
            Rec."Security Amount Received" := Rec."Security Deposit Amount" - Rec."Balance Amount";
    end;




}
