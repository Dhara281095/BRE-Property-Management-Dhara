page 50701 "Company Data"
{
    PageType = Card;
    SourceTable = "testData";
    ApplicationArea = All;
    Caption = 'Company Data';

    layout
    {
        area(content)
        {
            group("Company Information")
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    Caption = 'Company Name';
                }

                field("Company Logo"; Rec."Company Logo")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        AzureBlobUploader: Codeunit "Azure Blob Management";
                        InStream: InStream;
                        FileName: Text;
                        SASUrlBase: Text;
                        SASUrlWithFileName: Text;
                        UploadResult: Text;
                        ValidFormats: List of [Text];
                        FileExtension: Text[10];
                        ConfigRecord: Record AzureConfiguration;
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
                        // Error('SASUrlBase validate');
                        // Message('SASUrlBase validate');

                        if UploadIntoStream('Select Company Logo', '', '(*.png, *.jpg, *.jpeg)|*.png;*.jpg;*.jpeg', FileName, InStream) then begin
                            FileExtension := LowerCase(CopyStr(FileName, StrPos(FileName, '.'), StrLen(FileName) - StrPos(FileName, '.') + 1));

                            if not ValidFormats.Contains(FileExtension) then
                                Error('Unsupported file format. Only PNG, JPG, and JPEG allowed.');

                            // Dynamically set the full SAS URL
                            //SASUrlWithFileName := StrSubstNo('%1/%2/%3', SASUrlBase, 'companylogo', FileName);
                            SASUrlWithFileName := StrSubstNo('%1/%2?%3', CopyStr(SASUrlBase, 1, StrPos(SASUrlBase, '?') - 1), FileName, CopyStr(SASUrlBase, StrPos(SASUrlBase, '?') + 1));
                            //Error('Generated SAS URL: %1', SASUrlWithFileName);


                            // Call the image upload procedure
                            UploadResult := documentattachment.UploadDocumentToBlobStorage(SASUrlWithFileName, FileName, InStream);
                            //Error('Generated UploadResult URL: %1', UploadResult);

                            // Optionally, store metadata about the uploaded document in the table
                            Rec."Company Logo" := FileName;
                            Rec."Logo URL" := UploadResult;
                            Rec.Modify();
                            Message('Document uploaded successfully: %1', FileName);
                        end else
                            Message('No document was selected for upload.');
                    end;

                    //         if UploadResult <> '' then begin
                    //             Rec."Logo URL" := UploadResult;
                    //             Rec.Modify();
                    //             Error('Upload successful to Azure Blob URL: %1', UploadResult);
                    //         end else
                    //             Error('Upload failed. No URL returned.');
                    //     end;
                    // end;
                }

                field("Azure Blob URL"; Rec."Logo URL")
                {
                    // ApplicationArea = All;
                    // Editable = false;
                    // Caption = 'Azure Blob URL';
                    // ToolTip = 'This field displays the Azure Blob URL after uploading the image.';
                    ApplicationArea = All;
                    Editable = true;
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

                field("Tenant id"; Rec."Tenant id")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Id';
                }
                field("Environment Name"; Rec."Environment Name")
                {
                    ApplicationArea = All;
                    Caption = 'Environment Name';
                }
            }

            group("WorkflowFrequency")
            {
                part("Workflow Frequency"; "Workflow Frequency Card")
                {
                    SubPageLink = "Company ID" = FIELD("Company ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }



            }
            field("Access Validity"; Rec."Access Validity")
            {
                ApplicationArea = All;
                Caption = 'Access Validity (Days)';
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

    var
        documentattachment: Codeunit UploadAttachment;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        CompanyInfo: Record "Company Information";
    begin
        if CompanyInfo.Get() then
            Rec."Company Name" := CompanyInfo.Name;
    end;
}
