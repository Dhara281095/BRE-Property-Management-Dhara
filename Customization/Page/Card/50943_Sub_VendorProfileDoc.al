page 50943 "Vendor I/R DocumentSub"
{
    PageType = ListPart;
    SourceTable = "Vendor Contract Document";
    ApplicationArea = All;
    Caption = 'Vendor Invoice/Receipt Documents';

    layout
    {
        area(content)
        {
            repeater("Documents")
            {

                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                }

                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                }

                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                }

                field("Invoice Document Upload"; Rec."Invoice Document Upload")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
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
                        documentattachment: Codeunit UploadAttachment;

                    begin
                        // Validate and retrieve the SAS URL from the configuration table
                        if not ConfigRecord.FindFirst() then
                            Error('Azure configuration is missing. Please set up the SAS URL in the Azure Configuration table.');

                        ValidFormats.Add('.pdf');
                        ValidFormats.Add('.docx');
                        ValidFormats.Add('.jpg');
                        ValidFormats.Add('.jpeg');
                        // Get the SAS base URL (without the file name)
                        SASUrlBase := ConfigRecord."SAS URL";

                        // Load the file to be uploaded into an InStream
                        if UploadIntoStream('Select a Document', '', '(*.pdf, *.docx,*.jpeg, *.jpg)|*.pdf;*.docx;*.jpeg;*.jpg', FileName, InStream) then begin

                            FileExtension := LowerCase(CopyStr(FileName, StrPos(FileName, '.'), StrLen(FileName) - StrPos(FileName, '.') + 1));
                            if not ValidFormats.Contains(FileExtension) then
                                Error('Unsupported file format. Please upload PDF, DOCX, JPEG or JPG.');

                            FileSize := InStream.Length / 1024 / 1024; // Convert to MB
                            if FileSize > 5 then
                                Error('File is too large. Maximum size allowed is 5MB.');
                            // Append the file name to the base SAS URL to create a full SAS URL
                            SASUrlWithFileName := StrSubstNo('%1/%2?%3', CopyStr(SASUrlBase, 1, StrPos(SASUrlBase, '?') - 1), FileName, CopyStr(SASUrlBase, StrPos(SASUrlBase, '?') + 1));

                            // Call the upload function with the modified SAS URL
                            UploadResult := documentattachment.UploadDocumentToBlobStorage(SASUrlWithFileName, FileName, InStream);


                            Rec."Invoice Document Upload" := FileName;// Truncate to fit field length
                            Rec."Invoice Document URL" := UploadResult; // Truncate to fit field length
                            Rec.Modify();
                            Message('Document uploaded successfully: %1', FileName);
                        end else
                            Message('No document was selected for upload.');

                        // end 
                        //    else Message('Upload Cheque cannot be access for Payment Status is Cancelled');
                    end;
                }

                field("Invoice Document View"; Rec."Invoice Document View")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."Invoice Document URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;
                }

                field("Invoice Document URL"; Rec."Invoice Document URL")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Receipt ID"; Rec."Receipt ID")
                {
                    ApplicationArea = All;
                }

                field("Receipt Document Upload"; Rec."Receipt Document Upload")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
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
                        documentattachment: Codeunit UploadAttachment;

                    begin

                        // Validate and retrieve the SAS URL from the configuration table
                        if not ConfigRecord.FindFirst() then
                            Error('Azure configuration is missing. Please set up the SAS URL in the Azure Configuration table.');

                        ValidFormats.Add('.pdf');
                        ValidFormats.Add('.docx');
                        ValidFormats.Add('.jpg');
                        ValidFormats.Add('.jpeg');
                        // Get the SAS base URL (without the file name)
                        SASUrlBase := ConfigRecord."SAS URL";

                        // Load the file to be uploaded into an InStream
                        if UploadIntoStream('Select a Document', '', '(*.pdf, *.docx,*.jpeg, *.jpg)|*.pdf;*.docx;*.jpeg;*.jpg', FileName, InStream) then begin

                            FileExtension := LowerCase(CopyStr(FileName, StrPos(FileName, '.'), StrLen(FileName) - StrPos(FileName, '.') + 1));
                            if not ValidFormats.Contains(FileExtension) then
                                Error('Unsupported file format. Please upload PDF, DOCX, JPEG or JPG.');

                            FileSize := InStream.Length / 1024 / 1024; // Convert to MB
                            if FileSize > 5 then
                                Error('File is too large. Maximum size allowed is 5MB.');
                            // Append the file name to the base SAS URL to create a full SAS URL
                            SASUrlWithFileName := StrSubstNo('%1/%2?%3', CopyStr(SASUrlBase, 1, StrPos(SASUrlBase, '?') - 1), FileName, CopyStr(SASUrlBase, StrPos(SASUrlBase, '?') + 1));

                            // Call the upload function with the modified SAS URL
                            UploadResult := documentattachment.UploadDocumentToBlobStorage(SASUrlWithFileName, FileName, InStream);


                            Rec."Receipt Document Upload" := FileName;// Truncate to fit field length
                            Rec."Receipt Document URL" := UploadResult; // Truncate to fit field length
                            Rec.Modify();
                            Message('Document uploaded successfully: %1', FileName);
                        end else
                            Message('No document was selected for upload.');

                        // end 
                        //    else Message('Upload Cheque cannot be access for Payment Status is Cancelled');
                    end;
                }

                field("Receipt Document View"; Rec."Receipt Document View")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."Receipt Document URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;
                }

                field("Receipt Document URL"; Rec."Receipt Document URL")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
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


    procedure SetVendorID(pVendorID: Code[20])
    begin
        VendorID := pVendorID;
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        vendor: Record "Vendor Profile";
        PaymentStatus: Enum "Payment Status";
    begin
        Rec."Vendor ID" := VendorID;

        vendor.SetRange("vendor ID", Rec."vendor ID");
        if vendor.FindSet() then begin
            if Rec."Payment Status" = PaymentStatus::" " then
                Rec."Payment Status" := PaymentStatus::Scheduled;
        end;
    end;

    var
        VendorID: Code[20];

    trigger OnModifyRecord(): Boolean
    var
        vendor: Record "Vendor Profile";
        PaymentStatus: Enum "Payment Status";
    begin
        vendor.SetRange("vendor ID", Rec."vendor ID");
        if vendor.FindSet() then begin
            if Rec."Payment Status" = PaymentStatus::" " then
                Rec."Payment Status" := PaymentStatus::Scheduled;
        end;
    end;

}
