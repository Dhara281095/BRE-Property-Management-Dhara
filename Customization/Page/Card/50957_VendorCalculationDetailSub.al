page 50957 "Vendor Calculation Details Sub"
{
    PageType = ListPart;
    SourceTable = "Vendor Calculation Details";
    ApplicationArea = All;
    Caption = 'Vendor Calculation Details';

    layout
    {
        area(content)
        {
            repeater("Calculation Details")
            {

                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                }

                field("Vendor Name"; Rec."Vendor Name")
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

                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                }

                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                }

                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                }

                field("Frequency Of Payment"; Rec."Frequency Of Payment")
                {
                    ApplicationArea = All;
                }

                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    procedure SetVendorID(pVendorID: Code[20])
    begin
        VendorID := pVendorID;
    end;

    procedure SetStartEndDate(pStartDate: Date; pEndDate: Date; pvendorname: Text[100])
    begin
        startDate := pStartDate;
        endDate := pEndDate;
        vendorName := pvendorname;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Vendor ID" := VendorID;

        Rec."Start Date" := startDate;
        Rec."End Date" := endDate;
        Rec."Vendor Name" := vendorName;
    end;

    var
        VendorID: Code[20];
        startDate: Date;
        endDate: Date;
        vendorName: Text[100];

}


