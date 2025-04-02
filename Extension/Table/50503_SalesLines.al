tableextension 50503 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50101; "Contract ID"; Integer)
        {
            Caption = 'Contract ID';
        }
        field(50102; "FC ID"; Integer)
        {
            Caption = 'FC ID';
            DataClassification = ToBeClassified;

        }
    }

}