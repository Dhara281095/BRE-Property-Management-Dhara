codeunit 50511 "SendRejectionToLeaseTeam"
{
    procedure SendPaymentRejectionToLeaseManager(PaymentModeId: Integer; TenantId: Code[20]; ContractId: Integer; RejectionReason: Text)
    var
        EmailBody: Text;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        UserRec: Record User;
        UserPersonalizationRec: Record "User Personalization";
        LeasingManagerFullName: Text;
        EmailAddress: List of [Text];
        CCMail: List of [Text];
        BCCMail: List of [Text];
        CompanyInfo: Record "Company Information";

    begin
        // Get Leasing Manager Details
        UserPersonalizationRec.SetRange("Profile ID", 'LEASE_MANAGER');
        if UserPersonalizationRec.FindSet() then begin
            repeat
                if UserRec.Get(UserPersonalizationRec."User SID") then begin
                    EmailAddress.Add(UserRec."Contact Email");
                    LeasingManagerFullName := UserRec."User Name";
                end else
                    Error('Leasing Manager user not found.');
            until UserPersonalizationRec.Next = 0;
        end else
            Error('No user with Profile ID "LEASING MANAGER" found.');


        // Compose Email Body
        EmailBody := ComposeRejectionEmailBody(PaymentModeId, TenantId, ContractId, RejectionReason, LeasingManagerFullName, CompanyInfo.Name);

        // Create and send the email
        EmailMessage.Create(EmailAddress, 'Payment Entry Rejected – Action Required', EmailBody, true, CCMail, BCCMail);
        EmailMessage.SetBodyHTMLFormatted(true);

        if Email.Send(EmailMessage) then
            Message('Rejection email sent successfully.')
        else
            Error('Failed to send rejection email.');
    end;

    procedure ComposeRejectionEmailBody(PaymentTransactionId: Integer; TenantId: Text; ContractId: Integer; RejectionReason: Text; LeasingManagerFullName: Text; Compnyname: Text): Text
    var
        EmailBody: Text;
    begin
        EmailBody :=
            '<p>Dear Leasing Team,<br>' +
            'The payment entry for the following transaction has been reviewed and rejected by the Finance Manager due to the following reason(s):<br>' +
            '<strong>Reason for Rejection:</strong> ' + RejectionReason + '<br><br>' +
            'Below are the details of the rejected transaction:<br>' +
            '<table style="border: 1px solid black; border-collapse: collapse; width: 100%; text-align: left;">' +
            '<tr style="background-color: #f2f2f2;">' +
            '<th style="border: 1px solid black; padding: 8px;">Field</th>' +
            '<th style="border: 1px solid black; padding: 8px;">Value</th>' +
            '</tr>' +
            '<tr><td>Payment Transaction ID</td><td>%1</td></tr>' +
            '<tr><td>Tenant ID</td><td>%2</td></tr>' +
            '<tr><td>Contract ID</td><td>%3</td></tr>' +
            '</table>' +
            '<br>' +
            'Action Required:<br>' +
            'Please review the transaction and update the details as necessary to resolve the issue.<br>' +
            '<br>' +
            'You can take the necessary action by accessing the Payment Transactions List via the link below:<br>' +
            '<a href="https://businesscentral.dynamics.com/0fc6d7a4-aa1d-4825-bc34-7dd0c18a4f63/RealestateDev?company=BlueRidge%20Real-Estate&page=50515&dc=0&bookmark=15_TsUAAAJ7_1AAVAAtADEAOQ">Access Payment Transaction List</a><br>' +
            '<br>' +
            'If you have any questions, please contact the Finance Manager for clarification.<br>' +
            '<br>' +
            'Best regards,</p>' +
            '<p> Finance Team<br>' +
            '%4</p>';

        exit(StrSubstNo(EmailBody, PaymentTransactionId, TenantId, ContractId, Compnyname));
    end;
}