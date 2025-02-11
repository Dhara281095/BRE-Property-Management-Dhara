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
                    Editable = true;
                    //Editable = approvaleditable;
                    trigger OnValidate()
                    var
                        tenancyContract: Record "Tenancy Contract";
                    begin
                        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
                        if tenancyContract.FindFirst() then begin
                            Rec."Tenant Name" := tenancyContract."Customer Name";
                            Rec."Property Name" := tenancyContract."Property Name";
                            Rec."Unit Name" := tenancyContract."Unit Name";
                            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
                            Rec."Contract Period" := Format(tenancyContract."Contract Start Date") + 'To' + Format(tenancyContract."Contract End Date");

                        end else begin
                            Rec."Tenant Name" := '';
                            rec."Property Name" := '';
                            Rec."Unit Name" := '';
                            Rec."Contract Tenure" := '';
                            Rec."Contract Period" := ''

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
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer P.O"; Rec."Customer P.O")
                {
                    ApplicationArea = All;
                    Caption = 'Customer P.O';
                    Editable = NotAccessFieldFM;
                }
                field("Customer P.O Date"; Rec."Customer P.O Date")
                {
                    ApplicationArea = All;
                    Caption = 'Customer P.O Date';
                    Editable = NotAccessFieldFM;
                }
                field("Contract Period"; Rec."Contract Period")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Period';
                    Editable = false;
                }
                field("Reason for Rejection"; Rec."Reason for Rejection")
                {
                    Caption = 'Reason For Rejection';
                    ApplicationArea = All;
                    Editable = approvaleditable;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    ApplicationArea = All;
                    Editable = approvaleditable;
                    //Editable = true;
                }


            }
        }

        addlast(General)
        {
            field("View Document URL"; Rec."View Document URL")
            {
                ApplicationArea = All;
                Caption = 'View Document URL';
            }
            field("View Invoice"; Rec."View Invoice")
            {
                ApplicationArea = All;
                Caption = 'View Invoice';
                Editable = false;
                DrillDown = true;
                trigger OnDrillDown()
                var
                    FileURL: Text;
                begin
                    // Get the URL of the uploaded document
                    FileURL := Rec."View Document URL";

                    // Check if the file URL is not empty
                    if FileURL = '' then
                        Error('No document is available to view.');

                    // Open the file URL in the browser (new tab)
                    OpenFileInBrowser(FileURL);
                end;

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
        addafter(Action9)
        {
            action(ResendForApproval)
            {
                ApplicationArea = All;
                Caption = 'Resend For Approval';
                Image = SendMail;


                trigger OnAction()
                var
                    ResendInvoiceMail: Codeunit ResendUpdateInvoiceFM;
                begin
                    ResendInvoiceMail.ResendUpdateInvoice(Rec);
                end;
            }
        }

        modify(Post)
        {
            trigger OnBeforeAction()
            var
                AzureBlobUploader: Codeunit "Azure Blob Management";
                InStream: InStream;
                FileName: Text;
                SASUrlBase: Text;
                SASUrlWithFileName: Text;
                UploadResult: Text;
                TempBlob: Codeunit "Temp Blob";
                ValidFormats: List of [Text];
                FileExtension: Text[10];
                FileSize: Decimal;
                ConfigRecord: Record AzureConfiguration;
                ReportID: Integer; // Your report ID
                RecRef: RecordRef;
                OutStream: OutStream;
                documentattachment: Codeunit UploadAttachment;
            begin

                if not ConfigRecord.FindFirst() then
                    Error('Azure configuration is missing. Please set up the SAS URL in the Azure Configuration table.');
                // Error('formate validate enter');
                // Message('formate validate enter');
                // Allowed file formats
                ValidFormats.Add('.png');
                ValidFormats.Add('.jpg');
                ValidFormats.Add('.jpeg');
                // Error('formate validate');
                // Message('formate validate');

                SASUrlBase := ConfigRecord."SAS URL";
                FileExtension := '.pdf';
                ReportID := 50104;
                RecRef.Open(DATABASE::"Sales Header"); // Open the table reference
                RecRef.GetTable(Rec);
                TempBlob.CreateOutStream(OutStream);
                Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

                TempBlob.CreateInStream(InStream);
                FileName := 'Invoice_' + Rec."No." + FileExtension;
                // FileName := 'SalesInvoice' + FileExtension;
                SASUrlWithFileName := StrSubstNo('%1/%2?%3', CopyStr(SASUrlBase, 1, StrPos(SASUrlBase, '?') - 1), FileName, CopyStr(SASUrlBase, StrPos(SASUrlBase, '?') + 1));


                // Call the upload function with the modified SAS URL
                UploadResult := documentattachment.UploadDocumentToBlobStorage(SASUrlWithFileName, FileName, InStream);
                Rec."View Invoice" := FileName;
                Rec."View Document URL" := UploadResult;
                Rec.Modify();
            end;
        }


    }




    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure GetUserEditableStatus(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin

        if UserPersonalization.Get(UserSecurityId()) then begin

            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'LEASE_MANAGER':
                    exit(false);
                'finance manager':
                    exit(true);
            end;
        end;

        exit(false);
    end;

    procedure NotAccessFieldFinanceManager(): Boolean
    var
        UserPersonalization1: Record "User Personalization";
    begin

        if UserPersonalization1.Get(UserSecurityId()) then begin

            case UserPersonalization1."Profile ID" of
                'PROPERTY MANAGER':
                    exit(true);
                'LEASE_MANAGER':
                    exit(true);
                'finance manager':
                    exit(false);
            end;
        end;

        exit(false);
    end;

    trigger OnAfterGetRecord()
    var
        tenancyContract: Record "Tenancy Contract";
        customer: Record Customer;
        salesline: Record "Sales Line";
        VATPostingSetup: Record "VAT Posting Setup";


    begin
        approvaleditable := GetUserEditableStatus();
        NotAccessFieldFM := NotAccessFieldFinanceManager();
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
            Rec."Contract Period" := Format(tenancyContract."Contract Start Date") + ' To ' + Format(tenancyContract."Contract End Date")
        end else begin

            rec."Property Name" := '';
            Rec."Unit Name" := '';
            Rec."Contract Tenure" := '';
            Rec."Contract Period" := '';
        end;


    end;


    var
        approvaleditable: Boolean;
        NotAccessFieldFM: Boolean;

}

