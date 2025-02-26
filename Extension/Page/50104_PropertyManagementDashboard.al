pageextension 50104 "MyRoleCenterExtension" extends "Business Manager Role Center"
{
    actions
    {
        // addfirst(embedding)
        // {
        //     action("Project Management")
        //     {
        //         ApplicationArea = Basic, Suite;
        //         Caption = 'Project Management';
        //         RunObject = Page "Property Registration List";
        //     }
        // }
        addfirst(sections)
        {
            group(Action42)
            {
                Caption = 'Property Management';
                action(PeopertyRegistration)
                {
                    Caption = ' Property Registrations';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Property Registration List";
                }

                action(PropertyClassification)
                {
                    Caption = 'Property Classifications';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Primary Classification List";
                }

                action(UnitList)
                {
                    Caption = 'Unit Registrations';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Item List";
                }

                action(PropertyType)
                {
                    Caption = 'Property Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Property Type List";
                }

                action(TenantProfile)
                {
                    Caption = 'Tenant Profiles';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Customer List";
                }

                action(UnitType)
                {
                    Caption = 'Unit Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Secondary Classification List";
                }

                action(LeaseProposal)
                {
                    Caption = 'Lease Proposals';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lease Proposal List";
                }

                action(CountryList)
                {
                    Caption = 'Countries';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Country List";
                }

                action(TenancyContract)
                {
                    Caption = 'Tenancy Contracts';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Tenancy Contract List";
                }

                action(EmirateList)
                {
                    Caption = 'Emirates';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Emirate List";
                }

                action(OwnerProfile)
                {
                    Caption = 'Owner Profiles';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Owner Profile List";
                }

                action(CommunityList)
                {
                    Caption = 'Communities';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Community List";
                }
                action(MergeUnits)
                {
                    Caption = 'Merge Units';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Merged Units List";
                }
                action(RevenueItemlist)
                {
                    Caption = 'Revenue Items';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Primary Item List";
                }
                action(RevenueCategory)
                {
                    Caption = 'Revenue Categories';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Category List";
                }
                action(RevenueAllocation)
                {
                    Caption = 'Revenue Allocation';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Revenue Allocation List";
                }
                action(AvailabilityStatus)
                {
                    Caption = 'Availability Status';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Availability Status List";
                }
                action(ApprovalContractStatus)
                {
                    Caption = 'Approval Contract Status';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Approval Contract Status List";
                }
                action(ConytractRenewal)
                {
                    Caption = 'Contract Renewal';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Contract Renewal List";
                }
                action(SecurityDeposit)
                {
                    Caption = 'Security Deposit';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Security Deposit List";
                }
                action(AdjustSecurityDeposit)
                {
                    Caption = 'Adjust Security Deposit';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page Adjustment_Security_Deposit;
                }
                action(FinalCalculation)
                {
                    Caption = 'Final Calculation';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Final Calculation List";
                }

            }
        }

    }
}