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


        field(50110; "Tenant ID"; Code[20])
        {

            Caption = 'Tenant ID';

        }
        field(50111; "Tenant Name"; Text[100])
        {

            Caption = 'Tenant Name';

        }
        field(50915; "Invoiced"; Boolean)
        {
            Caption = 'Invoiced';
        }


        field(50914; "Contract ID"; Integer)
        {
            Caption = 'Contract ID';
        }

        field(50916; "Payment Status"; Text[100])
        {
            Caption = 'Payment Status';


        }
        field(50917; "Property Classification"; Text[100])
        {
            Caption = 'Property Classification';
            DataClassification = ToBeClassified;
        }
        // field(50916; "Tenant Name"; Text[100])
        // {
        //     Caption = 'Tenant Name';
        // }

        field(50918; "Contract Status"; Text[100])
        {
            Caption = 'Contract Status';
            DataClassification = ToBeClassified;
        }
        field(50919; "Invoice ID"; Code[50])
        {
            Caption = 'Invoice ID';
            DataClassification = ToBeClassified;
        }
        field(50920; "Overdue Invoice"; Text[20])
        {
            Caption = 'Overdue Invoice';
            DataClassification = ToBeClassified;
        }
        field(50921; "Payment Recieved Date"; Date)
        {
            Caption = 'Payment Recived Date';
            DataClassification = ToBeClassified;
        }

        field(50922; "Payment Mode"; Text[100])
        {
            Caption = 'Payment Mode';
        }

        field(50923; "Cheque Number"; Text[100])
        {
            Caption = 'Cheque Number';
        }
        field(50924; "Contract start date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Start date';
        }
        field(50925; "Property ID"; Code[40])
        {
            DataClassification = ToBeClassified;
            Caption = 'Property ID';

        }
        field(50926; "No of Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'No of Days';

        }
        field(50927; "Workflow frequency date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Workflow Frequency Date';
        }
        field(50928; "VAT%"; Integer)
        {
            //OptionMembers = "0%","5%";
            DataClassification = ToBeClassified;
            Caption = 'VAT%';
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }


    }




    // local procedure UpdateBalanceAmountOnPaymentReceived()
    // var
    //     PaymentScheduleRec: Record "Payment Schedule2";
    //     TenancyContractRec: Record "Tenancy Contract";
    // begin
    //     // Filter records where 'Secondary Item Type' is 'Security Deposit Amount' and 'Payment Status' is 'Received'
    //     PaymentScheduleRec.SetRange("Secondary Item Type", 'Security Deposit Amount');
    //     PaymentScheduleRec.SetRange("Payment Status", 'Received');

    //     if PaymentScheduleRec.FindSet() then begin
    //         repeat
    //             // Filter Tenancy Contract records based on Contract ID
    //             TenancyContractRec.SetRange("Contract ID", PaymentScheduleRec."Contract ID");

    //             if TenancyContractRec.FindSet() then begin
    //                 repeat
    //                     // If Balance Amount has a value, update it
    //                     if TenancyContractRec."Balance Amount" <> 0 then begin
    //                         TenancyContractRec."Balance Amount" += PaymentScheduleRec."Amount Including VAT";
    //                         TenancyContractRec."Security Balanced Amount" += PaymentScheduleRec."Amount Including VAT";
    //                     end
    //                     else begin
    //                         // If Balance Amount is 0, set it to Amount Including VAT
    //                         TenancyContractRec."Balance Amount" := PaymentScheduleRec."Amount Including VAT";
    //                         TenancyContractRec."Security Balanced Amount" := PaymentScheduleRec."Amount Including VAT";
    //                     end;

    //                     // Modify the record to save changes
    //                     TenancyContractRec.Modify();
    //                 until TenancyContractRec.Next() = 0;
    //             end;
    //         until PaymentScheduleRec.Next() = 0;
    //     end;
    // end;




}
