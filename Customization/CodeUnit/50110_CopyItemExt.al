codeunit 50110 "Copy Item Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Item", OnAfterCopyItem, '', false, false)]
    local procedure OnAfterCopyItem(var TargetItem: Record Item)
    var
        unitpage: Page "Item Card";
        NoSeriesManagement: Codeunit "No. Series";
        NewNo: Code[20];
        NewUnitNo: Code[20];
        unitcard: Record Item;
        item: Record Item;
    begin
        NewUnitNo := NoSeriesManagement.GetNextNo('UNITNO', 0D, true);
        TargetItem.FixedNumber := NewUnitNo;
        TargetItem.Modify();

        unitpage.AutoGenerateUnitName(TargetItem);
    end;
}