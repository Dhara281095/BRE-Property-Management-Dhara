page 50928 "Payment Mode Card2"
{
    PageType = ListPart;
    SourceTable = "Payment Mode2";
    ApplicationArea = All;
    Caption = 'Payment Mode Card2';

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }


                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }


                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }



                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = true;  // The ID is not editable since it's auto-incrementing
                }



                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"

                }



                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                     Editable = (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);  // The ID is not editable since it's auto-incrementing
                    //Editable = (Rec."Payment Mode" = 'Cheque'); // Editable only if Payment Mode is 'Cheque'
                     //Editable = not ((Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" = Rec."Payment Status"::Cancelled));


                }


                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = (Rec."Payment Mode" <> 'Cash');
                    // Editable = (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
                }

                field("Deposit Status"; Rec."Deposit Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Editable = (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);  
                    //Editable = not ((Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" = Rec."Payment Status"::Cancelled));
                }

                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                }

                field("Cheque Status"; Rec."Cheque Status")
                {
                    ApplicationArea = All;
                    //Editable = (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);  
                    //Editable = (Rec."Payment Mode" = 'Cheque'); // Editable only if Payment Mode is 'Cheque'
                    //Editable = not ((Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" = Rec."Payment Status"::Cancelled));
                    // trigger OnValidate()
                    // begin
                    //     if Rec."Payment Mode" <> 'Cheque' then
                    //         Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    // end;
                    // Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Invoice #"; Rec."Invoice #")
                {
                    ApplicationArea = All;
                     Editable = (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
                 
                }

                field("Receipt #"; Rec."Receipt #")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
           
                }

                field("Old Cheque #"; Rec."Old Cheque #")
                {
                    ApplicationArea = All;
                     Editable = (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);  
                   // Editable = (Rec."Payment Mode" = 'Cheque'); // Editable only if Payment Mode is 'Cheque'
                   // Editable = (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);
                  // Editable = not ((Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" = Rec."Payment Status"::Cancelled));


                    

                    trigger OnValidate()
                    begin
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;
                    // Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Upload Cheque"; Rec."Upload Cheque")
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


                            Rec."Upload Cheque" := FileName;// Truncate to fit field length
                            Rec."View Document URL" := UploadResult; // Truncate to fit field length
                            Rec.Modify();
                            Message('Document uploaded successfully: %1', FileName);
                        end else
                            Message('No document was selected for upload.');
                    end;
                }


                field("View"; Rec."View")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                  
                    trigger OnValidate()
                    begin
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;

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

                field("View Revenue Details"; Rec."View Revenue Details")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                      

                     trigger OnDrillDown()
                     var
                     PaymentModeRec: Record "Payment Mode2";
                    PaymentScheduleRec: Record "Payment Schedule2";
                    FilteredSchedulePage: Page "Payment Schedule Card2"; // Replace with your actual page name
                    begin
                    // Fetch the first entry's due date
                    //  if PaymentModeRec.FindSet() then begin
                    //  repeat
                    // Fetch the due date and apply it as a filter
              
                    PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
                   // PaymentScheduleRec.SetRange("Proposal ID", Rec."Proposal ID");
                    PaymentScheduleRec.SetRange("Tenant ID", Rec."Tenant ID");
                    PaymentScheduleRec.SetRange("Due Date", Rec."Due Date");
                    PaymentScheduleRec.SetRange("Payment Series", Rec."Payment Series");

                    // Hide other data and show the filtered records
                   if PaymentScheduleRec.FindFirst() then
                   FilteredSchedulePage.SetTableView(PaymentScheduleRec);

                   // Open the filtered page
                   PAGE.Run(PAGE::"Payment Schedule Card2", PaymentScheduleRec);

                    // until PaymentModeRec.Next() = 0;
                //    end;
                 end;

                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;// The ID is not editable since it's auto-incrementing
                    Visible = false;
                }

                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;// The ID is not editable since it's auto-incrementing
                    Visible = true;
                }



            }



              group(TotalAmountCalculation)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    Caption = 'Total VAT Amount';
                    Editable = false;
                }
                field("Total Amount Including VAT"; Rec."Total Amount Including VAT")
                {
                    Caption = 'Total Amount Including VAT';
                    Editable = false;
                }
            }


        }
    }




