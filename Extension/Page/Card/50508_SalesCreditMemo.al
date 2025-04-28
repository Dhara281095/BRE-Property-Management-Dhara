pageextension 50508 SalesCreditMemo extends "Sales Credit Memo"
{
    layout
    {
        addafter(General)
        {
            group("Contract Information")
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ID of the contract related to this credit memo.';
                    trigger OnValidate()
                    var
                        tenancyContract: Record "Tenancy Contract";
                        customercard: Record Customer;
                    begin
                        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
                        if tenancyContract.FindFirst() then begin
                            Rec."Tenant Name" := tenancyContract."Customer Name";
                            Rec."Property Name" := tenancyContract."Property Name";
                            Rec."Unit Name" := tenancyContract."Unit Name";
                            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
                            Rec."Contract Period" := Format(tenancyContract."Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>') + ' To ' + Format(tenancyContract."Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
                            Rec."Property Classification" := tenancyContract."Property Classification";
                        end else begin
                            Rec."Tenant Name" := '';
                            rec."Property Name" := '';
                            Rec."Unit Name" := '';
                            Rec."Contract Tenure" := '';
                            Rec."Contract Period" := '';
                            Rec."Property Classification" := '';

                            // Rec."Tenant Name" := '';

                        end;
                    end;

                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property related to this credit memo.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the unit related to this credit memo.';
                }
                field("Contract Tenure"; Rec."Contract Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tenure of the contract related to this credit memo.';
                }
                field("Contract Period"; Rec."Contract Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Period of the contract related to this credit memo.';
                }
                field("Property Classification"; Rec."Property Classification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Classification of the property related to this credit memo.';
                }
                field("Approval Status for CreditNote"; Rec."Approval Status for CreditNote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approval status of the credit note.';
                    Caption = 'Approval Status Credit Note';
                    // Editable = approvaleditable;
                }
                field("Rejection Reason CreditNote"; Rec."Rejection Reason CreditNote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Reason for rejection of the credit note.';
                    // Editable = approvaleditable;
                }


            }



        }
        addlast(General)
        {
            field("Credit Memo URL"; Rec."Credit Memo URL")
            {
                ApplicationArea = All;
                Caption = 'Credit Memo Document URL';
            }
            field("Credit Memo Document"; Rec."Credit Memo Document")
            {
                ApplicationArea = All;
                Caption = 'View Invoice';
                Editable = false;
                DrillDown = true;
                trigger OnDrillDown()
                var
                    FileURL: Text;
                begin

                    FileURL := Rec."Credit Memo URL";


                    if FileURL = '' then
                        Error('No document is available to view.');


                    OpenFileInBrowser(FileURL);
                end;

            }
        }


    }
    actions
    {
        addafter(Action7)
        {
            action("Send Approval to Finance Manager")
            {
                ApplicationArea = All;
                Caption = 'Send Approval to Finance Manager';
                trigger OnAction()
                var
                    sendMailToFMCreditNote: Codeunit "Send Mail to FM Credit Note";
                begin
                    sendMailToFMCreditNote.SendMailToFM(Rec);
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
                FieldRef1: FieldRef;
                FieldRef2: FieldRef;
                OutStream: OutStream;
                documentattachment: Codeunit UploadAttachment;
                SalesHeader1: Record "Sales Header";
                customercard: Record Customer;
            begin

                if not ConfigRecord.FindFirst() then
                    Error('Azure configuration is missing. Please set up the SAS URL in the Azure Configuration table.');
                ValidFormats.Add('.png');
                ValidFormats.Add('.jpg');
                ValidFormats.Add('.jpeg');

                SASUrlBase := ConfigRecord."SAS URL";
                FileExtension := '.pdf';
                ReportID := 50116;
                //  RecRef.Open(DATABASE::"Sales Header"); // Open the table reference
                // RecRef.GetTable(Rec);
                SalesHeader1.Reset();
                SalesHeader1.SetRange("No.", Rec."No.");
                SalesHeader1.SetRange("Document Type", Rec."Document Type"::"Credit Memo");
                if not SalesHeader1.FindFirst() then
                    Error('Sales Credit memo record not found.');

                // Open the correct record in RecRef
                RecRef.GetTable(SalesHeader1);
                // RecRef.GetTable(Rec);
                TempBlob.CreateOutStream(OutStream);
                Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);



                TempBlob.CreateInStream(InStream);
                FileName := 'CreditNote' + Rec."No." + FileExtension;
                SASUrlWithFileName := StrSubstNo('%1/%2?%3', CopyStr(SASUrlBase, 1, StrPos(SASUrlBase, '?') - 1), FileName, CopyStr(SASUrlBase, StrPos(SASUrlBase, '?') + 1));
                UploadResult := documentattachment.UploadDocumentToBlobStorage(SASUrlWithFileName, FileName, InStream);
                Rec."Credit Memo Document" := FileName;
                Rec."Credit Memo URL" := UploadResult;
                Rec.Modify();

            end;
        }

    }

    trigger OnAfterGetRecord()
    var
    begin
        approvaleditable := GetUserEditableStatus();
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

    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    var
        approvaleditable: Boolean;
}