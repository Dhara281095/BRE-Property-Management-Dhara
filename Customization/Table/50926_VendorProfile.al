table 50926 "Vendor Profile"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Vendor ID";
    fields
    {
        field(50100; "Vendor ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor ID';
            TableRelation = Vendor."No.";
        }

        field(50101; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name';
        }
        field(50102; "Vendor Contact No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Contact No.';
        }
        field(50103; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date';
        }
        field(50104; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }
        field(50146; "Vendor Category"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Category';
            TableRelation = "Vendor Category"."Vendor Category Type";
        }
        field(50105; "Calculation Method"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Calculation Method';
            OptionMembers = " ","Percentage Method","Fixed Amount";
        }

        field(50106; "Percentage Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Percentage Type';
            OptionMembers = " ","Fixed","Variable";
        }
        field(50107; "Base Amount"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Base Amount';
            OptionMembers = " ","Revenue","Collection","Annual Rent","Monthly Rent";
        }
        field(50108; "Frequency Of Payment"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Frequency Of Payment';
            OptionMembers = " ","Monthly","Quaterly","Half Yearly","Yearly";
        }

        field(50109; "Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Status';
            OptionMembers = " ","Active","Terminate";
        }
        field(50110; "Contract Document Upload"; Text[2000])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Document Upload';
            InitValue = 'Contract Upload';
        }
        field(50111; "Blocked"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Blocked';
            OptionMembers = " ","Payment","All";
        }
        field(50112; "Balance (LCY)"; Decimal)
        {
            Caption = 'Balance (LCY)';
        }
        field(50113; "Balance Due (LCY) As Customer"; Decimal)
        {
            Caption = 'Balance Due (LCY) As Customer';
        }
        field(50114; "Balance Due (LCY)"; Decimal)
        {
            Caption = 'Balance Due (LCY)';
        }
        field(50115; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(50116; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(50117; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
        }
        field(50118; City; Text[30])
        {
            Caption = 'City';
        }
        field(50119; Country; Text[30])
        {
            Caption = 'Country';
        }
        field(50120; "Post Code"; Code[80])
        {
            Caption = 'Post Code';
        }
        field(50121; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(50122; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
        }
        field(50123; "E-Mail"; Text[80])
        {
            Caption = 'Email';
        }
        field(50124; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
        }
        field(50125; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
        }
        field(50126; "Primary Contact Code"; Code[80])
        {
            Caption = 'Primary Contact Code';
        }
        field(50127; "Contact"; Code[80])
        {
            Caption = 'Contact';
        }

        field(50128; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(50129; "Price Calculation Method"; Enum "Price Calculation Method")
        {
            Caption = 'Price Calculation Method';
        }
        field(50130; "Price Including VAT"; Boolean)
        {
            Caption = 'Price Including VAT';
        }

        field(50131; "Application Method"; Enum "Application Method")
        {
            DataClassification = ToBeClassified;
            Caption = 'Application Method';
        }
        field(50132; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
        }
        field(50133; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
        }
        field(50134; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(50135; "Block Payment Tolerance"; Boolean)
        {
            Caption = 'Block Payment Tolerance';
        }
        field(50136; "Preferred Bank Account Code"; Code[100])
        {
            Caption = 'Preferred Bank Account Code';
        }
        field(50137; "Partner Type"; Enum "Partner Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Partner Type';
        }
        field(50138; "Cash Flow Payment Terms Code"; Code[100])
        {
            Caption = 'Cash Flow Payment Terms Code';
        }
        field(50139; "Creditor No."; Code[100])
        {
            Caption = 'Creditor No.';
        }
        field(50140; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(50141; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
        }
        field(50142; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(50143; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
        }
        field(50144; "Over-Receipt Code"; Code[20])
        {
            Caption = 'Over-Receipt Code';
        }
        field(50145; "Receive E-Document To"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receive E-Document To';
            OptionMembers = " ","Purchase Order","Purchase Invoice";
        }

    }
    keys
    {
        key(PK; "Vendor ID", "Vendor Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Vendor ID", "Vendor Name")
        {

        }
    }

}
