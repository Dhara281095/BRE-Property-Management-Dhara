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
                field("Owner ID"; Rec."Owner ID")
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
                    SubPageLink = "ID" = FIELD("ID"); // Link to filter attachments for this owner only
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
                    CalcHeaderRec: Record "Brokerage Calculation";
                    CardStartDate: Date;
                    CardEndDate: Date;
                begin
                    // 1. Validation
                    if Rec."Owner ID" = 0 then
                        Error('Owner Name is required.');
                    if Rec."Property ID" = '' then
                        Error('Property ID is required.');

                    // 2. Clear previous sub-records linked to current header
                    SubDetailRec.Reset();
                    SubDetailRec.SetRange("Property ID", Rec."Property ID"); // Link field between header and sub
                    if SubDetailRec.FindFirst() then
                        SubDetailRec.DeleteAll();

                    CalcHeaderRec.Get(Rec.ID); // Assuming current Rec is the header
                    begin
                        CardStartDate := CalcHeaderRec."Start Date";
                        CardEndDate := CalcHeaderRec."End Date";
                    end;

                    // 3. Filter master data using Vendor Name = Owner Name, and Property ID
                    MasterDataRec.Reset();
                    // MasterDataRec.SetRange("Owner Name", Rec."Owner Name");
                    MasterDataRec.SetRange("Property ID", Rec."Property ID");
                    MasterDataRec.SetRange("Owner ID", Rec."Owner ID");

                    if MasterDataRec.FindSet() then begin
                        repeat
                            if not (
                   (MasterDataRec."End Date" < CardStartDate) or
                   (MasterDataRec."Start Date" > CardEndDate)
               ) then begin
                                SubDetailRec.Init();

                                // Assign unique Entry No.
                                SubDetailRec.Reset();
                                if SubDetailRec.FindLast() then
                                    SubDetailRec."Entry No." := SubDetailRec."Entry No." + 1
                                else
                                    SubDetailRec."Entry No." := 1;

                                // Populate fields from master
                                SubDetailRec.ID := Rec.ID;
                                SubDetailRec."Owner ID" := MasterDataRec."Owner ID";
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
                                SubDetailRec."Brokerage Percentage" := MasterDataRec.Percentage;
                                SubDetailRec."Brokerage Amount" := MasterDataRec."Amount";
                                SubDetailRec."Owner Name" := MasterDataRec."Owner Name";
                                SubDetailRec."Calculation Method" := MasterDataRec."Calculation Method";
                                SubDetailRec."Base Amount Type" := MasterDataRec."Base Amount Type";
                                SubDetailRec."Base Amount" := MasterDataRec."Base Amount";
                                SubDetailRec."Amount" := MasterDataRec.Amount;


                                // Insert
                                SubDetailRec.Insert(true);
                            end;
                        until MasterDataRec.Next() = 0;

                        CurrPage.Update();
                        Message('Matching brokerage data inserted.');
                    end else begin
                        Message('No matching data found in master for selected Owner and Property.');
                    end;
                end;
            }
        }
    }
}



