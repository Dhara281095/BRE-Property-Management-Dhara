page 50519 "Payment Transaction Data"
{
    PageType = API;
    APIGroup = 'Finance';
    APIPublisher = 'RealeststeDev';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Payment Transaction API';
    DelayedInsert = true;
    EntityName = 'PaymentTransaction';
    EntitySetName = 'PaymentTransactions';
    ODataKeyFields = SystemId; // Ensure the SystemId is exposed in the API
    SourceTable = "Payment Transaction";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("PT_Id"; Rec."PT Id") { }
                field(SystemId; Rec.SystemId) { }
                field("Tenant_Id"; Rec."Tenant Id") { }
                field("Contract_Id"; Rec."Contract Id") { }
                field("Approval_Status"; Rec."Approval Status") { }
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