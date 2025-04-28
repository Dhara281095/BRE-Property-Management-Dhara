codeunit 50508 LeaseManagerSendMail
{

    trigger OnRun()
    //procedure sendmail()

    var
        EmailBody: Text;
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";

        SalesHeader: Record "Sales Header";
        FileManagement: Codeunit "File Management";
        TodayDate: Date;
        EmailAddress: List of [Text];
        CCMail: List of [Text];
        UserRec: Record User; // Record for User
        Username: Text;
        BCCMail: List of [Text];
        UserPersonalizationRec: Record "User Personalization";
        UserPersonalizationRec1: Record "User Personalization"; // Record for User Personalization
        InvoicesExist: Boolean;
    begin
        // Initialize to check if any invoices exist
        InvoicesExist := False;

        UserPersonalizationRec.SetRange("Profile ID", 'FINANCE MANAGER'); // Accounting Manager
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
            Error('No users with the "Finance Manager" profile have a valid email address.');

        UserPersonalizationRec1.SetRange("Profile ID", 'Property Manager');  // lease manager
                                                                             // if UserPersonalizationRec1.FindFirst() then begin
                                                                             //     UserRec.Get(UserPersonalizationRec1."User SID");
                                                                             //     CCMail.Add(UserRec."Contact Email");
                                                                             //     // Username := UserRec."User Name";
                                                                             //     //CCMail.Add('dhruvp6373@gmail.com');

        // end;
        if UserPersonalizationRec.FindSet() then
            repeat
                if UserRec.Get(UserPersonalizationRec."User SID") then
                    if UserRec."Contact Email" <> '' then
                        EmailAddress.Add(UserRec."Contact Email");
            until UserPersonalizationRec.Next() = 0;
        if EmailAddress.Count() = 0 then
            Error('No users with the "Property Manager" profile have a valid email address.');


        EmailBody := LeaseManagerSendInvoiceMail(InvoicesExist);

        if InvoicesExist then begin
            EmailMessage.Create(EmailAddress, 'Daily Invoice Summary', '<html>' +
                                           '<body>' +
                                           '<p>Dear ' + Username + ',</p>' +
                                           '<p>Today, new invoices were generated:</p>' +
                                           EmailBody +
                                           '<br/><br/><br/>' + 'Thank you' +
                                           '</body>' +
                                           '</html>', true, CCMail, BCCMail);
            EmailMessage.SetBodyHTMLFormatted(true);

            // if 
            Email.Send(EmailMessage)

        end;
    end;

    procedure LeaseManagerSendInvoiceMail(var InvoicesExist: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        TempEmailBody: Text;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        SalesHeader: Record "Sales Header";
        FileManagement: Codeunit "File Management";
        SalesLine: Record "Sales Line";
        TotalAmount: Decimal;
        UserRec: Record User;
        Username: Text;
        UserPersonalizationRec: Record "User Personalization";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        SalesHeader.SetRange("Posting Date", Today);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        if SalesHeader.FindSet() then begin
            InvoicesExist := True; // Set to true if any invoices are found
            TempEmailBody := '<table border = "1" style="width:100%; text-align:center;"><tr><th>Invoice No.</th><th>Contract ID</th><th>Tenant Name</th><th>Amount Including VAT</th></tr>';
            repeat
                TotalAmount := 0;
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then
                    repeat

                        TotalAmount += Round(SalesLine."Amount Including VAT");

                    until SalesLine.Next() = 0;
                TempEmailBody += StrSubstNo('<tr><td style="text-align:center;">%1</td><td style="text-align:center;">%2</td><td style="text-align:center;">%3</td><td style="text-align:center;">%4</td></tr>',
                                  SalesHeader."No.", SalesHeader."Contract ID", SalesHeader."Tenant Name", Format(TotalAmount));
            until SalesHeader.Next() = 0;
            TempEmailBody += '</table>';
        end;
        exit(TempEmailBody);
    end;
}
