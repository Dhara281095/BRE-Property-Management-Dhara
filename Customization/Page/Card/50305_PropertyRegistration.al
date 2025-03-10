page 50305 "Property Registration Card"
{
    PageType = Card;
    SourceTable = "Property Registration";
    ApplicationArea = All;
    Caption = 'Property Registration';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Property Details';


                field("Property ID"; rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field("Company ID"; rec."Company ID")
                {
                    ApplicationArea = All;
                    Visible = false;

                    // trigger OnValidate()
                    // begin
                    //     workflowfrequency();
                    // end;
                }

                field("Description"; rec."Description")
                {
                    ApplicationArea = All;
                }

                field("Property Name"; rec."Property Name")
                {
                    ApplicationArea = All;
                }

                // field("Blocked"; rec."Blocked")
                // {
                //     ApplicationArea = All;
                // }

                // field("Type"; rec."Type")
                // {
                //     ApplicationArea = All;
                // }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Property Size"; rec."Property Size")
                {
                    ApplicationArea = All;
                    Caption = 'Property Size';
                    Editable = true;
                }

                field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                }

                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                }
                field("Built-up Area"; Rec."Built-up Area")
                {
                    ApplicationArea = All;
                }
                field("Makani Number"; Rec."Makani Number")
                {
                    ApplicationArea = All;
                }
                field("Municipality Number"; Rec."Municipality Number")
                {
                    ApplicationArea = All;
                }
                field("DEWA Number"; Rec."DEWA Number")
                {
                    ApplicationArea = All;
                }
                field("Number of Floors"; Rec."Number of Floors")
                {
                    ApplicationArea = All;
                }
                field("Number of Lifts"; Rec."Number of Lifts")
                {
                    ApplicationArea = All;
                }

            }



            group("Additional Details")
            {
                Caption = 'Additional Information';

                // field("Status"; rec."Status")
                // {
                //     ApplicationArea = All;
                // }

                field("Emirate"; rec.Emirate)
                {
                    ApplicationArea = All;
                    Lookup = true;
                }
                field("Community"; rec."Community")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Number of Units"; rec."Number of Units")
                {
                    ApplicationArea = All;
                }

                field("Property Classification"; rec."Property Classification")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Property Type"; rec."Property Type")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }

                field("Registration Date"; rec."Registration Date")
                {
                    ApplicationArea = All;
                }

                field("GTIN"; rec."GTIN")
                {
                    ApplicationArea = All;
                }

                field("Owner ID"; rec."Owner ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                }
            }
            group(Documents)
            {

                // Add the Document Attachment Subpage here
                part("Document Attachments"; "Property Registration SubPage")
                {
                    SubPageLink = PropertyID = FIELD("Property ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = isVisible;
                }
            }

            group("WorkflowFrequencys")
            {
                part("Workflow Frequency"; "Workflow Frequency PR Card")
                {
                    SubPageLink = "Company ID" = FIELD("Company ID"),
                    "Property ID" = FIELD("Property ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

        }


    }



    var
        isVisible: Boolean;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."Property ID");
        workflowfrequency();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."Property ID");
        isVisible := true;

        workflowfrequency();
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."Property ID");

        if Rec."Property ID" <> '' then begin
            isVisible := true;
        end
        else begin
            isVisible := false;
        end;
        workflowfrequency();

    end;

    procedure workflowfrequency()
    var
        workflowfrequency: Record "Workflow Frequency";
        workflowfrequencyPR: Record "Workflow Frequency PR";
    begin
        workflowfrequencyPR.SetRange("Property ID", Rec."Property ID");
        workflowfrequencyPR.SetRange("Company ID", Rec."Company ID");

        if workflowfrequencyPR.FindSet() then begin
            workflowfrequencyPR.DeleteAll();
        end;

        if workflowfrequency.FindSet() then
            repeat
                workflowfrequencyPR.Init();
                // PaymentSchedule3."PS ID" := Rec."PS Id";
                workflowfrequencyPR."Property ID" := Rec."Property ID";
                workflowfrequencyPR."Company ID" := workflowfrequency."Company ID";
                workflowfrequencyPR.Workflow := workflowfrequency.Workflow;
                workflowfrequencyPR."frequncy Status" := workflowfrequency."frequncy Status";
                workflowfrequencyPR."No. of Days" := workflowfrequency."No. of Days";
                workflowfrequencyPR.Insert();
                Clear(workflowfrequencyPR);
            until workflowfrequency.Next() = 0;


    end;

}

