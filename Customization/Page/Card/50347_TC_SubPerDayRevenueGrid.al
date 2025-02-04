page 50347 "TC PerDayRent for Revenue Card"
{

    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "TC Per Day Rent for Revenue";
    Caption = 'Per Day Rent for Revenue Allocation';



    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Id"; rec."Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract Renewal Id"; rec."Contract Renewal Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Proposal Id"; rec."Proposal Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                // field("Merge Unit Id"; rec."Merge Unit Id")
                // {
                //     ApplicationArea = All;
                // }

                field("Year"; rec."Year")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Sq.Ft"; rec."Sq.Ft")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Per Day Rent Per Unit"; rec."Per Day Rent Per Unit")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }

        }

    }
}






