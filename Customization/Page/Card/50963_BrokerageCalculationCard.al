page 50963 "Brokerage Calculation Card"
{
    PageType = Card;
    SourceTable = "Brokerage Calculation";
    ApplicationArea = All;
    Caption = 'Brokerage Calculation Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Brokerage Calculation Details';
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }

            }

            group("Brokerage Calculation")
            {
                Caption = 'Brokerage Calculation';
                part("Brokerage Calculations"; "Brokerage Calculation Sub Card")
                {
                    SubPageLink = "Property ID" = FIELD("Property ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }


        }
    }

    actions
    {
        area(processing)
        {
            action(SelectVendor)
            {
                Caption = 'Brokerage Calculation';
                Image = Find;
                ApplicationArea = All;

                trigger OnAction()
                var
                    MasterDataRec: Record "Brokerage Master Data";
                    SubDetailRec: Record "Brokerage Calculation Sub";
                    ExistingSubDetail: Record "Brokerage Calculation Sub";
                begin
                    if Rec."Owner Name" = '' then
                        Error('Owner Name is required.');
                    if Rec."Property ID" = '' then
                        Error('Property ID is required.');

                    // Optional: Clear old records related to this Owner + Property
                    ExistingSubDetail.SetRange("Owner Name", Rec."Owner Name");
                    ExistingSubDetail.SetRange("Property ID", Rec."Property ID");
                    if ExistingSubDetail.FindFirst() then
                        ExistingSubDetail.DeleteAll();

                    // Filter master data
                    MasterDataRec.SetRange("Owner Name", Rec."Owner Name");
                    MasterDataRec.SetRange("Property ID", Rec."Property ID");
                    //  MasterDataRec.SetRange("Start Date", Rec."Start Date");

                    if MasterDataRec.FindSet() then begin
                        repeat
                            SubDetailRec.Init();
                            SubDetailRec."Owner Name" := MasterDataRec."Owner Name";
                            SubDetailRec."Vendor ID" := MasterDataRec."Vendor ID";
                            SubDetailRec."Start Date" := MasterDataRec."Start Date";
                            SubDetailRec."End Date" := MasterDataRec."End Date";
                            SubDetailRec."Property ID" := MasterDataRec."Property ID";
                            SubDetailRec."Contract ID" := MasterDataRec."Contract ID";
                            SubDetailRec."Tenant Name" := MasterDataRec."Tenant Name";
                            SubDetailRec."Property Name" := MasterDataRec."Property Name";
                            SubDetailRec."Unit Number" := MasterDataRec."Unit Number";
                            SubDetailRec."Unit Name" := MasterDataRec."Unit Name";
                            SubDetailRec."Vendor Name" := MasterDataRec."Vendor Name";

                            // Optional: Assign brokerage values
                            // SubDetailRec."Brokerage Percentage" := MasterDataRec."Brokerage Percentage";
                            // SubDetailRec."Calculation Amount" := MasterDataRec."Calculation Amount";

                            // Insert record
                            SubDetailRec.Insert(true); // true to force UI refresh
                            Clear(SubDetailRec);

                        until MasterDataRec.Next() = 0;

                        CurrPage.Update(); // Refresh UI
                        Message('Brokerage data populated.');
                    end else begin
                        Message('No matching master data found.');
                    end;
                end;


                // trigger OnAction()
                // var
                //     VendorRec: Record "Vendor Profile";
                // begin
                //     Message('hello');
                // end;
            }
        }
    }


}



