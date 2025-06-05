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
                    Visible = false;
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
                    trigger OnValidate()
                    begin
                        UpdateFieldEditability();
                    end;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                }

                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Editable = IsPercentageTypeEditable;
                }

                field("Percentage"; Rec."Percentage")
                {
                    ApplicationArea = All;
                    Editable = IsPercentageEditable;
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = IsAmountEditable;
                }

                field("Frequency Of Payment"; Rec."Frequency Of Payment")
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
        IsAmountEditable: Boolean;
        IsPercentageEditable: Boolean;
        IsPercentageTypeEditable: Boolean;


    procedure UpdateFieldEditability()
    begin
        case UpperCase(Rec."Calculation Method") of
            '':
                begin
                    IsAmountEditable := false;
                    IsPercentageEditable := false;
                    IsPercentageTypeEditable := false;
                end;

            'FIXED AMOUNT':
                begin
                    IsAmountEditable := true;
                    IsPercentageEditable := false;
                    IsPercentageTypeEditable := false;
                end;

            'PERCENTAGE BASED':
                begin
                    IsAmountEditable := false;
                    IsPercentageEditable := true;
                    IsPercentageTypeEditable := true;
                end;

            else begin
                // Default: Allow editing everything
                IsAmountEditable := false;
                IsPercentageEditable := true;
                IsPercentageTypeEditable := true;
            end;
        end;
    end;

}


