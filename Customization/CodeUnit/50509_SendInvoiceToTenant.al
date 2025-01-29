codeunit 50509 SendInvoiceToTenant
{
    procedure SendInvoice()
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

    begin



        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Approval Status", SalesHeader."Approval Status"::Approved);
        if SalesHeader.FindSet() then
            repeat
                TotalAmount := 0;
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then
                    repeat

                        TotalAmount += Round(SalesLine."Amount Including VAT");

                    until SalesLine.Next() = 0;
                if CompanyInfo.Get() then begin
                    if SalesHeader."Sell-to E-Mail" = '' then begin
                        customer.Get(SalesHeader."Sell-to Customer No.");

                        EmailMessage.Create(customer."E-Mail", 'Your Invoice ' + SalesHeader."No.",
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
                          true);

                    end
                    else begin
                        EmailMessage.Create(SalesHeader."Sell-to E-Mail", 'Your Invoice ' + SalesHeader."No.",
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
                          true);
                    end;
                end;
                if Email.Send(EmailMessage) then
                    Message('Email sent successfully :)');
            until SalesHeader.Next() = 0;


    end;

}