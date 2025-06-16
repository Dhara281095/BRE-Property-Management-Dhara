pageextension 50101 Items extends "Item Card"
{
    Caption = 'Unit Card';

    layout
    {
        modify("No.")
        {
            Editable = false;
        }
        modify("Item Category Code")
        {
            Visible = false;
        }
        modify(Description)
        {
            Visible = false;
        }
        modify("Automatic Ext. Texts")
        {
            Visible = false;
        }
        modify("Common Item No.")
        {
            Visible = false;
        }
        modify("Purchasing Code")
        {
            Visible = false;
        }
        modify("VariantMandatoryDefaultNo")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Visible = false;
        }
        modify("Last Date Modified")
        {
            Caption = 'Unit Registration Date';
            Editable = true;
        }
        modify(InventoryGrp)
        {
            Visible = false;
        }
        modify("Costs & Posting")
        {
            Visible = false;
        }
        modify("Prices & Sales")
        {
            Visible = false;
        }
        modify(Replenishment)
        {
            Visible = false;
        }
        modify(Planning)
        {
            Visible = false;
        }
        modify(ItemTracking)
        {
            Visible = false;
        }
        modify(Warehouse)
        {
            Visible = false;
        }
        modify(GTIN)
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            ShowMandatory = false;
            Editable = hideshowfields;
            Visible = hideshowfields;

        }
        modify("VAT Prod. Posting Group")
        {
            ShowMandatory = false;
            Editable = hideshowfields;
            Visible = hideshowfields;
        }
        modify("Service Item Group")
        {
            Editable = editablefalsefieldNonInventoryType;
            Visible = false;
        }
        modify(Item)
        {
            caption = 'Unit';
        }






        // addafter("Last Date Modified")
        // {
        //     field(GTIN_; rec.GTIN_)
        //     {
        //         ApplicationArea = All;
        //         // Editable = true;
        //         Editable = editablefalsefieldNonInventoryType;
        //         Caption = 'GTIN';
        //     }
        // }
        addafter("Base Unit of Measure")
        {
            field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
            {
                ApplicationArea = All;
                //Editable = true;
                Editable = editablefalsefieldNonInventoryType;
            }
        }

        addafter("Market Rate per Sq. Ft.")
        {
            field("Unit Size"; rec."Unit Size")
            {
                ApplicationArea = All;
                Caption = 'Unit Size';
                // Editable = true;
                Editable = editablefalsefieldNonInventoryType;
            }
        }
        // addafter(Type)
        // {
        //     field("Select Unit Type"; Rec."Select Unit Type")
        //     {
        //         ApplicationArea = All;
        //         trigger OnValidate()
        //         begin
        //             UpdateGroupVisibility();
        //         end;

        //     }
        // }
        addafter("Unit Size")
        {
            field("Amount"; rec."Amount")
            {
                ApplicationArea = All;
                Caption = 'Amount';
                Editable = false;
            }
        }
        addafter("Gen. Prod. Posting Group")
        {
            field("Primary Classification Type"; Rec."Primary Classification Type")
            {
                ApplicationArea = All;
                Caption = 'Primary Classification Type';
                Editable = ISPrimaryType;
                //Visible = hideshowfields;
            }
        }
        addafter(Item)
        {
            group(UnitManagement)
            {
                Caption = 'Unit Management';
                // Visible = IsUnitManagementVisible;
                field(FixedNumber; Rec.FixedNumber)
                {
                    ApplicationArea = All;
                    Caption = 'FixedNumber';
                    Editable = false;
                    Visible = false;
                }
                field("Country"; Rec.Country)
                {
                    ApplicationArea = All;
                    Caption = 'Country';
                    Lookup = true;
                    Editable = editablefalsefieldNonInventoryType;
                    trigger OnValidate()
                    begin
                        AutoGenerateUnitName(Rec); // Call to auto-generate the Unit Name when Merge Units changes
                    end;

                }
                field(Emirate; Rec.Emirate)
                {
                    ApplicationArea = All;
                    Caption = 'Emirate';
                    Lookup = true;
                    Editable = editablefalsefieldNonInventoryType;
                    trigger OnValidate()
                    begin
                        AutoGenerateUnitName(Rec); // Call to auto-generate the Unit Name when Merge Units changes
                    end;
                }
                field("Community"; Rec.Community)
                {
                    ApplicationArea = All;
                    Caption = 'Community';
                    Lookup = true;
                    Editable = editablefalsefieldNonInventoryType;
                    trigger OnValidate()
                    begin
                        AutoGenerateUnitName(Rec); // Call to auto-generate the Unit Name when Merge Units changes
                    end;
                }
                field("Property ID"; Rec."Property ID") // OOB Field (or create custom if not OOB)
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                    // ShowMandatory = true;
                    Editable = editablefalsefieldNonInventoryType;
                    trigger OnValidate()
                    begin
                        AutoGenerateUnitName(Rec);
                    end;
                }

                field("Property Name"; Rec."Property Name") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    Editable = false;
                }
                field("Floor Number"; Rec."Floor Number") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Floor Number';
                    //Editable = true;
                    Editable = editablefalsefieldNonInventoryType;
                }
                field("Unit Number"; Rec."Unit Number") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Unit Number';
                    // Editable = true;
                    Editable = editablefalsefieldNonInventoryType;
                    trigger OnValidate()
                    begin
                        AutoGenerateUnitName(Rec); // Call to auto-generate the Unit Name when Merge Units changes
                    end;
                }

                field("Unit ID"; Rec.UnitID) // Auto-generated Unit ID
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    Editable = false;
                }
                field("Unit Name"; Rec."Unit Name") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Unit Name';
                    Editable = false;
                }

                field("Usage Type"; rec."Usage Type")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }

                field("Unit Type"; rec."Unit Type")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = editablefalsefieldNonInventoryType;
                }
                field("Unit Address"; rec."Unit Address")
                {
                    ApplicationArea = All;
                    Editable = editablefalsefieldNonInventoryType;
                }

                // field("Registration Date"; rec."Unit Address")
                // {
                //     ApplicationArea = All;
                // }

                // field("Tenant ID"; Rec."Tenant ID") // OOB Field (or create custom if not OOB)
                // {
                //     ApplicationArea = All;
                //     Lookup = true;
                //     Caption = 'Tenant ID';
                //     ShowMandatory = true;
                //     NotBlank = true;

                // }
                field("Merging/Splitting"; rec."MergeSplitOption")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Unit Status"; rec."Unit Status")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }


            }



            part("Document Attachments"; "Unit Document SubPage")
            {
                SubPageLink = UnitID = FIELD("No."); // Link to filter attachments for this owner only
                ApplicationArea = All;
                // Visible = isVisible;
                Editable = editablefalsefieldNonInventoryType;
                Visible = ShowFinancialFields;

            }
        }


    }

    actions
    {

        modify(CopyItem)
        {
            trigger OnAfterAction()
            var
                myInt: Integer;
            begin
                AutoGenerateUnitName(Rec);
            end;
        }
        addafter("Item Journal")
        {
            action("Add New Line")
            {
                ApplicationArea = All;
                // Promoted = true;

                trigger OnAction()
                var
                    CustomLinesPage: Record "Revenue Structure Subpage";
                    CustomLinesPage2: Record "Revenue Structure";
                // DocumentUploadDetails: Record DocumentUploadDetails;
                begin
                    if CustomLinesPage.FindSet() then begin
                        CustomLinesPage.DeleteAll();
                        // DocumentUploadDetails.DeleteAll();
                    end;

                    if CustomLinesPage2.FindSet() then begin
                        CustomLinesPage2.DeleteAll();
                        // DocumentUploadDetails.DeleteAll();
                    end;
                end;
            }
        }
    }

    procedure AutoGenerateUnitName(var TargetItem: Record Item)
    var
        PropertyCode: Text;
        UnitID: Text;
        CountryCode: Text;
        EmiratesCode: Text;
        CommunityCode: Text;
        UnitnumberCode: Text;

        Country: Text;
        Emirates: Text;
        Community: Text;
        Unitnumber: Text;
    begin
        // Fixed starting number for new records
        // FixedNumber := 101;

        // Get Property Name and Format it
        PropertyCode := FormatName(TargetItem."Property Name");

        // Convert Option fields to Text using Format
        Country := Format(TargetItem.Country); // Assuming Rec has an "Option" field for Country
        Emirates := Format(TargetItem.Emirate); // Assuming Rec has an "Option" field for Emirates
        Community := Format(TargetItem."Community"); // Assuming Rec has an "Option" field for Community
        Unitnumber := Format(TargetItem."Unit Number"); // Assuming "Unit Number" is a field in the record


        // Format Country, Emirates, and Community the same way as Property Name
        CountryCode := FormatName(Country);
        EmiratesCode := FormatName(Emirates);
        CommunityCode := FormatName(Community);
        UnitnumberCode := Format(Unitnumber); // Assuming "Unit Number" is a field in the record

        // Step 1: Generate Unit Name: PropertyCode-UnitType-FixedNumber
        TargetItem."Unit Name" := PropertyCode + '-SU-' + Format(TargetItem.FixedNumber); // Assuming 'SU' is the Unit Type for Single Unit

        // Step 2: Generate Unit ID: CountryCode-EmiratesCode-CommunityCode-PropertyCode-FixedNumber
        UnitID := CountryCode + '-' + EmiratesCode + '-' + CommunityCode + '-' + PropertyCode + '-' + UnitnumberCode;

        // Set the Unit ID in the record
        TargetItem.UnitID := UnitID;
        TargetItem.Modify();
    end;


    // Helper function to format the name
    procedure FormatName(Name: Text): Text
    var
        Words: List of [Text];
        Word: Text;
        Code: Text;
        i: Integer;
    begin
        // Split the Name into words
        Words := Name.Split(' '); // Split by space

        // Check if it's a single word or multiple words
        if Words.Count() = 1 then begin
            // For single-word names, use the first three letters
            Code := CopyStr(Words.Get(1), 1, 3);
        end else begin
            // For multi-word names, use the first letter of each word
            Code := '';
            for i := 1 to Words.Count() do begin
                Word := Words.Get(i);
                Code += CopyStr(Word, 1, 1); // Take the first letter of each word
            end;
        end;

        exit(Code); // Return the formatted code
    end;


    var
        isVisible: Boolean;

    // trigger OnQueryClosePage(CloseAction: Action): Boolean
    // begin
    //     // Validate Property ID before the page closes
    //     if Rec."Property ID" = '' then begin
    //         Message('Please fill in the Property ID field.');
    //         exit(false); // Prevents page from closing
    //     end;

    //     exit(true); // Allows page to close if validation passes
    // end;

    // trigger OnClosePage()
    // var
    // begin
    //     Rec.TestField("Property ID");
    // end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Document Attachments".Page.SetUnitId(Rec."No.");
        ISPrimaryType := SetPrimaryType();
        hideshowfields := hidefields();
        editablefalsefieldNonInventoryType := editablefalseNonInventory();

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Document Attachments".Page.SetUnitId(Rec."No.");
        isVisible := true;
        if Rec."Property Name" = '' then begin
            exit; // Default value for new records
        end
        else if Rec."Property Name" <> '' then begin
            AutoGenerateUnitName(Rec); // Call to auto-generate the Unit Name when a new record is inserted
        end;
    end;

    trigger OnAfterGetRecord()
    // UpdateGroupVisibility();
    begin
        CurrPage."Document Attachments".Page.SetUnitId(Rec."No.");
        if Format(Rec."No.") <> '' then begin
            isVisible := true;
        end
        else begin
            isVisible := false;
        end;
        ISPrimaryType := SetPrimaryType();
        hideshowfields := hidefields();
        editablefalsefieldNonInventoryType := editablefalseNonInventory();


    end;

    trigger OnAfterGetCurrRecord()
    begin
        ISPrimaryType := SetPrimaryType();
        hideshowfields := hidefields();
        editablefalsefieldNonInventoryType := editablefalseNonInventory();

    end;




    procedure SetPrimaryType(): Boolean
    var
    begin
        if Rec.Type = Rec.Type::"Non-Inventory" then
            exit(true)
        else
            exit(false);
    end;

    procedure hidefields(): Boolean
    var
    begin
        if Rec.Type = Rec.Type::Service then
            exit(false)
        else
            exit(true);
    end;

    procedure editablefalseNonInventory(): Boolean
    var
    begin
        if Rec.Type = Rec.Type::"Non-Inventory" then
            exit(false)
        else
            exit(true);
    end;

    trigger OnOpenPage()
    var
    begin
        hideshowfields := hidefields();
        editablefalsefieldNonInventoryType := editablefalseNonInventory();
        ShowFinancialFields := not IsUserInProfile('FINANCE MANAGER');

    end;

    var
        ISPrimaryType: Boolean;

        ShowFinancialFields: Boolean;
        documentattachment: Codeunit UploadAttachment;

        hideshowfields: Boolean;
        editablefalsefieldNonInventoryType: Boolean;




    local procedure IsUserInProfile(ProfileID: Code[20]): Boolean
    var
        AccessControl: Record "User Personalization";
    begin
        AccessControl.SetRange("User ID", UserId());
        AccessControl.SetRange("Profile ID", ProfileID);
        exit(AccessControl.FindFirst());
    end;




    // trigger OnOpenPage()
    // begin
    //     // Initialize visibility when page opens
    //     UpdateGroupVisibility();
    // end;

    // trigger OnAfterGetCurrRecord()
    // begin
    //     UpdateGroupVisibility();
    // end;

    // local procedure UpdateGroupVisibility()
    // begin
    //     // Defalt to hiding both groups
    //     IsUnitManagementVisible := false;
    //     IsMergedUnitsVisible := false;

    //     // Set visibility based on Select Unit Type
    //     case Rec."Select Unit Type" of
    //         Rec."Select Unit Type"::"Single Unit":
    //             begin
    //                 IsUnitManagementVisible := true;
    //             end;
    //         Rec."Select Unit Type"::"Merge Unit":
    //             begin
    //                 IsMergedUnitsVisible := true;
    //             end;
    //     end;

    //     // Force page to refresh
    //     CurrPage.Update(false);
    // end;

    // var
    //     IsUnitManagementVisible: Boolean;
    //     IsMergedUnitsVisible: Boolean;
}