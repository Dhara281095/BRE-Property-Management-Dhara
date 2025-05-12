table 50911 "Revenue Structure"
{
    DataClassification = ToBeClassified;

    fields
    {
        // field(50100; "Proposal ID"; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Proposal ID';
        //     TableRelation = "Lease Proposal Details"."Proposal ID";



        // }

        field(50112; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
            TableRelation = "Tenancy Contract"."Contract ID";



        }

        field(50101; "RS ID"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true; // Automatically increment the ID
            Editable = false; // Make it read-only for the user
        }

        field(50102; "Secondary Item Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Secondary Item Type';
            Editable = false;
        }

        field(50103; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
            Editable = false;
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

        field(50106; "Number of Installments"; Integer)
        {
            // DataClassification = ToBeClassified;
            Caption = 'Number of Installments';
            //  Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = sum("Revenue Structure Subpage"."Yearly No. of Installment" where("Proposal Id" = field("Proposal ID"), "RS ID" = field("RS ID")));



        }

        field(50107; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Amount';
            Editable = false;
        }

        field(50108; "Amount Including VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Including VAT';
            Editable = false;
        }

        field(50109; "Tenant ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
            Editable = false;
            TableRelation = "Lease Proposal Details"."Tenant ID";
        }
        field(50110; "Rent Calculation Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Rent Calculation Type';
            Editable = false;
        }

        field(50111; "VAT %"; Option)
        {
            OptionMembers = "0","5";
            Caption = 'VAT %';
            Editable = false;
        }





    }



    keys
    {
        key(PK; "RS ID")
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
        Deleterevenuerecognition();
    end;

    procedure deletepaymentschedule()
    var
        paymentschedule: Record "Revenue Structure Subpage";

    begin
        paymentschedule.SetRange("Contract Id", Rec."Contract ID");
        paymentschedule.SetRange("RS ID", Rec."RS ID");
        if paymentschedule.FindSet() then begin
            paymentschedule.DeleteAll();
        end

    end;

    procedure deleterevenuestructuresubpag1()
    var
        revenuestructuresubpage1: Record "Revenue Structure Subpage1";
    begin
        revenuestructuresubpage1.SetRange("Contract ID", Rec."Contract ID");
        revenuestructuresubpage1.SetRange("RS ID", Rec."RS ID");
        if revenuestructuresubpage1.FindSet() then begin
            revenuestructuresubpage1.DeleteAll();
        end;
    end;

    procedure Deleterevenuerecognition()
    var
        revenuerecognition: Record "RevenueRecognition Othercharge";
    begin
        revenuerecognition.SetRange("Contract ID", Rec."Contract ID");
        if revenuerecognition.FindSet() then
            repeat
                revenuerecognition.DeleteAll();
            until revenuerecognition.Next() = 0;
    end;


    //-----------------Delete record also delete subgrid -----------------//

}





