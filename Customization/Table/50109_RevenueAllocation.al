table 50109 "Revenue Allocation Details"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "No.";
    fields
    {
        field(50100; "No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
            AutoIncrement = true;
        }

        field(50101; "Financial Year"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Financial Year';
        }

        field(50102; "Month"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Month';
            OptionCaption = 'January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }
}
