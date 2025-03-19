page 50953 "Payment Details"
{
    PageType = ListPart;
    SourceTable = "Paymend Details";
    ApplicationArea = All;
    Caption = 'Payment Schedule Details';
    //UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VAT Amount';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount Including VAT';
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Recieved Date"; Rec."Payment Recieved Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}