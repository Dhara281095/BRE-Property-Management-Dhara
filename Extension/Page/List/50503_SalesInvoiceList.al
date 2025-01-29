pageextension 50503 salesinvoiceext extends "Sales Invoice List"
{
    actions
    {
        addbefore("&Invoice")
        {
            action(CreateSalesInvoice)
            {
                Caption = 'Sale Invoice';
                ApplicationArea = All;
                trigger OnAction()
                var
                    generateSaleInvoice: Codeunit GenerateConsolidatedInvoices;

                begin
                    generateSaleInvoice.GenerateConsolidatedInvoicesDirectly();


                end;
            }
            action(SendInvoiceLeaserManager)
            {
                Caption = 'Lease Manager Send Mail';
                ApplicationArea = All;
                trigger OnAction()
                var
                    sendmail: Codeunit 50508;
                begin
                    sendmail.sendmail();

                end;
            }

        }
    }
}