table 50960 "Revenue Recognition Main"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50100; "RR_No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(50101; "Month"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(50102; "Financial Year"; Integer)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "RR_No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
    begin
        revenueitem();
        revenueitemdetails();
    end;

    procedure revenueitem()
    var
        revenueitems: Record "Revenue Recognition Item";

    begin
        revenueitems.SetRange("RR_No.", Rec."RR_No.");
        if revenueitems.FindSet() then begin
            revenueitems.DeleteAll();
        end

    end;

    procedure revenueitemdetails()
    var
        revenueitemdetail: Record "Revenue Recognition Details";

    begin
        revenueitemdetail.SetRange("RR_No.", Rec."RR_No.");
        if revenueitemdetail.FindSet() then begin
            revenueitemdetail.DeleteAll();
        end
    end;
}
