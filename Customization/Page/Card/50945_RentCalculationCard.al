page 50945 "Rent Calculation Card"
{
    PageType = Card;
    SourceTable = "Rent Calculation";
    ApplicationArea = All;
    Caption = 'Rent Calculation Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {


                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                }

                // field("Proposal ID"; Rec."Proposal ID")
                // {
                //     ApplicationArea = All;
                //     Editable = false; // The ID is not editable since it's auto-incrementing
                //     Lookup = true;
                // }

                field("RC ID"; Rec."RC ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Enter the Amount.';
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                }

                field("Number of Installments"; Rec."Number of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                    ToolTip = 'Enter the Number of Instalments.';
                    Editable = false;
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT Amount.';
                    // Visible = false;
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the Amount Including VAT.';
                    // Visible = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Visible = false;

                }
                field("Rent Calculation Type"; Rec."Rent Calculation Type")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Calculation Type';
                    ToolTip = 'Enter the Rent Calculation Type.';
                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                }




            }


            group("Payment Schedule")
            {
                part("Rent Calculation"; "Rent Calculation SubCard")
                {
                    SubPageLink = "RC ID" = FIELD("RC ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Rent Payment Schedule")
            {
                part("Rent Calculation2";
                "Rent Calculation SubCard2")
                {
                    SubPageLink = "RC ID" = FIELD("RC ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
        }
    }


    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     CalculateAndSetTotalAmount();
    // end;



    // local procedure CalculateTotals()
    // var
    //     RevenueStructureRec: Record "Revenue Structure Subpage"; // Ensure this matches the actual subpage table name
    //     TotalAmount: Integer;
    // begin
    //     // Initialize totals to zero
    //     TotalAmount := 0;
    //     // TotalAnnualAmount := 0;
    //     // TotalRoundOff := 0;

    //     // Filter records by Proposal ID
    //     RevenueStructureRec.SetRange("Proposal ID", Rec."Proposal ID");

    //     // Calculate totals for filtered records
    //     if RevenueStructureRec.FindSet() then
    //         repeat
    //             TotalAmount += RevenueStructureRec."Final Annual Amount"; // Replace with correct field names
    //                                                                       // TotalAnnualAmount += SingleUnitRentRec."Annual Amount";
    //                                                                       // TotalRoundOff += SingleUnitRentRec."Round Off";
    //         until RevenueStructureRec.Next() = 0;

    //     // Update the current record fields
    //     Rec."Total Amount" := TotalAmount;
    //     // Rec.TotalAnnualAmount := TotalAnnualAmount;
    //     // Rec.TotalRoundOff := TotalRoundOff;

    //     // Save changes
    //     Rec.Modify(false);
    // end;





}