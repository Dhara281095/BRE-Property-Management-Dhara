page 50903 "Final Calculation Card"
{
    PageType = Card;
    SourceTable = "Final Calculation";
    ApplicationArea = All;
    Caption = 'Final Calculation Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Contract Details")
            {


                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing

                }

                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                    Editable = false;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                    Editable = false;
                }

                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type';
                    ToolTip = 'Enter the Unit Type.';
                    Editable = false;
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    ToolTip = 'Enter the Contract Amount.';
                    Editable = false;
                }


                field("Intimation Date"; Rec."Intimation Date")
                {
                    ApplicationArea = All;
                    Caption = 'Intimation Date';
                    ToolTip = 'Enter the Initmation Date.';

                }


                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    ToolTip = 'Enter the Termination Date.';

                    trigger OnValidate()
                    var
                        TerminateDate: Date;
                        DaysCal: Integer;
                        StartDate: Date;
                        FinalCalculation: Record "Final Calculation";

                    begin
                        FinalCalculation.SetRange("FC ID", Rec."FC ID");
                        FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                        if FinalCalculation.FindFirst() then begin

                            StartDate := Rec."Contract Start Date";
                            TerminateDate := Rec."Termination Date";
                            DaysCal := TerminateDate - StartDate + 1;
                            Rec."Actual Contract Tenure" := DaysCal;
                            Rec.Modify();

                        end;
                        // CurrPage.Update();

                        GetContractTerminationYear();

                        Fetchperdayrent();
                        PopulateRevenueCalculationGrid();
                        GetDataTenancyContract();
                        BillingCalcGridRentCalc();
                        BillingCalcridTenancyContractSubpge();
                        RentCalculate();
                        OtherPaymentCalculate();
                        RevenueCalculateOneTime();
                        RevenueCalculate();
                    end;
                }
                field("ContractYear(Termination Date)"; Rec."ContractYear(Termination Date)")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Year On Termination Date';
                    ToolTip = 'Enter the ContractYear(Termination Date).';
                    Editable = false;

                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Editable = false;

                }
                field("Original Contract Tenure"; Rec."Original Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Original Contract Tenure';
                    ToolTip = 'Enter the Original Contract Tenure.';
                    Editable = false;
                }

                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Contract Tenure';
                    ToolTip = 'Enter the Actual Contract Tenure.';
                    Editable = false;
                }

                field("Total No. Of Days"; Rec."Total No. Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Total No. Of Days(Termination Year)';
                    ToolTip = 'Enter the Total No. Of Days.';
                    Editable = false;
                }

                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent(Termination Year)';
                    ToolTip = 'Enter the Per Day Rent.';
                    Editable = false;
                }
                field("Annual Rent Amount TermiYear"; Rec."Annual Rent Amount TermiYear")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount of Termination Year';
                    Editable = false;
                }

                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                }
            }

            group("Final Revenue Calculation")
            {
                part("FinalRevenueCalculation"; "Final Revenue Calculation Grid")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID");
                    ApplicationArea = All;


                }
            }
            group("Billing Calculation")
            {
                part("BillingCalculation"; "Final Billing Calculation")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID");
                    ApplicationArea = All;
                }
            }

            group("Pending receivable/Payable")
            {
                part("Pendingreceivable/Payable"; "Pending Recevieable Grid")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID");
                    ApplicationArea = All;
                }
            }
            group("Termination Additional Charges")
            {
                part("Additional Charges"; "Additional Charges Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }


            group("Rent-Calculation")
            {

                part("Rent Calculation"; "Rent Calculate Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Revenue-structure")
            {

                part("Other Payment"; "OtherPayment Calculate SubCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Revenue structure - Yearly break-down")
            {

                part("Revenue Structure"; "Revenue Calculate Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Payment Details")
            {

                part("PaymentSchedule"; "Payment Schedule Card2")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                  "Tenant ID" = FIELD("Tenant ID");
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FinalCalculation)
            {
                ApplicationArea = All;
                Caption = 'Final Calculation';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SecurityDepositEntry: Record "Approval Final Calculation";
                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    // Create new entry
                    SecurityDepositEntry.Init();
                    SecurityDepositEntry."ID" := Rec."FC ID";
                    SecurityDepositEntry."Contract ID" := Rec."Contract ID";
                    SecurityDepositEntry."Tenant ID" := Rec."Tenant ID";
                    SecurityDepositEntry."Status" := Rec."Status";
                    SecurityDepositEntry."Contract Start Date" := Rec."Contract Start Date";
                    SecurityDepositEntry."Contract End Date" := Rec."Contract End Date";
                    SecurityDepositEntry."Termination Date" := Rec."Termination Date";
                    SecurityDepositEntry.Insert(true);

                    Message('Entry posted successfully!');

                    // Open the entries list
                    // Page.Run(Page::"Security Deposit Entries");
                end;
            }
        }
    }


    //////////////////  START Final Revenue Calculation Grid ////////////////////
    procedure PopulateRevenueCalculationGrid()
    var
        FinalCalcHeader: Record "Final Calculation";
        FinalRevCalcGrid: Record "Final Revenue Calculation Grid";
        RentCalc: Record "Rent Calculation";
        TenancyContractLine: Record "Tenancy Contract Subpage";
    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        FinalRevCalcGrid.SetRange("Contract ID", Rec."Contract ID");
        if FinalRevCalcGrid.FindSet() then begin
            FinalRevCalcGrid.DeleteAll();
        end;

        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc.SetRange("Contract ID", Rec."Contract ID");
        if RentCalc.FindSet() then begin
            repeat
                FinalRevCalcGrid.Init();
                FinalRevCalcGrid."Contract ID" := RentCalc."Contract ID";
                FinalRevCalcGrid."Revenue Description" := RentCalc."Secondary Item Type";
                FinalRevCalcGrid."Original Amount" := RentCalc."Amount";
                FinalRevCalcGrid."Original VAT" := RentCalc."VAT Amount";
                FinalRevCalcGrid."Original Amount Incl." := RentCalc."Amount Including VAT";
                FinalRevCalcGrid."Actual Contract Tenure" := Rec."Actual Contract Tenure";
                // FinalRevCalcGrid."Per Day Rent" := Rec."Per Day Rent";
                FinalRevCalcGrid."ContractYear(Termination Date)" := Rec."ContractYear(Termination Date)";
                // FinalRevCalcGrid."Annual Rent Amount TermiYear" := Rec."Annual Rent Amount TermiYear";
                FinalRevCalcGrid."Total No. Of Days" := Rec."Total No. Of Days";
                FinalRevCalcGrid.Insert();
                Clear(FinalRevCalcGrid);
            until RentCalc.Next() = 0;
        end;

    end;


    procedure GetDataTenancyContract()
    var
        FinalRevCalcGrid1: Record "Final Revenue Calculation Grid";
        TenancyContractLine1: Record "Tenancy Contract Subpage";

    begin

        // TenancyContractLine.Reset();
        TenancyContractLine1.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractLine1.FindSet() then begin
            repeat
                FinalRevCalcGrid1.Init();
                FinalRevCalcGrid1."Contract ID" := Rec."Contract ID";
                FinalRevCalcGrid1."Revenue Description" := TenancyContractLine1."Secondary Item Type";
                FinalRevCalcGrid1."Original Amount" := TenancyContractLine1.Amount;

                // Calculate VAT amount based on percentage
                FinalRevCalcGrid1."Original VAT" := TenancyContractLine1."VAT Amount";

                FinalRevCalcGrid1."Original Amount Incl." := TenancyContractLine1."Amount Including VAT";
                FinalRevCalcGrid1."Actual Contract Tenure" := Rec."Actual Contract Tenure";
                //   FinalRevCalcGrid1."Per Day Rent" := Rec."Per Day Rent";
                FinalRevCalcGrid1."ContractYear(Termination Date)" := Rec."ContractYear(Termination Date)";
                //  FinalRevCalcGrid1."Annual Rent Amount TermiYear" := Rec."Annual Rent Amount TermiYear";
                FinalRevCalcGrid1."Total No. Of Days" := Rec."Total No. Of Days";
                FinalRevCalcGrid1.Insert();
                Clear(FinalRevCalcGrid1);
            until TenancyContractLine1.Next() = 0;
        end;
    end;


    procedure GetContractTerminationYear()
    var
        ContractStartDate: Date;
        ContractEndDate: Date;
        YearStartDate: Date;
        YearEndDate: Date;
        YearNumber: Integer;
        StartYear: Integer;
        UserYear: Integer;
        FinalCalculation: Record "Final Calculation";
        RentCalculation: Record "Rent Calculation";
        RentCalculationSub: Record "Rent Calculation Subpage";
        Terminationdate: Date;
        Perdayrent: Decimal;

    begin
        UserYear := 0;
        Terminationdate := Rec."Termination Date";
        RentCalculationSub.SetRange("Contract ID", Rec."Contract ID");
        if RentCalculationSub.FindSet() then begin
            repeat


                if (Terminationdate >= RentCalculationSub."Period Start Date") and (Terminationdate <= RentCalculationSub."Period End Date") then
                    UserYear := RentCalculationSub.Year;
            until (RentCalculationSub.Next() = 0) or (UserYear <> 0);
        end;
        Rec."ContractYear(Termination Date)" := UserYear;
        Rec.Modify();
    end;

    procedure Fetchperdayrent()
    var
        RentCalculation1: Record "Rent Calculation Subpage";
        DifferenceDays: Integer;
    begin
        RentCalculation1.SetRange("Contract ID", Rec."Contract ID");
        RentCalculation1.SetRange("Year", Rec."ContractYear(Termination Date)");

        if RentCalculation1.FindSet() then
            repeat
                Rec."Per Day Rent" := RentCalculation1."Per Day Rent";
                DifferenceDays := Rec."Termination Date" - RentCalculation1."Period Start Date";
                Rec."Total No. Of Days" := DifferenceDays + 1;
                Rec."Annual Rent Amount TermiYear" := RentCalculation1."Final Annual Amount";
                Rec.Modify();
            until RentCalculation1.Next() = 0;
    end;



    procedure RentCalculate()
    var
        RentCalculationSub: Record "Rent Calculation Subpage";
        RentCalculate: Record "Rent Calculate Sub";
    begin


        RentCalculate.SetRange("Contract ID", Rec."Contract ID");
        if RentCalculate.FindSet() then begin
            RentCalculate.DeleteAll();
        end;

        // TenancyContractLine.Reset();
        RentCalculationSub.SetRange("Contract ID", Rec."Contract ID");
        RentCalculationSub.SetRange("Tenant ID", Rec."Tenant ID");
        if RentCalculationSub.FindSet() then begin
            repeat
                RentCalculate.Init();
                RentCalculate."Contract ID" := Rec."Contract ID";
                RentCalculate."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                RentCalculate."Year" := RentCalculationSub."Year";
                RentCalculate."Period Start Date" := RentCalculationSub."Period Start Date";
                RentCalculate."Period End Date" := RentCalculationSub."Period End Date";
                RentCalculate."Number Of Days" := RentCalculationSub."Number Of Days";
                RentCalculate."Final Annual Amount" := RentCalculationSub."Final Annual Amount";
                RentCalculate."Per Day Rent" := RentCalculationSub."Per Day Rent";
                RentCalculate.Insert();
                Clear(RentCalculate);
            until RentCalculationSub.Next() = 0;
        end;

    end;




    procedure RevenueCalculateOneTime()
    var
        TenancyContractSub: Record "Tenancy Contract Subpage";
        //PaymentSchedule2: Record "Payment Schedule2";
        RevenueCalculate: Record "Revenue Calculate Sub";

    begin

        RevenueCalculate.SetRange("Contract ID", Rec."Contract ID");
        if RevenueCalculate.FindSet() then begin
            RevenueCalculate.DeleteAll();
        end;

        TenancyContractSub.SetRange("ContractID", Rec."Contract ID");
        TenancyContractSub.SetRange("TenantID", Rec."Tenant ID");

        TenancyContractSub.SetRange("Payment Type", 1);
        if TenancyContractSub.FindSet() then
            repeat
                RevenueCalculate.Init();
                RevenueCalculate."Contract ID" := TenancyContractSub."ContractID";
                RevenueCalculate."Tenant ID" := TenancyContractSub."TenantId";
                RevenueCalculate."Secondary Item Type" := TenancyContractSub."Secondary Item Type";
                RevenueCalculate.Amount := TenancyContractSub.Amount;
                RevenueCalculate."VAT Amount" := TenancyContractSub."VAT Amount";
                RevenueCalculate."Amount Including VAT" := TenancyContractSub."Amount Including VAT";
                RevenueCalculate."Installment Start Date" := TenancyContractSub."Start Date";
                RevenueCalculate."Installment End Date" := TenancyContractSub."End Date";
                RevenueCalculate.Insert();
                Clear(RevenueCalculate);
            until TenancyContractSub.Next() = 0;
    end;

    procedure RevenueCalculate()
    var
        RevenueStructureSubpage: Record "Revenue Structure Subpage";
        RevenueCalculateSub: Record "Revenue Calculate Sub";
    begin

        RevenueCalculateSub.SetRange("Contract ID", Rec."Contract ID");
        if RevenueCalculateSub.FindSet() then begin
            RevenueCalculateSub.DeleteAll();
        end;

        // TenancyContractLine.Reset();
        RevenueStructureSubpage.SetRange("Contract ID", Rec."Contract ID");
        RevenueStructureSubpage.SetRange("Tenant ID", Rec."Tenant ID");
        if RevenueStructureSubpage.FindSet() then begin
            repeat
                RevenueCalculateSub.Init();
                RevenueCalculateSub."Contract ID" := Rec."Contract ID";
                RevenueCalculateSub."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                RevenueCalculateSub."Secondary Item Type" := RevenueStructureSubpage."Secondary Item Type";
                RevenueCalculateSub."Amount" := RevenueStructureSubpage."Final Annual Amount";
                RevenueCalculateSub."VAT Amount" := RevenueStructureSubpage."VAT Amount";
                RevenueCalculateSub."Amount Including VAT" := RevenueStructureSubpage."Amount Including VAT";
                RevenueCalculateSub."Installment Start Date" := RevenueStructureSubpage."Period Start Date";
                RevenueCalculateSub."Installment End Date" := RevenueStructureSubpage."Period End Date";
                RevenueCalculateSub.Insert();
                Clear(RevenueCalculateSub);
            until RevenueStructureSubpage.Next() = 0;
        end;

    end;

    procedure OtherPaymentCalculate()
    var
        TenancyContractSub: Record "Tenancy Contract Subpage";
        OtherPaymentCalculate: Record "Other Payment Calculate Sub";

    begin

        OtherPaymentCalculate.SetRange("Contract ID", Rec."Contract ID");
        if OtherPaymentCalculate.FindSet() then begin
            OtherPaymentCalculate.DeleteAll();
        end;

        // TenancyContractLine.Reset();
        TenancyContractSub.SetRange("ContractID", Rec."Contract ID");
        TenancyContractSub.SetRange("TenantID", Rec."Tenant ID");
        if OtherPaymentCalculate.FindSet() then begin
            repeat
                OtherPaymentCalculate.Init();
                OtherPaymentCalculate."Contract ID" := Rec."Contract ID";
                OtherPaymentCalculate."Tenant ID" := Rec."Tenant ID";
                OtherPaymentCalculate."Secondary Item Type" := TenancyContractSub."Secondary Item Type";
                OtherPaymentCalculate."Amount" := TenancyContractSub."Amount";
                OtherPaymentCalculate."VAT Amount" := TenancyContractSub."VAT Amount";
                OtherPaymentCalculate."Amount Including VAT" := TenancyContractSub."Amount Including VAT";
                OtherPaymentCalculate."Start Date" := TenancyContractSub."Start Date";
                OtherPaymentCalculate."End Date" := TenancyContractSub."End Date";
                OtherPaymentCalculate.Insert();
                Clear(OtherPaymentCalculate);
            until OtherPaymentCalculate.Next() = 0;
        end;

    end;


    trigger OnAfterGetRecord()
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."Contract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
    end;


    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."Contract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."Contract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
    end;

    procedure BillingCalcGridRentCalc()
    var

        BillinCalcGrid: Record "Final Billing Calculation Grid";
        RentCalc1: Record "Rent Calculation";

    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        BillinCalcGrid.SetRange("Contract ID", Rec."Contract ID");
        if BillinCalcGrid.FindSet() then begin
            BillinCalcGrid.DeleteAll();
        end;

        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc1.SetRange("Contract ID", Rec."Contract ID");
        if RentCalc1.FindSet() then begin
            repeat
                BillinCalcGrid.Init();
                BillinCalcGrid."Contract ID" := RentCalc1."Contract ID";
                BillinCalcGrid."RevenueDescription" := RentCalc1."Secondary Item Type";

                BillinCalcGrid.Insert();
                Clear(BillinCalcGrid);
            until RentCalc1.Next() = 0;
        end;

    end;


    procedure BillingCalcridTenancyContractSubpge()
    var
        BillingCalc1: Record "Final Billing Calculation Grid";
        TenancyContractLine2: Record "Tenancy Contract Subpage";

    begin

        // TenancyContractLine.Reset();
        TenancyContractLine2.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractLine2.FindSet() then begin
            repeat
                BillingCalc1.Init();
                BillingCalc1."Contract ID" := Rec."Contract ID";
                BillingCalc1."RevenueDescription" := TenancyContractLine2."Secondary Item Type";

                BillingCalc1.Insert();
                Clear(BillingCalc1);
            until TenancyContractLine2.Next() = 0;
        end;
    end;

}