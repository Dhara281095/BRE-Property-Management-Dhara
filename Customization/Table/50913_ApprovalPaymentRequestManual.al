// table 50913 "ManualApprovalPaymentRequest"
// {
//     DataClassification = ToBeClassified;
//     DataCaptionFields = "ID";

//     fields
//     {
//         field(50101; "ID"; Integer)
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'ID';
//             Editable = false;
//             AutoIncrement = true;

//         }
//         field(50102; "Approval Status"; Text[100])
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'Status';
//         }
//         field(50108; "Request Type"; Text[50])
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'Request Type';
//         }

//         field(50107; "Tenant ID"; Text[50])
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'Tenant ID';
//         }
//         field(50104; "Contract ID"; Integer)
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'Contract ID';
//         }

//         field(50114; "New Amount"; Decimal)
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'New Amount';
//         }
//         field(50115; "New VAT Amount"; Decimal)
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'New Vat Amount';
//         }

//         field(50109; "Change Amount Including VAT"; Decimal)
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'New Amount Including VAT';
//         }

//         field(50113; "Payment mode"; Text[300])
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'Payment mode';
//         }


//         field(50117; "Due Date"; Date)
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'New Due Date';
//         }

//         field(50111; "Payment Series"; Text[200])
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'Payment Series';
//         }
//         Field(50110; "Description"; Text[500])
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'Description';
//             Editable = true;
//         }

//         field(50118; "Items"; Text[500])
//         {
//             DataClassification = ToBeClassified;
//             Caption = 'Items';
//         }
//     }

//     keys
//     {
//         key(PK; "ID")
//         {
//             Clustered = false;
//         }
//     }


//     // trigger OnModify()
//     // var
//     //     emailrec: Codeunit "Send Change Payment Request";
//     // begin

//     //     if Rec."Approval Status" = 'Approve' then
//     //         emailrec.SendEmail(Rec)
//     //     // else if Rec."Payment Status" = Rec."Payment Status"::Cancelled then
//     //     //     emailrec.SendEmailCancelled(Rec)
//     //     // else if Rec."Payment Status" = Rec."Payment Status"::Overdue then
//     //     //     emailrec.SendEmailOverdue(Rec);
//     // end;
// }