actions
{
    area(processing)
    {
        action(InsertData)
        {
            ApplicationArea = All;
            Caption = 'Insert Data';
            Image = NewDocument;

            trigger OnAction()
            var
                PaymentModeRec: Record "Payment Mode2";
                PrePDCTransRec: Record "PDC Transaction";
                PDCTransRec: Record "PDC Transaction";
                paymentTransRec : Record "Payment Transaction";
                PrePaymentTransRec : Record "Payment Transaction";
                paymentGridRec : Record "Payment Series Details";
                PrePaymentGridRec : Record "Payment Series Details";
                IsPaymentTransactionCreated: Boolean;
            begin
                        // Filter Payment Mode records by Contract ID and Tenant ID
                    PaymentModeRec.SetRange("Contract ID", Rec."Contract ID");
                    PaymentModeRec.SetRange("Tenant Id", Rec."Tenant Id");

                    if PaymentModeRec.FindSet() then begin
                        IsPaymentTransactionCreated := false;

                        repeat
                            paymentTransRec.SetRange("Contract Id", PaymentModeRec."Contract ID");
                            paymentTransRec.SetRange("Tenant Id", PaymentModeRec."Tenant Id");
                            if not paymentTransRec.FindSet() then begin
                                    // Create a Payment Transaction if not already created
                                if not IsPaymentTransactionCreated then begin
                                    PaymentTransRec.Init();
                                    PaymentTransRec."Tenant Id" := Rec."Tenant Id";
                                    PaymentTransRec."Contract Id" := Rec."Contract ID";
                                    PaymentTransRec.Insert(true);
                                    IsPaymentTransactionCreated := true;
                                end;
                            end;
                            

                            // Check for duplicate Payment Series Details record
                            PaymentGridRec.SetRange("Payment Transaction Id", PaymentTransRec."PT Id");
                            PaymentGridRec.SetRange("payment Series", PaymentModeRec."Payment Series");

                            if not PaymentGridRec.FindSet() then begin
                                // Insert records into Payment Series Grid under Payment Transaction
                                PaymentGridRec.Init();
                                PaymentGridRec."payment Series" := PaymentModeRec."Payment Series";
                                PaymentGridRec.Amount := PaymentModeRec."Amount Including VAT";
                                PaymentGridRec."Due Date" := PaymentModeRec."Due Date";
                                PaymentGridRec."Payment Mode" := PaymentModeRec."Payment Mode";
                                PaymentGridRec."Cheque Number" := PaymentModeRec."Cheque Number";
                                PaymentGridRec."Deposite Bank" := PaymentModeRec."Deposit Bank";
                                PaymentGridRec."Deposite Status" := PaymentModeRec."Deposit Status";
                                PaymentGridRec."Payment Status" := PaymentModeRec."Payment Status";
                                PaymentGridRec."Cheque Status" := PaymentModeRec."Cheque Status";
                                PaymentGridRec."Old Cheque" := PaymentModeRec."Old Cheque #";
                                PaymentGridRec."View Document URL" := PaymentModeRec."View Document URL";
                                PaymentGridRec."Approval Status" := PaymentGridRec."Approval Status"::Pending;
                                PaymentGridRec."Contract Id" := PaymentModeRec."Contract ID";
                                paymentGridRec."Tenant Id" := PaymentModeRec."Tenant Id";
                                PaymentGridRec."Payment Transaction Id" := PaymentTransRec."PT Id";
                                PaymentGridRec.Insert(true);
                                Clear(paymentGridRec);
                            end;
                                
                        until PaymentModeRec.Next() = 0;

                        // Process records with Payment Mode as "Cheque" for PDC Transaction
                        PaymentModeRec.SetRange("Payment Mode", 'Cheque');
                        if PaymentModeRec.FindSet() then begin
                            repeat
                                // Check for duplicate PDC Transaction record
                                PrePDCTransRec.SetRange("Cheque Number", PaymentModeRec."Cheque Number");
                                PrePDCTransRec.SetRange("Tenant Id", PaymentModeRec."Tenant Id");
                                PrePDCTransRec.SetRange("Contract ID", PaymentModeRec."Contract ID");
                                PrePDCTransRec.SetRange("payment Series", PaymentModeRec."Payment Series");

                                if not PrePDCTransRec.FindSet() then begin
                                    // Insert record into PDC Transaction
                                    PDCTransRec.Init();
                                    PDCTransRec."Cheque Number" := PaymentModeRec."Cheque Number";
                                    PDCTransRec."Bank Name" := PaymentModeRec."Deposit Bank";
                                    PDCTransRec."Cheque Date" := PaymentModeRec."Due Date";
                                    PDCTransRec.Amount := PaymentModeRec."Amount Including VAT";
                                    PDCTransRec."Tenant Id" := PaymentModeRec."Tenant Id";
                                    PDCTransRec."Contract ID" := PaymentModeRec."Contract ID";
                                    PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::"Cheque Received";
                                    PDCTransRec."Approval Status" := PDCTransRec."Approval Status"::Pending;
                                    PDCTransRec.View := PaymentModeRec."View Document URL";
                                    PDCTransRec."payment Series" := PaymentModeRec."Payment Series";
                                    PDCTransRec.Insert(true);
                                    Clear(PDCTransRec);
                                end;

                            until PaymentModeRec.Next() = 0;

                            Message('Data successfully inserted into PDC Transaction and Payment Transaction.');
                        end;
                        //     Message('No payment modes with cheque details found.');
                    end else
                        Message('No payment modes found for the given Contract ID and Tenant ID.');
                end;
        }
    }
}



 trigger OnAfterGetRecord()
    begin
        // If the field is blank, assign '-'
        if Rec."Cheque Number" = '' then
            Rec."Cheque Number" := '-';

            //  if Rec."Old Cheque #" = '' then
            // Rec."Old Cheque #" := '-';

            //  if Rec."Receipt #" = '' then
            // Rec."Receipt #" := '-';

            //  if Rec."Invoice #" = '' then
            // Rec."Invoice #" := '-';


            if Rec."Due Date" <> xRec."Due Date" then begin
                    if Rec."Due Date" = Today() then
                        Rec."Payment Status" := Rec."Payment Status"::"Due"
                    else if Rec."Due Date" < Today() then
                        Rec."Payment Status" := Rec."Payment Status"::"Overdue"
                    else
                        Rec."Payment Status" := Rec."Payment Status";

                 //   Modify();
                end;
    end;
    
    
  
    procedure SetProposalID(pProposalID: Integer)
    begin
        proposalID := pProposalID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;

     procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

      procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    // procedure SetStartEndDate(pStartDate: Date; pEndDate: Date)
    // begin
    //     startDate := pStartDate;
    //     endDate := pEndDate;
    // end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

         Rec."Tenant ID" := tenantID;
         Rec."Contract ID" := ContractID;

    end;

    var
        proposalID: Integer;
        tenantID: Code[20];
        ContractID: Integer;


}
    












