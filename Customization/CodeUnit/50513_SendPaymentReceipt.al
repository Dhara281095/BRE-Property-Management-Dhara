codeunit 50513 "Send Payment Reciept"
{
    Subtype = Normal;

    procedure GenerateAndSendReceipt(CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStream: InStream;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        FileName: Text;
        Customer: Record Customer;
        ReportID: Integer;
        paymentReceipt: Record "Gen. Journal Line";
    begin
        // Set the correct Payment Receipt Report ID
        ReportID := 50112;

        // Ensure payment entry exists in "Gen. Journal Line"
        Clear(paymentReceipt);
        paymentReceipt.SetRange("Document Type", paymentReceipt."Document Type"::Payment);
        paymentReceipt.SetRange("Document No.", CustLedgerEntry."Document No."); // Use Document No. instead of Applies-to Doc. No.

        if not paymentReceipt.FindFirst() then
            Error('No payment found for Document No.: %1', CustLedgerEntry."Document No.");

        // Generate PDF for this specific transaction
        TempBlob.CreateOutStream(OutStr);
        Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr); // Ensure correct record is passed
        TempBlob.CreateInStream(InStream);

        // Get customer details
        if Customer.Get(CustLedgerEntry."Customer No.") then begin
            if Customer."E-Mail" = '' then
                Error('Customer does not have an email address.');

            // Set PDF File Name
            FileName := 'PaymentReceipt_' + CustLedgerEntry."Document No." + '.pdf';

            // Create Email
            EmailMessage.Create(Customer."E-Mail", 'Payment Receipt',
                'Dear ' + Customer.Name + ', please find your payment receipt attached.');

            EmailMessage.AddAttachment(FileName, '', InStream);

            if Email.Send(EmailMessage) then
                Message('Email sent successfully to: %1', Customer."E-Mail")
            else
                Error('Failed to send email. Please verify SMTP settings and email addresses.');
        end else begin
            Error('Customer record not found for Customer No. %1.', CustLedgerEntry."Customer No.");
        end;
    end;

    procedure GeneratePaymentReceipt(DocumentNo: Code[20]; RecipientEmail: Text)
    var
        EmailMsg: Codeunit "Email Message";
        EmailSender: Codeunit "Email";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStream: InStream;
        FileName: Text;
        ReportID: Integer;
    begin
        ReportId := 50112;
        if RecipientEmail = '' then
            Error('Recipient email is missing. Cannot send receipt.');

        // Generate the PDF Report
        FileName := 'PaymentReceipt_' + DocumentNo + '.pdf';
        TempBlob.CreateOutStream(OutStr);
        Report.SaveAs(ReportId, '', ReportFormat::Pdf, OutStr);
        TempBlob.CreateInStream(InStream);
        // Prepare Email Message
        EmailMsg.Create('noreply@yourcompany.com', RecipientEmail, 'Payment Receipt');
        EmailMsg.AddAttachment(FileName, '', InStream);

        // Send Email
        EmailSender.Send(EmailMsg);
    end;

    // procedure GenerateAndSendReceipt(CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     TempBlob: Codeunit "Temp Blob";
    //     OutStr: OutStream;
    //     InStream: InStream;
    //     Email: Codeunit Email;
    //     EmailMessage: Codeunit "Email Message";
    //     FileName: Text;
    //     Customer: Record Customer;
    //     recRef: RecordRef;
    //     ReportID: Integer;
    //     paymentReceipt: Record "Gen. Journal Line";
    // begin
    //     // Use standard report "Customer - Payment Receipt" (ID: 206 in standard BC)
    //     ReportID := 211;
    //     Clear(paymentReceipt);
    //     // paymentReceipt.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
    //     paymentReceipt.SetRange("Document Type", CustLedgerEntry."Document Type"::Payment);
    //     paymentReceipt.SetRange("Applies-to Doc. No.", CustLedgerEntry."Document No.");
    //     if paymentReceipt.FindSet() then begin

    //         // recRef.GetTable(CustLedgerEntry);
    //         recRef.GetTable(paymentReceipt);

    //         // Generate PDF
    //         TempBlob.CreateOutStream(OutStr);
    //         Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr, recRef);
    //         TempBlob.CreateInStream(InStream);
    //         // Get customer details
    //         if Customer.Get(CustLedgerEntry."Customer No.") then begin
    //             if Customer."E-Mail" = '' then
    //                 Error('Customer does not have an email address.');

    //             // Create Email
    //             EmailMessage.Create('pinkal@miraclecloud-technology.com', 'Payment Receipt', 'Dear ' + Customer.Name + ', please find your payment receipt attached.');
    //             EmailMessage.AddAttachment('PaymentReceipt.pdf', '', InStream);
    //             // Email.Send(EmailMessage);
    //             if Email.Send(EmailMessage) then
    //                 Message('Email sent successfully to: %1', Customer."E-Mail")
    //             else
    //                 Error('Failed to send email. Please verify SMTP settings and email addresses.');
    //         end else begin
    //             Error('Customer record not found for Customer No. %1.', CustLedgerEntry."Customer No.");
    //         end;
    //     end;
    // end;

    procedure SendReceiptEmail(CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStream: InStream;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        FileName: Text;
        Customer: Record Customer;
        ReportID: Integer;
        paymentReceipt: Record "Gen. Journal Line";
    begin
        // **Set Report ID (Ensure this matches your report in Business Central)**
        ReportID := 50112;

        // **Filter for the specific payment record matching the CustLedgerEntry**
        Clear(paymentReceipt);
        paymentReceipt.SetRange("Document Type", paymentReceipt."Document Type"::Payment);
        paymentReceipt.SetRange("Applies-to Doc. No.", CustLedgerEntry."Document No.");

        if paymentReceipt.FindFirst() then begin
            // **Generate PDF for this specific transaction**
            TempBlob.CreateOutStream(OutStr);
            Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr); // **Corrected Syntax**
            TempBlob.CreateInStream(InStream);

            // **Get customer details**
            if Customer.Get(CustLedgerEntry."Customer No.") then begin
                if Customer."E-Mail" = '' then
                    Error('Customer does not have an email address.');

                // **Set PDF File Name**
                FileName := 'PaymentReceipt_' + CustLedgerEntry."Document No." + '.pdf';

                // **Create Email**
                EmailMessage.Create(Customer."E-Mail", 'Payment Receipt',
                    'Dear ' + Customer.Name + ', please find your payment receipt attached.');

                EmailMessage.AddAttachment(FileName, '', InStream);

                if Email.Send(EmailMessage) then
                    Message('Email sent successfully to: %1', Customer."E-Mail")
                else
                    Error('Failed to send email. Please verify SMTP settings and email addresses.');
            end else begin
                Error('Customer record not found for Customer No. %1.', CustLedgerEntry."Customer No.");
            end;
        end else begin
            Error('No payment receipt found for Document No.: %1', CustLedgerEntry."Document No.");
        end;
    end;

    local procedure GetCustomerEmail(CustomerNo: Code[20]): Text
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then
            exit(Customer."E-Mail")
        else
            exit('');
    end;

    procedure SendPaymentReceiptEmail(PaymentEntry: Record "Payment Mode2")
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStream: InStream;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        FileName: Text;
        Tenant: Record Customer; // Assuming Tenant Table exists
        ReportID: Integer;
    begin
        // 🔹 Set the correct Payment Receipt Report ID
        ReportID := 50112;  // Change to your actual report ID

        // 🔹 Generate PDF for this Payment Entry
        TempBlob.CreateOutStream(OutStr);
        Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr);
        TempBlob.CreateInStream(InStream);

        // 🔹 Get Tenant details (assuming relation with Payment Entry)
        if Tenant.Get(PaymentEntry."Tenant ID") then begin
            if Tenant."E-Mail" = '' then
                Error('Tenant does not have an email address.');

            // 🔹 Set PDF File Name
            FileName := 'PaymentReceipt_' + Format(PaymentEntry."Contract ID") + '.pdf';

            // 🔹 Create Email
            EmailMessage.Create(Tenant."E-Mail", 'Payment Receipt',
                'Dear ' + Tenant.Name + ', your payment has been received. Please find your receipt attached.');

            EmailMessage.AddAttachment(FileName, '', InStream);

            if Email.Send(EmailMessage) then
                Message('Email sent successfully to Tenant: %1', Tenant."E-Mail")
            else
                Error('Failed to send email. Please verify SMTP settings and email addresses.');
        end else begin
            Error('Tenant record not found for Tenant ID %1.', PaymentEntry."Tenant ID");
        end;
    end;


    // procedure SendPaymentReceiptEmail(CustomerNo: Code[20]; CustLedgerEntryNo: Integer)
    // var
    //     ReportObj: Report;
    //     ReportInStream: InStream;
    //     TempBlob: Codeunit "Temp Blob";
    //     EmailMsg: Codeunit "Email Message";
    //     EmailAttachment: Codeunit "Email Attachment";
    //     Customer: Record Customer;
    // begin
    //     if Customer.Get(CustomerNo) then begin
    //         // Generate PDF
    //         TempBlob.CreateOutStream(ReportInStream);
    //         ReportObj.SetTableView(CustLedgerEntryNo);
    //         ReportObj.SaveAs("Customer Payment Receipt", ReportInStream, ReportFormat::Pdf);

    //         // Prepare Email
    //         EmailMsg.Create('customer@company.com', 'Customer Payment Receipt', 'Please find attached your payment receipt.');
    //         EmailAttachment.SetStream(ReportInStream, 'CustomerPaymentReceipt_' + CustomerNo + '.pdf', 'application/pdf');
    //         EmailMsg.AddAttachment(EmailAttachment);

    //         // Send Email
    //         EmailMsg.Send();
    //     end;
    // end;

}