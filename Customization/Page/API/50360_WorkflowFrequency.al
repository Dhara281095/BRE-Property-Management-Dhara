page 50360 "Workflow Frequency PR API"
{
    PageType = API;
    SourceTable = "Workflow Frequency PR";
    APIPublisher = 'RealestateDev';
    APIGroup = 'WorkflowManagement';
    APIVersion = 'v2.0';
    EntityName = 'workflowFrequencyPR';
    EntitySetName = 'workflowFrequencyPRs';
    Caption = 'Workflow Frequency PR API';
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            field("SystemId"; Rec.SystemId) // System ID field for unique identification in API calls
            {
                Caption = 'System Identifier';
            }

            field("CompanyID"; Rec."Company ID")
            {
            }

            field("Workflow"; Rec."Workflow")
            {
            }

            field("FrequencyStatus"; Rec."frequncy Status")
            {
            }

            field("NoOfDays"; Rec."No. of Days")
            {
            }

            field("PropertyID"; Rec."Property ID")
            {
            }
        }
    }
}
