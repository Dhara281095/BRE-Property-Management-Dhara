tableextension 50504 PostedSalesInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50101; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';

        }

        field(50102; "Property Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property Name';

        }
        field(50103; "Unit Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Name';
        }
        field(50104; "Contract Tenure"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Tenure';
        }
        field(50105; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Approved,Rejected;
            Caption = 'Approval Status';

        }
        field(50106; "Tenant Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Name';
        }
        field(50107; "Customer P.O"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer P.O';
        }
        field(50108; "Customer P.O Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer P.O Date';
        }
        field(50109; "Contract Period"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Period';
        }
        field(50110; "Reason For Rejection"; Text[1000])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reason For Rejection';
        }
        field(50111; "View Invoice"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'View Invoice';
        }
        field(50112; "View Document URL"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'View Document URL';
        }

    }
    trigger OnAfterInsert()
    var
        postedinvoiceheader: Record "Sales Invoice Header";
        paymentschedule2: Record "Payment Schedule2";
        paymentmode2: Record "Payment Mode2";
        paymentschedule2grid: Record "Payment Schedule2";
    begin
        paymentschedule2.SetRange("Contract ID", Rec."Contract ID");
        paymentschedule2.SetRange("Invoice ID", Rec."Pre-Assigned No.");
        if paymentschedule2.FindSet() then
            repeat
                paymentschedule2."Invoice ID" := Rec."No.";
                paymentschedule2.Modify();
            until paymentschedule2.Next() = 0;

        // paymentmode2.SetRange("Contract ID", paymentschedule2grid."Contract ID");
        // paymentmode2.SetRange("Payment Series", paymentschedule2grid."Payment Series");
        // if paymentmode2.FindSet() then
        //     repeat
        //         paymentmode2."Invoice #" := paymentschedule2grid."Invoice ID";
        //         paymentmode2.Modify();
        //     until paymentmode2.Next() = 0;

    end;


}