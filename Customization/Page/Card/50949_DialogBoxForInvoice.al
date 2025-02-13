page 50949 DialogBoxForInvoiceRejection
{
    PageType = StandardDialog;
    Caption = 'Enter Reason Rejection';
    layout
    {
        area(content)
        {
            field(ReasonForRejection; reasonvalue)
            {
                Caption = 'Reason for Rejection';
                ApplicationArea = All;
                ToolTip = 'Enter the reason for rejecting this invoice.';
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin

        reasonvalue := DelChr(reasonvalue, '=', ' ');

        if reasonvalue = '' then begin
            Message('Please enter a reason for rejection before proceeding.');
            exit(false);
        end;

        exit(true);
    end;

    procedure GetReason(): Text;
    begin
        exit(reasonvalue);
    end;

    var
        reasonvalue: Text;
}