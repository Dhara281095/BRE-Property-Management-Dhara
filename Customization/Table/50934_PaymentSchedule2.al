table 50934 "Payment Schedule2"
{
    DataClassification = ToBeClassified;


    fields
    {




        field(50100; "Secondary Item Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Secondary Item Type';

        }


        field(50101; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';

        }


        field(50102; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Amount';

        }



        field(50103; "Amount Including VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Including VAT';

        }

        field(50104; "Installment Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Installment Start Date';

        }

        field(50105; "Installment End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Installment End Date';

        }



        field(50106; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';

        }

        field(50107; "Installment No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Installment No.';

        }



        field(50116; "Payment Series"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Series';

        }

        field(50108; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }



        // field(50109; "Proposal ID"; Integer)
        // {

        //     Caption = 'Proposal ID';

        //     // trigger OnValidate()
        //     // var
        //     //     leaserec: Record "Lease Proposal Details";
        //     //     payschedule: Record "Payment Schedule2";
        //     // begin
        //     //     payschedule.FetchPaymentScheduleData("Proposal ID", "Tenant ID");

        //     // end;

        // }

        field(50110; "Tenant ID"; Code[20])
        {

            Caption = 'Tenant ID';

        }
        field(50111; "Tenant Name"; Text[100])
        {

            Caption = 'Tenant Name';

        }
        // field(50111; "PS ID"; Integer)
        // {

        //     Caption = 'PS ID';

        // }
        field(50915; "Invoiced"; Boolean)
        {
            Caption = 'Invoiced';
        }


        field(50914; "Contract ID"; Integer)
        {
            Caption = 'Contract ID';
        }
        // field(50916; "Tenant Name"; Text[100])
        // {
        //     Caption = 'Tenant Name';
        // }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }


    }





    // procedure FetchPaymentScheduleData(pProposalID: Integer; pTenantID: Code[20])
    // var
    //     RevenueStructureSubpageRec: Record "Revenue Structure Subpage1";
    //     Onetimepay: Record "Revenue Item Subpage";
    //     PaymentScheduleRec: Record "Payment Schedule2";
    // begin
    //     // Clear existing data in the Payment Schedule2 table for the given ProposalID and TenantID
    //     PaymentScheduleRec.SetRange("Proposal ID", pProposalID);
    //     PaymentScheduleRec.SetRange("Tenant ID", pTenantID);
    //     if PaymentScheduleRec.FindSet() then
    //         repeat
    //             PaymentScheduleRec.Delete();
    //         until PaymentScheduleRec.Next() = 0;

    //     // Insert data from Revenue Structure Subpage1
    //     RevenueStructureSubpageRec.SetRange("Proposal ID", pProposalID);
    //     RevenueStructureSubpageRec.SetRange("Tenant ID", pTenantID);

    //     if RevenueStructureSubpageRec.FindSet() then
    //         repeat
    //             PaymentScheduleRec.Init();
    //             PaymentScheduleRec."Proposal ID" := RevenueStructureSubpageRec."Proposal ID";
    //             PaymentScheduleRec."Tenant ID" := RevenueStructureSubpageRec."Tenant ID";
    //             PaymentScheduleRec."Secondary Item Type" := RevenueStructureSubpageRec."Secondary Item Type";
    //             PaymentScheduleRec."Amount" := RevenueStructureSubpageRec."Amount";
    //             PaymentScheduleRec."VAT Amount" := RevenueStructureSubpageRec."VAT Amount";
    //             PaymentScheduleRec."Amount Including VAT" := RevenueStructureSubpageRec."Amount Including VAT";
    //             PaymentScheduleRec."Installment Start Date" := RevenueStructureSubpageRec."Installment Start Date";
    //             PaymentScheduleRec."Installment End Date" := RevenueStructureSubpageRec."Installment End Date";
    //             PaymentScheduleRec."Due Date" := RevenueStructureSubpageRec."Due Date";
    //             PaymentScheduleRec."Installment No." := RevenueStructureSubpageRec."Installment No.";
    //             PaymentScheduleRec."Proposal ID" := pProposalID;
    //             PaymentScheduleRec."Tenant ID" := pTenantID;
    //             PaymentScheduleRec.Insert();
    //         until RevenueStructureSubpageRec.Next() = 0;

    //     // Insert data from Revenue Item Subpage
    //     Onetimepay.SetRange("ProposalID", pProposalID);
    //     Onetimepay.SetRange("TenantID", pTenantID);

    //     if Onetimepay.FindSet() then
    //         repeat
    //             PaymentScheduleRec.Init();
    //             PaymentScheduleRec."Proposal ID" := Onetimepay."ProposalID";
    //             PaymentScheduleRec."Tenant ID" := Onetimepay."TenantID";
    //             PaymentScheduleRec."Secondary Item Type" := Onetimepay."Secondary Item Type";
    //             PaymentScheduleRec."Amount" := Onetimepay.Amount;
    //             PaymentScheduleRec."VAT Amount" := Onetimepay."VAT Amount";
    //             PaymentScheduleRec."Amount Including VAT" := Onetimepay."Amount Including VAT";
    //             PaymentScheduleRec."Installment Start Date" := Onetimepay."Start Date";
    //             PaymentScheduleRec."Installment End Date" := Onetimepay."End Date";
    //             PaymentScheduleRec."Due Date" := Onetimepay."Start Date";
    //             PaymentScheduleRec."Installment No." := Onetimepay."Payment Type";
    //             PaymentScheduleRec."Proposal ID" := pProposalID;
    //             PaymentScheduleRec."Tenant ID" := pTenantID;
    //             PaymentScheduleRec.Insert();
    //         until Onetimepay.Next() = 0;

    //     // Update the page with new data
    //     // CurrPage.SetTableView(PaymentScheduleRec);
    //     // CurrPage.Update();
    // end;





}
