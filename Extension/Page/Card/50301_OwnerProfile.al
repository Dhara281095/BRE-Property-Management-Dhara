pageextension 50100 OwnerProfileCardExt extends "Owner Profile Card"
{

    layout
    {
        modify("Banking Information")
        {
            Visible = ShowBankingInfo;
        }

        modify("TRN")
        {
            Visible = ShowBankingInfo;
        }


        modify("Document Attachments")
        {
            Visible = ShowOwnerDocs;
        }

    }


    trigger OnOpenPage()
    begin
        ShowBankingInfo := not (IsUserInProfile('LEASE_MANAGER') or IsUserInProfile('PROPERTY MANAGER'));
        ShowOwnerDocs := not IsUserInProfile('LEASE_MANAGER');
    end;

    var
        ShowBankingInfo: Boolean;
        ShowOwnerDocs: Boolean;

    local procedure IsUserInProfile(ProfileID: Code[20]): Boolean
    var
        AccessControl: Record "User Personalization";
    begin
        AccessControl.SetRange("User ID", UserId());
        AccessControl.SetRange("Profile ID", ProfileID);
        exit(AccessControl.FindFirst());
    end;
}



// pageextension 50301 _OwnerProfileCardExt extends "Owner Profile Card"
// {
//     layout
//     {
//         modify("Bank Account Number")
//         {
//             Visible = ShowBankingInfo;
//         }
//         modify("IBAN")
//         {
//             Visible = ShowBankingInfo;
//         }
//         modify("Bank Name")
//         {
//             Visible = ShowBankingInfo;
//         }
//         modify("SWIFT/IFSC Code")
//         {
//             Visible = ShowBankingInfo;
//         }
//     }

//     trigger OnOpenPage()
//     begin
//         ShowBankingInfo := not (IsUserInRole('LEASE MANAGER') or IsUserInRole('PROPERTY MANAGER'));
//     end;

//     var
//         ShowBankingInfo: Boolean;

//     local procedure IsUserInRole(RoleID: Code[20]): Boolean
//     var
//         AccessControl: Record "Access Control";
//     begin
//         AccessControl.SetRange("User Security ID", UserSecurityId());
//         AccessControl.SetRange("Role ID", RoleID);
//         exit(AccessControl.FindFirst());
//     end;
// }
