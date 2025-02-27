pageextension 50507 "PostedSalesInvoiceLine" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Gen. Prod. Posting Group")
        {
            field("Contract ID"; Rec."Contract ID")
            {
                ApplicationArea = All;
                Caption = 'Contract ID';
                Editable = false;
            }
        }
    }
}