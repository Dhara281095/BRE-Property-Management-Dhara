table 50110 "Revenue Allocation SubGrid"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
            AutoIncrement = true;
            Editable = false;
        }

        field(2; "Property Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Name';
        }

        field(3; "Contract Id"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Id';
        }

        field(4; "Contract Tenure"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Tenure';
        }

        field(5; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer Name';
        }

        field(6; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Start Date';
        }

        field(7; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract End Date';
        }

        field(8; "Grace Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Grace Days';
        }

        field(9; "Termination Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Termination Date';
        }

        field(10; "Suspension Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Suspension Start Date';
        }

        field(11; "Suspension End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Suspension End Date';
        }

        field(12; "Multi Year Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Multi Year Start Date';
        }

        field(13; "Multi Year End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Multi Year End Date';
        }

        field(14; "Contract Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Amount';
        }

        field(15; "Annual Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Annual Amount';
        }

        field(16; "Posting Month"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Month';
            OptionCaption = 'January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }

        field(17; "Posting Year"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Year';
        }

        field(18; "Posting Period"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Period';
        }

        field(19; "No Of Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'No Of Days';
        }

        field(20; "Per Day Rent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Per Day Rent';
        }

        field(21; "Total Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Value';
        }

        field(22; "Owner Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner Name';
        }

        field(23; "Owner Share"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner Share';
        }

    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }

    }



    // trigger OnInsert()
    // begin
    //     if "Line No." = 0 then
    //         "Line No." := GetNextLineNo();
    // end;

    // local procedure GetNextLineNo(): Integer
    // var
    //     MaxLineNo: Integer;
    // begin
    //     MaxLineNo := 0;
    //     if FindSet() then
    //         repeat
    //             if "Line No." > MaxLineNo then
    //                 MaxLineNo := "Line No.";
    //         until Next() = 0;
    //     exit(MaxLineNo + 1);
    // end;



}
