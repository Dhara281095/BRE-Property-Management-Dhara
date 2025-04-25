page 50954 "Management Fee MasterData List"
{
    PageType = List;
    SourceTable = "Management Fee MasterData";
    ApplicationArea = All;
    Caption = 'Management Fee Master Data';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        VendorProfile: Record "Vendor Profile";
                    begin
                        VendorProfile.SetRange("Vendor ID", Rec."Vendor ID");
                        if VendorProfile.FindSet() then
                            PAGE.RunModal(PAGE::"Vendor Profile Card", VendorProfile)
                        else
                            Message('No Vendor Profile found using FindFirst either.');
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        PropertyProfile: Record "Property Registration";
                    begin
                        PropertyProfile.SetRange("Property ID", Rec."Property ID");
                        if PropertyProfile.FindSet() then
                            PAGE.RunModal(PAGE::"Property Registration Card", PropertyProfile)
                        else
                            Message('No Property Registration found using FindFirst either.');
                    end;
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Percentage"; Rec."Percentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Frequency Of Payment"; Rec."Frequency Of Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Company ID"; Rec."Company ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

}
