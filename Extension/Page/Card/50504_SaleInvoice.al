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
                    // Editable = false;
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

                        end;
                    end;
                }
                field("Property Name"; Rec."Property Name")
                {
                    Caption = 'Property Name';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    Caption = 'Unit Name';
                    ApplicationArea = All;
                }
                field("Contract Tenure"; Rec."Contract Tenure")
                {
                    Caption = 'Contract Tenure';
                    ApplicationArea = All;
                }
                field("Sell-to Phone No."; Rec."Sell-to Phone No.")
                {
                    Caption = 'Customer Phone No.';
                    ApplicationArea = All;
                }
                field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
                {
                    Caption = 'Customer Email';
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    ApplicationArea = All;
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

    trigger OnAfterGetRecord()
    var
        tenancyContract: Record "Tenancy Contract";
        customer: Record Customer;
        salesline: Record "Sales Line";
        VATPostingSetup: Record "VAT Posting Setup";

    begin
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




}

