page 50942 "Vendor Profile Card"
{
    PageType = Card;
    SourceTable = "Vendor Profile";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Identification")
            {
                Caption = 'Vendor Identification Details';

                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }

                field("Vendor Contact No."; Rec."Vendor Contact No.")
                {
                    ApplicationArea = All;
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor Category"; Rec."Vendor Category")
                {
                    ApplicationArea = All;
                }

                field("Privacy Blocked"; Rec."Privacy Blocked")
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field("Document Sending Profile"; Rec."Document Sending Profile")
                {
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Disable Search by Name"; Rec."Disable Search by Name")
                {
                    ApplicationArea = All;
                }
                field("Company Size Code"; Rec."Company Size Code")
                {
                    ApplicationArea = All;
                }

                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                }

                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies which transactions with the vendor that cannot be processed, for example a vendor that is declared insolvent.';
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts including VAT on all completed purchase invoices and credit memos.';
                }
                field("Balance Due (LCY) As Customer"; Rec."Balance Due (LCY) As Customer")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts including VAT on all completed purchase invoices and credit memos.';
                }
                field("Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts including VAT on all open purchase invoices and credit memos.';
                }
            }

            group("Address & Contact")
            {
                Caption = 'Address & Contact';
                group(AddressDetails)
                {
                    Caption = 'Address';
                    field(Address; Rec.Address)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the vendor''s address.';
                    }
                    field("Address 2"; Rec."Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Country/Region Code"; Rec."Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(City; Rec.City)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the vendor''s city.';
                    }
                    field(Country; Rec.Country)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the vendor''s city.';
                    }
                    field("Post Code"; Rec."Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the postal code.';
                    }
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s telephone number.';
                }
                field(MobilePhoneNo; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                    ToolTip = 'Specifies the vendor''s mobile telephone number.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s email address.';
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s web site.';
                }
                field("Our Account No."; Rec."Our Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies your account number with the vendor, if you have one.';
                }
                group(Contact)
                {
                    Caption = 'Contact';
                    field("Primary Contact Code"; Rec."Primary Contact Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Primary Contact Code';
                        ToolTip = 'Specifies the primary contact number for the vendor.';
                    }
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';

                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = VAT;
                    ToolTip = 'Specifies the vendor''s VAT registration number.';
                }
                field("Price Calculation Method"; Rec."Price Calculation Method")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the default price calculation method.';
                }
                field("Price Including VAT"; Rec."Price Including VAT")
                {
                    ApplicationArea = VAT;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                }

            }
            group(Payments)
            {
                Caption = 'Payments';

                field("Application Method"; Rec."Application Method")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how to apply payments to entries for this vendor.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the importance of the vendor when suggesting payments using the Suggest Vendor Payments function.';
                }
                field("Block Payment Tolerance"; Rec."Block Payment Tolerance")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the vendor allows payment tolerance.';
                }
                field("Preferred Bank Account Code"; Rec."Preferred Bank Account Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor bank account that will be used by default on payment journal lines for export to a payment bank file.';
                }
                field("Partner Type"; Rec."Partner Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the vendor is a person or a company.';
                }
                field("Cash Flow Payment Terms Code"; Rec."Cash Flow Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a payment term that will be used for calculating cash flow.';
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the vendor.';
                }
            }
            group(Receiving)
            {
                Caption = 'Receiving';
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                }
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a customizable calendar for delivery planning that holds the vendor''s working days and holidays.';
                }
            }
            field("Over-Receipt Code"; Rec."Over-Receipt Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the policy that will be used for the vendor if more items than ordered are received.';
            }
            field("Receive E-Document To"; Rec."Receive E-Document To")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the policy that will be used for the vendor if more items than ordered are received.';
            }

            group("Calculation Details")
            {
                Caption = 'Calculation Details';
                part("Calculation Detail"; "Vendor Calculation Details Sub")
                {
                    SubPageLink = "Vendor ID" = FIELD("Vendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("Vendor Document")
            {
                Caption = 'Vendor Document';
                part("Vendor Documents"; "Vendor Document Sub")
                {
                    SubPageLink = "Vendor ID" = FIELD("Vendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("Contract Document")
            {
                Caption = 'Invoice/Receipt Documents';
                part("Contract Documents"; "Vendor I/R DocumentSub")
                {
                    SubPageLink = "Vendor ID" = FIELD("Vendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage."Contract Documents".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetStartEndDate(Rec."Start Date", Rec."End Date", Rec."Vendor Name");
        CurrPage."Vendor Documents".Page.SetVendorID(Rec."Vendor ID");
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Contract Documents".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetStartEndDate(Rec."Start Date", Rec."End Date", Rec."Vendor Name");
        CurrPage."Vendor Documents".Page.SetVendorID(Rec."Vendor ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Contract Documents".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetVendorID(Rec."Vendor ID");
        CurrPage."Calculation Detail".Page.SetStartEndDate(Rec."Start Date", Rec."End Date", Rec."Vendor Name");
        CurrPage."Vendor Documents".Page.SetVendorID(Rec."Vendor ID");
    end;

}


