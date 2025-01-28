page 50327 "Suspend Reason Card"
{
    PageType = Card;
    SourceTable = SuspendReasonTable;
    ApplicationArea = All;
    Caption = 'Suspend Reason Card';
    UsageCategory = Administration;

    layout
    {
        area(content)
        {


            group("Tenancy Details")
            {
                Caption = 'Tenancy Details';


                field("Contract Type"; rec."Contract Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        UpdateFieldsEnable();
                    end;
                }

                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Proposal ID';
                    Enabled = ProposalIDEnabled;
                }

                field("Renewal Proposal ID"; Rec."Renewal Proposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Renewal Proposal ID';
                    Enabled = RenewalProposalIDEnabled;
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                }

                field(TenantID; Rec.TenantID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(TenantName; Rec.TenantName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(EmiratesID; Rec.EmiratesID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(ContactNumber; Rec.ContactNumber)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(EmailAddress; Rec.EmailAddress)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(TenantTradeLicenseNo; Rec.TradeLicenseNo)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(TenantLicensingAuthority; Rec.LicensingAuthority)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group("General Information")
            {
                Caption = 'General Details';

                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }

                field(DateEffective; Rec.DateEffective)
                {
                    ApplicationArea = All;
                }

                field(SuspensionEndDate; Rec.SuspensionEndDate)
                {
                    ApplicationArea = All;
                }

                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        UpdateVisibility(); // Update visibility when Reason is changed
                    end;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Tenant Contract Status"; Rec."Tenant Contract Status")
                {
                    ApplicationArea = All;
                }

                field("ReleaseUnits"; Rec."ReleaseUnits")
                {
                    ApplicationArea = All;
                }


            }



            group("Legal Reason Details")
            {
                Caption = 'Legal Reason Details';
                Visible = ShowLegalReasonFields;

                field(ReleaseUnit; Rec.ReleaseUnit)
                {
                    ApplicationArea = All;
                    Caption = 'Release Unit';
                }

                field(ReleaseDate; Rec.ReleaseDate)
                {
                    ApplicationArea = All;
                    Caption = 'Release Date';
                }
            }

            group("Business Reason Details")
            {
                Caption = 'Business Reason Details';
                Visible = ShowBusinessReasonFields;

                field(SuspensionEffectiveDate; Rec.SuspensionEffectiveDate)
                {
                    ApplicationArea = All;
                    Caption = 'Effective Date of Suspension to Active';
                }

                field(IssueResolutionDescription; Rec.IssueResolutionDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Issue Resolution Description';
                }
            }
        }

        area(factboxes)
        {
            systempart(ControlLinks; Links)
            {
                ApplicationArea = RecordLinks;
            }

            systempart(ControlNotes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    var
        ShowLegalReasonFields: Boolean;
        ShowBusinessReasonFields: Boolean;

    // Initialize visibility when the page opens
    trigger OnOpenPage()
    begin
        UpdateVisibility();
    end;

    // Procedure to update visibility dynamically
    procedure UpdateVisibility()
    begin
        ShowLegalReasonFields := (Rec.Reason = Rec.Reason::"Legal Reason");
        ShowBusinessReasonFields := (Rec.Reason = Rec.Reason::"Business Reason");
    end;

    trigger OnAfterGetRecord()
    begin


        UpdateFieldsEnable();
    end;

    var
        ProposalIDEnabled: Boolean;
        RenewalProposalIDEnabled: Boolean;


    local procedure UpdateFieldsEnable()
    begin
        ProposalIDEnabled := Rec."Contract Type" = Rec."Contract Type"::"New Contract";
        RenewalProposalIDEnabled := Rec."Contract Type" = Rec."Contract Type"::"Renewal Contract";

        CurrPage.Update(false);
    end;
}
