pageextension 50512 "PostedsalesinvoiceList" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("Pre-Assigned No."; Rec."Pre-Assigned No.")
            {
                ApplicationArea = All;
            }
        }
    }
}