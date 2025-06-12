page 50306 "Property Registration List"
{
    PageType = List;
    SourceTable = "Property Registration";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = 50305;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Property ID"; rec."Property ID")
                {
                    ApplicationArea = All;
                }
                field("Property Name"; rec."Property Name")
                {
                    ApplicationArea = All;
                }

                field("Description"; rec."Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Type"; rec."Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }

                field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                }

                field("Community"; rec.Community)
                {
                    ApplicationArea = All;
                }
                // field("Postal Code"; rec."Postal Code")
                // {
                //     ApplicationArea = All;
                // }

                // field("Status"; rec."Status")
                // {
                //     ApplicationArea = All;
                // }

                field("Owner ID"; rec."Owner ID")
                {
                    ApplicationArea = All;
                }
                field("Registration Date"; rec."Registration Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


}
