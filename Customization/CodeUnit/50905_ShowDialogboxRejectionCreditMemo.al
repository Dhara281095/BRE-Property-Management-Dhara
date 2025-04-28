codeunit 50905 "DialogboxRejectionCreditMemo"
{
    procedure Dialogboxcreditmemo(var Rec: Record "Sales Header")
    var
        ReasonForRejection: Text;
        DialogConfirmed: Boolean;
        dialogpage: Page DialogBoxForInvoiceRejection;
        salesheader1: Record "Sales Header";
        Rejectionmail: Codeunit "Reject Credit Memo";

    begin
        salesheader1.SetRange(salesheader1."Document Type", Rec."Document Type"::"Credit Memo");
        salesheader1.SetRange(salesheader1."No.", Rec."No.");

        if salesheader1.FindSet() then begin
            if dialogpage.RunModal() = Action::OK then begin
                ReasonForRejection := dialogpage.GetReason();
                Rec."Rejection Reason CreditNote" := ReasonForRejection;
                Rec.Modify();
                Rejectionmail.SendInvoiceToLeaseManager(Rec);
            end else begin
                // Message('Please Enter Reason');
            end;
        end;
    end;
}