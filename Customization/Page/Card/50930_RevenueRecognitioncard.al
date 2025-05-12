page 50930 "Revenue Recognition Card"
{
    PageType = Card;
    SourceTable = "Revenue Recognition";
    ApplicationArea = All;
    Caption = 'Revenue Recognition Rent';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {

                field("RR ID"; Rec."RR ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ShowMandatory = true;
                    NotBlank = true;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                }
            }

            group("Revenue Recognition")
            {
                part("RevenueRecognition"; "Revenue Recognition Card2")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;

                }
            }

        }
    }

    // trigger OnAfterGetRecord()
    // begin
    //     CurrPage."RevenueRecognition".Page.SetRR_ID(Rec."RR Id");
    // end;


    // trigger OnModifyRecord(): Boolean
    // begin
    //     CurrPage."RevenueRecognition".Page.SetRR_ID(Rec."RR Id");
    // end;

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     CurrPage."RevenueRecognition".Page.SetRR_ID(Rec."RR Id");
    // end;

}



