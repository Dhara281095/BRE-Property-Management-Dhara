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

                            Rec."Property Name" := tenancyContract."Property Name";
                            Rec."Unit Name" := tenancyContract."Unit Name";
                            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
                            Rec."Contract Period" := Format(tenancyContract."Contract Start Date") + 'To' + Format(tenancyContract."Contract End Date");

                        end else begin
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
                }
                field("Customer P.O Date"; Rec."Customer P.O Date")
                {
                    ApplicationArea = All;
                    Caption = 'Customer P.O Date';
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

                TempBlob: Codeunit "Temp Blob";
                OutStream: OutStream;
                InStream: InStream;
                FileName: Text;
                FileExtension: Text;
                DocumentAttachment: Record "Document Attachment";
                ReportID: Integer; // Your report ID
                RecRef: RecordRef;
                FieldRef: FieldRef;
                MIMEType: Text[250];
                SystemIdFieldNo: Integer;

            begin

                FileExtension := '.pdf';
                ReportID := 50104;
                RecRef.Open(DATABASE::"Sales Header"); // Open the table reference
                RecRef.GetTable(Rec);
                TempBlob.CreateOutStream(OutStream);
                Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

                TempBlob.CreateInStream(InStream);
                FileName := 'Invoice_' + Rec."No." + FileExtension;
                MIMEType := GetMimeTypeFromFileName(FileName);
                SystemIdFieldNo := RecRef.SystemIdNo();
                FieldRef := RecRef.Field(SystemIdFieldNo);
                DocumentAttachment.Init();
                DocumentAttachment.SaveAttachmentFromStream(InStream, RecRef, FileName);
                DocumentAttachment."Record Id" := FieldRef.Value;
                DocumentAttachment."Table ID" := DATABASE::"Sales Header"; // Set to your table ID, for Sales Header
                DocumentAttachment."No." := Rec."No.";
                DocumentAttachment."Document Type" := DocumentAttachment."Document Type"::Invoice;
                DocumentAttachment."File Name" := FileName;
                DocumentAttachment."DocumentMedia".ImportStream(InStream, FileName);
                DocumentAttachment."Document BLOB".CreateInStream(InStream);
                DocumentAttachment."MIME Type" := MIMEType;
                DocumentAttachment.Modify();
            end;
        }


    }

    procedure GetMimeTypeFromFileName(FileName: Text): Text
    var
        FileExtension: Text;
    begin
        // Extract the file extension from the file name
        FileExtension := LowerCase(CopyStr(FileName, StrPos(FileName, '.'), StrLen(FileName) - StrPos(FileName, '.') + 1));

        case FileExtension of
            '.pdf':
                exit('application/pdf');
            '.jpg', '.jpeg':
                exit('image/jpeg');
            '.png':
                exit('image/png');
            '.gif':
                exit('image/gif');
            '.txt':
                exit('text/plain');
            '.doc', '.docx':
                exit('application/msword');
            '.xls', '.xlsx':
                exit('application/vnd.ms-excel');
            '.ppt', '.pptx':
                exit('application/vnd.ms-powerpoint');
            '.zip':
                exit('application/zip');
            '.rar':
                exit('application/x-rar-compressed');
            '.csv':
                exit('text/csv');
            '.json':
                exit('application/json');
            '.xml':
                exit('application/xml');
            '.html', '.htm':
                exit('text/html');
            '.mp4':
                exit('video/mp4');
            '.mp3':
                exit('audio/mpeg');
            '.wav':
                exit('audio/wav');
            '.avi':
                exit('video/x-msvideo');
            '.exe':
                exit('application/x-msdownload');
            else
                exit('application/octet-stream'); // Default MIME type for unknown files
        end;
    end;




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

}

