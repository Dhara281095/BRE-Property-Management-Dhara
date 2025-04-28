pageextension 50107 "Sales Header" extends "Sales Credit Memo"
{
    actions
    {
        addbefore(ApplyEntries)
        {
            action("Create Credit Note")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    CreditNote: Report "Credit Note";
                begin
                    SalesHeader.SetRange("No.", Rec."No.");
                    CreditNote.SetTableView(SalesHeader);
                    CreditNote.RunModal();
                end;
            }
        }
    }
}