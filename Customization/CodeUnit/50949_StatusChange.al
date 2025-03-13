// codeunit 50949 "Daily Job Queue"
// {
//     // procedure UpdateStatusForDueDate(var SubGridRec: Record "Payment Mode2")

//     // begin

//     //     if SubGridRec.FindSet() then begin
//     //         repeat
//     //             if SubGridRec."Due Date" = Today() then begin
//     //                 SubGridRec."Payment Status" := SubGridRec."Payment Status"::"Due";
//     //             end
//     //             else if SubGridRec."Due Date" < Today() then begin
//     //                 SubGridRec."Payment Status" := SubGridRec."Payment Status"::"Overdue";
//     //             end;

//     //             SubGridRec.Modify();
//     //         until SubGridRec.Next() = 0;
//     //     end;
//     // end;

//     procedure UpdateStatusForDueDate(var SubGridRec: Record "Payment Mode2")
//     begin
//         if SubGridRec.FindSet() then begin
//             repeat
//                 // Check if the current status is not manually set to "Cancelled", "Received", or any other status
//                 if (SubGridRec."Payment Status" = SubGridRec."Payment Status"::"Due") or
//                    (SubGridRec."Payment Status" = SubGridRec."Payment Status"::"Overdue") then begin

//                     if SubGridRec."Due Date" = Today() then begin
//                         SubGridRec."Payment Status" := SubGridRec."Payment Status"::"Due";
//                     end
//                     else if SubGridRec."Due Date" < Today() then begin
//                         SubGridRec."Payment Status" := SubGridRec."Payment Status"::"Overdue";
//                     end;

//                     SubGridRec.Modify();
//                 end;
//             until SubGridRec.Next() = 0;
//         end;
//     end;


// }
