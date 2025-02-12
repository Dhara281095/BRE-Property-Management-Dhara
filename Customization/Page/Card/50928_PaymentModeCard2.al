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
                    Editable = true; // The ID is not editable since it's auto-incrementing
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

                    //  trigger OnValidate()
                    // var
                    //     Statuschange: Codeunit "Daily Job Queue";
                    // begin
                    //     Statuschange.UpdateStatusForDueDate(Rec);
                    // end;
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

                        if Rec."Payment Status" = Rec."Payment Status"::Cancelled then begin
                            Message('Upload Cheque cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
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

                        // end 
                        //    else Message('Upload Cheque cannot be access for Payment Status is Cancelled');
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

                        if Rec."Payment Status" = Rec."Payment Status"::Cancelled then begin
                            Message('View cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
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
                        if Rec."Payment Status" = Rec."Payment Status"::Cancelled then begin
                            Message('View Revenue Details cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
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
                    Visible = false;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    // Editable = IsFinanceManager;
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    // Editable = IsFinanceManager;
                }
                field(IsUpdated; Rec.IsUpdated)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Approve/Decline Status"; Rec."Approve/Decline Status")
                {
                    ApplicationArea = All;
                }


                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
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
                Visible = IsLeaseManager;

                trigger OnAction()
                var
                    approvalflow: Codeunit 50510;
                    PaymentModeRec: Record "Payment Mode2";
                    PrePDCTransRec: Record "PDC Transaction";
                    PDCTransRec: Record "PDC Transaction";
                    paymentRec: Record "Payment Mode";
                    paymentTransRec: Record "Payment Transaction";
                    PrePaymentTransRec: Record "Payment Transaction";
                    paymentGridRec: Record "Payment Series Details";
                    PrePaymentGridRec: Record "Payment Series Details";
                    IsPaymentTransactionCreated: Boolean;
                    Isupdate: Boolean;
                begin
                    Isupdate := false;
                    approvalflow.SendPaymentModeApprovalToFinanceManger(Format(Rec."Contract ID"), Rec."Tenant Id", Rec."Contract ID", Isupdate);

                    // Update Approval Status in the grid
                    PaymentModeRec.SetRange("Contract ID", Rec."Contract ID"); // Filter by Contract ID
                    if PaymentModeRec.FindSet() then begin
                        repeat
                            PaymentModeRec."Approval Status" := PaymentModeRec."Approval Status"::Pending; // Set Approval Status to Pending

                            PaymentModeRec.Modify();
                        until PaymentModeRec.Next() = 0;
                    end;

                    paymentRec.SetRange("Contract ID", Rec."Contract ID");
                    paymentRec.SetRange("Tenant Id", Rec."Tenant Id");
                    if paymentRec.FindSet() then begin
                        paymentRec."Approval Status" := paymentRec."Approval Status"::Pending;

                    end;

                    // Insert records into PDC Transaction for Payment Modes with "Cheque"
                    PaymentModeRec.SetRange("Contract ID", Rec."Contract ID"); // Filter by Contract ID
                    PaymentModeRec.SetRange("Tenant Id", Rec."Tenant Id"); // Filter by Tenant ID
                    PaymentModeRec.SetRange("Payment Mode", 'Cheque'); // Filter by Payment Mode = Cheque

                    if PaymentModeRec.FindSet() then begin
                        repeat
                            // Check for duplicate PDC Transaction record
                            // PrePDCTransRec.SetRange("Cheque Number", PaymentModeRec."Cheque Number");
                            PrePDCTransRec.SetRange("Tenant Id", PaymentModeRec."Tenant Id");
                            PrePDCTransRec.SetRange("Contract ID", PaymentModeRec."Contract ID");
                            PrePDCTransRec.SetRange("payment Series", PaymentModeRec."Payment Series");

                            if not PrePDCTransRec.FindFirst() then begin
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
                                PDCTransRec."View Document URL" := PaymentModeRec."View Document URL";
                                PDCTransRec."payment Series" := PaymentModeRec."Payment Series";
                                PDCTransRec.Insert(true);
                                Clear(PDCTransRec);
                            end;

                        until PaymentModeRec.Next() = 0;

                        Message('PDC Transaction records successfully created for Cheque payment modes.');
                    end else
                        Message('No payment modes with "Cheque" found for the given Contract ID and Tenant ID.');
                end;


            }

            action(UpdateData)
            {
                ApplicationArea = All;
                Caption = 'Update Data';
                Image = NewDocument;
                Visible = IsLeaseManager;

                trigger OnAction()
                var
                    approvalflow: Codeunit 50510;
                    PaymentModeRec: Record "Payment Mode2";
                    paymentRec: Record "Payment Mode";
                    Isupdate: Boolean;
                begin
                    Isupdate := true;
                    approvalflow.SendPaymentModeApprovalToFinanceManger(Format(Rec."Contract ID"), Rec."Tenant Id", Rec."Contract ID", Isupdate);
                end;

            }
        }
    }



    trigger OnAfterGetRecord()
    begin
        // If the field is blank, assign '-'
        if Rec."Cheque Number" = '' then
            Rec."Cheque Number" := '-';

        if Rec."Old Cheque #" = '' then
            Rec."Old Cheque #" := '-';

        if Rec."Receipt #" = '' then
            Rec."Receipt #" := '-';

        if Rec."Invoice #" = '' then
            Rec."Invoice #" := '-';


        // if Rec."Due Date" <> xRec."Due Date" then begin
        //         if Rec."Due Date" = Today() then
        //             Rec."Payment Status" := Rec."Payment Status"::"Due"
        //         else if Rec."Due Date" < Today() then
        //             Rec."Payment Status" := Rec."Payment Status"::"Overdue"
        //         else
        //             Rec."Payment Status" := Rec."Payment Status";

        //      //   Modify();
        //     end;
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

    procedure SetDetails(pTenantName: Text[100]; pTenantEmail: Text[80])
    begin
        tenantName := pTenantName;
        tenantEmail := pTenantEmail;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."Tenant ID" := tenantID;
        Rec."Contract ID" := ContractID;
        Rec."Tenant Name" := tenantName;
        Rec."Tenant Email" := tenantEmail;  

    end;

    var
        proposalID: Integer;
        tenantID: Code[20];

        tenantName: Text[100];
        tenantEmail: Text[80];
        ContractID: Integer;
        isApproved: Boolean;
        IsLeaseManager: Boolean;
        IsFinanceManager: Boolean;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsLeaseManager := false;
        IsFinanceManager :=false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE_MANAGER');
        if PermissionSet.FindSet() then begin
            if PermissionSet."Profile ID" = 'LEASE_MANAGER' then
                IsLeaseManager := true;
        end
        // else if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
        //         IsFinanceManager := true;


    end;



}
    












