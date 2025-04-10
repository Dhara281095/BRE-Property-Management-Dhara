codeunit 50303 "SendTenantMail"
{
    procedure SendEmailToTenant(Rec: Record "ContractEndProcessApproval"): Text;
    var
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        CompanyInfo: Record "Company Information";
        RemainingDays: Integer;
    begin

        RemainingDays := Rec."End Date" - Today;
        if Rec."Property_M Status" = 'Approved' then begin
            // Ensure that the correct record is passed and exists
            if CompanyInfo.Get() then begin
                // Create the email message
                EmailMessage.Create(
                    Rec."Tenant Email", // The recipient's email address
                    'Contract Renewal Confirmation : Contract ID - ' + Format(Rec."Contract ID"),
                    '<html><body>' +
                    '<p>Dear ' + Rec."Tenant Name" + ',</p>' +
                     '<p>I hope this email finds you well. This is a kind reminder that your contract with Contract ID - ' +
            Format(Rec."Contract ID") +
            ' is set to expire in the next <b>' +
            Format(RemainingDays) +
            ' days</b>. To ensure continuity, we would like to know if you are interested in renewing your contract.</p>' +

                    '<p>Please let us know your decision at your earliest convenience so we can proceed accordingly. If you have any questions or require assistance, feel free to reach out to us.</p>' +
                    '<p>Looking forward to your response.</p>' +
                    '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
                    '</body></html>',
                    true
                );

                // Send the email
                if Email.Send(EmailMessage) then
                    Message('Email sent successfully for Contract Renewal Confirmation: %1', Rec."Tenant Email")
                else
                    Error('Failed to send email. Please verify SMTP settings and email addresses.');
            end;
        end;
    end;
}