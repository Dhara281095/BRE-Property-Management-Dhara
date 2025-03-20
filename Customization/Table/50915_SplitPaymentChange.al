table 50915 "Split Payment Change"
{
    DataClassification = ToBeClassified;


    fields
    {

        field(50100; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';

        }
        field(50101; "Split Payment Series"; Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                PaymentMode2Rec: Record "Payment Mode2";
                Selection: Page "Payment Mode2 List";
            begin
                // Ensure Contract ID is selected first
                if Rec."Contract ID" = 0 then
                    Error('Please select a Contract ID first');

                // Filter Payment Mode2 records based on Contract ID
                PaymentMode2Rec.Reset();
                PaymentMode2Rec.SetRange("Contract ID", Rec."Contract ID");
                PaymentMode2Rec.SetFilter("Payment Status", '<> %1 & <> %2', PaymentMode2Rec."Payment Status"::Cancelled, PaymentMode2Rec."Payment Status"::Received);

                Selection.LookupMode(true);
                Selection.SetTableView(PaymentMode2Rec);

                if Selection.RunModal() = ACTION::LookupOK then begin
                    Selection.SetSelectionFilter(PaymentMode2Rec);

                    if PaymentMode2Rec.FindSet() then begin
                        Rec."Split Payment Series" := PaymentMode2Rec."Payment Series"; // Select only one value
                    end;
                end;
            end;
        }


        field(50102; "Secondary Item Type"; Text[100])
        {
            DataClassification = ToBeClassified;


            trigger OnLookup()
            var
                PaymentMode2Rec: Record "Payment Mode2";
                Selection: Page "Payment Schedule2 List";
                PaymentSchedule2Rec: Record "Payment Schedule2";
                SelectedPaymentSeries: Text[250];
                TotalAmount: Decimal;
                TotalVATAmount: Decimal;
                TotalAmountInclVAT: Decimal;
            begin
                // First check if Contract ID is selected
                if Rec."Contract ID" = 0 then
                    Error('Please select a Contract ID first');

                // Filter Payment Mode2 records based on Contract ID
                PaymentSchedule2Rec.Reset();
                PaymentSchedule2Rec.SetRange("Contract ID", Rec."Contract ID");
                PaymentSchedule2Rec.SetRange("Payment Series", Rec."Split Payment Series");

                Selection.LookupMode(true);
                Selection.SetTableView(PaymentSchedule2Rec);

                if Selection.RunModal() = ACTION::LookupOK then begin
                    // Clear totals
                    Clear(TotalAmount);
                    Clear(TotalVATAmount);
                    Clear(TotalAmountInclVAT);
                    Clear(SelectedPaymentSeries);

                    Selection.SetSelectionFilter(PaymentSchedule2Rec);
                    if PaymentSchedule2Rec.FindSet() then begin
                        repeat
                            // Add to payment series string
                            if SelectedPaymentSeries <> '' then
                                SelectedPaymentSeries := SelectedPaymentSeries + ',';
                            SelectedPaymentSeries := SelectedPaymentSeries + PaymentSchedule2Rec."Secondary Item Type";

                            // Sum up amounts
                            TotalAmount += PaymentSchedule2Rec.Amount;
                            TotalVATAmount += PaymentSchedule2Rec."VAT Amount";
                            TotalAmountInclVAT += PaymentSchedule2Rec."Amount Including VAT";
                        until PaymentSchedule2Rec.Next() = 0;

                        // Set all values to the record
                        Rec."Secondary Item Type" := SelectedPaymentSeries;
                        Rec."Split Amount" := TotalAmount;
                        Rec."Split VAT Amount" := TotalVATAmount;
                        Rec."Split Amount Including VAT" := TotalAmountInclVAT;
                    end;
                end;
            end;

        }
        field(50103; "Split Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50104; "Split Payment Mode"; Text[150])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Type"."Payment Method";
        }

        field(50105; "Split Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50106; "Split VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50107; "Split Amount Including VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50108; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(50109; "Tenant Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';

        }




    }

    keys
    {
        key(Key1; "Entry No.", "Contract ID")
        {
            Clustered = true;
        }
    }


}