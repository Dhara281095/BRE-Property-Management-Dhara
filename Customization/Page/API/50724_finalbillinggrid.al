namespace BREPropertyManagemenMeghatMaster.BREPropertyManagemenMeghatMaster;

page 50724 finalbillinggrid
{
    APIGroup = 'finalcal';
    APIPublisher = 'RealeststeDev';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'finalbillinggrid';
    DelayedInsert = true;
    EntityName = 'finalbillinggrid';
    EntitySetName = 'finalbillinggrids';
    PageType = API;
    SourceTable = "Final Billing Calculation Grid";
    ODataKeyFields = SystemId;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(contractID; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                }
                field(differenceAmount; Rec.DifferenceAmount)
                {
                    Caption = 'Difference Amount';
                }
                field(differenceAmountInclVAT; Rec.DifferenceAmountInclVAT)
                {
                    Caption = 'Difference Amount Incl. VAT';
                }
                field(differenceVAT; Rec.DifferenceVAT)
                {
                    Caption = 'Difference VAT';
                }
                field(entryNo; Rec."Entry No")
                {
                    Caption = 'Entry No';
                }
                field(invoicedAmount; Rec.InvoicedAmount)
                {
                    Caption = 'Invoiced Amount';
                }
                field(invoicedAmountInclVAT; Rec.InvoicedAmountInclVAT)
                {
                    Caption = 'Invoiced Amount Incl. VAT';
                }
                field(invoicedVAT; Rec.InvoicedVAT)
                {
                    Caption = 'Invoiced VAT';
                }
                field(revenueDescription; Rec.RevenueDescription)
                {
                    Caption = 'Revenue Description';
                }
                field(revisedAmount; Rec.RevisedAmount)
                {
                    Caption = 'Revised Amount';
                }
                field(revisedAmountInclVAT; Rec.RevisedAmountInclVAT)
                {
                    Caption = 'Revised Amount Incl. VAT';
                }
                field(revisedVAT; Rec.RevisedVAT)
                {
                    Caption = 'Revised VAT';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
                field(terminationDate; Rec."Termination Date")
                {
                    Caption = 'Termination Date';
                }
                field(totalDifferenceVAT; Rec."Total Difference VAT")
                {
                    Caption = 'Total Invoiced Amount';
                }
                field(totalDifferenceAmountInclVAT; Rec."Total DifferenceAmountIncl.VAT")
                {
                    Caption = 'Total Difference Amount Incl. VAT';
                }
                field(totalDifferneceAmount; Rec."Total Differnece Amount")
                {
                    Caption = 'Total Difference Amount';
                }
                field(totalInvoicedAmount; Rec."Total Invoiced Amount")
                {
                    Caption = 'Total Invoiced Amount';
                }
                field(totalInvoicedAmountInclVAT; Rec."Total Invoiced AmountIncl. VAT")
                {
                    Caption = 'Total Invoiced Amount';
                }
                field(totalInvoicedVAT; Rec."Total Invoiced VAT")
                {
                    Caption = 'Total Invoiced VAT';
                }
                field(totalRevisedAmount; Rec."Total Revised Amount")
                {
                    Caption = 'Total Revised Amount';
                }
                field(totalRevisedAmountInclVAT; Rec."Total Revised AmountIncl. VAT")
                {
                    Caption = 'Total Revised Amount Incl. VAT';
                }
                field(totalRevisedVAT; Rec."Total Revised VAT")
                {
                    Caption = 'Total Invoiced Amount';
                }
            }
        }
    }
}
