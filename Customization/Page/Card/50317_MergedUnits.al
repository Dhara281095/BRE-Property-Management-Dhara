page 50317 "Merged Units Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Merged Units";
    Caption = 'Merged Unit Card';

    layout
    {
        area(content)
        {
            group(Group)
            {

                field(FixedNumber; Rec.FixedNumber)
                {
                    ApplicationArea = All;
                    Caption = 'FixedNumber';
                    Editable = false;
                    // Visible = false;
                }

                field("Merged Unit ID"; Rec."Merged Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                }

                field("Property Name"; Rec."Property Name") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    Editable = false;
                }

                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = true;
                    AssistEdit = true;

                    // trigger OnValidate()
                    // begin
                    //     AutoGenerateUnitName();
                    // end;



                    trigger OnLookup(var Text: Text): Boolean
                    var
                        UnitList: Page "Item List"; // Reference to the Unit List Page
                        UnitRec: Record "Item"; // Reference to the Unit table
                    begin
                        if Rec."Property ID" = '' then begin
                            Message('Please select a Property ID first.');
                            exit(false);
                        end;

                        // Apply filters to show only units that are free and have the merging/splitting status as "Single"
                        UnitRec.Reset();
                        UnitRec.SetRange("Property ID", Rec."Property ID");
                        UnitRec.SetRange("Unit Status", 'Free'); // Filter for free units
                        UnitRec.SetRange("MergeSplitOption", UnitRec."MergeSplitOption"::Single); // Filter for merging/splitting status

                        if UnitRec.IsEmpty then begin
                            Message('No available units that are free and have "Single" option for the selected Property ID.');
                            exit(false);
                        end;

                        UnitList.SetTableView(UnitRec);

                        if UnitList.LookupMode then begin
                            if UnitList.RunModal() = Action::LookupOk then begin
                                Rec."Unit ID" := UnitRec."No."; // Set selected unit ID
                                exit(true);
                            end;
                        end;
                        exit(false);
                    end;



                    trigger OnAssistEdit()
                    var
                        UnitList: Page "Item List"; // Reference to the Unit List Page
                        UnitRec: Record "Item"; // Reference to the Unit table
                        SubMergedUnitRec: Record "Sub Merged Units"; // Reference to the Sub Merged Units table
                        SelectedUnits: Text[1024]; // To store selected Unit IDs
                        TotalUnitSize: Decimal;
                        TotalMarketRate: Decimal;
                        TotalAmount: Decimal;
                        UnitNames: Text[1024]; // To store concatenated Unit Names
                        confirmDialog: Boolean;
                        UnitNumber: Code[1024]; // To store concatenated Unit Numbers
                    begin
                        if Rec."Property ID" = '' then begin
                            Message('Please select a Property ID first.');
                            exit;
                        end;

                        // Apply filters to show only units that are free and have the merging/splitting status as "Single"
                        UnitRec.Reset();
                        UnitRec.SetRange("Property ID", Rec."Property ID");
                        UnitRec.SetRange("Unit Status", 'Free'); // Filter for free units
                        UnitRec.SetRange("MergeSplitOption", UnitRec."MergeSplitOption"::Single); // Filter for merging/splitting status

                        if UnitRec.IsEmpty then begin
                            Message('No available units that are free and have "Single" option for the selected Property ID.');
                            exit;
                        end;

                        UnitList.SetTableView(UnitRec);
                        UnitList.LookupMode := true;

                        // Run the page and capture selected units
                        if UnitList.RunModal() = Action::LookUpOk then begin
                            SelectedUnits := UnitList.GetSelectionFilter();
                            confirmDialog := Dialog.Confirm('Please confirm if you would like to proceed with the merge of items/units %1.', true, SelectedUnits, TotalUnitSize, TotalMarketRate, TotalAmount);

                            if confirmDialog then begin
                                // Reset totals for calculation
                                TotalUnitSize := 0;
                                TotalMarketRate := 0;
                                TotalAmount := 0;

                                // Delete existing Sub Merged Units for the current Merged Unit
                                SubMergedUnitRec.SetRange("Merged Unit ID", Rec."Merged Unit ID");
                                if SubMergedUnitRec.FindSet() then begin
                                    repeat
                                        SubMergedUnitRec.Delete();
                                    until SubMergedUnitRec.Next() = 0;
                                end;

                                // Loop through selected units to calculate total unit size, market rate, and amount
                                UnitRec.Reset();
                                UnitRec.SetFilter("No.", SelectedUnits); // Apply filter on selected Unit IDs
                                if UnitRec.FindSet() then begin
                                    repeat
                                        TotalUnitSize += UnitRec."Unit Size"; // Sum the unit sizes
                                        TotalMarketRate += UnitRec."Market Rate per Sq. Ft."; // Sum the market rate per square values
                                        TotalAmount += UnitRec."Unit Size" * UnitRec."Market Rate per Sq. Ft."; // Calculate total amount based on market rate per square
                                        UnitNames += UnitRec."Unit Name" + ', '; // Concatenate unit names (using "Unit Name" field)
                                        UnitNumber += UnitRec."Unit Number" + ', '; // Concatenate unit numbers (using "No." field)

                                        // Insert into Sub Merged Units table
                                        SubMergedUnitRec.Init();
                                        SubMergedUnitRec."Merged Unit ID" := Rec."Merged Unit ID";
                                        SubMergedUnitRec."Unit ID" := UnitRec."No.";
                                        SubMergedUnitRec."Base Unit of Measure" := UnitRec."Base Unit of Measure";
                                        SubMergedUnitRec."Unit Size" := UnitRec."Unit Size";
                                        SubMergedUnitRec."Market Rate per Square" := UnitRec."Market Rate per Sq. Ft.";
                                        SubMergedUnitRec."Amount" := UnitRec."Unit Size" * UnitRec."Market Rate per Sq. Ft.";
                                        SubMergedUnitRec."Single Unit Name" := UnitRec."Unit Name";

                                        SubMergedUnitRec.Insert();

                                        // Update unit's status
                                        UnitRec."MergeSplitOption" := UnitRec."MergeSplitOption"::Merge; // Change the status to "Merge"
                                        UnitRec."Merged Unit ID" := Rec."Merged Unit ID";
                                        UnitRec.Modify(); // Save the changes
                                    until UnitRec.Next() = 0;
                                end;

                                // Remove trailing comma and space from UnitNames
                                if StrLen(UnitNames) > 2 then
                                    UnitNames := CopyStr(UnitNames, 1, StrLen(UnitNames) - 2);

                                // Set the total unit size, total market rate, and total amount in the respective fields
                                Rec."Unit Size" := TotalUnitSize;
                                Rec."Market Rate per Square" := TotalMarketRate;
                                Rec."Amount" := TotalAmount;

                                // Set the selected Unit IDs to the Unit ID field
                                Rec."Unit ID" := SelectedUnits;
                                Rec."Single Unit Name" := UnitNames;
                                Rec."Unit Number" := UnitNumber;

                                Rec."Spliting Status" := Rec."Spliting Status"::"Merge";
                                Rec.Modify(); // Explicitly save changes to the current record
                            end;
                        end;
                    end;



                }



                field("Merged Unit Name"; Rec."Merged Unit Name")
                {
                    ApplicationArea = All;

                }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }

                field("Unit Size"; Rec."Unit Size")
                {
                    ApplicationArea = All;
                }

                field("Market Rate per Square"; Rec."Market Rate per Square")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                }

                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                }

                field("Single Unit Name"; Rec."Single Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                }

                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;

                    // trigger OnValidate()
                    // var
                    //     ItemRec: Record Item;
                    //     SelectedUnits: Text[1024];
                    // begin
                    //     // Check if the Status is set to Free
                    //     if Rec."Status" = Rec."Status"::Free then begin
                    //         // Retrieve the list of units associated with this merged unit
                    //         SelectedUnits := Rec."Unit ID"; // Contains the Unit IDs associated with the merged unit

                    //         // Update each item in the Item table with the Unit IDs in SelectedUnits
                    //         ItemRec.SetFilter("No.", SelectedUnits); // Apply filter to the selected units
                    //         if ItemRec.FindSet() then begin
                    //             repeat
                    //                 ItemRec."Unit Status" := 'Free'; // Set Unit Status to Free

                    //                 // Set Merging/Splitting to Single
                    //                 ItemRec.Modify(); // Save changes to the Item record
                    //             until ItemRec.Next() = 0;
                    //         end;

                    //         // Ensure the Merged Unit record is saved
                    //         Rec.Modify();
                    //     end;
                    // end;
                }


                field("Splitting Status"; Rec."Spliting Status")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        ItemRec: Record Item;
                        SelectedUnits: Text[1024];
                    begin // Check if the Splitting Status is set to Unmerge
                        if Rec."Spliting Status" = Rec."Spliting Status"::Unmerge then begin
                            // Set Merge Unit Status to N/A
                            Rec."Status" := Rec."Status"::"N/A";

                            // Retrieve the list of units associated with this merged unit
                            SelectedUnits := Rec."Unit ID"; // Contains the Unit IDs associated with the merged unit

                            // Update each item in the Item table with the Unit IDs in SelectedUnits
                            ItemRec.SetFilter("No.", SelectedUnits); // Apply filter to the selected units
                            if ItemRec.FindSet() then begin
                                repeat
                                    ItemRec."Unit Status" := 'Free'; // Set Unit Status to Free
                                    ItemRec."MergeSplitOption" := ItemRec."MergeSplitOption"::Single;
                                    ItemRec."Merged Unit ID" := 0; // Set Merging/Splitting to Single
                                    ItemRec.Modify(); // Save changes to the Item record
                                until ItemRec.Next() = 0;
                            end;

                            // Update the Merged Unit record with the new Status
                            Rec.Modify();
                        end;
                    end;
                }

                // field("Splitting Status"; Rec."Spliting Status")
                // {
                //     ApplicationArea = All;

                //     trigger OnValidate()
                //     var
                //         ItemRec: Record Item;
                //         SelectedUnits: Text[1024];
                //     begin
                //         // Check if the Splitting Status is set to Unmerge
                //         if Rec."Spliting Status" = Rec."Spliting Status"::Unmerge then begin
                //             // Set Merge Unit Status to N/A
                //             Rec."Status" := Rec."Status"::"N/A";

                //             // Retrieve the list of units associated with this merged unit
                //             SelectedUnits := Rec."Unit ID"; // Contains the Unit IDs associated with the merged unit

                //             // Update each item in the Item table with the Unit IDs in SelectedUnits
                //             ItemRec.SetFilter("No.", SelectedUnits); // Apply filter to the selected units
                //             if ItemRec.FindSet() then begin
                //                 repeat
                //                     ItemRec."Unit Status" := 'Free'; // Set Unit Status to Free
                //                     ItemRec."MergeSplitOption" := ItemRec."MergeSplitOption"::Single; // Set Merging/Splitting to Single
                //                     ItemRec.Modify(); // Save changes to the Item record
                //                 until ItemRec.Next() = 0;
                //             end;

                //             // Update the Merged Unit record with the new Status
                //             Rec.Modify();
                //         end
                //         // New code for when Splitting Status is Occupied and Status is Merge
                //         else if (Rec."Spliting Status" = Rec."Spliting Status"::Merge) and (Rec."Status" = Rec."Status"::Occupied) then begin
                //             // Retrieve the list of units associated with this merged unit
                //             SelectedUnits := Rec."Unit ID"; // Contains the Unit IDs associated with the merged unit

                //             // Update each item in the Item table with the Unit IDs in SelectedUnits
                //             ItemRec.SetFilter("No.", SelectedUnits); // Apply filter to the selected units
                //             if ItemRec.FindSet() then begin
                //                 repeat
                //                     ItemRec."Unit Status" := 'Occupied'; // Set Unit Status to Occupied
                //                     ItemRec.Modify(); // Save changes to the Item record
                //                 until ItemRec.Next() = 0;
                //             end;

                //             // Update the Merged Unit record with the new Status
                //             Rec.Modify();
                //         end;
                //     end;
                // }



            }
            group("Unit Details")
            {
                Caption = 'Unit all Details';


                part("Unit all Details"; "Sub Merged Units Card")
                {
                    SubPageLink = "Merged Unit ID" = FIELD("Merged Unit ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;


                }
            }
        }


        // procedure AutoGenerateUnitName()
        // var
        //     PropertyCode: Text;
        // // UnitID: Text;

        // begin


        //     // Get Property Name and Format it
        //     PropertyCode := FormatName(Rec."Property Name");
        //     // Step 1: Generate Unit Name: PropertyCode-UnitType-FixedNumber
        //     Rec."Merged Unit Name" := PropertyCode + '-MU-' + Format(Rec.FixedNumber); // Assuming 'MU' is the Unit Type for Merge Unit

        //     // Set the Unit ID in the record
        //     // Rec."Unit ID" := UnitID;
        // end;


        // // Helper function to format the name
        // procedure FormatName(Name: Text): Text
        // var
        //     Words: List of [Text];
        //     Word: Text;
        //     Code: Text;
        //     i: Integer;
        // begin
        //     // Split the Name into words
        //     Words := Name.Split(' '); // Split by space

        //     // Check if it's a single word or multiple words
        //     if Words.Count() = 1 then begin
        //         // For single-word names, use the first three letters
        //         Code := CopyStr(Words.Get(1), 1, 3);
        //     end else begin
        //         // For multi-word names, use the first letter of each word
        //         Code := '';
        //         for i := 1 to Words.Count() do begin
        //             Word := Words.Get(i);
        //             Code += CopyStr(Word, 1, 1); // Take the first letter of each word
        //         end;
        //     end;

        //     exit(Code); // Return the formatted code
        // end;



    }

    trigger OnAfterGetRecord()
    begin
        // Ensure data is loaded into the subpage grid
        CurrPage."Unit all Details".Page.Update(); // Reload the grid data
    end;
}

