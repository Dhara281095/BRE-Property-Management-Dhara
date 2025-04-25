page 50966 "Credit Note Card"
{
    PageType = Card;
    SourceTable = "Credit Note";
    ApplicationArea = All;
    Caption = 'Credit Note Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Contract Details")
            {
                field("Credit Note Type"; Rec."Credit Note Type")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note Type';
                    ToolTip = 'Enter the Credit Note Type.';
                    Editable = false;
                }
                // field("TerminationCreditNoteType"; Rec."TerminationCreditNoteType")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Credit Note Type';
                //     ToolTip = 'Enter the Credit Note Type.';
                //     Editable = false;
                //     Visible = ShowTermination;
                // }

                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    TableRelation = "Tenancy Contract"."Contract ID";

                    trigger OnValidate()
                    var
                        TenancyContract: Record "Tenancy Contract";
                    begin
                        TenancyContract.SetRange("Contract ID", Rec."Contract ID");
                        if TenancyContract.FindSet() then begin
                            Rec."Credit Note Type" := Rec."Credit Note Type"::"Standard Credit Note";
                            Rec."Contract Start Date" := TenancyContract."Contract Start Date";
                            Rec."Contract End Date" := TenancyContract."Contract End Date"; // Convert Integer to Text
                            Rec."Unit Type" := TenancyContract."Unit Type";
                            Rec."Contract Amount" := TenancyContract."Annual Rent Amount";
                            Rec."Tenant ID" := TenancyContract."Tenant ID";
                            Rec."Tenant Name" := TenancyContract."Customer Name";
                            Rec."Tenant Email" := TenancyContract."Email Address"; // Convert Integer to Text
                        end else begin // Clear the fields if no record is found
                            Rec."Credit Note Type" := Rec."Credit Note Type"::"Standard Credit Note";
                            Rec."Contract Start Date" := 0D;
                            Rec."Contract End Date" := 0D; // Convert Integer to Text
                            Rec."Unit Type" := '';
                            Rec."Contract Amount" := 0;
                            Rec."Tenant ID" := '';
                            Rec."Tenant Name" := '';
                            Rec."Tenant Email" := ''; // Convert Integer to Text
                        end;

                    end;
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
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                }

            }
            group("Customer Details")
            {
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Email';
                    Editable = false;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false;
                }
            }
            field("Invoice ID"; Rec."Invoice ID")
            {
                ApplicationArea = All;
                Caption = 'Invoice ID';
            }
            field("Amount"; Rec."Amount")
            {
                ApplicationArea = All;
                Caption = 'Credit Note Amount';
            }
            group("Credit-Note Details")
            {
                part("Invoice-CreditNote"; "Invoice-Credit Note Card")
                {
                    SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Generate Credit-Note Details")
            {
                part("Final Invoice-CreditNote"; "Filtered Invoice Detail Card")
                {
                    SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
        }
    }

}

