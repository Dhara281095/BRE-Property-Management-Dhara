table 50964 "Brokerage Calculation Sub"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(50100; "Owner ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner ID';
            Editable = false;
        }
        field(50101; "Owner Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner Name';
            Editable = false;
        }
        field(50102; "Property ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property ID';
            Editable = false;
        }
        field(50103; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
            Editable = false;
        }

        field(50104; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date';
        }

        field(50105; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }
        field(50106; "Tenant Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Name';
            Editable = false;
        }
        field(50107; "Property Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Name';
            Editable = false;
        }
        field(50108; "Unit Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Name';
            Editable = false;
        }
        field(50109; "Unit Number"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Number';
            Editable = false;
        }
        field(50110; "Vendor ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor ID';
            Editable = false;
        }
        field(50111; "Vendor Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(50112; "Brokerage Percentage"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Brokerage Percentage';
            Editable = false;
        }
        field(50113; "Calculation Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Calculation Amount';
            Editable = false;
        }
        field(50114; "Paid By"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Paid By';
            OptionMembers = " ","Owner","Tenant";
        }
        field(50115; "Remark"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Remark';
        }
        field(50116; "Action Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Action Date';
        }

        field(50117; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(50118; "ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ID';
            Editable = false;
        }
        field(50119; "Total brokerage Amount"; Decimal)
        {
            // DataClassification = ToBeClassified;
            Caption = 'Total brokerage Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Brokerage Calculation Sub"."Calculation Amount" where("ID" = field("ID"), "Owner ID" = field("Owner ID")));
        }

    }


    keys
    {
        key(PK; "Entry No.", "ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Property ID", "Owner ID")
        {

        }
    }

}
