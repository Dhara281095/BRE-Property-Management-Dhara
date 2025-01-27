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
            TableRelation = "Tenancy Contract"."Contract ID";
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

                end else begin
                    // Clear the field if no record is found
                    // "Proposal Id" := '';
                    "Tenant Id" := '';
                end;
                UpdatePaymentSchedule2();
                addrevnuestructurpagelinePaymentschedule2();
                // AssignPaymentSeries();
                EvaluatePaymentSchedule();
                GetNextSequenceNo();


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

    begin
        PaymentSchedule2.SetRange("Contract ID", Rec."Contract ID");
        PaymentSchedule2.SetRange("Tenant ID", Rec."Tenant ID");
        // PaymentSchedule2.SetRange("Proposal ID", Rec."Proposal ID");
        if PaymentSchedule2.FindSet() then begin
            PaymentSchedule2.DeleteAll();
        end;
        PaymentSchedule2.SetRange("Contract ID", Rec."Contract ID");
        PaymentSchedule2.SetRange("Tenant ID", Rec."Tenant ID");
        // RevenueSubpage.SetRange(ProposalID, Rec."Proposal ID");
        RevenueSubpage.SetRange("Payment Type", 1);
        if RevenueSubpage.FindSet() then
            repeat

                // PaymentSchedule2.SetRange("PS ID", Rec."PS Id");

                PaymentSchedule2.Init();
                // PaymentSchedule2."PS ID" := Rec."PS Id";
                PaymentSchedule2."Contract ID" := RevenueSubpage."ContractID";
                // PaymentSchedule2."Proposal ID" := rec."Proposal ID";
                PaymentSchedule2."Tenant ID" := RevenueSubpage."TenantId";
                PaymentSchedule2."Secondary Item Type" := RevenueSubpage."Secondary Item Type";
                PaymentSchedule2.Amount := RevenueSubpage.Amount;
                PaymentSchedule2."VAT Amount" := RevenueSubpage."VAT Amount";
                PaymentSchedule2."Amount Including VAT" := RevenueSubpage."Amount Including VAT";
                PaymentSchedule2."Installment Start Date" := RevenueSubpage."Start Date";
                PaymentSchedule2."Installment End Date" := RevenueSubpage."End Date";
                PaymentSchedule2."Due Date" := RevenueSubpage."Start Date";
                PaymentSchedule2."Installment No." := 1;
                PaymentSchedule2.Insert();
                Clear(PaymentSchedule2);
            until RevenueSubpage.Next() = 0;


    end;

    procedure addrevnuestructurpagelinePaymentschedule2()
    var
        RevenueStructureSubpage: Record "Revenue Structure Subpage1";
        PaymentSchedule3: Record "Payment Schedule2";
    begin

        RevenueStructureSubpage.SetRange("Contract ID", Rec."Contract ID");
        RevenueStructureSubpage.SetRange("Tenant ID", Rec."Tenant ID");

        if RevenueStructureSubpage.FindSet() then
            repeat
                PaymentSchedule3.Init();
                // PaymentSchedule3."PS ID" := Rec."PS Id";
                PaymentSchedule3."Contract ID" := RevenueStructureSubpage."Contract ID";
                // PaymentSchedule3."Proposal ID" := Rec."Proposal ID";
                PaymentSchedule3."Tenant ID" := RevenueStructureSubpage."Tenant Id";
                PaymentSchedule3."Secondary Item Type" := RevenueStructureSubpage."Secondary Item Type";
                PaymentSchedule3.Amount := RevenueStructureSubpage.Amount;
                PaymentSchedule3."VAT Amount" := RevenueStructureSubpage."VAT Amount";
                PaymentSchedule3."Installment Start Date" := RevenueStructureSubpage."Installment Start Date";
                PaymentSchedule3."Installment End Date" := RevenueStructureSubpage."Installment End Date";
                PaymentSchedule3."Installment No." := RevenueStructureSubpage."Installment No.";
                PaymentSchedule3."Amount Including VAT" := RevenueStructureSubpage."Amount Including VAT";
                PaymentSchedule3."Due Date" := RevenueStructureSubpage."Due Date";
                PaymentSchedule3.Insert();
                Clear(PaymentSchedule3);
            until RevenueStructureSubpage.Next() = 0;

    end;



    // procedure AssignPaymentSeries()
    // var
    //     PaymentRec: Record "Payment Schedule2";
    //     SortedDueDates: Dictionary of [Date, Text];
    //     CurrentSeries: Integer;
    //     SeriesCode: Text[10];
    //     DueDate: Date;
    // begin
    //     CurrentSeries := 1;

    //     // Step 1: Process all Payment Schedule2 records
    //     if PaymentRec.FindSet(true) then begin
    //         repeat
    //             DueDate := PaymentRec."Due Date";

    //             // Step 2: Check if Due Date is already assigned a Payment Series
    //             if not SortedDueDates.ContainsKey(DueDate) then begin
    //                 // Generate series code as PAY01, PAY02, etc.
    //                 SeriesCode := StrSubstNo('PAY%1', Format(CurrentSeries, 2, '0'));
    //                 SortedDueDates.Add(DueDate, SeriesCode);
    //                 CurrentSeries := CurrentSeries + 1;
    //             end;

    //             // Step 3: Assign the Payment Series from the dictionary
    //             PaymentRec."Payment Series" := SortedDueDates.Get(DueDate);
    //             PaymentRec.Modify();
    //         until PaymentRec.Next() = 0;
    //     end;
    // end;




    procedure EvaluatePaymentSchedule()
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        PaymentScheduleRec2: Record "Payment Schedule2";
        NewPaymentCode: Code[20];
        SequenceNo: Integer;
        DueDate: Date;
        MinDueDate: Date;
        ProcessedDueDates: Dictionary of [Date, Boolean]; // Track processed due dates
        DueDateList: List of [Date]; // List to store due dates
        TempDate: Date;
        i: Integer; // Declare the variable 'i' for the loop
        SortedDueDateList: List of [Date]; // List for sorted due dates

    begin
        // Filter by Proposal ID, Tenant ID, and Contract ID
        // PaymentScheduleRec.SetRange("Proposal ID", Rec."Proposal ID");
        PaymentScheduleRec.SetRange("Tenant ID", Rec."Tenant ID");
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");

        // Sort records by Due Date
        // Collect unique due dates
        if PaymentScheduleRec.FindSet() then
            repeat
                MinDueDate := PaymentScheduleRec."Due Date";
                if not DueDateList.Contains(MinDueDate) then
                    DueDateList.Add(MinDueDate);
            until PaymentScheduleRec.Next() = 0;

        // Sort the DueDateList
        while DueDateList.Count() > 0 do begin
            TempDate := DueDateList.Get(1); // Assume the first date is the smallest
            for i := 2 to DueDateList.Count() do begin
                if DueDateList.Get(i) < TempDate then
                    TempDate := DueDateList.Get(i); // Update if a smaller date is found
            end;
            SortedDueDateList.Add(TempDate); // Add the smallest date to the sorted list
            DueDateList.Remove(TempDate); // Remove the smallest date from the original list
        end;

        // Process each due date in the sorted order
        for i := 1 to SortedDueDateList.Count() do begin
            MinDueDate := SortedDueDateList.Get(i);


            // Generate unique Payment Series
            SequenceNo := GetNextSequenceNo();
            NewPaymentCode := GeneratePaymentCode(SequenceNo);

            // Process records for the current Due Date
            PaymentScheduleRec2.Reset();
            PaymentScheduleRec2.SetRange("Due Date", MinDueDate);

            //  PaymentScheduleRec2.SetRange("Proposal ID", Rec."Proposal ID");
            PaymentScheduleRec2.SetRange("Tenant ID", Rec."Tenant ID");
            PaymentScheduleRec2.SetRange("Contract ID", Rec."Contract ID");

            if PaymentScheduleRec2.FindSet() then begin
                // Modify existing records
                repeat
                    PaymentScheduleRec2."Payment Series" := NewPaymentCode;
                    PaymentScheduleRec2.Modify();
                until PaymentScheduleRec2.Next() = 0;
            end else begin
                // Insert a new record for the current Due Date
                PaymentScheduleRec2.Init();
                //  PaymentScheduleRec2."Proposal ID" := Rec."Proposal ID";
                PaymentScheduleRec2."Tenant ID" := Rec."Tenant ID";
                PaymentScheduleRec2."Contract ID" := Rec."Contract ID";
                PaymentScheduleRec2."Due Date" := DueDate;
                PaymentScheduleRec2."Payment Series" := NewPaymentCode;

                PaymentScheduleRec2.Insert();
                Clear(PaymentScheduleRec2);
            end

            // until PaymentScheduleRec.Next() = 0;
        end;

        Message('Process completed successfully.');
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

    local procedure GetNextSequenceNo(): Integer
    var
        MaxSequence: Integer;
        LastSequence: Text[10];
        PaymentScheduleRec: Record "Payment Schedule2";
    begin
        PaymentScheduleRec.Reset();
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
        //PaymentScheduleRec.SetRange("Proposal ID", Rec."Proposal ID");

        if PaymentScheduleRec.FindSet() then begin
            repeat
                // Extract the numeric part of the Payment Series
                LastSequence := CopyStr(PaymentScheduleRec."Payment Series", 4, StrLen(PaymentScheduleRec."Payment Series"));
                if Evaluate(MaxSequence, LastSequence) and (MaxSequence > MaxSequence) then
                    MaxSequence := MaxSequence;
            until PaymentScheduleRec.Next() = 0;
        end else
            MaxSequence := 0; // Default to 0 if no records are found

        exit(MaxSequence + 1);
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

        // Paymentschedulesubpage.SetRange("Proposal ID", Rec."Proposal ID");
        if Paymentschedulesubpage.FindSet() then
            Paymentschedulesubpage.DeleteAll();

    end;








}
