codeunit 50102 "Send Payment Receipt"
{
    procedure SendEmail(Rec: Record "Payment Mode2"): Text;
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text[250];
        TempFilePath: Text[250];
        ReportID: Integer;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        CompanyInfo: Record "Company Information";
        ConsolidatedInvoiceHeader: Record "Payment Mode2";
        RecRef: RecordRef;
        FileManagement: Codeunit "File Management";
    begin
        ReportID := 50112;

        // Apply filters to fetch the specific record
        ConsolidatedInvoiceHeader.Reset();
        ConsolidatedInvoiceHeader.SetRange("Tenant ID", Rec."Tenant ID");
        ConsolidatedInvoiceHeader.SetRange("Contract ID", Rec."Contract ID"); // Ensure filtering on unique ID

        if ConsolidatedInvoiceHeader.FindFirst() then begin
            // Prepare the report output
            RecRef.GetTable(ConsolidatedInvoiceHeader);
            TempBlob.CreateOutStream(OutStream);

            Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

            TempBlob.CreateInStream(InStream);
            FileName := 'Receipt_' + Format(ConsolidatedInvoiceHeader."Tenant ID") + '.pdf';

            // Debugging to confirm email creation parameters
            Message('Preparing to send email to: %1', ConsolidatedInvoiceHeader."Tenant Email");

            // Retrieve company information
            if CompanyInfo.Get() then begin
                // Create email with detailed contract information
                EmailMessage.Create(
                    ConsolidatedInvoiceHeader."Tenant Email",
                    'Payment Receipt Attached_' + Format(ConsolidatedInvoiceHeader."Tenant ID"),
                    '<html>' +
                    '<body>' +
                    '<p>Dear ' + ConsolidatedInvoiceHeader."Tenant Name" + ',' +
                    'Your payment has been received. Please find your receipt attached.</p>' +
                    '</body>' +
                    '</html>',
                    true
                );

                // Attach the PDF document
                EmailMessage.AddAttachment(FileName, '', InStream);

                // Send the email
                if Email.Send(EmailMessage) then
                    Message('Email sent successfully to: %1', ConsolidatedInvoiceHeader."Tenant Email")
                else
                    Error('Failed to send email. Please verify SMTP settings and email addresses.');
            end;

            exit('Email sent successfully');
        end else
            Error('No Payment Receipt details found for Tenant ID: %1, Contract ID: %2', Rec."Tenant ID", Rec."Contract ID");
    end;
}