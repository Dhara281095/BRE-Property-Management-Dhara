page 50337 "Security Deposit Card"
{
    PageType = Card;
    SourceTable = "Security Deposit";
    ApplicationArea = All;
    Caption = 'Security Deposit Transfer';

    layout
    {
        area(content)
        {
            group("Carry Forward From")
            {
                field("Security Deposit ID"; rec."Security Deposit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tenant Full Name"; rec."Tenant Full Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                }


                field("Contract ID"; rec."Contract ID")
                {
                    ApplicationArea = All;
                }


                field("Contract Start Date"; rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract End Date"; rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Security Deposit Amount"; rec."Security Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Balance Amount"; rec."Balance Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


            }

            group("Carry Forward To")
            {

                field("New_Contract ID"; rec."New_Contract ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                }

                field("New_Tenant Full Name"; rec."New_Tenant Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }



                field("New_Contract Start Date"; rec."New_Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Contract Start Date';

                }

                field("New_Contract End Date"; rec."New_Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Contract End Date';
                }

                field("New_Security Deposit Amount"; rec."New_Security Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = true;


                }
                field("New Security Amount"; rec."New Security Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("New_Balance Amount"; rec."New_Balance Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Adjusted amount"; rec."Adjusted amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Narration"; rec."Narration")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                }
            }
        }
    }


    // actions
    // {
    //     area(processing)
    //     {
    //         action(Save)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Save';
    //             trigger OnAction()
    //             begin
    //                 // Save logic, if needed
    //             end;
    //         }
    //     }
    // }



}

