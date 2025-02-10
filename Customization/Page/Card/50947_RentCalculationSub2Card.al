page 50947 "Rent Calculation SubCard2"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Rent Calculation Subpage2";
    Caption = 'Rent Calculation Card';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Year"; Rec."Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Enter the Year.';
                }
                field("Installment No."; Rec."Installment No.")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment No.';
                }

                field("Installment Start Date"; Rec."Installment Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment Start Date';


                }

                field("Installment End Date"; Rec."Installment End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment End Date';
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';

                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    Visible = true;
                    Editable = false;

                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    Visible = true;

                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    Visible = false;

                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                }


                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                }


            }
            group(TotalAmount)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Amount';

                }
            }
        }
    }

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

    procedure SetProposalID(pProposalID: Integer)
    begin
        proposalID := pProposalID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;
    end;

    var
        ContractID: Integer;
        proposalID: Integer;
        tenantID: Code[20];



}


