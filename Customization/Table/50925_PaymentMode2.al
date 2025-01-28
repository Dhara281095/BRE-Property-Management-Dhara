table 50925 "Payment Mode2"
{
    DataClassification = ToBeClassified;

    fields
    {

        field(50100; "Payment Series"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Series';

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

        field(50104; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date';



            // trigger OnValidate()
            // begin
            //     if Rec."Due Date" <> xRec."Due Date" then begin
            //         if Rec."Due Date" = Today() then
            //             Rec."Payment Status" := Rec."Payment Status"::"Due"
            //         else if Rec."Due Date" < Today() then
            //             Rec."Payment Status" := Rec."Payment Status"::"Overdue"
            //         else
            //             Rec."Payment Status" := Rec."Payment Status";

            //         Modify();
            //     end;
            // end;


            // trigger OnValidate()
            // begin
            //     // Check if the Due Date matches today's date
            //     if Rec."Due Date" = Today() then begin
            //         Rec."Payment Status" := Rec."Payment Status"::"Due"; // Update Payment Status to "Due"
            //                                                              //  else 
            //                                                              //     // Reset the Payment Status if Due Date does not match
            //                                                              //     Rec."Payment Status" := Rec."Payment Status"::" "; // Or any default status
            //     end;

            //     // // Ensure the changes are saved

            //     if Rec."Due Date" <= Today() then begin
            //         if Rec."Due Date" = Today() then
            //             Rec."Payment Status" := Rec."Payment Status"::"Due" // Update Payment Status to "Due"
            //         else
            //             Rec."Payment Status" := Rec."Payment Status"::"Overdue"; // Update Payment Status to "Overdue"
            //     end;
            //     Modify();
            // end;

        }



        field(50105; "Payment Mode"; Text[100])
        {
            Caption = 'Payment Mode';
            TableRelation = "Payment Type"."Payment Method";
        }

        field(50106; "Cheque Number"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cheque Number';
        }

        field(50107; "Deposit Bank"; Code[100])
        {
            Caption = 'Deposit Bank';
            TableRelation = "Bank Account"."No.";
        }

        field(50108; "Deposit Status"; Option)
        {
            OptionMembers = "-","N","Y";
            Caption = 'Deposit Status';
        }

        field(50112; "Payment Status"; Enum "Payment Status")
        {
            //OptionMembers = "Scheduled","Due","Received","Overdue","Cancelled";
            Caption = 'Payment Status';
        }

        field(50113; "Cheque Status"; Enum "PDC Status Type Enum")
        {
            // OptionMembers = "-","Cheque Received","Cleared","Deposited","Due & cheque not deposited","Retrieved","Returned","Replaced & Received","Deferred";
            Caption = 'Cheque Status';


            trigger OnValidate()
            begin
                if (Rec."Cheque Status" in [Rec."Cheque Status"::Cleared, Rec."Cheque Status"::Deposited, Rec."Cheque Status"::Returned]) then
                    Rec."Deposit Status" := Rec."Deposit Status"::"Y"
                else
                    Rec."Deposit Status" := Rec."Deposit Status"::"N";


                // Update Payment Status based on Cheque Status
                if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) then
                    Rec."Payment Status" := Rec."Payment Status"::"Received";

            end;

        }

        field(50114; "Invoice #"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice #';
        }

        field(50115; "Receipt #"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Receipt #';
        }

        field(50116; "Old Cheque #"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Old Cheque #';
        }

        field(50117; "Upload Cheque"; Text[2048])
        {
            DataClassification = ToBeClassified;
            Caption = 'Upload Cheque';
            InitValue = 'Upload Cheque';
        }


        field(50118; "Download"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Download';
            InitValue = 'Download';
        }

        field(50120; "View"; Text[2048])
        {
            DataClassification = ToBeClassified;
            Caption = 'View';
            InitValue = 'View';
        }

        field(50119; "View Revenue Details"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'View Revenue Details';
            InitValue = 'View Revenue Details';
        }
        field(50121; "View Document URL"; Text[2048])
        {
            DataClassification = ToBeClassified;
            Caption = 'View Document URL';
        }


        field(50123; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Mode2".Amount where("Contract ID" = field("Contract ID"), "Tenant ID" = field("Tenant ID")));
        }

        field(50912; "Total VAT Amount"; Decimal)
        {
            Caption = 'Total VAT Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Mode2"."VAT Amount" where("Contract ID" = field("Contract ID"), "Tenant ID" = field("Tenant ID")));
        }
        field(50913; "Total Amount Including VAT"; Decimal)
        {
            Caption = 'Total Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Mode2"."Amount Including VAT" where("Contract ID" = field("Contract ID"), "Tenant ID" = field("Tenant ID")));
        }

        field(50110; "Tenant Id"; Code[20])
        {
            Caption = 'Tenant Id';
        }
        field(50111; "Contract ID"; Integer)
        {
            Caption = 'Contract ID';
        }

        field(50122; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(50124; "Id"; Integer)
        {
            DataClassification = ToBeClassified;
        }


    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }



    // procedure UpdateStatusForDueDate()
    // var
    //     SubGridRec: Record "Payment Mode2"; // Replace "Payment" with the actual subgrid table
    // begin
    //     // Filter the subgrid records to match today's date
    //     if SubGridRec.FindSet() then begin
    //         repeat
    //             if SubGridRec."Due Date" = Today() then begin
    //                 // Update the status to "Due"
    //                 SubGridRec."Payment Status" := SubGridRec."Payment Status"::"Due";
    //                 SubGridRec.Modify();
    //             end;
    //         until SubGridRec.Next() = 0;
    //     end;
    // end;



    // trigger OnAfterValidate()
    // begin
    //     if Rec."Due Date" = Today() then begin
    //         Rec."Payment Status" := Rec."Payment Status"::"Due";
    //         Modify();
    //     end;
    // end;


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;





}
