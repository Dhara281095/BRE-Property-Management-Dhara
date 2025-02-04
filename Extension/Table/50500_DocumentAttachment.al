tableextension 50500 MyDocumentAttachment extends "Document Attachment"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Field No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Record Id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        // field(50102; "Field Name"; Text[100])
        // {
        //     DataClassification = ToBeClassified;
        // }
        field(50103; "Table Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(50104; "Upload Document Type"; Text[100])
        {
            DataClassification = ToBeClassified;

        }

        field(50105; "Document Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50106; "Document File"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50107; "Upload Document"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50108; "Document BLOB"; Blob)
        {
            DataClassification = ToBeClassified;
        }

        field(50109; "DocumentMedia"; MediaSet)
        {
            DataClassification = ToBeClassified;
        }

        field(50110; "MIME Type"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }


    // trigger OnBeforeDelete()
    // var
    //     RecordRef: RecordRef;
    //     FieldRef: FieldRef;
    // begin
    //     RecordRef.Open("Table ID");
    //     RecordRef.GetBySystemId("Record Id");

    //     FieldRef := RecordRef.Field("Field No.");
    //     FieldRef.Value := '';
    //     RecordRef.Modify();
    // end;


    var
        myInt: Integer;
}