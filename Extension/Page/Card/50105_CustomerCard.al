pageextension 50105 Customers extends "Customer Card"
{
    layout
    {
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify(BalanceAsVendor)
        {
            Visible = false;
        }
        modify("salesperson code")
        {
            Visible = false;
        }
        modify("Service Zone Code")
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        // modify("Profit (LCY)")
        // {
        //     Visible = false;
        // }
        modify("Disable Search by Name")
        {
            Visible = false;
        }


        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Credit Limit (LCY)")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Visible = false;
        }
        modify(TotalSales2)
        {
            Visible = false;
        }
        modify(Payments)
        {
            Visible = false;
        }
        modify(Shipping)
        {
            Visible = false;
        }
        modify("Intrastat Partner Type")
        {
            Visible = false;
        }


        modify(Statistics)
        {
            Visible = false;
        }
        modify("IC Partner Code")
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify(City)
        {
            Visible = false;
        }
        modify("Post Code")
        {
            Visible = false;
        }
        modify("Fax No.")
        {
            Visible = false;
        }
        modify("Home Page")
        {
            Visible = false;
        }
        modify("Language Code")
        {
            Visible = false;
        }
        modify("Format Region")
        {
            Visible = false;
        }
        modify(ContactDetails)
        {
            Visible = false;
        }
        modify("No.")
        {
            Caption = 'Tenant ID';
            Editable = false;
        }
        modify(Name)
        {
            Caption = 'Full Name';
        }
        modify("Phone No.")
        {
            Caption = 'Contact Number';
        }
        modify(MobilePhoneNo)
        {
            Caption = 'Emergency Contact';
        }
        modify("E-Mail")
        {
            Caption = 'Email Address';
        }
        modify(Address)
        {
            Caption = 'Local Address';
        }
        modify("Address 2")
        {
            Caption = 'Mailing Address';
        }
        modify(ShowMap)
        {
            Visible = false;
        }
        modify(AddressDetails)
        {
            Caption = 'Customer Address';
        }
        // addafter("No.")
        // {
        //     field("Tenant ID"; Rec."Tenant ID")
        //     {
        //         ApplicationArea = All;
        //     }
        // }
        addafter(AddressDetails)
        {
            group(CustContactDetails)
            {
                Caption = 'Contact Details';
            }
        }
        movefirst(CustContactDetails; "Phone No.", "MobilePhoneNo", "E-Mail")
        addafter(Name)
        {
            field(Username; Rec.Username)
            {
                ApplicationArea = All;
            }
            field("Password"; rec."Password")
            {
                ApplicationArea = All;
            }
            field("Date Of Birth"; rec."Date Of Birth")
            {
                ApplicationArea = All;
            }
            field("Nationality"; rec."Nationality")
            {
                ApplicationArea = All;
            }
            field("Emirates ID"; rec."Emirates ID")
            {
                ApplicationArea = All;
            }
            field("Emirates ID Expiry Date"; rec."Emirates ID Expiry Date")
            {
                ApplicationArea = All;
            }
            field("License No."; Rec."License No.")
            {
                ApplicationArea = All;
            }
            field("Licensing Authority"; Rec."Licensing Authority")
            {
                ApplicationArea = All;
            }
            field("Code Area"; Rec."Code Area")
            {
                ApplicationArea = All;
                Caption = 'Code Area';
                Visible = false;
            }
            field(Occupation; Rec.Occupation)
            {
                ApplicationArea = All;
                Caption = 'Occupation';
            }
        }
        addlast(General)
        {
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type';
            }

            field("Business Unit"; Rec."Business Unit")
            {
                ApplicationArea = All;
                Caption = 'Business unit';
                Visible = false;
            }
        }
        addafter("Address & Contact")
        {
            group("Passport Details")
            {
                field("Passport Number"; rec."Passport Number")
                {
                    ApplicationArea = All;
                }
                field("Passport Issue Date"; rec."Passport Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Passport Expiry Date"; rec."Passport Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Country of Passport"; rec."Country of Passport")
                {
                    ApplicationArea = All;
                }
            }

            part("Document Attachments"; "Tenant Document SubPage")
            {
                SubPageLink = No = FIELD("No."); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Visible = isVisible;
            }

            group("Tenant Screening")
            {
                field("Approve"; Rec."Approve")
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                }
                field("Decline"; Rec."Decline")
                {
                    ApplicationArea = All;
                    Caption = 'Decline';
                }
            }

        }
        addafter("Address 2")
        {
            field("P.O.Box"; Rec."P.O.Box")
            {
                ApplicationArea = All;
                Caption = 'P.O.Box';
            }
        }
    }

    var
        isVisible: Boolean;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."No.");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."No.");
        isVisible := true;
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."No.");
        if Rec."No." <> '' then begin
            isVisible := true;
        end
        else begin
            isVisible := false;
        end;
    end;

    var
        documentattachment: Codeunit UploadAttachment;
}