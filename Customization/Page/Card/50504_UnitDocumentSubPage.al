page 50504 "Unit Document SubPage"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Unit Document Details";
    Caption = 'Unit Document SubPage';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document Name"; Rec."Document Name")
                {
                    ApplicationArea = All;
                }
                field("Upload Document"; Rec."Upload Document")
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
                        TempBlob: Codeunit "Temp Blob";
                        ValidFormats: List of [Text];
                        FileExtension: Text[10];
                        FileSize: Decimal;
                        ConfigRecord: Record AzureConfiguration;

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


                            // Optionally, store metadata about the uploaded document in the table
                            Rec."Upload Document" := FileName;
                            Rec."View Document URL" := UploadResult;
                            Rec.Modify();
                            Message('Document uploaded successfully: %1', FileName);
                        end else
                            Message('No document was selected for upload.');
                    end;
                }


                field("View & Download"; Rec."View & Download")
                {
                    ApplicationArea = All;
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
                field(Download; Rec.Download)
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        DownloadUrl: Text;
                    begin
                        // Get the URL of the uploaded document
                        DownloadUrl := Rec."View Document URL";

                        // Check if the URL is not empty
                        if DownloadUrl = '' then
                            Error('No document is available to download.');

                        // Open the document URL in the browser (this triggers a download)
                        Hyperlink(DownloadUrl);

                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    local procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure SetUnitId(pOwnerId: code[20])
    begin
        unitId := pOwnerId;
    end;

    // procedure SetHeaderNo(HeaderNo: code[20])
    // begin
    //     TenantId := HeaderNo;
    // end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.UnitID := unitId;
    end;

    var
        unitId: code[20];
        documentattachment: Codeunit UploadAttachment;
}