codeunit 57804 "BCB Item Jnl. Posting - Init"
{
    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        DeleteJournalLines();
        CreateDocNoSeriesIfNotExists();
        TestDataGenerator.CreateItemJournalLines(1000);
    end;

    local procedure DeleteJournalLines()
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.SetRange("Journal Template Name", TestDataGenerator.GetItemJournalTemplateName());
        ItemJournalLine.SetRange("Journal Batch Name", TestDataGenerator.GetItemJournalBatchName());
        ItemJournalLine.DeleteAll();
    end;

    local procedure CreateDocNoSeriesIfNotExists()
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.SetRange(Code, TestDataGenerator.GetItemJnlDocNoSeriesCode());
        if NoSeries.IsEmpty() then
            TestDataGenerator.CreateItemJnlDocNoSeries();
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
