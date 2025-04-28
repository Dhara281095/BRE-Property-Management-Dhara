page 50309 "Owner Profile Card"
{
    PageType = Card;
    SourceTable = "Owner Profile";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Identification")
            {
                Caption = 'Owner Identification Details';

                field("Owner ID"; rec."Owner ID")
                {
                    ApplicationArea = All;
                }

                field("Full Name"; rec."Full Name")
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
            }

            group("Contact Information")
            {
                Caption = 'Contact Information';

                field("Phone Number"; rec."Phone Number")
                {
                    ApplicationArea = All;
                }

                field("Email Address"; rec."Email Address")
                {
                    ApplicationArea = All;
                }

                field("P.O.Box"; Rec."P.O.Box")
                {
                    ApplicationArea = All;
                }

                field("Mailing Address"; rec."Mailing Address")
                {
                    ApplicationArea = All;
                }

                field("Local Address in UAE"; rec."Local Address in UAE")
                {
                    ApplicationArea = All;
                }
            }

            group("Ownership Details")
            {
                Caption = 'Ownership Details';

                field("Ownership Type"; rec."Ownership Type")
                {
                    ApplicationArea = All;
                }

                field("TRN"; rec."TRN")
                {
                    ApplicationArea = All;
                }

                // field("Property Linked"; rec."Property Linked")
                // {
                //     ApplicationArea = All;
                //     Lookup = true;

                // }
            }

            group("Banking Information")
            {
                Caption = 'Banking Information';

                field("Bank Account Number"; rec."Bank Account Number")
                {
                    ApplicationArea = All;
                }

                field("IBAN"; rec."IBAN")
                {
                    ApplicationArea = All;
                }

                field("Bank Name"; rec."Bank Name")
                {
                    ApplicationArea = All;
                }

                field("SWIFT/IFSC Code"; rec."SWIFT/IFSC Code")
                {
                    ApplicationArea = All;
                }
            }

            group("Status and Remarks")
            {
                Caption = 'Status and Remarks';

                field("Status"; rec."Status")
                {
                    ApplicationArea = All;
                }

                field("Date of Registration"; rec."Date of Registration")
                {
                    ApplicationArea = All;
                }

                field("Remarks/Notes"; rec."Remarks/Notes")
                {
                    ApplicationArea = All;
                }

                field("Ejari Registration Number"; Rec."Ejari Registration Number")
                {
                    ApplicationArea = All;
                }
                field("RERA Owner ID"; Rec."RERA Owner ID")
                {
                    ApplicationArea = All;
                }

            }

            // Add the Document Attachment Subpage here
            part("Document Attachments"; "Owner Document Subpage")
            {
                SubPageLink = OwnerId = FIELD("Owner ID"); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Visible = isVisible;
            }
        }
    }

    // actions
    // {
    //     area(Navigation)
    //     {
    //         action("Delete All")
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             var
    //                 // CustomLinesPage: Record Item;
    //                 // CustomLinesPage: Record "Document Attachment";
    //                 DocumentUploadDetails: Record "Unit Document Details";
    //             begin
    //                 if DocumentUploadDetails.FindSet() then begin
    //                     DocumentUploadDetails.DeleteAll();
    //                     //  DocumentUploadDetails.DeleteAll();
    //                 end;
    //             end;
    //         }
    //     }
    // }

    var
        isVisible: Boolean;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Document Attachments".Page.SetOwnerId(Rec."Owner ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Document Attachments".Page.SetOwnerId(Rec."Owner ID");
        isVisible := true;
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Document Attachments".Page.SetOwnerId(Rec."Owner ID");
        if Format(Rec."Owner ID") <> '' then begin
            isVisible := true;
        end
        else begin
            isVisible := false;
        end;
    end;
}
