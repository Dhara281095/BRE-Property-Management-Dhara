// codeunit 50503 "Send Contract Email"
// {
//     procedure SendEmail(Rec: Record "Tenancy Contract"): Text;
//     var
//         TempBlob: Codeunit "Temp Blob";
//         OutStream: OutStream;
//         InStream: InStream;
//         FileName: Text[250];
//         TempFilePath: Text[250];
//         ReportID: Integer;
//         Email: Codeunit "Email";
//         EmailMessage: Codeunit "Email Message";
//         CompanyInfo: Record "Company Information";
//         ConsolidatedInvoiceHeader: Record "Tenancy Contract";
//         RecRef: RecordRef;
//         FileManagement: Codeunit "File Management";
//     begin
//         ReportID := 50101; // Replace with your actual report ID for the Tenancy Contract document

//         // Apply filters to fetch the specific record
//         ConsolidatedInvoiceHeader.Reset();
//         ConsolidatedInvoiceHeader.SetRange("Tenant ID", Rec."Tenant ID");
//         ConsolidatedInvoiceHeader.SetRange("Contract ID", Rec."Contract ID"); // Ensure filtering on unique ID

//         // Fetch the correct record
//         if ConsolidatedInvoiceHeader.FindFirst() then begin
//             // Prepare the report output
//             RecRef.GetTable(ConsolidatedInvoiceHeader);
//             TempBlob.CreateOutStream(OutStream);

//             Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

//             TempBlob.CreateInStream(InStream);
//             FileName := 'Contract_' + Format(ConsolidatedInvoiceHeader."Tenant ID") + '.pdf';

//             // Debugging to confirm email creation parameters
//             Message('Preparing to send email to: %1', ConsolidatedInvoiceHeader."Email Address");

//             // Retrieve company information
//             if CompanyInfo.Get() then begin
//                 // Create email with detailed contract information
//                 EmailMessage.Create(
//                     ConsolidatedInvoiceHeader."Email Address",
//                     'Tenancy Contract Document Attached_' + Format(ConsolidatedInvoiceHeader."Tenant ID"),
//                     '<html>' +
//                     '<body>' +
//                     '<p>Dear ' + ConsolidatedInvoiceHeader."Customer Name" + ',</p>' +
//                     '<p>We are pleased to inform you that the tenancy contract for your property has been finalized. Please find the contract document attached to this email for your review and records.</p>' +
//                     '<h3>Contract Summary:</h3>' +
//                     '<b>Property Name:</b> ' + Format(ConsolidatedInvoiceHeader."Property Name") + '<br/>' +
//                     '<b>Unit Number:</b> ' + Format(ConsolidatedInvoiceHeader."Unit Number") + '<br/>' +
//                     '<b>Location:</b> ' + Format(ConsolidatedInvoiceHeader.Emirate) + ' ' + Format(ConsolidatedInvoiceHeader.Community) + '<br/>' +
//                     '<b>Contract ID:</b> ' + Format(ConsolidatedInvoiceHeader."Contract ID") + '<br/>' +
//                     '<b>Contract Period:</b> ' + Format(ConsolidatedInvoiceHeader."Contract Start Date", 0, '<Day,2>-<Month,2>-<Year4>') + ' To ' + Format(ConsolidatedInvoiceHeader."Contract End Date", 0, '<Day,2>-<Month,2>-<Year4>') + '<br/>' +
//                     '<b>Lease Amount:</b> ' + Format(ConsolidatedInvoiceHeader."Annual Rent Amount") + '<br/>' +
//                     '<b>Payment Mode:</b> ' + Format(ConsolidatedInvoiceHeader."No of Installments") + '  ' + Format(ConsolidatedInvoiceHeader."Payment Method") + '</p>' +
//                     '<p>Kindly review the attached document thoroughly. If you have any questions or need further clarification, please do not hesitate to contact us.</p>' + CompanyInfo.Name +
//                     '<h3>Important:</h3>' +
//                     '<p>By signing this agreement, you acknowledge and agree to the terms outlined in the document. Please ensure to return the signed copy to us within the stipulated timeline.</p>' +
//                     '<p>Thank you for choosing ' + CompanyInfo.Name + '.</p>' +
//                     '<p>We look forward to serving you and ensuring a seamless tenancy experience.</p>' +
//                     '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
//                     '</body>' +
//                     '</html>',
//                     true
//                 );

