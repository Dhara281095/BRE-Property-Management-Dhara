table 50319 "Security Deposit"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Security Deposit ID";

    fields
    {
        field(50100; "Security Deposit ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Security Deposit ID';
            AutoIncrement = true;
        }


        field(50103; "Tenant Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Full Name';
            TableRelation = Customer.Name;

            trigger OnLookup()
            var
                CustomerRec: Record Customer;
            begin
                if PAGE.RunModal(PAGE::"Customer List", CustomerRec) = ACTION::LookupOK then
                    "Tenant Full Name" := CustomerRec.Name;
            end;

            trigger OnValidate()
            var
                CustomerRec: Record Customer;
            begin
                if "Tenant Full Name" <> '' then begin
                    CustomerRec.SetRange(Name, "Tenant Full Name");
                    if not CustomerRec.FindFirst() then
                        Error('The selected tenant does not exist in the Customer table.');
                end;
            end;
        }




        field(50102; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';

            TableRelation = "Tenancy Contract"."Contract ID";

            trigger OnLookup()
            var
                TenancyContractRec: Record "Tenancy Contract";
            begin
                if "Tenant Full Name" = '' then
                    Error('Please select a tenant before choosing a contract.');

                // Filter the contracts by the selected tenant
                TenancyContractRec.SetRange("Customer Name", "Tenant Full Name");
                if PAGE.RunModal(PAGE::"Tenancy Contract List", TenancyContractRec) = ACTION::LookupOK then
                    "Contract ID" := TenancyContractRec."Contract ID";

                FetchContractDetails("Contract ID", false);
            end;
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

        field(50106; "Security Deposit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Security Deposit Amount';

            trigger OnValidate()
            begin
                UpdateAdjustedAmount();
            end;
        }

        field(50107; "New_Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'New Contract ID';
            TableRelation = "Tenancy Contract"."Contract ID";

            trigger OnLookup()
            var
                TenancyContractRec: Record "Tenancy Contract";
            begin
                if "Tenant Full Name" = '' then
                    Error('Please select a tenant before choosing a new contract.');

                // Filter the contracts by the selected tenant
                TenancyContractRec.SetRange("Customer Name", "Tenant Full Name");
                if PAGE.RunModal(PAGE::"Tenancy Contract List", TenancyContractRec) = ACTION::LookupOK then
                    "New_Contract ID" := TenancyContractRec."Contract ID";

                FetchContractDetails("New_Contract ID", true);
            end;
        }

        field(50108; "New_Tenant Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'New Tenant Full Name';
        }

        field(50109; "New_Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'New Contract Start Date';
        }

        field(50110; "New_Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'New Contract End Date';
        }

        field(50111; "New_Security Deposit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enter Amount';

            trigger OnValidate()
            begin
                UpdateAdjustedAmount();
            end;
        }

        field(50112; "Adjusted amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Adjustment Amount';
            Editable = false; // Make it non-editable since it's auto-calculated
        }

        field(50113; "Narration"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'Narration';
        }

        field(50176; "Balance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50177; "New Security Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50178; "New_Balance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Security Deposit ID", "Tenant Full Name")
        {
            Clustered = true;
        }
    }

    //------------------- Fetch Contract Data -------------------//


    local procedure FetchContractDetails(ContractID: Integer; IsNewContract: Boolean)
    var
        TenancyContractRec: Record "Tenancy Contract";
    begin
        TenancyContractRec.SetRange("Contract ID", ContractID);
        if TenancyContractRec.FindFirst() then begin
            if IsNewContract then begin
                "New_Contract Start Date" := TenancyContractRec."Contract Start Date";
                "New_Contract End Date" := TenancyContractRec."Contract End Date";
                "New_Tenant Full Name" := TenancyContractRec."Customer Name";
                "New Security Amount" := TenancyContractRec."Security Deposit Amount";
                "New_Balance Amount" := TenancyContractRec."Balance Amount";


                // Update the Narration field dynamically
                "Narration" := StrSubstNo(
                    'Carry forward of security deposit from %1 to %2.',
                    "Contract ID", "New_Contract ID");
            end else begin
                "Contract Start Date" := TenancyContractRec."Contract Start Date";
                "Contract End Date" := TenancyContractRec."Contract End Date";
                // "Tenant Full Name" := TenancyContractRec."Customer Name";
                "Security Deposit Amount" := TenancyContractRec."Security Deposit Amount";
                "Balance Amount" := TenancyContractRec."Balance Amount";
            end;


            // Recalculate Adjusted Amount
            UpdateAdjustedAmount();
        end else begin
            // Clear fields if no record is found
            if IsNewContract then begin
                Clear("New_Contract Start Date");
                Clear("New_Contract End Date");
                Clear("New_Tenant Full Name");
                Clear("New Security Amount");
                Clear("New_Balance Amount");

            end else begin
                Clear("Contract Start Date");
                Clear("Contract End Date");
                Clear("Tenant Full Name");
                Clear("Security Deposit Amount");
                Clear("Balance Amount");

            end;

            // Clear Adjusted Amount
            UpdateAdjustedAmount();
        end;
    end;




    local procedure UpdateAdjustedAmount()
    var
        TenancyContractRec: Record "Tenancy Contract";
    begin


        // Adjust the Balance Amount and Adjusted Amount based on conditions
        if "Balance Amount" > "New_Security Deposit Amount" then begin
            // "Adjusted amount" := 0; // Adjusted amount is set to 0
            "Balance Amount" := "Balance Amount" - "New_Security Deposit Amount";
            "New_Balance Amount" := "New_Security Deposit Amount";
            "Adjusted amount" := "New Security Amount" - "New_Balance Amount"; // Update the remaining balance
        end else begin
            // Difference becomes Adjusted Amount
            "Balance Amount" := 0; // Balance is cleared
        end;

        // Save changes to the Tenancy Contract table
        TenancyContractRec.SetRange("Contract ID", "Contract ID");
        if TenancyContractRec.FindFirst() then begin
            TenancyContractRec."Balance Amount" := "Balance Amount"; // Update the Balance Amount
            TenancyContractRec.Modify(); // Save the record
        end;

        TenancyContractRec.SetRange("Contract ID", "New_Contract ID");
        if TenancyContractRec.FindFirst() then begin
            TenancyContractRec."Balance Amount" := "New_Balance Amount"; // Update the Balance Amount
            TenancyContractRec.Modify(); // Save the record
        end;
    end;

    // local procedure UpdateAdjustedAmount()
    // var
    //     TenancyContractRec: Record "Tenancy Contract";
    // begin
    //     // Adjust the Balance Amount and Adjusted Amount based on the new security deposit amount
    //     if "New_Security Deposit Amount" > "New Security Amount" then begin
    //         "Adjusted amount" := "New_Security Deposit Amount" - "New Security Amount"; // Remaining amount will go to Adjusted Amount
    //         "New_Balance Amount" := 0; // Set New Balance Amount to 0 since the deposit exceeds
    //     end else begin
    //         "Adjusted amount" := 0; // No remaining amount, Adjusted amount is set to 0
    //         "New_Balance Amount" := "New Security Amount" - "New_Security Deposit Amount"; // New Balance Amount is the difference
    //     end;

    //     // Save changes to the Tenancy Contract table
    //     TenancyContractRec.SetRange("Contract ID", "Contract ID");
    //     if TenancyContractRec.FindFirst() then begin
    //         TenancyContractRec."Balance Amount" := "New_Balance Amount"; // Update the Balance Amount
    //         TenancyContractRec.Modify(); // Save the record
    //     end;
    // end;

    // local procedure UpdateAdjustedAmount()
    // var
    //     TenancyContractRec: Record "Tenancy Contract";
    // begin
    //     // Ensure that New Security Deposit Amount is greater than zero
    //     if "New_Security Deposit Amount" > 0 then begin
    //         // Subtract the New Security Deposit Amount from the current Balance Amount
    //         "Balance Amount" := "Balance Amount" - "New_Security Deposit Amount";

    //         // Store the remaining Balance Amount in Adjusted Amount field
    //         "Adjusted amount" := "Balance Amount";

    //         // Display the same New Security Deposit Amount in the New Balance Amount field
    //         "New_Balance Amount" := "New_Security Deposit Amount";

    //         // If the Balance Amount becomes negative or zero, reset it to zero
    //         if "Balance Amount" < 0 then begin
    //             "Balance Amount" := 0;
    //         end;
    //     end else begin
    //         // Reset fields if no New Security Deposit Amount is entered
    //         "Adjusted amount" := 0;
    //         "New_Balance Amount" := 0;
    //         "Balance Amount" := 0;
    //     end;

    //     // Save changes to the Tenancy Contract table
    //     TenancyContractRec.SetRange("Contract ID", "Contract ID");
    //     if TenancyContractRec.FindFirst() then begin
    //         TenancyContractRec."Balance Amount" := "Balance Amount"; // Update the Balance Amount in the Tenancy Contract
    //         // TenancyContractRec."New_Balance Amount" := "New_Balance Amount"; // Update the New Balance Amount in the Tenancy Contract
    //         TenancyContractRec.Modify(); // Save the record
    //     end;
    // end;



    //------------------- Update Adjust Amount With New and Old Contract -------------------//
}
