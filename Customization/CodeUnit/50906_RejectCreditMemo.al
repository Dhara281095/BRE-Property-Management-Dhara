codeunit 50906 "Reject Credit Memo"
{
    procedure SendInvoiceToLeaseManager(Rec: Record "Sales Header")
    var
        EmailBody: Text;
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        customer: Record Customer;
        SalesHeader: Record "Sales Header";
        FileManagement: Codeunit "File Management";
        TodayDate: Date;
        EmailAddress: List of [Text];
        CCMail: List of [Text];
        UserRec: Record User; // Record for User
        Username: Text;
        BCCMail: List of [Text];
        // Record for User Personalization
        TempEmailBody: Text;
        SalesLine: Record "Sales Line";
        TotalAmount: Decimal;
        CompanyInfo: Record "Company Information";
        RecRef: RecordRef;
        UserPersonalizationRec: Record "User Personalization";
        Creditmemolink: Text;

    begin
        UserPersonalizationRec.SetRange("Profile ID", 'LEASE_MANAGER'); // Accounting Manager
        // if UserPersonalizationRec.FindFirst() then begin
        //     UserRec.Get(UserPersonalizationRec."User SID");
        //     EmailAddress.Add(UserRec."Contact Email");
        //     Username := UserRec."User Name";
        //     //CCMail.Add('dhruvp6373@gmail.com');
        // end;
        if UserPersonalizationRec.FindSet() then
            repeat
                if UserRec.Get(UserPersonalizationRec."User SID") then
                    if UserRec."Contact Email" <> '' then
                        EmailAddress.Add(UserRec."Contact Email");
            until UserPersonalizationRec.Next() = 0;
        if EmailAddress.Count() = 0 then
            Error('No users with the "LEASE_MANAGER" profile have a valid email address.');

        SalesHeader.SetRange("No.", Rec."No.");
        SalesHeader.SetRange("Document Type", Rec."Document Type"::"Credit Memo");


        if SalesHeader.FindSet(true) then
            repeat

                TotalAmount := 0;
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then
                    repeat
                        TotalAmount += Round(SalesLine."Amount Including VAT");
                    until SalesLine.Next() = 0;

                Creditmemolink := GETURL(ClientType::Current, COMPANYNAME, ObjectType::Page, PAGE::"Sales Credit Memo", Rec);

                if CompanyInfo.Get() then begin

                    EmailMessage.Create(EmailAddress, 'Credit Memo Rejection Notification - ' + SalesHeader."No.",
                        '<html>' +
                         '<body>' +
                         '<p>Dear ' + Username + ',</p>' +
                         '<h3>Credit Memo Rejection Details:</h3>' +
                         '<p>The following invoice has been rejected:</p>' +
                         '<p><b>Invoice ID:</b> ' + SalesHeader."No." + '<br/>' +
                         '<b>Contract ID:</b> ' + Format(SalesHeader."Contract ID") + '<br/>' +
                          '<b>Applies-to Invoice No.:</b> ' + SalesHeader."Applies-to Doc. No." + '<br/>' +
                         '<b>Property Name:</b> ' + SalesHeader."Property Name" + '<br/>' +
                         '<b>Total Amount:</b> ' + Format(TotalAmount) + '<br/>' +
                         '<b>Reason For Rejection:</b> ' + SalesHeader."Rejection Reason CreditNote" + '<br/>' +
                         '<p>Please review the details and update the Credit Memo</p>' +
                         '<p><a href="' + Creditmemolink + '" target="_blank">Click here to view the Credit Memo</a></p>' +
                         '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +

                        '</body>' +
                        '</html>',
                        true);
                end;

                if Email.Send(EmailMessage)
                then begin
                    Message('Rejection email sent successfully.');
                end
                else begin
                    Error('Failed to send rejection email.');
                end;

            until SalesHeader.Next() = 0;
    end;
}