table 50954 "Credit Note"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50100; "ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ID';
            Editable = false;
        }
        field(50101; "Contract ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract ID';
        }
        field(50102; "Tenant ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant ID';
        }

        field(50103; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Start Date';
        }

        field(50104; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract End Date';
        }

        field(50105; "Unit Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Type';
        }

        field(50106; "Contract Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Amount';

        }
        field(50107; "Tenant Email"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Email';
        }
        field(50116; "Tenant Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tenant Name';
        }
        field(50117; "Credit Note Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Credit Note Type';
            OptionMembers = "Termination Credit Note";
        }
        // field(50118; "TerminationCreditNoteType"; Option)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Credit Note Type';
        //     OptionMembers = "Termination Credit Note";
        // }
        // field(50119; "Invoice ID"; Integer)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Invoice ID';
        // }
        field(50121; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
            OptionMembers = "Pending","Approved","Reject";
        }

        field(50124; "FC ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'FC ID';
        }
        field(50125; "Reason for Rejection"; Text[250])
        {
            Caption = 'Reason for Rejection';
        }
        field(50126; "Credit Note No."; Code[20])
        {
            Caption = 'Credit Note No.';
            Editable = false;

        }
        field(50135; "Credit Note Document"; Text[1000])
        {
            DataClassification = ToBeClassified;
            Caption = 'Credit Note Document';
            InitValue = 'Credit Note Document';
        }
        field(50136; "Credit Note URL"; Text[1000])
        {
            DataClassification = ToBeClassified;
            Caption = 'Credit Note View';
            InitValue = 'Credit Note View';
        }

    }


    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
    }

    // trigger OnInsert()
    // var
    //     NextID: Integer;
    //     MyRec: Record "Credit Note";
    // begin
    //     if ID = 0 then begin
    //         // Get the next available numeric ID manually
    //         if MyRec.FindLast() then
    //             NextID := MyRec.ID + 1
    //         else
    //             NextID := 1;

    //         ID := NextID; // Integer field
    //         "Credit Note No." := 'CN_' + CopyStr('00000' + Format(NextID), StrLen('00000' + Format(NextID)) - 4, 5);
    //     end;
    // end;

}
