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
        addafter("Last Date Modified")
        {
            field(GTIN_; rec.GTIN_)
            {
                ApplicationArea = All;
                Editable = true;
                Caption = 'GTIN';
            }
        }
        addafter("Base Unit of Measure")
        {
            field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }

        addafter("Market Rate per Sq. Ft.")
        {
            field("Unit Size"; rec."Unit Size")
            {
                ApplicationArea = All;
                Caption = 'Unit Size';
                Editable = true;
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
                    trigger OnValidate()
                    begin
                        AutoGenerateUnitName(); // Call to auto-generate the Unit Name when Merge Units changes
                    end;
                }
                field(Emirate; Rec.Emirate)
                {
                    ApplicationArea = All;
                    Caption = 'Emirate';
                    Lookup = true;
                    trigger OnValidate()
                    begin
                        AutoGenerateUnitName(); // Call to auto-generate the Unit Name when Merge Units changes
                    end;
                }
                field("Community"; Rec.Community)
                {
                    ApplicationArea = All;
                    Caption = 'Community';
                    Lookup = true;
                    trigger OnValidate()
                    begin
                        AutoGenerateUnitName(); // Call to auto-generate the Unit Name when Merge Units changes
                    end;
                }
                field("Property ID"; Rec."Property ID") // OOB Field (or create custom if not OOB)
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                    // ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        AutoGenerateUnitName();
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
                    Editable = true;
                }
                field("Unit Number"; Rec."Unit Number") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Unit Number';
                    Editable = true;
                    // trigger OnValidate()
                    // begin
                    //     AutoGenerateUnitName(); // Call to auto-generate the Unit Name when Unit Number changes
                    // end;
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
                }
                field("Unit Address"; rec."Unit Address")
                {
                    ApplicationArea = All;
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
                // field("Merge Units"; Rec."Merge Units") // Custom Field
                // {
                //     ApplicationArea = All;
                //     Caption = 'Merge Units';
                //     Editable = false;
                //     trigger OnValidate()
                //     begin
                //         AutoGenerateUnitName(); // Call to auto-generate the Unit Name when Merge Units changes
                //     end;
                // }
                field("Unit Status"; rec."Unit Status")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

            }


            // group(MergedUnits)
            // {
            //     Caption = 'Merged Units';
            //     Visible = IsMergedUnitsVisible;

            //     field("Merged Unit ID"; Rec."Merged Unit ID")
            //     {
            //         ApplicationArea = All;
            //     }
            //     // field("Merged FixedNumber"; Rec."Merged FixedNumber")
            //     // {
            //     //     ApplicationArea = All;
            //     // }
            //     field("Merged Property ID"; Rec."Merged Property ID")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("Merged Property Name"; Rec."Merged Property Name")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("UnitID"; Rec."Unit ID")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("Merge Unit Name"; Rec."Merge Unit Name")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("Merged Base Unit of Measure"; Rec."Merged Base Unit of Measure")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("Merged Unit Size"; Rec."Merged Unit Size")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("Merged Amount"; Rec."Merged Amount")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("Merged Property Type"; Rec."Merged Property Type")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("Merged Status"; Rec."Merged Status")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("Merged Spliting Status"; Rec."Merged Spliting Status")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            //     field("Single Unit Name"; Rec."Single Unit Name")
            //     {
            //         ApplicationArea = All;
            //         Editable = false;
            //     }
            // }

            part("Document Attachments"; "Unit Document SubPage")
            {
                SubPageLink = UnitID = FIELD("No."); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Visible = isVisible;

            }
        }


    }

    actions
    {
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




    procedure AutoGenerateUnitName()
    var
        PropertyCode: Text;
        UnitID: Text;
        CountryCode: Text;
        EmiratesCode: Text;
        CommunityCode: Text;

        Country: Text;
        Emirates: Text;
        Community: Text;
    begin
        // Fixed starting number for new records
        // FixedNumber := 101;

        // Get Property Name and Format it
        PropertyCode := FormatName(Rec."Property Name");

        // Convert Option fields to Text using Format
        Country := Format(Rec.Country); // Assuming Rec has an "Option" field for Country
        Emirates := Format(Rec.Emirate); // Assuming Rec has an "Option" field for Emirates
        Community := Format(Rec."Community"); // Assuming Rec has an "Option" field for Community

        // Format Country, Emirates, and Community the same way as Property Name
        CountryCode := FormatName(Country);
        EmiratesCode := FormatName(Emirates);
        CommunityCode := FormatName(Community);

        // Step 1: Generate Unit Name: PropertyCode-UnitType-FixedNumber
        Rec."Unit Name" := PropertyCode + '-SU-' + Format(Rec.FixedNumber); // Assuming 'SU' is the Unit Type for Single Unit

        // Step 2: Generate Unit ID: CountryCode-EmiratesCode-CommunityCode-PropertyCode-FixedNumber
        UnitID := CountryCode + '-' + EmiratesCode + '-' + CommunityCode + '-' + PropertyCode + '-' + Format(Rec.FixedNumber);

        // Set the Unit ID in the record
        Rec.UnitID := UnitID;
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
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Document Attachments".Page.SetUnitId(Rec."No.");
        isVisible := true;
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

    end;

    trigger OnAfterGetCurrRecord()
    begin
        ISPrimaryType := SetPrimaryType();
    end;


    procedure SetPrimaryType(): Boolean
    var
    begin
        if Rec.Type = Rec.Type::"Non-Inventory" then
            exit(true)
        else
            exit(false);
    end;

    var
        ISPrimaryType: Boolean;
        documentattachment: Codeunit UploadAttachment;

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
    //     // Default to hiding both groups
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