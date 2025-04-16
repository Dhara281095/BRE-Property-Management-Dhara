page 50906 "Additional Charges Sub Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Additional Charges Sub";
    Caption = 'Termination Additional Charges';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ShowMandatory = true;
                    NotBlank = true;
                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(); // Refresh the page to apply changes immediately
                    end;
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Lookup = true;
                    Editable = false;
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Lookup = true;
                    Editable = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                }
                field("Invoiced ID"; Rec."Invoiced ID")
                {
                    ApplicationArea = All;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                }
            }

            group(TotalAmount)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Invoice)
            {
                ApplicationArea = All;
                Caption = 'Generate Invoice';
                Image = NewInvoice;
                trigger OnAction()
                var
                begin

                end;
            }
        }
    }

    procedure SetContractID(pContractID: Integer)
    begin
        contractID := pContractID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;


    procedure SetStartEndDate(pStartDate: Date; pEndDate: Date)
    begin
        startDate := pStartDate;
        endDate := pEndDate;

    end;

    procedure SetUnitType(punittype: Text[20])

    begin
        unittype := punittype;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;

        Rec."Start Date" := startDate;
        Rec."End Date" := endDate;
        Rec."Unit Type" := unittype;

        // Add this call to update totals
        // CurrPage.UPDATE;
        // UpdateParentPage();
        // exit(true);
    end;

    // Add this procedure to call back to the parent page
    // procedure UpdateParentPage()
    // var
    //     FinalCalculationCard: Page "Final Calculation Card";
    // begin
    //     CurrPage.UPDATE;
    //     if CurrPage.EDITABLE then begin
    //         FinalCalculationCard.UpdateTotalsFromSubpage();
    //     end;
    // end;


    var
        contractID: Integer;
        tenantID: Code[20];
        startDate: Date;
        endDate: Date;

        unittype: Text[20];

}




