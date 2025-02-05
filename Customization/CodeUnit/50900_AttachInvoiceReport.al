// codeunit 50900 "Attach Invoice Report"
// {


//     procedure AttachInvoiceReport(Rec: Record "Sales Header")
//     var

//         TempBlob: Codeunit "Temp Blob";
//         OutStream: OutStream;
//         InStream: InStream;
//         FileName: Text;
//         FileExtension: Text;
//         DocumentAttachment: Record "Document Attachment";
//         ReportID: Integer; // Your report ID
//         RecRef: RecordRef;
//         FieldRef: FieldRef;
//         MIMEType: Text[250];
//         SystemIdFieldNo: Integer;
//     begin
//         FileExtension := '.pdf';
//         ReportID := 50104;
//         RecRef.Open(DATABASE::"Sales Header"); // Open the table reference
//         RecRef.GetTable(Rec);
//         TempBlob.CreateOutStream(OutStream);
//         Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

//         TempBlob.CreateInStream(InStream);
//         FileName := 'Invoice_' + Rec."No." + FileExtension;
//         MIMEType := GetMimeTypeFromFileName(FileName);
//         SystemIdFieldNo := RecRef.SystemIdNo();
//         FieldRef := RecRef.Field(SystemIdFieldNo);
//         DocumentAttachment.Init();
//         DocumentAttachment.SaveAttachmentFromStream(InStream, RecRef, FileName);
//         DocumentAttachment."Record Id" := FieldRef.Value;
//         DocumentAttachment."Table ID" := DATABASE::"Sales Header"; // Set to your table ID, for Sales Header
//         DocumentAttachment."No." := Rec."No.";
//         DocumentAttachment."Document Type" := DocumentAttachment."Document Type"::Invoice;
//         DocumentAttachment."File Name" := FileName;
//         DocumentAttachment."DocumentMedia".ImportStream(InStream, FileName);
//         DocumentAttachment."Document BLOB".CreateInStream(InStream);
//         DocumentAttachment."MIME Type" := MIMEType;
//         DocumentAttachment.Modify();

//     end;

//     procedure GetMimeTypeFromFileName(FileName: Text): Text
//     var
//         FileExtension: Text;
//     begin
//         // Extract the file extension from the file name
//         FileExtension := LowerCase(CopyStr(FileName, StrPos(FileName, '.'), StrLen(FileName) - StrPos(FileName, '.') + 1));

//         case FileExtension of
//             '.pdf':
//                 exit('application/pdf');
//             '.jpg', '.jpeg':
//                 exit('image/jpeg');
//             '.png':
//                 exit('image/png');
//             '.gif':
//                 exit('image/gif');
//             '.txt':
//                 exit('text/plain');
//             '.doc', '.docx':
//                 exit('application/msword');
//             '.xls', '.xlsx':
//                 exit('application/vnd.ms-excel');
//             '.ppt', '.pptx':
//                 exit('application/vnd.ms-powerpoint');
//             '.zip':
//                 exit('application/zip');
//             '.rar':
//                 exit('application/x-rar-compressed');
//             '.csv':
//                 exit('text/csv');
//             '.json':
//                 exit('application/json');
//             '.xml':
//                 exit('application/xml');
//             '.html', '.htm':
//                 exit('text/html');
//             '.mp4':
//                 exit('video/mp4');
//             '.mp3':
//                 exit('audio/mpeg');
//             '.wav':
//                 exit('audio/wav');
//             '.avi':
//                 exit('video/x-msvideo');
//             '.exe':
//                 exit('application/x-msdownload');
//             else
//                 exit('application/octet-stream'); // Default MIME type for unknown files
//         end;
//     end;

// }
