enum 50508 "Termination Type Enum"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Early")
    {
        Caption = 'Early';
    }
    value(2; Standard)
    {
        Caption = 'Standard';
    }
    value(3; Suspension)
    {
        Caption = 'Suspension';
    }
}

enum 50509 "Penalty Type Enum"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Fixed")
    {
        Caption = 'Fixed';
    }
    value(2; "Percentage")
    {
        Caption = 'Percentage';
    }

}

enum 50510 "Penalty Status Enum"
{
    Extensible = true;
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Pending")
    {
        Caption = 'Pending';
    }
    value(2; "Applied")
    {
        Caption = 'Applied';
    }
    value(3; "Waived")
    {
        Caption = 'Waived';
    }

}