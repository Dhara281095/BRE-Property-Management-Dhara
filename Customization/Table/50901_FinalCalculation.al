table 50901 "Final Calculation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50112; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';


        }
        field(50113; "ContractYear(Termination Date)"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Year On Termination Date';

        }

        field(50101; "FC ID"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true; // Automatically increment the ID
                                  // Make it read-only for the user
        }

        field(50104; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Start Date';

        }

        field(50105; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract End Date';

        }

        field(50102; "Unit Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Type';

        }

        field(50103; "Contract Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Amount';

        }

        field(50109; "Tenant ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';

            TableRelation = "Lease Proposal Details"."Tenant ID";
        }
        field(50106; "Intimation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Intimation Date';

        }
        field(50107; "Termination Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Termination Date';

        }

        field(50110; "Original Contract Tenure"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Original Contract Tenure';

        }

        field(50111; "Actual Contract Tenure"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Actual Contract Tenure';

        }

        field(50114; "Total No. Of Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total No. Of Days(Termination Year)';

        }


        field(50115; "Per Day Rent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Per Day Rent(Termination Year)';

        }

        field(50116; "Annual Rent Amount TermiYear"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Annual Rent Amount of Termination Year';
        }

        field(50117; Status; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
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
        deletefinalrevenuecalculation();
        deletebillingcaculation();
        PendingreceivablePayable();

    end;

    procedure deletefinalrevenuecalculation()
    var
        finalrevenuecalculation: Record "Final Revenue Calculation Grid";

    begin
        finalrevenuecalculation.SetRange("Contract Id", Rec."Contract ID");
        //  finalrevenuecalculation.SetRange("FC ID", Rec."FC ID");
        if finalrevenuecalculation.FindSet() then begin
            finalrevenuecalculation.DeleteAll();
        end

    end;

    procedure deletebillingcaculation()
    var
        billingcalculation: Record "Final Billing Calculation Grid";
    begin
        billingcalculation.SetRange("Contract ID", rec."Contract ID");
        if billingcalculation.FindSet() then begin
            billingcalculation.DeleteAll();
        end;
    end;

    procedure PendingreceivablePayable()
    var
        pendingRecevieable: Record "Pending Receviable Grid";
    begin
        pendingRecevieable.SetRange("Contract ID", Rec."Contract ID");
        if pendingRecevieable.FindSet() then begin
            pendingRecevieable.DeleteAll();
        end;

    end;

    //-----------------Delete record also delete subgrid -----------------//

}





