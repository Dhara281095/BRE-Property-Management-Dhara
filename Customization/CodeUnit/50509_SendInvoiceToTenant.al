codeunit 50509 SendInvoiceToTenant
{
    procedure SendInvoice(Rec: Record "Sales Header")
    var
        EmailBody: Text;
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        customer: Record Customer;
        SalesHeader: Record "Sales Header";
        FileManagement: Codeunit "File Management";
        TodayDate: Date;
        Tomail: List of [Text];
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


        OutStream: OutStream;
        InStream: InStream;
        FileName: Text[250];
        TempFilePath: Text[250];
        ReportID: Integer;
        ConfirmationResult: Boolean;
        UserPersonalizationRec: Record "User Personalization";


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
            Error('No users with the "Lease Manager" profile have a valid email address.');

        ReportID := 50104;
        SalesHeader.SetRange("No.", Rec."No.");
        SalesHeader.SetRange("Document Type", Rec."Document Type"::Invoice);
        //SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        //  SalesHeader.SetRange("Approval Status", SalesHeader."Approval Status"::Approved);

        if SalesHeader.FindSet() then
            repeat
                RecRef.GetTable(SalesHeader);

                TempBlob.CreateOutStream(OutStream);

                Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

                TempBlob.CreateInStream(InStream);

                FileName := 'Invoice_' + SalesHeader."No." + '.pdf';
                TotalAmount := 0;
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then
                    repeat

                        TotalAmount += Round(SalesLine."Amount Including VAT");


                    until SalesLine.Next() = 0;
                if CompanyInfo.Get() then begin
                    if SalesHeader."Sell-to E-Mail" = '' then begin
                        customer.Get(SalesHeader."Sell-to Customer No.");
                        Tomail.Add(customer."E-Mail");
                        EmailMessage.Create(Tomail, 'Your Invoice ' + SalesHeader."No.",
                        '<html>' +
                         '<body>' +
                         '<p>Dear ' + SalesHeader."Sell-to Customer Name" + ',</p>' +
                         '<h3>Invoice Details:</h3>' +
                                           '<p><b>Contract ID:</b> ' + Format(SalesHeader."Contract ID") + '<br/>' +
                                           '<b>Property Name:</b> ' + SalesHeader."Property Name" + '<br/>' +
                                             '<b>Total Amount:</b> ' + Format(TotalAmount) + '<br/>' +
                                             '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +
                         '</body>' +
                         '</html>',
                          true, EmailAddress, BCCMail);

                    end
                    else begin
                        Tomail.Add(SalesHeader."Sell-to E-Mail");
                        EmailMessage.Create(Tomail, 'Your Invoice ' + SalesHeader."No.",
                        '<html>' +
                         '<body>' +
                         '<p>Dear ' + SalesHeader."Sell-to Customer Name" + ',</p>' +
                         '<h3>Invoice Details:</h3>' +
                                           '<p><b>Invoice ID:</b> ' + SalesHeader."No." + '<br/>' +
                                           '<b>Contract ID:</b> ' + Format(SalesHeader."Contract ID") + '<br/>' +
                                                              '<b>Property Name:</b> ' + SalesHeader."Property Name" + '<br/>' +
                                                                '<b>Total Amount:</b> ' + Format(TotalAmount) + '<br/>' +
                                                                '<p>Best regards,<br/>' + CompanyInfo.Name + '</p>' +

                                            '</body>' +
                                            '</html>',
                          true, EmailAddress, BCCMail);
                    end;
                end;
                EmailMessage.AddAttachment(FileName, '', InStream);
                ConfirmationResult := Confirm('Do you want to send the invoice email to ' + SalesHeader."Sell-to Customer Name" + '?', false);
                if ConfirmationResult then begin
                    if Email.Send(EmailMessage) then
                        Message('Email sent successfully :)');
                end else begin
                    Message('Email sending canceled.');
                end;


            until SalesHeader.Next() = 0;
    end;

}