page 50930 "Revenue Recognition Card"
{
    PageType = Card;
    SourceTable = "Revenue Recognition";
    ApplicationArea = All;
    Caption = 'Revenue Recognition Card';
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


                //Caption = 'Primary Item Details';
                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    // Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    ShowMandatory = true;
                    NotBlank = true;

                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;

                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                }

                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                }


            }



            group("Revenue Recognition")
            {
                part("RevenueRecognition"; "Revenue Recognition Card2")
                {
                    SubPageLink = "Proposal ID" = FIELD("Proposal ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;

                    // Visible = isVisible;
                }
            }

        }
    }








}



