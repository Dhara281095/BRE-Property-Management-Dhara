codeunit 50514 "Trigger Payment Receipt"
{
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure OnBeforeInsertCustLedgerEntry(var Rec: Record "Cust. Ledger Entry")
    var
        PaymentReceipt: Codeunit "Send Payment Reciept";
        data: Record "Gen. Journal Line";
    begin
        // data.SetRange("Applies-to Doc. No.", Rec."Document No.");
        // // data.SetRange("Customer Id", Rec."Customer No.");
        // data.SetRange("Account No.", Rec."Customer No.");
        // if data.FindSet() then begin
        //     if Rec."Document Type" = Rec."Document Type"::Invoice then
        //         PaymentReceipt.GenerateAndSendReceipt(Rec);
        // end;
        // Ensure we are working with a Payment entry, not an Invoice
        PaymentReceipt.SendReceiptEmail(Rec);


    end;
}