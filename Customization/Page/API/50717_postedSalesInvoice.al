namespace BREPropertyManagemenMeghatMaster.BREPropertyManagemenMeghatMaster;

using Microsoft.Sales.History;

page 50717 postedSalesInvoice
{
    APIGroup = 'payment';
    APIPublisher = 'RealeststeDev';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'postedSalesInvoice';
    DelayedInsert = true;
    EntityName = 'postedSalesInvoice';
    EntitySetName = 'postedSalesInvoices';
    PageType = API;
    ODataKeyFields = SystemId;
    SourceTable = "Sales Invoice Header";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(allowLineDisc; Rec."Allow Line Disc.")
                {
                    Caption = 'Allow Line Disc.';
                }
                field("ViewDocumentURL"; Rec."View Document URL")
                {
                    Caption = 'View Document URL';
                }
                field("ViewInvoice"; Rec."View Invoice")
                {
                    Caption = 'View Invoice';
                }
                field(altGenBusPostingGroup; Rec."Alt. Gen. Bus Posting Group")
                {
                    Caption = 'Alternative Gen. Bus. Posting Group';
                }
                field(altVATBusPostingGroup; Rec."Alt. VAT Bus Posting Group")
                {
                    Caption = 'Alternative VAT Bus. Posting Group';
                }
                field(altVATRegistrationNo; Rec."Alt. VAT Registration No.")
                {
                    Caption = 'Alternative VAT Registration No.';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(amountIncludingVAT; Rec."Amount Including VAT")
                {
                    Caption = 'Amount Including VAT';
                }
                field(appliesToDocNo; Rec."Applies-to Doc. No.")
                {
                    Caption = 'Applies-to Doc. No.';
                }
                field(appliesToDocType; Rec."Applies-to Doc. Type")
                {
                    Caption = 'Applies-to Doc. Type';
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                }
                field("area"; Rec."Area")
                {
                    Caption = 'Area';
                }
                field(balAccountNo; Rec."Bal. Account No.")
                {
                    Caption = 'Bal. Account No.';
                }
                field(balAccountType; Rec."Bal. Account Type")
                {
                    Caption = 'Bal. Account Type';
                }
                field(billToAddress; Rec."Bill-to Address")
                {
                    Caption = 'Bill-to Address';
                }
                field(billToAddress2; Rec."Bill-to Address 2")
                {
                    Caption = 'Bill-to Address 2';
                }
                field(billToCity; Rec."Bill-to City")
                {
                    Caption = 'Bill-to City';
                }
                field(billToContact; Rec."Bill-to Contact")
                {
                    Caption = 'Bill-to Contact';
                }
                field(billToContactNo; Rec."Bill-to Contact No.")
                {
                    Caption = 'Bill-to Contact No.';
                }
                field(billToCountryRegionCode; Rec."Bill-to Country/Region Code")
                {
                    Caption = 'Bill-to Country/Region Code';
                }
                field(billToCounty; Rec."Bill-to County")
                {
                    Caption = 'Bill-to County';
                }
                field(billToCustomerNo; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-to Customer No.';
                }
                field(billToName; Rec."Bill-to Name")
                {
                    Caption = 'Bill-to Name';
                }
                field(billToName2; Rec."Bill-to Name 2")
                {
                    Caption = 'Bill-to Name 2';
                }
                field(billToPostCode; Rec."Bill-to Post Code")
                {
                    Caption = 'Bill-to Post Code';
                }
                // field(cfdiCancellationID; Rec."CFDI Cancellation ID")
                // {
                //     Caption = 'CFDI Cancellation ID';
                // }
                // field(cfdiCancellationReasonCode; Rec."CFDI Cancellation Reason Code")
                // {
                //     Caption = 'CFDI Cancellation Reason';
                // }
                // field(cfdiExportCode; Rec."CFDI Export Code")
                // {
                //     Caption = 'CFDI Export Code';
                // }
                // field(cfdiPeriod; Rec."CFDI Period")
                // {
                //     Caption = 'CFDI Period';
                // }
                // field(cfdiPurpose; Rec."CFDI Purpose")
                // {
                //     Caption = 'CFDI Purpose';
                // }
                // field(cfdiRelation; Rec."CFDI Relation")
                // {
                //     Caption = 'CFDI Relation';
                // }
                field(campaignNo; Rec."Campaign No.")
                {
                    Caption = 'Campaign No.';
                }
                field(cancelled; Rec.Cancelled)
                {
                    Caption = 'Cancelled';
                }
                // field(certificateSerialNo; Rec."Certificate Serial No.")
                // {
                //     Caption = 'Certificate Serial No.';
                // }
                field(closed; Rec.Closed)
                {
                    Caption = 'Closed';
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
                field(companyBankAccountCode; Rec."Company Bank Account Code")
                {
                    Caption = 'Company Bank Account Code';
                }
                field(contractID; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                }
                field(contractPeriod; Rec."Contract Period")
                {
                    Caption = 'Contract Period';
                }
                field(contractTenure; Rec."Contract Tenure")
                {
                    Caption = 'Contract Tenure';
                }
                field(correction; Rec.Correction)
                {
                    Caption = 'Correction';
                }
                field(corrective; Rec.Corrective)
                {
                    Caption = 'Corrective';
                }
                // field(coupledToCRM; Rec."Coupled to CRM")
                // {
                //     Caption = 'Coupled to Dynamics 365 Sales';
                // }
                field(coupledToDataverse; Rec."Coupled to Dataverse")
                {
                    Caption = 'Coupled to Dynamics 365 Sales';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(currencyFactor; Rec."Currency Factor")
                {
                    Caption = 'Currency Factor';
                }
                field(custLedgerEntryNo; Rec."Cust. Ledger Entry No.")
                {
                    Caption = 'Cust. Ledger Entry No.';
                }
                field(customerDiscGroup; Rec."Customer Disc. Group")
                {
                    Caption = 'Customer Disc. Group';
                }
                field(customerPO; Rec."Customer P.O")
                {
                    Caption = 'Customer P.O';
                }
                field(customerPODate; Rec."Customer P.O Date")
                {
                    Caption = 'Customer P.O Date';
                }
                field(customerPostingGroup; Rec."Customer Posting Group")
                {
                    Caption = 'Customer Posting Group';
                }
                field(customerPriceGroup; Rec."Customer Price Group")
                {
                    Caption = 'Customer Price Group';
                }
                // field(dateTimeCancelSent; Rec."Date/Time Cancel Sent")
                // {
                //     Caption = 'Date/Time Cancel Sent';
                // }
                // field(dateTimeCanceled; Rec."Date/Time Canceled")
                // {
                //     Caption = 'Date/Time Canceled';
                // }
                // field(dateTimeFirstReqSent; Rec."Date/Time First Req. Sent")
                // {
                //     Caption = 'Date/Time First Req. Sent';
                // }
                // field(dateTimeSent; Rec."Date/Time Sent")
                // {
                //     Caption = 'Date/Time Sent';
                // }
                // field(dateTimeStampReceived; Rec."Date/Time Stamp Received")
                // {
                //     Caption = 'Date/Time Stamp Received';
                // }
                // field(dateTimeStamped; Rec."Date/Time Stamped")
                // {
                //     Caption = 'Date/Time Stamped';
                // }
                // field(digitalStampPAC; Rec."Digital Stamp PAC")
                // {
                //     Caption = 'Digital Stamp PAC';
                // }
                // field(digitalStampSAT; Rec."Digital Stamp SAT")
                // {
                //     Caption = 'Digital Stamp SAT';
                // }
                field(dimensionSetID; Rec."Dimension Set ID")
                {
                    Caption = 'Dimension Set ID';
                }
                field(directDebitMandateID; Rec."Direct Debit Mandate ID")
                {
                    Caption = 'Direct Debit Mandate ID';
                }
                field(disputeStatus; Rec."Dispute Status")
                {
                    Caption = 'Dispute Status';
                }
                field(disputeStatusId; Rec."Dispute Status Id")
                {
                    Caption = 'Dispute Status Id';
                }
                field(docExchOriginalIdentifier; Rec."Doc. Exch. Original Identifier")
                {
                    Caption = 'Doc. Exch. Original Identifier';
                }
                field(documentDate; Rec."Document Date")
                {
                    Caption = 'Document Date';
                }
                field(documentExchangeIdentifier; Rec."Document Exchange Identifier")
                {
                    Caption = 'Document Exchange Identifier';
                }
                field(documentExchangeStatus; Rec."Document Exchange Status")
                {
                    Caption = 'Document Exchange Status';
                }
                field(draftInvoiceSystemId; Rec."Draft Invoice SystemId")
                {
                    Caption = 'Draft Invoice SystemId';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(eu3PartyTrade; Rec."EU 3-Party Trade")
                {
                    Caption = 'EU 3-Party Trade';
                }
                // field(electronicDocumentSent; Rec."Electronic Document Sent")
                // {
                //     Caption = 'Electronic Document Sent';
                // }
                // field(electronicDocumentStatus; Rec."Electronic Document Status")
                // {
                //     Caption = 'Electronic Document Status';
                // }
                // field(errorCode; Rec."Error Code")
                // {
                //     Caption = 'Error Code';
                // }
                // field(errorDescription; Rec."Error Description")
                // {
                //     Caption = 'Error Description';
                // }
                // field(exchangeRateUSD; Rec."Exchange Rate USD")
                // {
                //     Caption = 'Exchange Rate USD';
                // }
                field(exitPoint; Rec."Exit Point")
                {
                    Caption = 'Exit Point';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                // field(fiscalInvoiceNumberPAC; Rec."Fiscal Invoice Number PAC")
                // {
                //     Caption = 'Fiscal Invoice Number PAC';
                // }
                // field(foreignTrade; Rec."Foreign Trade")
                // {
                //     Caption = 'Foreign Trade';
                // }
                field(formatRegion; Rec."Format Region")
                {
                    Caption = 'Format Region';
                }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field(getShipmentUsed; Rec."Get Shipment Used")
                {
                    Caption = 'Get Shipment Used';
                }
                field(invoiceDiscCode; Rec."Invoice Disc. Code")
                {
                    Caption = 'Invoice Disc. Code';
                }
                field(invoiceDiscountAmount; Rec."Invoice Discount Amount")
                {
                    Caption = 'Invoice Discount Amount';
                }
                field(invoiceDiscountCalculation; Rec."Invoice Discount Calculation")
                {
                    Caption = 'Invoice Discount Calculation';
                }
                field(invoiceDiscountValue; Rec."Invoice Discount Value")
                {
                    Caption = 'Invoice Discount Value';
                }
                field(languageCode; Rec."Language Code")
                {
                    Caption = 'Language Code';
                }
                field(lastEmailSentMessageId; Rec."Last Email Sent Message Id")
                {
                    Caption = 'Last Email Sent Message Id';
                }
                field(lastEmailSentTime; Rec."Last Email Sent Time")
                {
                    Caption = 'Last Email Sent Time';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                // field(markedAsCanceled; Rec."Marked as Canceled")
                // {
                //     Caption = 'Marked as Canceled';
                // }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(noPrinted; Rec."No. Printed")
                {
                    Caption = 'No. Printed';
                }
                field(noSeries; Rec."No. Series")
                {
                    Caption = 'No. Series';
                }
                // field(noOfEDocumentsSent; Rec."No. of E-Documents Sent")
                // {
                //     Caption = 'No. of E-Documents Sent';
                // }
                field(onHold; Rec."On Hold")
                {
                    Caption = 'On Hold';
                }
                field(opportunityNo; Rec."Opportunity No.")
                {
                    Caption = 'Opportunity No.';
                }
                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                }
                field(orderNo; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
                field(orderNoSeries; Rec."Order No. Series")
                {
                    Caption = 'Order No. Series';
                }
                // field(originalDocumentXML; Rec."Original Document XML")
                // {
                //     Caption = 'Original Document XML';
                // }
                // field(originalString; Rec."Original String")
                // {
                //     Caption = 'Original String';
                // }
                // field(pacWebServiceName; Rec."PAC Web Service Name")
                // {
                //     Caption = 'PAC Web Service Name';
                // }
                field(packageTrackingNo; Rec."Package Tracking No.")
                {
                    Caption = 'Package Tracking No.';
                }
                field(paymentDiscount; Rec."Payment Discount %")
                {
                    Caption = 'Payment Discount %';
                }
                field(paymentMethodCode; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                }
                field(paymentReference; Rec."Payment Reference")
                {
                    Caption = 'Payment Reference';
                }
                field(paymentServiceSetID; Rec."Payment Service Set ID")
                {
                    Caption = 'Payment Service Set ID';
                }
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code';
                }
                field(pmtDiscountDate; Rec."Pmt. Discount Date")
                {
                    Caption = 'Pmt. Discount Date';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(postingDescription; Rec."Posting Description")
                {
                    Caption = 'Posting Description';
                }
                field(preAssignedNo; Rec."Pre-Assigned No.")
                {
                    Caption = 'Pre-Assigned No.';
                }
                field(preAssignedNoSeries; Rec."Pre-Assigned No. Series")
                {
                    Caption = 'Pre-Assigned No. Series';
                }
                field(prepaymentInvoice; Rec."Prepayment Invoice")
                {
                    Caption = 'Prepayment Invoice';
                }
                field(prepaymentNoSeries; Rec."Prepayment No. Series")
                {
                    Caption = 'Prepayment No. Series';
                }
                field(prepaymentOrderNo; Rec."Prepayment Order No.")
                {
                    Caption = 'Prepayment Order No.';
                }
                field(priceCalculationMethod; Rec."Price Calculation Method")
                {
                    Caption = 'Price Calculation Method';
                }
                field(pricesIncludingVAT; Rec."Prices Including VAT")
                {
                    Caption = 'Prices Including VAT';
                }
                field(promisedPayDate; Rec."Promised Pay Date")
                {
                    Caption = 'Promised Pay Date';
                }
                field(propertyName; Rec."Property Name")
                {
                    Caption = 'Property Name';
                }
                // field(qrCode; Rec."QR Code")
                // {
                //     Caption = 'QR Code';
                // }
                field(quoteNo; Rec."Quote No.")
                {
                    Caption = 'Quote No.';
                }
                field(reasonCode; Rec."Reason Code")
                {
                    Caption = 'Reason Code';
                }
                field(reasonForRejection; Rec."Reason For Rejection")
                {
                    Caption = 'Reason For Rejection';
                }
                field(registrationNumber; Rec."Registration Number")
                {
                    Caption = 'Registration No.';
                }
                field(remainingAmount; Rec."Remaining Amount")
                {
                    Caption = 'Remaining Amount';
                }
                field(responsibilityCenter; Rec."Responsibility Center")
                {
                    Caption = 'Responsibility Center';
                }
                field(reversed; Rec.Reversed)
                {
                    Caption = 'Reversed';
                }
                // field(satAddressID; Rec."SAT Address ID")
                // {
                //     Caption = 'SAT Address ID';
                // }
                // field(satInternationalTradeTerm; Rec."SAT International Trade Term")
                // {
                //     Caption = 'SAT International Trade Term';
                // }
                // field(steTransactionID; Rec."STE Transaction ID")
                // {
                //     Caption = 'STE Transaction ID';
                // }
                field(salespersonCode; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code';
                }
                field(sellToAddress; Rec."Sell-to Address")
                {
                    Caption = 'Sell-to Address';
                }
                field(sellToAddress2; Rec."Sell-to Address 2")
                {
                    Caption = 'Sell-to Address 2';
                }
                field(sellToCity; Rec."Sell-to City")
                {
                    Caption = 'Sell-to City';
                }
                field(sellToContact; Rec."Sell-to Contact")
                {
                    Caption = 'Sell-to Contact';
                }
                field(sellToContactNo; Rec."Sell-to Contact No.")
                {
                    Caption = 'Sell-to Contact No.';
                }
                field(sellToCountryRegionCode; Rec."Sell-to Country/Region Code")
                {
                    Caption = 'Sell-to Country/Region Code';
                }
                field(sellToCounty; Rec."Sell-to County")
                {
                    Caption = 'Sell-to County';
                }
                field(sellToCustomerName; Rec."Sell-to Customer Name")
                {
                    Caption = 'Sell-to Customer Name';
                }
                field(sellToCustomerName2; Rec."Sell-to Customer Name 2")
                {
                    Caption = 'Sell-to Customer Name 2';
                }
                field(sellToCustomerNo; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                field(sellToEMail; Rec."Sell-to E-Mail")
                {
                    Caption = 'Email';
                }
                field(sellToPhoneNo; Rec."Sell-to Phone No.")
                {
                    Caption = 'Sell-to Phone No.';
                }
                field(sellToPostCode; Rec."Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code';
                }
                field(shipToAddress; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address';
                }
                field(shipToAddress2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address 2';
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';
                }
                field(shipToCode; Rec."Ship-to Code")
                {
                    Caption = 'Ship-to Code';
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-to Contact';
                }
                field(shipToCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code';
                }
                field(shipToCounty; Rec."Ship-to County")
                {
                    Caption = 'Ship-to County';
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name';
                }
                field(shipToName2; Rec."Ship-to Name 2")
                {
                    Caption = 'Ship-to Name 2';
                }
                field(shipToPhoneNo; Rec."Ship-to Phone No.")
                {
                    Caption = 'Ship-to Phone No.';
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';
                }
                // field(shipToUPSZone; Rec."Ship-to UPS Zone")
                // {
                //     Caption = 'Ship-to UPS Zone';
                // }
                field(shipmentDate; Rec."Shipment Date")
                {
                    Caption = 'Shipment Date';
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                    Caption = 'Shipment Method Code';
                }
                field(shippingAgentCode; Rec."Shipping Agent Code")
                {
                    Caption = 'Shipping Agent Code';
                }
                field(shippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    Caption = 'Shipping Agent Service Code';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                }
                // field(signedDocumentXML; Rec."Signed Document XML")
                // {
                //     Caption = 'Signed Document XML';
                // }
                field(sourceCode; Rec."Source Code")
                {
                    Caption = 'Source Code';
                }
                // field(substitutionDocumentNo; Rec."Substitution Document No.")
                // {
                //     Caption = 'Substitution Document No.';
                // }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
                field(taxAreaCode; Rec."Tax Area Code")
                {
                    Caption = 'Tax Area Code';
                }
                // field(taxExemptionNo; Rec."Tax Exemption No.")
                // {
                //     Caption = 'Tax Exemption No.';
                // }
                field(taxLiable; Rec."Tax Liable")
                {
                    Caption = 'Tax Liable';
                }
                field(tenantName; Rec."Tenant Name")
                {
                    Caption = 'Tenant Name';
                }
                field(transactionSpecification; Rec."Transaction Specification")
                {
                    Caption = 'Transaction Specification';
                }
                field("transactionType"; Rec."Transaction Type")
                {
                    Caption = 'Transaction Type';
                }
                // field(transitToLocation; Rec."Transit-to Location")
                // {
                //     Caption = 'Transit-to Location';
                // }
                field(transportMethod; Rec."Transport Method")
                {
                    Caption = 'Transport Method';
                }
                field(unitName; Rec."Unit Name")
                {
                    Caption = 'Unit Name';
                }
                field(userID; Rec."User ID")
                {
                    Caption = 'User ID';
                }
                field(vatBaseDiscount; Rec."VAT Base Discount %")
                {
                    Caption = 'VAT Base Discount %';
                }
                field(vatBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    Caption = 'VAT Bus. Posting Group';
                }
                field(vatCountryRegionCode; Rec."VAT Country/Region Code")
                {
                    Caption = 'VAT Country/Region Code';
                }
                field(vatRegistrationNo; Rec."VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
                }
                field(vatReportingDate; Rec."VAT Reporting Date")
                {
                    Caption = 'VAT Date';
                }
                field(workDescription; Rec."Work Description")
                {
                    Caption = 'Work Description';
                }
                field(yourReference; Rec."Your Reference")
                {
                    Caption = 'Your Reference';
                }
            }
        }
    }
}
