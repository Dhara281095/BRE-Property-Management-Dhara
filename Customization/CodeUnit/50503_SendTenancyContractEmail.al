
codeunit 50503 "Send Contract Email"
{
    procedure SendEmail(Rec: Record "Tenancy Contract"): Text;
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text[250];
        ReportID: Integer;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        CompanyInfo: Record "Company Information";
        CurrentEmirateValue: Text;
        RecRef: RecordRef;
    begin
        // Determine the appropriate report ID based on the emirate
        if Rec.Emirate = 'Dubai' then begin
            ReportID := 50101; // Report ID for Dubai tenancy contract
            CurrentEmirateValue := 'Dubai';
        end else if Rec.Emirate = 'Umm Al Quwain' then begin
            ReportID := 50115; // Report ID for Abu Dhabi tenancy contract
            CurrentEmirateValue := 'Umm Al Quwain';
        end else if Rec.Emirate = 'Abu Dhabi' then begin
            ReportID := 50101; // Report ID for Abu Dhabi tenancy contract
            CurrentEmirateValue := 'Abu Dhabi';
        end else if Rec.Emirate = 'Sharjah' then begin
            ReportID := 50101; // Report ID for Abu Dhabi tenancy contract
            CurrentEmirateValue := 'Sharjah';
        end else if Rec.Emirate = 'Ajman' then begin
            ReportID := 50101; // Report ID for Abu Dhabi tenancy contract
            CurrentEmirateValue := 'Ajman';
        end else if Rec.Emirate = 'Fujairah' then begin
            ReportID := 50101; // Report ID for Abu Dhabi tenancy contract
            CurrentEmirateValue := 'Fujairah';
        end else if Rec.Emirate = 'Ras Al Khaimah' then begin
            ReportID := 50101; // Report ID for Abu Dhabi tenancy contract
            CurrentEmirateValue := 'Ras Al Khaimah';
        end else begin
            Error('Unsupported emirate: %1', Rec.Emirate);
        end;

        // આ બદલાવ - direct current record use કરો, બીજા records find નહીં કરવા
        if Rec."Tenant ID" <> '' then begin
            // Explicitly set the Emirate value to ensure it's correct
            Rec.Emirate := CurrentEmirateValue;

            // Generate the report with specific record filter
            TempBlob.CreateOutStream(OutStream);

            // Set filter on current record to ensure only this record is used in report
            Rec.SetRecFilter();
            RecRef.GetTable(Rec);
            Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

            // Prepare the file name for the attachment
            TempBlob.CreateInStream(InStream);
            FileName := 'Contract_' + Format(Rec."Tenant ID") + '.pdf';

            // Debugging to confirm email creation parameters
            Message('Preparing to send email to: %1', Rec."Email Address");

            if CompanyInfo.Get() then begin
                // Create the email message
                EmailMessage.Create(
                    Rec."Email Address",
                    'Tenancy Contract Document Attached_' + Format(Rec."Tenant ID"),
                    '<html>' +
                    '<body>' +
                    '<p>Dear ' + Rec."Customer Name" + ',</p>' +
                    '<p>We are pleased to inform you that the tenancy contract for your property has been finalized. Please find the contract document attached to this email for your review and records.</p>' +
                    '<h3>Contract Summary:</h3>' +
                    '<p><b>Contract ID:</b> ' + Format(Rec."Contract ID") + '<br/>' + // Added Contract ID
                    '<b>Unit Number:</b> ' + Rec."Unit Number" + '<br/>' +   // Added Unit Number
                    '<b>Property Name:</b> ' + Rec."Property Name" + '<br/>' +
                    '<b>Location:</b> ' + CurrentEmirateValue + '   ' + Rec.Community + '<br/>' +
                    '<b>Contract Period:</b> ' + Format(Rec."Contract Start Date") + '  ' + 'To' + '  ' + Format(Rec."Contract End Date") + '<br/>' +
                    '<b>Lease Amount:</b> ' + Format(Rec."Annual Rent Amount") + '<br/>' +
                    '<b>Payment Mode:</b> ' + Format(Rec."No of Installments") + '  ' + Format(Rec."Payment Method") + '</p>' + '<br/>' +
                    '<p>Kindly review the attached document thoroughly. If you have any questions or need further clarification, please do not hesitate to contact us.</p>' +
                    '<p>Thank you for choosing ' + CompanyInfo.Name + '.</p>' +
                    '<p>We look forward to serving you and ensuring a seamless tenancy experience.</p>' +
                    '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
                    '</body>' +
                    '</html>',
                    true
                );
            end;

            // Attach the generated PDF to the email
            EmailMessage.AddAttachment(FileName, '', InStream);

            // Send the email and provide feedback
            if Email.Send(EmailMessage) then
                Message('Email sent successfully to: %1', Rec."Email Address")
            else
                Error('Failed to send email. Please verify SMTP settings and email addresses.');

            exit('Email sent successfully.');
        end else
            Error('No tenancy contract details found for Tenant ID: %1', Rec."Tenant ID");
    end;
}









