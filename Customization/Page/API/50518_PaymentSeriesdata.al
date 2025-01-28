page 50518 "Payment Series Data"
{
    PageType = API;
    APIGroup = 'Finance';
    APIPublisher = 'RealeststeDev';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Payment Series API';
    DelayedInsert = true;
    EntityName = 'PaymentSeriesdata';
    EntitySetName = 'PaymentSeriesdatas';
    ODataKeyFields = SystemId; // Ensure the SystemId is exposed in the API
    SourceTable = "Payment Series Details";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("payment_Series"; Rec."payment Series") { }
                field(SystemId; Rec.SystemId) { }
                field(Amount; Rec.Amount) { }
                field("Due_Date"; Rec."Due Date") { }
                field("Payment_Mode"; Rec."Payment Mode") { }
                field("Cheque_Number"; Rec."Cheque Number") { }
                field("Deposite_Bank"; Rec."Deposite Bank") { }
                field("Deposite_Status"; Rec."Deposite Status") { }
                field("Payment_Status"; Rec."Payment Status") { }
                field("Cheque_Status"; Rec."Cheque Status") { }
                field("Old_Cheque"; Rec."Old Cheque") { }
                field(View; Rec.View) { }
                field("View_Document_URL"; Rec."View Document URL") { }
                field("Approval_Status"; Rec."Approval Status") { }
                field("Payment_Transaction_Id"; Rec."Payment Transaction Id") { }
                field("Contract_Id"; Rec."Contract Id") { }
                field("Tenant_Id"; Rec."Tenant Id") { }


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

    var
        myInt: Integer;
}