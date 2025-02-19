table 50901 "Final Calculation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50112; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
            TableRelation = "Tenancy Contract"."Contract ID";

        }

        field(50101; "FC ID"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true; // Automatically increment the ID
            Editable = false; // Make it read-only for the user
        }

        field(50104; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Start Date';
            Editable = false;
        }

        field(50105; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract End Date';
            Editable = false;
        }

        field(50102; "Unit Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Type';
            Editable = false;
        }

        field(50103; "Contract Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Amount';
            Editable = false;
        }

        field(50109; "Tenant ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
            Editable = false;
            TableRelation = "Lease Proposal Details"."Tenant ID";
        }
        field(50106; "Initmation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Initmation Date';
            Editable = false;
        }
        field(50107; "Termination Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Termination Date';
            Editable = false;
        }

        field(50110; "Original Contract Tenure"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Original Contract Tenure';
            Editable = false;
        }

        field(50111; "Actual Contract Tenure"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Actual Contract Tenure';
            Editable = false;
        }

    }



    keys
    {
        key(PK; "FC ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Contract ID")
        {

        }
    }

    //-----------------Delete record also delete subgrid record ----------------//

    trigger OnDelete()
    var
    begin
        deletepaymentschedule();
        deleterevenuestructuresubpag1();
    end;

    procedure deletepaymentschedule()
    var
        paymentschedule: Record "Revenue Structure Subpage";

    begin
        paymentschedule.SetRange("Contract Id", Rec."Contract ID");
        //  paymentschedule.SetRange("FC ID", Rec."FC ID");
        if paymentschedule.FindSet() then begin
            paymentschedule.DeleteAll();
        end

    end;

    procedure deleterevenuestructuresubpag1()
    var
        revenuestructuresubpage1: Record "Revenue Structure Subpage1";
    begin
        revenuestructuresubpage1.SetRange("Contract ID", Rec."Contract ID");
        // revenuestructuresubpage1.SetRange("FC ID", Rec."FC ID");
        if revenuestructuresubpage1.FindSet() then begin
            revenuestructuresubpage1.DeleteAll();
        end;
    end;

    //-----------------Delete record also delete subgrid -----------------//

}





