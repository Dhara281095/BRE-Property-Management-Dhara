codeunit 50103 "FS_Receivable Payment Receipt"
{
    procedure SendEmail(Rec: Record FinalSettlement): Text;
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
        ConsolidatedInvoiceHeader: Record FinalSettlement;
        RecRef: RecordRef;
        FileManagement: Codeunit "File Management";
    // NoSeriesManagement: Codeunit "No. Series";
    // ReceiptNo: Code[20];
    begin
        ReportID := 50114;
        ConsolidatedInvoiceHeader.SetRange("Contract ID", Rec."Contract ID");

        if ConsolidatedInvoiceHeader.FindSet() then begin
            RecRef.GetTable(ConsolidatedInvoiceHeader);
            TempBlob.CreateOutStream(OutStream);

            Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

            TempBlob.CreateInStream(InStream);
            FileName := 'Payment Receipt_' + Format(ConsolidatedInvoiceHeader."Contract ID") + '.pdf';

            // Debugging to confirm email creation parameters
            Message('Preparing to send email to: %1', ConsolidatedInvoiceHeader."Tenant Email");

            if CompanyInfo.Get() then begin

                EmailMessage.Create(
                                   ConsolidatedInvoiceHeader."Tenant Email",
                                   'Payment Receipt Attached_' + Format(ConsolidatedInvoiceHeader."Contract ID"),
                                   '<html>' +
                                   '<body>' +
                                    '<p>Dear ' + ConsolidatedInvoiceHeader."Tenant Name" + ',</p>' +
                                   '<p>Your payment has been received. Please find your receipt attached.</p>' +
                                   '</body>' +
                                   '</html>',
                                   true // Ensure the email is sent as an HTML email
                               );
            end;
            EmailMessage.AddAttachment(FileName, '', InStream);

            // Debugging to confirm the email sending process
            if Email.Send(EmailMessage) then
                Message('Email sent successfully to: %1', ConsolidatedInvoiceHeader."Tenant Email")
            else
                Error('Failed to send email. Please verify SMTP settings and email addresses.');

            exit('Email send successfully');
        end else
            Error('No lease proposal details found for Proposal ID: %1', Rec."Contract ID");
    end;
}