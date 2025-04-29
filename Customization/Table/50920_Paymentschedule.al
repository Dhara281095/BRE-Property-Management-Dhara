table 50920 "Payment Schedule"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Contract ID";

    fields
    {


        // field(50100; "Proposal ID"; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Lease Proposal Details"."Proposal ID";

        //     // trigger OnValidate()
        //     // var
        //     //     leaserec: Record "Lease Proposal Details";
        //     //     payschedule: Record "Payment Schedule2";
        //     // begin

        //     //     leaserec.SetRange("Proposal ID", Rec."Proposal ID");
        //     //     if leaserec.FindFirst() then begin
        //     //         "Tenant Id" := leaserec."Tenant Id";

        //     //     end else begin
        //     //         // Clear the field if no record is found
        //     //         "Tenant Id" := '';
        //     //     end;
        //     //     UpdatePaymentSchedule2();
        //     //     addrevnuestructurpagelinePaymentschedule2();
        //     //     //FetchPaymentScheduleData();
        //     //     //payschedule.FetchPaymentScheduleData();

        //     // end;

        // }
        field(50101; "Tenant Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Id';
            TableRelation = "Lease Proposal Details"."Tenant ID";
            Editable = false; // Make it read-only for the user

        }


        field(50102; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tenancy Contract"."Contract ID" WHERE("Tenant Contract Status" = CONST(Active));
            // AutoIncrement = true;
            Caption = 'Contract ID';

            trigger OnValidate()
            var
                leaserec: Record "Tenancy Contract";

            begin
                leaserec.SetRange("Contract ID", Rec."Contract ID");
                if leaserec.FindFirst() then begin
                    //"Proposal ID" := leaserec."Proposal ID";
                    "Tenant Id" := leaserec."Tenant Id";
                    "Tenant Name" := leaserec."Customer Name";
                    "Contract Status" := Format(leaserec."Tenant Contract Status");
                    "Contract Start date" := leaserec."Contract Start Date";
                    "Property ID" := leaserec."Property ID";
                    "Property Classification" := leaserec."Property Classification";
                end else begin
                    // Clear the field if no record is found
                    // "Proposal Id" := '';
                    "Tenant Id" := '';
                    "Tenant Name" := '';
                    "Contract Status" := '';
                    "Property ID" := '';
                    "Property Classification" := '';

                end;
                UpdatePaymentSchedule2();
                UpdatePaymentSchedule();
                addrevnuestructurpagelinePaymentschedule2();
                // AssignPaymentSeries();
                EvaluatePaymentSchedule();
                //GetNextSequenceNo();


            end;

        }

        field(50103; "Total Amount Including VAT"; Decimal)
        {
            Caption = 'Total Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Schedule2"."Amount Including VAT" where("Contract ID" = field("Contract ID")));
        }


        field(50111; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Schedule2".Amount where("Contract ID" = field("Contract ID"), "Tenant ID" = field("Tenant ID")));
        }

        field(50912; "Total VAT Amount"; Decimal)
        {
            Caption = 'Total VAT Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Schedule2"."VAT Amount" where("Contract ID" = field("Contract ID"), "Tenant ID" = field("Tenant ID")));
        }

        // field(50913; "Total Amount Including VAT"; Decimal)
        // {
        //     Caption = 'Total Amount Including VAT';
        //     Editable = false;
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Payment Schedule2"."Amount Including VAT" where("Proposal ID" = field("Proposal ID"), "Tenant ID" = field("Tenant ID")));
        // }
        field(50913; "Tenant Name"; Text[100])
        {
            Caption = 'Tenant Name';

        }
        field(50914; "Property Classification"; Text[100])
        {
            Caption = 'Property Classification';
            DataClassification = ToBeClassified;
        }

        field(50915; "Contract Status"; Text[100])
        {
            Caption = 'Contract Status';
            DataClassification = ToBeClassified;
        }
        field(50916; "Contract Start date"; Date)
        {
            Caption = 'Contract Start date';
            DataClassification = ToBeClassified;
        }
        field(50917; "Property ID"; Code[40])
        {
            Caption = 'Property ID';
            DataClassification = ToBeClassified;
        }


    }

    keys
    {
        key(PK; "Contract ID")
        {
            Clustered = true;
        }


    }
    procedure UpdatePaymentSchedule2()
    var
        RevenueSubpage: Record "Tenancy Contract Subpage";
        PaymentSchedule2: Record "Payment Schedule2";
        vatper: Integer;

    begin
        PaymentSchedule2.SetRange("Contract ID", Rec."Contract ID");
        //PaymentSchedule2.SetRange("Tenant ID", Rec."Tenant ID");

        // PaymentSchedule2.SetRange("Proposal ID", Rec."Proposal ID");
        if PaymentSchedule2.FindSet() then begin
            PaymentSchedule2.DeleteAll();
        end;
        // PaymentSchedule2.SetRange("Contract ID", Rec."Contract ID");
        //PaymentSchedule2.SetRange("Tenant ID", Rec."Tenant ID");
        RevenueSubpage.SetRange("ContractID", Rec."Contract ID");
        // RevenueSubpage.SetRange(ProposalID, Rec."Proposal ID");
        RevenueSubpage.SetRange("Payment Type", 1);
        if RevenueSubpage.FindSet() then
            repeat

                // PaymentSchedule2.SetRange("PS ID", Rec."PS Id");

                PaymentSchedule2.Init();
                // PaymentSchedule2."PS ID" := Rec."PS Id";
                PaymentSchedule2."Contract ID" := RevenueSubpage."ContractID";
                PaymentSchedule2."Contract start date" := Rec."Contract Start date";
                // PaymentSchedule2."Proposal ID" := rec."Proposal ID";
                PaymentSchedule2."Contract Status" := Rec."Contract Status";
                PaymentSchedule2."Property ID" := Rec."Property ID";
                PaymentSchedule2."Tenant Name" := Rec."Tenant Name";
                PaymentSchedule2."Tenant ID" := RevenueSubpage."TenantId";
                PaymentSchedule2."Property Classification" := Rec."Property Classification";
                PaymentSchedule2."Secondary Item Type" := RevenueSubpage."Secondary Item Type";
                PaymentSchedule2.Amount := RevenueSubpage.Amount;
                PaymentSchedule2."VAT Amount" := RevenueSubpage."VAT Amount";
                PaymentSchedule2."Amount Including VAT" := RevenueSubpage."Amount Including VAT";
                PaymentSchedule2."Installment Start Date" := RevenueSubpage."Start Date";
                PaymentSchedule2."Installment End Date" := RevenueSubpage."End Date";
                PaymentSchedule2."Due Date" := RevenueSubpage."Start Date";
                PaymentSchedule2."Installment No." := 1;
                // if PaymentSchedule2."VAT%" = RevenueSubpage."VAT %"::"5%" then
                //     vatper := 5
                // else
                //     vatper := 0;
                if RevenueSubpage."VAT %" = RevenueSubpage."VAT %"::"5%" then
                    vatper := 5
                else
                    vatper := 0;
                PaymentSchedule2."VAT%" := vatper;
                PaymentSchedule2.Insert();
                Clear(PaymentSchedule2);
            until RevenueSubpage.Next() = 0;


    end;


    procedure UpdatePaymentSchedule()
    var
        RentCalculationSubpage: Record "Rent Calculation Subpage2";
        PaymentSchedule: Record "Payment Schedule2";
        vatper: Integer;

    begin

        RentCalculationSubpage.SetRange("Contract ID", Rec."Contract ID");
        // RevenueStructureSubpage.SetRange("Tenant ID", Rec."Tenant ID");

        if RentCalculationSubpage.FindSet() then
            repeat
                PaymentSchedule.Init();
                // PaymentSchedule3."PS ID" := Rec."PS Id";
                PaymentSchedule."Contract ID" := RentCalculationSubpage."Contract ID";
                // PaymentSchedule3."Proposal ID" := Rec."Proposal ID";
                PaymentSchedule."Contract start date" := Rec."Contract Start date";
                PaymentSchedule."Contract Status" := Rec."Contract Status";
                PaymentSchedule."Property ID" := Rec."Property ID";
                PaymentSchedule."Tenant Name" := Rec."Tenant Name";
                PaymentSchedule."Tenant ID" := RentCalculationSubpage."Tenant Id";
                PaymentSchedule."Secondary Item Type" := RentCalculationSubpage."Secondary Item Type";
                PaymentSchedule.Amount := RentCalculationSubpage.Amount;
                PaymentSchedule."VAT Amount" := RentCalculationSubpage."VAT Amount";
                PaymentSchedule."Property Classification" := RentCalculationSubpage."Primary Classification";
                PaymentSchedule."Installment Start Date" := RentCalculationSubpage."Installment Start Date";
                PaymentSchedule."Installment End Date" := RentCalculationSubpage."Installment End Date";
                PaymentSchedule."Installment No." := RentCalculationSubpage."Installment No.";
                PaymentSchedule."Amount Including VAT" := RentCalculationSubpage."Amount Including VAT";
                PaymentSchedule."Due Date" := RentCalculationSubpage."Due Date";
                PaymentSchedule."VAT%" := RentCalculationSubpage."VAT %";
                // if RentCalculationSubpage."VAT %" = 5 then
                //     vatper := 5
                // else
                //     vatper := 0;
                // PaymentSchedule."VAT%" := vatper;

                PaymentSchedule.Insert();
                Clear(PaymentSchedule);
            until RentCalculationSubpage.Next() = 0;

    end;



    procedure addrevnuestructurpagelinePaymentschedule2()
    var
        RevenueStructureSubpage: Record "Revenue Structure Subpage1";
        PaymentSchedule3: Record "Payment Schedule2";
    begin

        RevenueStructureSubpage.SetRange("Contract ID", Rec."Contract ID");
        // RevenueStructureSubpage.SetRange("Tenant ID", Rec."Tenant ID");

        if RevenueStructureSubpage.FindSet() then
            repeat
                PaymentSchedule3.Init();
                // PaymentSchedule3."PS ID" := Rec."PS Id";
                PaymentSchedule3."Contract ID" := RevenueStructureSubpage."Contract ID";
                // PaymentSchedule3."Proposal ID" := Rec."Proposal ID";
                PaymentSchedule3."Contract start date" := Rec."Contract Start date";
                PaymentSchedule3."Contract Status" := Rec."Contract Status";
                PaymentSchedule3."Property ID" := Rec."Property ID";
                PaymentSchedule3."Tenant Name" := Rec."Tenant Name";
                PaymentSchedule3."Tenant ID" := RevenueStructureSubpage."Tenant Id";
                PaymentSchedule3."Property Classification" := Rec."Property Classification";
                PaymentSchedule3."Secondary Item Type" := RevenueStructureSubpage."Secondary Item Type";
                PaymentSchedule3.Amount := RevenueStructureSubpage.Amount;
                PaymentSchedule3."VAT Amount" := RevenueStructureSubpage."VAT Amount";
                PaymentSchedule3."Installment Start Date" := RevenueStructureSubpage."Installment Start Date";
                PaymentSchedule3."Installment End Date" := RevenueStructureSubpage."Installment End Date";
                PaymentSchedule3."Installment No." := RevenueStructureSubpage."Installment No.";
                PaymentSchedule3."Amount Including VAT" := RevenueStructureSubpage."Amount Including VAT";
                PaymentSchedule3."Due Date" := RevenueStructureSubpage."Due Date";
                PaymentSchedule3."VAT%" := RevenueStructureSubpage."VAT %";
                PaymentSchedule3.Insert();
                Clear(PaymentSchedule3);
            until RevenueStructureSubpage.Next() = 0;

    end;

    // procedure EvaluatePaymentSchedule()
    // var
    //     PaymentScheduleRec: Record "Payment Schedule2";
    //     PaymentScheduleRec2: Record "Payment Schedule2";
    //     NewPaymentCode: Code[20];
    //     SequenceNo: Integer;
    //     DueDate: Date;
    //     MinDueDate: Date;
    //     ProcessedDueDates: Dictionary of [Date, Boolean]; // Track processed due dates
    //     DueDateList: List of [Date]; // List to store due dates
    //     TempDate: Date;
    //     i: Integer; // Declare the variable 'i' for the loop
    //     SortedDueDateList: List of [Date]; // List for sorted due dates

    // begin
    //     // Filter by Proposal ID, Tenant ID, and Contract ID
    //     // PaymentScheduleRec.SetRange("Proposal ID", Rec."Proposal ID");
    //     PaymentScheduleRec.SetRange("Tenant ID", Rec."Tenant ID");
    //     PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");

    //     // Sort records by Due Date
    //     // Collect unique due dates
    //     if PaymentScheduleRec.FindSet() then
    //         repeat
    //             MinDueDate := PaymentScheduleRec."Due Date";
    //             if not DueDateList.Contains(MinDueDate) then
    //                 DueDateList.Add(MinDueDate);
    //         until PaymentScheduleRec.Next() = 0;

    //     // Sort the DueDateList
    //     while DueDateList.Count() > 0 do begin
    //         TempDate := DueDateList.Get(1); // Assume the first date is the smallest
    //         for i := 2 to DueDateList.Count() do begin
    //             if DueDateList.Get(i) < TempDate then
    //                 TempDate := DueDateList.Get(i); // Update if a smaller date is found
    //         end;
    //         SortedDueDateList.Add(TempDate); // Add the smallest date to the sorted list
    //         DueDateList.Remove(TempDate); // Remove the smallest date from the original list
    //     end;

    //     // Process each due date in the sorted order
    //     for i := 1 to SortedDueDateList.Count() do begin
    //         MinDueDate := SortedDueDateList.Get(i);


    //         // Generate unique Payment Series
    //         SequenceNo := GetNextSequenceNo();
    //         NewPaymentCode := GeneratePaymentCode(SequenceNo);

    //         // Process records for the current Due Date
    //         PaymentScheduleRec2.Reset();
    //         PaymentScheduleRec2.SetRange("Due Date", MinDueDate);

    //         //  PaymentScheduleRec2.SetRange("Proposal ID", Rec."Proposal ID");
    //         PaymentScheduleRec2.SetRange("Tenant ID", Rec."Tenant ID");
    //         PaymentScheduleRec2.SetRange("Contract ID", Rec."Contract ID");

    //         if PaymentScheduleRec2.FindSet() then begin
    //             // Modify existing records
    //             repeat
    //                 PaymentScheduleRec2."Payment Series" := NewPaymentCode;
    //                 PaymentScheduleRec2.Modify();
    //             until PaymentScheduleRec2.Next() = 0;
    //         end else begin
    //             // Insert a new record for the current Due Date
    //             PaymentScheduleRec2.Init();
    //             //  PaymentScheduleRec2."Proposal ID" := Rec."Proposal ID";
    //             PaymentScheduleRec2."Tenant ID" := Rec."Tenant ID";
    //             PaymentScheduleRec2."Contract ID" := Rec."Contract ID";
    //             //PaymentScheduleRec2."Tenant Name" := Rec."Tenant Name";
    //             PaymentScheduleRec2."Due Date" := DueDate;
    //             PaymentScheduleRec2."Payment Series" := NewPaymentCode;

    //             PaymentScheduleRec2.Insert();
    //             Clear(PaymentScheduleRec2);
    //         end

    //         // until PaymentScheduleRec.Next() = 0;
    //     end;

    //     Message('Process completed successfully.');
    // end;



    // local procedure GeneratePaymentCode(SequenceNumber: Integer): Code[20]
    // begin
    //     exit('PAY' + PadStr(Format(SequenceNumber), 2, '0'));
    // end;

    // local procedure PadStr(Input: Text[20]; Length: Integer; PaddingChar: Char): Text[20]
    // begin
    //     while StrLen(Input) < Length do
    //         Input := PaddingChar + Input;
    //     exit(Input);
    // end;

    // local procedure GetNextSequenceNo(): Integer
    // var
    //     MaxSequence: Integer;
    //     LastSequence: Text[10];
    //     PaymentScheduleRec: Record "Payment Schedule2";
    // begin
    //     PaymentScheduleRec.Reset();
    //     PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
    //     //PaymentScheduleRec.SetRange("Proposal ID", Rec."Proposal ID");

    //     if PaymentScheduleRec.FindSet() then begin
    //         repeat
    //             // Extract the numeric part of the Payment Series
    //             LastSequence := CopyStr(PaymentScheduleRec."Payment Series", 4, StrLen(PaymentScheduleRec."Payment Series"));
    //             if Evaluate(MaxSequence, LastSequence) and (MaxSequence > MaxSequence) then
    //                 MaxSequence := MaxSequence;
    //         until PaymentScheduleRec.Next() = 0;
    //     end else
    //         MaxSequence := 0; // Default to 0 if no records are found

    //     exit(MaxSequence + 1);
    // end;
    procedure EvaluatePaymentSchedule()
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        PaymentScheduleRec2: Record "Payment Schedule2";
        NewPaymentCode: Code[20];
        SequenceNo: Integer;
        MinDueDate: Date;
        DueDateList: List of [Date]; // List to store unique due dates
        TempDate: Date;
        i: Integer; // Declare the variable 'i' for the loop
        j: Integer; // Additional loop counter
        SortedDueDateList: List of [Date]; // List for sorted due dates
    begin
        // Filter by Tenant ID and Contract ID
        PaymentScheduleRec.SetRange("Tenant ID", Rec."Tenant ID");
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");

        // Collect unique due dates
        if PaymentScheduleRec.FindSet() then
            repeat
                if not DueDateList.Contains(PaymentScheduleRec."Due Date") then
                    DueDateList.Add(PaymentScheduleRec."Due Date");
            until PaymentScheduleRec.Next() = 0;

        // Sort the due dates in ascending order
        while DueDateList.Count() > 0 do begin
            TempDate := DueDateList.Get(1); // Start with first date
            for i := 2 to DueDateList.Count() do begin
                if DueDateList.Get(i) < TempDate then
                    TempDate := DueDateList.Get(i); // Find the earliest date
            end;
            SortedDueDateList.Add(TempDate); // Add to sorted list
            DueDateList.Remove(TempDate); // Remove from original list
        end;

        // Reset sequence counter at the beginning
        SequenceNo := 1;

        // Process each due date in the sorted order
        for i := 1 to SortedDueDateList.Count() do begin
            MinDueDate := SortedDueDateList.Get(i);

            // Generate payment code for this due date
            NewPaymentCode := GeneratePaymentCode(SequenceNo);

            // Find all records with this due date
            PaymentScheduleRec2.Reset();
            PaymentScheduleRec2.SetRange("Due Date", MinDueDate);
            PaymentScheduleRec2.SetRange("Tenant ID", Rec."Tenant ID");
            PaymentScheduleRec2.SetRange("Contract ID", Rec."Contract ID");

            if PaymentScheduleRec2.FindSet() then begin
                // Modify all records with this due date to have the same payment series
                repeat
                    PaymentScheduleRec2."Payment Series" := NewPaymentCode;
                    PaymentScheduleRec2.Modify();
                until PaymentScheduleRec2.Next() = 0;
            end;

            // Increment sequence for the next due date
            SequenceNo += 1;
        end;

        Message('Payment series assignment completed successfully.');
    end;

    local procedure GeneratePaymentCode(SequenceNumber: Integer): Code[20]
    begin
        exit('PAY' + PadStr(Format(SequenceNumber), 2, '0'));
    end;

    local procedure PadStr(Input: Text[20]; Length: Integer; PaddingChar: Char): Text[20]
    begin
        while StrLen(Input) < Length do
            Input := PaddingChar + Input;
        exit(Input);
    end;


    trigger OnDelete()
    var
    begin
        Deletepaymetnscheudlesubpage();

    end;

    procedure Deletepaymetnscheudlesubpage()
    var
        Paymentschedulesubpage: Record "Payment Schedule2";
    begin
        //  Paymentschedulesubpage.SetRange("PS ID", Rec."PS Id");

        Paymentschedulesubpage.SetRange("Contract ID", Rec."Contract ID");
        if Paymentschedulesubpage.FindSet() then
            Paymentschedulesubpage.DeleteAll();

    end;








}
