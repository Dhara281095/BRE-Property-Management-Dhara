table 50924 "Payment Mode"
{
    DataClassification = ToBeClassified;


    fields
    {



        field(50103; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Schedule"."Contract ID";
            // AutoIncrement = true;
            Caption = 'Contract ID';
            trigger OnValidate()
            var
                leaserec: Record "Payment Schedule";
                payschedule: Record "Payment Schedule2";
            begin

                leaserec.SetRange("Contract ID", Rec."Contract ID");
                if leaserec.FindFirst() then begin
                    // "Proposal ID" := leaserec."Proposal ID";
                    "Tenant Id" := leaserec."Tenant Id";

                end else begin
                    // Clear the field if no record is found
                    // "Proposal Id" := '';
                    "Tenant Id" := '';
                end;
                EvaluatePaymentSchedule();
                GetNextSequenceNo();

            end;
        }


        // field(50102; "PS Id"; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     //AutoIncrement = true;
        //     Caption = 'PS Id';
        //     TableRelation = "Payment Schedule"."PS Id";

        //     trigger OnValidate()
        //     var
        //         payrec: Record "Payment Schedule";
        //     begin
        //         payrec.SetRange("PS ID", Rec."PS ID");
        //         if payrec.FindFirst() then begin
        //             "Proposal ID" := payrec."Proposal ID";
        //             "Tenant Id" := payrec."Tenant Id";

        //         end else begin
        //             // Clear the field if no record is found
        //             "Proposal ID" := 0;
        //             "Tenant Id" := '';
        //         end;


        //     end;

        // }


        // field(50100; "Proposal ID"; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     Editable = false;
        //     TableRelation = "Payment Schedule"."Proposal ID";

        //     // trigger OnValidate()
        //     // var
        //     //     payrec: Record "Payment Schedule";
        //     // begin
        //     //     payrec.SetRange("Proposal ID", Rec."Proposal ID");
        //     //     if payrec.FindFirst() then begin
        //     //         "Tenant Id" := payrec."Tenant Id";

        //     //     end else begin
        //     //         // Clear the field if no record is found
        //     //         "Tenant Id" := '';
        //     //     end;
        //     //     MergePaymentScheduleRecords();
        //     //     //GeneratePaymentCode();
        //     //     GetNextSequenceNo();

        //     // end;


        // }
        field(50101; "Tenant Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Id';
            TableRelation = "Payment Schedule"."Contract ID";
            Editable = false; // Make it read-only for the user

        }



    }

    keys
    {
        key(PK; "Contract ID")
        {
            Clustered = true;
        }


    }






    // procedure EvaluatePaymentSchedule()
    // var
    //     PaymentScheduleRec: Record "Payment Schedule2";
    //     PaymentScheduleRec2: Record "Payment Schedule2";
    //     MergedRecord: Record "Payment Mode2";
    //     TotalAmount: Decimal;
    //     TotalVAT: Decimal;
    //     GrandTotal: Decimal;
    //     NewPaymentCode: Code[20];
    //     SequenceNo: Integer;
    //     MinDueDate: Date;
    //     MaxDueDate: Date;
    //     DueDates: Text[100];
    //     IsValid: Boolean;
    //     DueDateList: List of [Date];  // List to store due dates
    //     i: Integer;  // Declare the variable 'i' for the loop
    // begin
    //     // Initialize totals
    //     TotalAmount := 0;
    //     TotalVAT := 0;
    //     GrandTotal := 0;

    //     // Filter by Proposal ID and Tenant ID
    //     PaymentScheduleRec.SetRange("Proposal ID", Rec."Proposal ID");
    //     PaymentScheduleRec.SetRange("Tenant ID", Rec."Tenant ID");
    //     PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
    //     // Debugging: Add message to check if records are being found
    //     if PaymentScheduleRec.FindSet() then

    //         // Start looping over the records
    //         repeat
    //             // Get the due date for the current record
    //             MinDueDate := PaymentScheduleRec."Due Date";

    //             // Store the due date in the list
    //             if not DueDateList.Contains(PaymentScheduleRec."Due Date") then begin
    //                 DueDateList.Add(MinDueDate);

    //                 //  Reset totals for the next group of records
    //                 TotalAmount := 0;
    //                 TotalVAT := 0;
    //                 GrandTotal := 0;

    //                 // Set the filter to process the records for this due date
    //                 PaymentScheduleRec2.SetRange("Due Date", MinDueDate);
    //                 PaymentScheduleRec2.SetRange("Proposal ID", Rec."Proposal ID");
    //                 PaymentScheduleRec2.SetRange("Tenant ID", Rec."Tenant ID");
    //                 PaymentScheduleRec2.SetRange("Contract ID", Rec."Contract ID");
    //                 if PaymentScheduleRec2.FindSet() then
    //                     // Loop through and calculate totals for the records with the same due date
    //                     repeat
    //                         TotalAmount += PaymentScheduleRec2."Amount";
    //                         TotalVAT += PaymentScheduleRec2."VAT Amount";
    //                         GrandTotal += PaymentScheduleRec2."Amount Including VAT";
    //                     until PaymentScheduleRec2.Next() = 0;

    //                 SequenceNo := GetNextSequenceNo();
    //                 NewPaymentCode := GeneratePaymentCode(SequenceNo);

    //                 // Insert a new merged record for the current due date
    //                 MergedRecord.Init();
    //                 MergedRecord."Proposal ID" := Rec."Proposal ID";
    //                 MergedRecord."Tenant ID" := Rec."Tenant ID";
    //                 MergedRecord."Contract ID" := Rec."Contract ID";
    //                 MergedRecord."Payment Series" := NewPaymentCode;
    //                 MergedRecord."Amount" := TotalAmount;
    //                 MergedRecord."VAT Amount" := TotalVAT;
    //                 MergedRecord."Amount Including VAT" := GrandTotal;
    //                 MergedRecord."Due Date" := MinDueDate; // Store only the current due date

    //                 // Debugging: Add message before inserting
    //                 Message('Inserting record with Payment Series: %1', NewPaymentCode);

    //                 MergedRecord.Insert();
    //                 Clear(MergedRecord);

    //                 // // Add debug messages to check totals
    //                 // Message('Due Date: %1, Total Amount: %2, Total VAT: %3, Grand Total: %4', MinDueDate, TotalAmount, TotalVAT, GrandTotal);
    //             end;



    //         // Process the next due date in the list (if more than 1)
    //         // if DueDateList.Count() > 0 then begin  // Modify this to just check if there are any dates
    //         //                                        // Loop through all due dates in the list
    //         //     for i := 1 to DueDateList.Count() do begin
    //         //         MinDueDate := DueDateList.Get(i);  // Correct method to access list item

    //         //         // Get the next sequence number and generate a new payment code (e.g., PAY01, PAY02)


    //         //         // Display message for inserted record
    //         //         Message('Record inserted for Proposal ID: %1, Due Date: %2, Payment Series: %3', Rec."Proposal ID", MinDueDate, NewPaymentCode);
    //         //     end;


    //         until PaymentScheduleRec.Next() = 0 // Move to the next record

    //     else
    //         Error('No records found for Proposal ID: %1, Tenant ID: %2', Rec."Proposal ID", Rec."Tenant ID");

    //     Message(Format(DueDateList));
    // end;




    procedure EvaluatePaymentSchedule()
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        PaymentScheduleRec2: Record "Payment Schedule2";
        MergedRecord: Record "Payment Mode2";
        TotalAmount: Decimal;
        TotalVAT: Decimal;
        GrandTotal: Decimal;
        NewPaymentCode: Code[20];
        SequenceNo: Integer;
        MinDueDate: Date;
        MaxDueDate: Date;
        DueDates: Text[100];
        IsValid: Boolean;
        DueDateList: List of [Date]; // List to store due dates
        i: Integer; // Declare the variable 'i' for the loop
        SortedDueDateList: List of [Date]; // List for sorted due dates
        TempDate: Date;
    begin
        // Initialize totals
        TotalAmount := 0;
        TotalVAT := 0;
        GrandTotal := 0;

        // Filter by Proposal ID and Tenant ID
        //PaymentScheduleRec.SetRange("Proposal ID", Rec."Proposal ID");
        PaymentScheduleRec.SetRange("Tenant ID", Rec."Tenant ID");
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");

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

            // Reset totals for the next group of records
            TotalAmount := 0;
            TotalVAT := 0;
            GrandTotal := 0;

            // Set the filter to process the records for this due date
            PaymentScheduleRec2.SetRange("Due Date", MinDueDate);
            // PaymentScheduleRec2.SetRange("Proposal ID", Rec."Proposal ID");
            PaymentScheduleRec2.SetRange("Tenant ID", Rec."Tenant ID");
            PaymentScheduleRec2.SetRange("Contract ID", Rec."Contract ID");

            if PaymentScheduleRec2.FindSet() then
                repeat
                    TotalAmount += PaymentScheduleRec2."Amount";
                    TotalVAT += PaymentScheduleRec2."VAT Amount";
                    GrandTotal += PaymentScheduleRec2."Amount Including VAT";
                until PaymentScheduleRec2.Next() = 0;

            SequenceNo := GetNextSequenceNo();
            NewPaymentCode := GeneratePaymentCode(SequenceNo);

            // Check for existing record
            MergedRecord.Reset();
            // MergedRecord.SetRange("Proposal ID", Rec."Proposal ID");
            MergedRecord.SetRange("Tenant ID", Rec."Tenant ID");
            MergedRecord.SetRange("Contract ID", Rec."Contract ID");
            MergedRecord.SetRange("Due Date", MinDueDate);

            if not MergedRecord.FindFirst() then begin
                // Insert a new merged record for the current due date
                MergedRecord.Init();
                // MergedRecord."Proposal ID" := Rec."Proposal ID";
                MergedRecord."Tenant ID" := Rec."Tenant ID";
                MergedRecord."Contract ID" := Rec."Contract ID";
                MergedRecord."Payment Series" := NewPaymentCode;
                MergedRecord."Amount" := TotalAmount;
                MergedRecord."VAT Amount" := TotalVAT;
                MergedRecord."Amount Including VAT" := GrandTotal;
                MergedRecord."Due Date" := MinDueDate;

                //Message('Inserting record with Payment Series: %1', NewPaymentCode);

                MergedRecord.Insert();
                Clear(MergedRecord);
            end //else
                // Message('Record for Due Date %1 already exists. Skipping.', MinDueDate);

        end;

        // Message('Process completed successfully.');
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
        MergedRecord: Record "Payment Mode2";
    begin
        MergedRecord.Reset();
        MergedRecord.SetRange("Contract ID", Rec."Contract ID");
        //MergedRecord.SetRange("Proposal ID", Rec."Proposal ID");

        if MergedRecord.FindSet() then begin
            repeat
                // Extract the numeric part of the Payment Series
                LastSequence := CopyStr(MergedRecord."Payment Series", 4, StrLen(MergedRecord."Payment Series"));
                if Evaluate(MaxSequence, LastSequence) and (MaxSequence > MaxSequence) then
                    MaxSequence := MaxSequence;
            until MergedRecord.Next() = 0;
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
        Paymentmodesubpage: Record "Payment Mode2";
    begin
        //  Paymentschedulesubpage.SetRange("PS ID", Rec."PS Id");
        Paymentmodesubpage.SetRange("Contract ID", Rec."Contract ID");
        // Paymentmodesubpage.SetRange("Proposal ID", Rec."Proposal ID");

        if Paymentmodesubpage.FindSet() then
            repeat
                Paymentmodesubpage.DeleteAll();
            until Paymentmodesubpage.Next() = 0;
    end;





}


