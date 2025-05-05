tableextension 50301 VendorExtention extends Vendor
{

    fields
    {

        field(50114; "Country"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country';
            TableRelation = Country."Country Code";
            trigger OnValidate()
            begin
                Emirate := '';
                "Community" := '';
            end;
        }
        field(50115; "Emirate"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Emirate';
            TableRelation = Emirate."Emirate Name"
                 where("Country Code" = field(Country));

            trigger OnValidate()
            begin
                "Community" := '';
            end;
        }
        field(50116; "Community"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Community';
            // Filter the Property Type values based on the selected Primary Classification
            TableRelation = Community."Community Name"
                 where("Emirate Name" = field(Emirate));

        }

    }


}
