page 50517 "Payment Series Grid"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Payment Series Details";
    Caption = 'Payment Series Grid';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("payment Series"; Rec."payment Series")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                }
                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;

                }
                field("Deposite Bank"; Rec."Deposite Bank")
                {
                    ApplicationArea = All;
                }
                field("Deposite Status"; Rec."Deposite Status")
                {
                    ApplicationArea = All;
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                    ApplicationArea = All;
                }
                field("Old Cheque"; Rec."Old Cheque")
                {
                    ApplicationArea = All;
                }
                field(View; Rec.View)
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnValidate()
                    begin
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."View Document URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);
                    end;
                }

                field("View Document URL"; Rec."View Document URL")
                {
                    ApplicationArea = All;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    var
        myInt: Integer;
}