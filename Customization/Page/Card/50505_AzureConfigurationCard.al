page 50505 "Azure Configuration"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = AzureConfiguration;
    Caption = 'Azure Configuration Card';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General Information';
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SAS URL"; Rec."SAS URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the SAS URL here.';
                    Editable = true;
                    trigger OnValidate()
                    var
                        IsValid: Boolean;
                    begin
                        IsValid := ValidateURL(Rec."SAS URL");
                        if not IsValid then
                            Error('The entered URL is not valid. Ensure it starts with "https://" and is a properly formatted URL.');
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Save)
            {
                Caption = 'Save SAS URL';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Commit();
                    Message('SAS URL saved successfully.');
                end;
            }


        }
    }

    procedure ValidateURL(URL: Text[2048]): Boolean
    var
        HttpPrefix: Text[8];
        HttpsPrefix: Text[9];
        Position: Integer;
    begin
        HttpPrefix := 'http://';
        HttpsPrefix := 'https://';

        // Check for "http://" or "https://"
        if (CopyStr(URL, 1, StrLen(HttpPrefix)) <> HttpPrefix) and
           (CopyStr(URL, 1, StrLen(HttpsPrefix)) <> HttpsPrefix) then
            exit(false);

        // Check if there's a '.' after the protocol
        Position := StrPos(CopyStr(URL, StrLen(HttpsPrefix) + 1), '.');
        if Position = 0 then
            exit(false);

        exit(true);
    end;

    trigger OnOpenPage()
    var
        AzureConfig: Record AzureConfiguration;
    begin
        // Redirect to the existing record if one exists
        if AzureConfig.FindFirst() then
            CurrPage.SetRecord(AzureConfig);
    end;

    var
        myInt: Integer;
}