//                 // Attach the PDF document
//                 EmailMessage.AddAttachment(FileName, '', InStream);

//                 // Send the email
//                 if Email.Send(EmailMessage) then
//                     Message('Email sent successfully to: %1', ConsolidatedInvoiceHeader."Email Address")
//                 else
//                     Error('Failed to send email. Please verify SMTP settings and email addresses.');
//             end;

//             exit('Email sent successfully');
//         end else
//             Error('No tenancy contract details found for Tenant ID: %1, Contract ID: %2', Rec."Tenant ID", Rec."Contract ID");
//     end;
// }



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
        ConsolidatedInvoiceHeader: Record "Tenancy Contract";
        RecRef: RecordRef;
        CurrentEmirateValue: Text;
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

        ConsolidatedInvoiceHeader.SetRange("Tenant ID", Rec."Tenant ID");

        if ConsolidatedInvoiceHeader.FindSet() then begin
            // Explicitly set the Emirate value to ensure it's correct
            ConsolidatedInvoiceHeader.Emirate := CurrentEmirateValue;

            // Prepare the record for the report
            RecRef.GetTable(ConsolidatedInvoiceHeader);

            // Generate the report and save it as a PDF
            TempBlob.CreateOutStream(OutStream);
            Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

            // Prepare the file name for the attachment
            TempBlob.CreateInStream(InStream);
            FileName := 'Contract_' + Format(ConsolidatedInvoiceHeader."Tenant ID") + '.pdf';

            // Debugging to confirm email creation parameters
            Message('Preparing to send email to: %1', ConsolidatedInvoiceHeader."Email Address");

            if CompanyInfo.Get() then begin
                // Create the email message
                EmailMessage.Create(
                    ConsolidatedInvoiceHeader."Email Address",
                    'Tenancy Contract Document Attached_' + Format(ConsolidatedInvoiceHeader."Tenant ID"),
                    '<html>' +
                    '<body>' +
                    '<p>Dear ' + ConsolidatedInvoiceHeader."Customer Name" + ',</p>' +
                    '<p>We are pleased to inform you that the tenancy contract for your property has been finalized. Please find the contract document attached to this email for your review and records.</p>' +
                    '<h3>Contract Summary:</h3>' +
                    '<p><b>Contract ID:</b> ' + Format(ConsolidatedInvoiceHeader."Contract ID") + '<br/>' + // Added Contract ID
                    '<b>Unit Number:</b> ' + ConsolidatedInvoiceHeader."Unit Number" + '<br/>' +   // Added Unit Number
                    '<b>Property Name:</b> ' + ConsolidatedInvoiceHeader."Property Name" + '<br/>' +
                    '<b>Location:</b> ' + CurrentEmirateValue + '   ' + ConsolidatedInvoiceHeader.Community + '<br/>' +
                    '<b>Contract Period:</b> ' + Format(ConsolidatedInvoiceHeader."Contract Start Date") + '  ' + 'To' + '  ' + Format(ConsolidatedInvoiceHeader."Contract End Date") + '<br/>' +
                    '<b>Lease Amount:</b> ' + Format(ConsolidatedInvoiceHeader."Annual Rent Amount") + '<br/>' +
                    '<b>Payment Mode:</b> ' + Format(ConsolidatedInvoiceHeader."No of Installments") + '  ' + Format(ConsolidatedInvoiceHeader."Payment Method") + '</p>' + '<br/>' +
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
                Message('Email sent successfully to: %1', ConsolidatedInvoiceHeader."Email Address")
            else
                Error('Failed to send email. Please verify SMTP settings and email addresses.');

            exit('Email sent successfully.');
        end else
            Error('No tenancy contract details found for Tenant ID: %1', Rec."Tenant ID");
    end;
}








