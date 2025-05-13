page 50974 "Revenue Recognition Detail Sub"
{

    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Revenue Recognition Details";
    Caption = 'Revenue Recognition Details';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    Editable = false;
                }
                field("Contract Id"; Rec."Contract Id")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Id';
                    Editable = false;
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                    Editable = false;
                }
                field("Contract Tenure"; Rec."Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Tenure';
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    Editable = false;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    Editable = false;
                }
                field("Grace Days"; Rec."Grace Days")
                {
                    ApplicationArea = All;
                    Caption = 'Grace Days';
                    Editable = false;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    Editable = false;
                }
                field("Suspension Start Date"; Rec."Suspension Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Suspension Start Date';
                    Editable = false;
                }
                field("Suspension End Date"; Rec."Suspension End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Suspension End Date';
                    Editable = false;
                }
                // field("Multi Year Start Date"; Rec."Multi Year Start Date")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Multi Year Start Date';
                //     Editable = false;
                // }
                // field("Multi Year End Date"; Rec."Multi Year End Date")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Multi Year End Date';
                //     Editable = false;
                // }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    Editable = false;
                }
                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    Editable = false;
                }
                field("Posting Month"; Rec."Posting Month")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Month';
                    Editable = false;
                }
                field("Posting Year"; Rec."Posting Year")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Year';
                    Editable = false;
                }
                field("Posting Period"; Rec."Posting Period")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Period';
                    Editable = false;
                }
                field("Final Annual Amount"; Rec."Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                }
                field("No Of Days"; Rec."No Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'No Of Days';
                    Editable = false;
                }
                field("Per Day Amount"; Rec."Per Day Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Amount';
                    Editable = false;
                }
                field("Total Value"; Rec."Total Value")
                {
                    ApplicationArea = All;
                    Caption = 'Total Value';
                    Editable = false;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    Caption = 'Owner Name';
                    Editable = false;
                }
                field("Owner Share"; Rec."Owner Share")
                {
                    ApplicationArea = All;
                    Caption = 'Owner Share';
                    Editable = false;
                }
            }
        }
    }

    procedure SetRIID(pRRID: Integer)
    begin
        RRID := pRRID;

    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."RR_No." := RRID;
    end;

    var
        RRID: Integer;
}