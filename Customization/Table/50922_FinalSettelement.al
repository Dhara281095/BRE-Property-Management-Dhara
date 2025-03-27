table 50922 "FinalSettlement"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50100; "Refund Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }
        field(50101; "Refund Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Amount';
        }
        field(50102; "Refund Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';
        }
        field(50103; "Refund Payment mode"; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment mode';
            TableRelation = "Payment Type"."Payment Method";
        }
        field(50104; "Refund Payment Status"; Enum "Payment Status")
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Status';
        }

        field(50105; "Refund Cheque No."; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cheque No.';
        }

        field(50106; "Receivable Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Amount';
        }
        field(50107; "Receivable Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';
        }
        field(50108; "Receivable Payment mode"; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment mode';
            TableRelation = "Payment Type"."Payment Method";
        }
        field(50109; "Receivable Payment Status"; Enum "Payment Status")
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Status';
        }

        field(50110; "Receivable Cheque No."; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cheque No.';
        }

        field(50111; "Deposit Bank"; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Deposit Bank';
            TableRelation = "Bank Account";

            trigger OnValidate()
            var
                BankAccountRec: Record "Bank Account";
            begin
                // When a Deposit Bank is selected (i.e., a Bank Account No. is provided)
                if "Deposit Bank" <> '' then begin
                    // Attempt to find the Bank Account using the No. from the Deposit Bank
                    if BankAccountRec.Get("Deposit Bank") then
                        "Deposit Bank" := BankAccountRec."Name"; // Populating the Name field from the Bank Account table
                end;
            end;
        }



        field(50112; "Deposit Status"; Option)
        {
            Caption = 'Deposit Status';
            OptionMembers = "-","N","Y";
        }

        field(50113; "Refund Tenant ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
        }

        field(50114; "Receivable Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }

        field(50115; "Receivable Tenant ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
        }
        // field(50114; "Receivable Entry No."; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     AutoIncrement = true;
        // }

        // field(50114; "Refund Entry No."; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     AutoIncrement = true;
        // }


        field(50116; "Receivable from the Tenant"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receivable from the Tenant';
        }

        field(50117; "Payment Processed"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Processed';
        }
        field(50118; "Balance Receivable"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Balance Receivable';
        }

        field(50119; "PaymentStatus"; Option)
        {
            OptionMembers = "Pending","Received";
            Caption = 'Payment Status';
        }

        field(50120; "Net Refund to the Tenant"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Net Refund to the Tenant';
        }

        field(50121; "Refund Processed"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Refund Processed';
        }
        field(50122; "Balance Refundable"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Balance Refundable';
        }

        field(50123; "Refund Status"; Option)
        {
            OptionMembers = "Pending","Received";
            Caption = 'Refund Status';
        }

        field(50124; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }

        field(50125; "Payment Receipt"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Receipt';
            InitValue = 'View';
        }
        field(50126; "Payment Receipt document URL"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Receipt Document URL';
        }

        field(50127; "Payment Receipt/Proof"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Receipt/Proof';
            InitValue = 'View';
        }
        field(50128; "Pay Receipt/Proof document URL"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Receipt/Proof document URL';
        }
    }

    keys
    {
        key(PK; "Receivable Contract ID", "Refund Contract ID", "Contract ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if Rec."Receivable Payment Mode" = 'Cheque' then begin
            if DelChr(Rec."Receivable Cheque No.", '=', ' ') = '' then
                Error('Cheque Number cannot be blank when Payment Mode is Cheque.');
        end;

        if Rec."Refund Payment Mode" = 'Cheque' then begin
            if DelChr(Rec."Refund Cheque No.", '=', ' ') = '' then
                Error('Cheque Number cannot be blank when Payment Mode is Cheque.');
        end;
    end;

}

