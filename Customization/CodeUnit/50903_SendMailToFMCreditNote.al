codeunit 50903 "Send Mail to FM Credit Note"
{
    procedure SendMailToFM(Rec: Record "Sales Header")
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
        InvoiceLink: Text;

    begin
        UserPersonalizationRec.SetRange("Profile ID", 'FINANCE MANAGER');
        // if UserPersonalizationRec.FindFirst() then begin
        //     UserRec.Get(UserPersonalizationRec."User SID");
        //     EmailAddress.Add(UserRec."Contact Email");
        //     Username := UserRec."User Name";
        // end;
        if UserPersonalizationRec.FindSet() then
            repeat
                if UserRec.Get(UserPersonalizationRec."User SID") then
                    if UserRec."Contact Email" <> '' then
                        EmailAddress.Add(UserRec."Contact Email");
            until UserPersonalizationRec.Next() = 0;
        if EmailAddress.Count() = 0 then
            Error('No users with the "Finance Manager" profile have a valid email address.');


        SalesHeader.SetRange("No.", Rec."No.");
        SalesHeader.SetRange("Document Type", Rec."Document Type"::"Credit Memo");

        if SalesHeader.FindSet() then
            repeat
                TotalAmount := 0;
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then
                    repeat
                        TotalAmount += Round(SalesLine."Amount Including VAT");
                    until SalesLine.Next() = 0;
            until SalesHeader.Next = 0;
        InvoiceLink := GETURL(ClientType::Current, COMPANYNAME, ObjectType::Page, PAGE::"Sales Credit Memo", Rec);
        if CompanyInfo.get() then begin
            EmailMessage.Create(EmailAddress, 'Approval Required: Sales Credit Memo' + SalesHeader."No." + 'for' + salesheader."Sell-to Customer Name",
            '<html>' +
                         '<body>' +
                         '<p>Dear ' + Username + ',</p>' +
                         '<p>I have prepared a Sales Credit Memo requiring your review and approval. Below are the key details:</p>' +
                         '<h3>Sales Credit Memo Details:</h3>' +
                         '<p><b>Credit Memo No.</b> ' + SalesHeader."No." + '<br/>' +
                            '<b>Customer Name:</b> ' + SalesHeader."Sell-to Customer Name" + '<br/>' +
                            '<b>Customer No.:</b> ' + SalesHeader."Sell-to Customer No." + '<br/>' +
                            '<b>Posting Date:</b> ' + Format(SalesHeader."Posting Date") + '<br/>' +
                            '<b>Original Invoice No.:</b> ' + SalesHeader."Applies-to Doc. No." + '<br/>' +
                         '<b>Contract ID:</b> ' + Format(SalesHeader."Contract ID") + '<br/>' +
                         '<b>Property Name:</b> ' + SalesHeader."Property Name" + '<br/>' +
                         '<b>Total Amount:</b> ' + Format(TotalAmount) + '<br/>' +
                         '<p>Please review the updated details and provide your approval at your earliest convenience. If any adjustments are needed, kindly let us know.</p>' +
                       '<p><a href="' + InvoiceLink + '" target="_blank">Click here to view the Credit Note</a></p>' +
                         '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +

                        '</body>' +
                        '</html>',
                        true);

            if Email.Send(EmailMessage)
   then begin
                Message('Email sent successfully.');
            end
            else begin
                Error('Failed to send email.');
            end;
        end;

    end;
}