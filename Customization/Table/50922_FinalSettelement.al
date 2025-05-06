table 50922 "FinalSettlement"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(50100; "FC ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receivable FC ID';
        }
        field(50101; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receivable Contract ID';
        }

        field(50102; "Receivable from the Tenant"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receivable from the Tenant';
        }

        field(50103; "Payment Processed"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Processed';
        }
        field(50104; "Balance Receivable"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Balance Receivable';
        }

        field(50105; "PaymentStatus"; Option)
        {
            OptionMembers = "Pending","Received";
            Caption = 'Payment Status';
        }


        field(50106; "Receivable Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Amount';
        }
        field(50107; "Receivable Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';
        }
        field(50108; "Receivable Payment mode"; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment mode';
            TableRelation = "Payment Type"."Payment Method";
        }
        field(50109; "Receivable Payment Status"; Enum "Payment Status")
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Status';

            trigger OnValidate()
            var
                Email: Codeunit "FS_Receivable Payment Receipt";
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
                paymentmode2Grid: Record FinalSettlement;
                FinalSettlementPosting: Codeunit "Final Settlement Posting Mgt.";
            begin
                if Rec."Receivable Payment Status" = Enum::"Payment Status"::Received then begin
                    Email.SendEmail(Rec);

                    if not ConfigRecord.FindFirst() then
                        Error('Azure configuration is missing. Please set up the SAS URL in the Azure Configuration table.');
                    ValidFormats.Add('.png');
                    ValidFormats.Add('.jpg');
                    ValidFormats.Add('.jpeg');

                    SASUrlBase := ConfigRecord."SAS URL";
                    FileExtension := '.pdf';
                    ReportID := 50114;
                    //  RecRef.Open(DATABASE::"Sales Header"); // Open the table reference
                    // RecRef.GetTable(Rec);
                    paymentmode2Grid.Reset();
                    paymentmode2Grid.SetRange("Tenant ID", Rec."Tenant ID");
                    paymentmode2Grid.SetRange("Contract ID", Rec."Contract ID"); // Ensure filtering on unique ID

                    if not paymentmode2Grid.FindFirst() then
                        Error('Not avavilable');
                    RecRef.GetTable(paymentmode2Grid);
                    // RecRef.GetTable(Rec);
                    TempBlob.CreateOutStream(OutStream);
                    Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

                    TempBlob.CreateInStream(InStream);
                    FileName := 'Receipt_' + Format(Rec."Contract ID") + Format(Rec."FC ID") + FileExtension;
                    SASUrlWithFileName := StrSubstNo('%1/%2?%3', CopyStr(SASUrlBase, 1, StrPos(SASUrlBase, '?') - 1), FileName, CopyStr(SASUrlBase, StrPos(SASUrlBase, '?') + 1));
                    UploadResult := documentattachment.UploadDocumentToBlobStorage(SASUrlWithFileName, FileName, InStream);
                    Rec."Payment Receipt" := FileName;
                    Rec."Payment Receipt document URL" := UploadResult;
                    Rec.Modify();

                    // Call the Final Settlement Posting codeunit to post the amount
                    FinalSettlementPosting.PostFinalSettlementAmount(Rec);
                    // FinalSettlementPosting.receivecashrecipt(Rec);
                    // FinalSettlementPosting.receivablecashrecipt(Rec);
                end
            end;
        }

        field(50110; "Receivable Cheque No."; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cheque No.';
        }

        field(50111; "Deposit Bank"; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Deposit Bank';
            TableRelation = "Bank Account";

            trigger OnValidate()
            var
                BankAccountRec: Record "Bank Account";
            begin
                // When a Deposit Bank is selected (i.e., a Bank Account No. is provided)
                if "Deposit Bank" <> '' then begin
                    // Attempt to find the Bank Account using the No. from the Deposit Bank
                    if BankAccountRec.Get("Deposit Bank") then
                        "Deposit Bank" := BankAccountRec."Name"; // Populating the Name field from the Bank Account table
                end;
            end;
        }

        field(50112; "Deposit Status"; Option)
        {
            Caption = 'Deposit Status';
            OptionMembers = "-","N","Y";
        }

        field(50113; "Payment Receipt"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Receipt';
            Editable = false;
            // InitValue = 'View';
        }
        field(50114; "Payment Receipt document URL"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Receipt Document URL';
        }
        field(50117; "Tenant ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Receivable Tenant ID';
        }
        field(50120; "Tenant Email"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Email';
        }
        field(50122; "Tenant Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Name';
        }
        field(50118; "Invoiced"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoiced';
        }
        field(50119; "Invoice ID"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice ID';
        }
        field(50121; "View Reciept document URL"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice ID';
        }
        // field(50118; "Entry No."; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     AutoIncrement = true;
        // }

    }

    // keys
    // {
    //     key(Key1; "Entry No.", "FC ID")
    //     {
    //         Clustered = true;
    //     }
    // }
    keys
    {
        key(PK; "FC ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if Rec."Receivable Payment Mode" = 'Cheque' then begin
            if DelChr(Rec."Receivable Cheque No.", '=', ' ') = '' then
                Error('Cheque Number cannot be blank when Payment Mode is Cheque.');
        end;
    end;

}

