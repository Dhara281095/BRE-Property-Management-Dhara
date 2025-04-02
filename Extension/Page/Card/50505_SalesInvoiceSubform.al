pageextension 50505 SalesInvoiceSubformExt extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Document No.")
        {
            field("Contract ID"; Rec."Contract ID")
            {
                ApplicationArea = All;
            }
            field("FC ID"; Rec."FC ID")
            {
                ApplicationArea = All;
                Editable = false;
            }

        }

    }

    trigger OnAfterGetRecord()
    var
        vatpostingsetup: Record "VAT Posting Setup";
        salesline: Record "Sales Line";
        salesheader: Record "Sales Header";
        TotalAmount: Decimal;
    begin

        if VATPostingSetup.Get(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") then begin
            Rec.Validate("VAT Identifier", vatpostingsetup."VAT Identifier");
            Rec.Validate("VAT %", VATPostingSetup."VAT %");
            Rec."VAT Base Amount" := Rec.Amount * (Rec."VAT %" / 100);

            Rec."Amount Including VAT" := Rec."Line Amount" + Rec."VAT Base Amount";
            Rec.Modify();
        end;


    end;





}
