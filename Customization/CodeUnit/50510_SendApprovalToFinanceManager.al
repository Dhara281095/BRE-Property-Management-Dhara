codeunit 50510 "SendApprovalToFinanceManager"
{
    procedure SendPaymentModeApprovalToFinanceManger(PaymentTransactionId: Code[50]; TenantId: Code[20]; ContractId: Integer; IsUpdate: Boolean)
    var
        EmailBody: Text;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        UserRec: Record User;
        UserPersonalizationRec: Record "User Personalization";
        FinanceManagerFullName: Text;
        EmailAddress: List of [Text];
        CCMail: List of [Text];
        BCCMail: List of [Text];
        CompanyInfo: Record "Company Information";

    begin
        // Get Finance Manager Details
        UserPersonalizationRec.SetRange("Profile ID", 'FINANCE MANAGER');
        if UserPersonalizationRec.FindSet() then begin
            repeat
                if UserRec.Get(UserPersonalizationRec."User SID") then begin
                    EmailAddress.Add(UserRec."Contact Email");
                    FinanceManagerFullName := UserRec."User Name";
                end else
                    Error('Finance Manager user not found.');
            until UserPersonalizationRec.Next = 0;
        end else
            Error('No user with Profile ID "FINANCE MANAGER" found.');

        if CompanyInfo.Get() then begin
            // Compose Email Body based on the action (New or Update)
            if IsUpdate then
                EmailBody := ComposeUpdatedEmailBody(PaymentTransactionId, TenantId, ContractId)
            else
                EmailBody := ComposeNewEmailBody(PaymentTransactionId, TenantId, ContractId);
        end else
            if IsUpdate then
                EmailBody := ComposeUpdatedEmailBody(PaymentTransactionId, TenantId, ContractId)
            else
                EmailBody := ComposeNewEmailBody(PaymentTransactionId, TenantId, ContractId);


        // Create and send the email
        EmailMessage.Create(EmailAddress, 'Payment Transaction Approval Required', EmailBody, true, CCMail, BCCMail);
        EmailMessage.SetBodyHTMLFormatted(true);

        if Email.Send(EmailMessage) then
            Message('Approval email sent successfully.')
        else
            Error('Failed to send approval email.');
    end;

    // procedure ComposeEmailBody(PaymentTransactionId: Text; TenantId: Text; ContractId: Integer): Text
    // var
    //     EmailBody: Text;
    // begin
    //     EmailBody :=
    //                 '<p>Dear FinanceTeam,<br>' +
    //                'A new Payment Transaction has been created and requires your approval. Below are the transaction details:<br>' +
    //                '<table style="border: 1px solid black; border-collapse: collapse; width: 100%; text-align: left;">' +
    //                '<tr style="background-color: #f2f2f2;">' +
    //                '<th style="border: 1px solid black; padding: 8px;">Field</th>' +
    //                '<th style="border: 1px solid black; padding: 8px;">Value</th>' +
    //                '</tr>' +
    //                '<tr><td>Payment Mode Id</td><td>%1</td></tr>' +
    //                '<tr><td>TenantId</td><td>%2</td></tr>' +
    //                '<tr><td>ContractId</td><td>%3</td></tr>' +
    //                '</table>' +
    //                '<br>' +
    //                'Please review this transaction and take the necessary action:<br>' +
    //                '<br>' +
    //                'Approve the transaction if the details are correct.<br>' +
    //                'Reject the transaction if the details are incorrect or require changes.<br>' +
    //                'You can take action directly by accessing the PDC Approval List via the link below:<br>' +
    //                '<a href="https://businesscentral.dynamics.com/0fc6d7a4-aa1d-4825-bc34-7dd0c18a4f63/RealestateDev?company=BlueRidge%20Real-Estate&page=50515&dc=0&bookmark=15_TsUAAAJ7_1AAVAAtADEAOQ">Access Payment Transaction List</a><br>' +
    //                '<br>' +
    //                'For any questions or concerns, feel free to contact the initiator of this transaction.<br>' +
    //                '<br>' +
    //                'Best regards,</p>';

    //     exit(StrSubstNo(EmailBody, PaymentTransactionId, TenantId, ContractId));
    // end;

    procedure ComposeNewEmailBody(PaymentTransactionId: Text; TenantId: Text; ContractId: Integer): Text
    var
        EmailBody: Text;
    begin
        EmailBody :=
            '<p>Dear Finance Team,<br>' +
            'A new Payment Transaction has been created and requires your approval. Below are the transaction details:<br>' +
            '<table style="border: 1px solid black; border-collapse: collapse; width: 100%; text-align: left;">' +
            '<tr style="background-color: #f2f2f2;">' +
            '<th style="border: 1px solid black; padding: 8px;">Field</th>' +
            '<th style="border: 1px solid black; padding: 8px;">Value</th>' +
            '</tr>' +
            '<tr><td>Payment Mode ID</td><td>%1</td></tr>' +
            '<tr><td>Tenant ID</td><td>%2</td></tr>' +
            '<tr><td>Contract ID</td><td>%3</td></tr>' +
            '</table>' +
            '<br>' +
            'Please review this transaction and take the necessary action:<br>' +
            '<a href="https://businesscentral.dynamics.com/0fc6d7a4-aa1d-4825-bc34-7dd0c18a4f63/RealestateDev?company=BlueRidge%20Real-Estate&page=50515&dc=0&bookmark=15_TsUAAAJ7_1AAVAAtADEAOQ">Access Payment Transaction List</a><br>' +
            '<br>' +
            'For any questions or concerns, feel free to contact the initiator of this transaction.<br>' +
            '<br>' +
            'Best regards,<br>' +
            // '[Your Name]<br>' +
            // '[Your Position]<br>' +
            // '[Company Name]'+
            '</p>';

        exit(StrSubstNo(EmailBody, PaymentTransactionId, TenantId, ContractId));
    end;

    procedure ComposeUpdatedEmailBody(PaymentTransactionId: Text; TenantId: Text; ContractId: Integer): Text
    var
        EmailBody: Text;
    begin
        EmailBody :=
            '<p>Dear Finance Manager,<br>' +
            'We have updated the payment details as per the feedback. Kindly review and approve the revised entry for the <strong> contract ' + Format(ContractId) + '</strong> for further processing.<br>' +
            '<br>' +
            // '<strong>Updated Payment Details:</strong><br>' +
            // '<table style="border: 1px solid black; border-collapse: collapse; width: 100%; text-align: left;">' +
            // '<tr style="background-color: #f2f2f2;">' +
            // '<th style="border: 1px solid black; padding: 8px;">SL No.</th>' +
            // '<th style="border: 1px solid black; padding: 8px;">Contract ID</th>' +
            // '<th style="border: 1px solid black; padding: 8px;">Payment ID</th>' +
            // '<th style="border: 1px solid black; padding: 8px;">Description</th>' +
            // '<th style="border: 1px solid black; padding: 8px;">Status</th>' +
            // '</tr>' +
            // '<tr>' +
            // '<td>1</td>' +
            // '<td>%1</td>' +
            // '<td>%2</td>' +
            // '<td>[Description]</td>' +
            // '<td>Pending Approval</td>' +
            // '</tr>' +
            // '</table>' +
            // '<br>' +
            'Please review and provide your approval at your earliest convenience.<br>' +
            '<br>' +
            'Best regards,<br>' +
            // '[Your Name]<br>' +
            // '[Your Position]<br>' +
            // '[Company Name]'+
            '</p>';

        exit(StrSubstNo(EmailBody, ContractId, PaymentTransactionId));
    end;
}