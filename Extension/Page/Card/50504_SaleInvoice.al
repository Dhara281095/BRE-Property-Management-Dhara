pageextension 50504 SalesInvoice extends "Sales Invoice"
{

    layout
    {
        addafter(General)
        {
            group("Contract Details")
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    var
                        tenancyContract: Record "Tenancy Contract";
                    begin
                        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
                        if tenancyContract.FindFirst() then begin

                            Rec."Property Name" := tenancyContract."Property Name";
                            Rec."Unit Name" := tenancyContract."Unit Name";
                            Rec."Contract Tenure" := tenancyContract."Contract Tenor";

                        end else begin
                            rec."Property Name" := '';
                            Rec."Unit Name" := '';
                            Rec."Contract Tenure" := '';
                            // Rec."Tenant Name" := '';

                        end;
                    end;
                }
                field("Property Name"; Rec."Property Name")
                {
                    Caption = 'Property Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    Caption = 'Unit Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Tenure"; Rec."Contract Tenure")
                {
                    Caption = 'Contract Tenure';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Phone No."; Rec."Sell-to Phone No.")
                {
                    Caption = 'Customer Phone No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
                {
                    Caption = 'Customer Email';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    ApplicationArea = All;
                    Editable = approvaleditable;
                    //Editable = true;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        addafter(Release)
        {
            action("Run Report")
            {
                Caption = 'Run Report';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesInvoice: Record "Sales Header";
                    SalesInvoiceReport: Report InvoiceTemplate; // Replace with your report name or ID
                begin
                    // Commit the transaction to avoid conflicts
                    Commit();

                    // Set a specific filter on the report
                    SalesInvoice.SetRange("No.", Rec."No."); // Example: Apply filter on "No."

                    // Apply the filtered record to the report and run it
                    SalesInvoiceReport.SetTableView(SalesInvoice);
                    SalesInvoiceReport.Run();
                end;
            }
        }
    }

    procedure GetUserEditableStatus(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin

        if UserPersonalization.Get(UserSecurityId()) then begin
            // Assuming the role is stored in the "Profile ID" field as seen in the screenshot
            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'finance manager':
                    exit(true);
            end;
        end;

        exit(false); // Default to not editable if the role is neither Property Manager nor Accounting Manager
    end;

    // trigger OnOpenPage()
    // var
    // begin
    //     approvaleditable := GetUserEditableStatus();
    // end;

    trigger OnAfterGetRecord()
    var
        tenancyContract: Record "Tenancy Contract";
        customer: Record Customer;
        salesline: Record "Sales Line";
        VATPostingSetup: Record "VAT Posting Setup";


    begin
        approvaleditable := GetUserEditableStatus();
        customer.SetRange("No.", Rec."Sell-to Customer No.");
        if customer.FindSet() then begin
            Rec."Sell-to Customer Name" := customer.Name;
            Rec."Sell-to Address" := customer.Address;
            Rec."Gen. Bus. Posting Group" := customer."Gen. Bus. Posting Group";
            Rec."VAT Bus. Posting Group" := customer."VAT Bus. Posting Group";
            Rec."Customer Posting Group" := customer."Customer Posting Group";
            Rec."Sell-to Phone No." := customer."Phone No.";
            Rec."Sell-to E-Mail" := customer."E-Mail";
            Rec."Bill-to Customer No." := customer."No.";
            Rec."Bill-to Name" := customer.Name;
            Rec."Bill-to Address" := customer.Address;
            Rec.Modify();

        end;

        salesline.SetRange("Document No.", Rec."No.");
        if salesline.FindSet() then
            repeat

                salesline."Gen. Bus. Posting Group" := Rec."Gen. Bus. Posting Group";
                salesline."Customer Price Group" := Rec."Customer Price Group";
                salesline."VAT Bus. Posting Group" := Rec."VAT Bus. Posting Group";

                salesline.Modify();
            until salesline.Next() = 0;




        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
        if tenancyContract.FindFirst() then begin

            Rec."Property Name" := tenancyContract."Property Name";
            Rec."Unit Name" := tenancyContract."Unit Name";
            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
        end else begin

            rec."Property Name" := '';
            Rec."Unit Name" := '';
            Rec."Contract Tenure" := '';

        end;


    end;


    var
        approvaleditable: Boolean;

}

