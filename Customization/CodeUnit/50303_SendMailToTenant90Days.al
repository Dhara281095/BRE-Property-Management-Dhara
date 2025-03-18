codeunit 50303 "SendTenantMail"
{
    procedure SendEmailToTenant(Rec: Record "ContractEndProcessApproval"): Text;
    var
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        CompanyInfo: Record "Company Information";
    begin
        if Rec."Property_M Status" = 'Approved' then begin
            // Ensure that the correct record is passed and exists
            if CompanyInfo.Get() then begin
                // Create the email message
                EmailMessage.Create(
                    Rec."Tenant Email", // The recipient's email address
                    'Payment Mode Details - ' + Format(Rec."Contract ID"),
                    '<html><body>' +
                    '<p>Dear ' + Rec."Tenant Name" + ',</p>' +
                    '<p>I hope this message finds you well. We confirm the receipt of your payment towards Rent/Charges.</p>' +
                    '<h3>Details of the Payment:</h3>' +
                    '<b>Contract ID:</b> ' + Format(Rec."Contract ID") + '<br/>' +

                    '<p>Kindly review the information provided and let us know if you have any questions or need further clarification.</p>' +
                    '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
                    '</body></html>',
                    true
                );

                // Send the email
                if Email.Send(EmailMessage) then
                    Message('Email sent successfully for Payment Mode: %1', Rec."Tenant Email")
                else
                    Error('Failed to send email. Please verify SMTP settings and email addresses.');
            end;
        end;
    end;
}