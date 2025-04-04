page 50942 "Vendor Profile Card"
{
    PageType = Card;
    SourceTable = "Vendor Profile";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Identification")
            {
                Caption = 'Vendor Identification Details';

                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }

                field("Vendor Contact No."; Rec."Vendor Contact No.")
                {
                    ApplicationArea = All;
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }

                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                }

                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                }

                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                }

                field("Frequency Of Payment"; Rec."Frequency Of Payment")
                {
                    ApplicationArea = All;
                }

                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                }

                field("Contract Document Upload"; Rec."Contract Document Upload")
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


                            Rec."Contract Document Upload" := FileName;// Truncate to fit field length
                            // Rec."Invoice Document URL" := UploadResult; // Truncate to fit field length
                            Rec.Modify();
                            Message('Document uploaded successfully: %1', FileName);
                        end else
                            Message('No document was selected for upload.');

                        // end 
                        //    else Message('Upload Cheque cannot be access for Payment Status is Cancelled');
                    end;
                }
            }

            group("Contract Document")
            {
                part("Contract Documents"; "Vendor Contract Document Sub")
                {
                    SubPageLink = "Vendor ID" = FIELD("Vendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
        }
    }

}
