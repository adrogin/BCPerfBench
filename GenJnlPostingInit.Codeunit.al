codeunit 57800 "BCB Gen. Jnl. Posting - Init"
{
    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        DeleteJournalLines();
        CreateDocNoSeriesIfNotExists();
        TestDataGenerator.CreateGenJournalLines(1000);
    end;

    local procedure DeleteJournalLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", TestDataGenerator.GetGeneralJournalTemplateName());
        GenJournalLine.SetRange("Journal Batch Name", TestDataGenerator.GetGeneralJournalBatchName());
        GenJournalLine.DeleteAll();
    end;

    local procedure CreateDocNoSeriesIfNotExists()
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.SetRange(Code, TestDataGenerator.GetGenJnlDocNoSeriesCode());
        if NoSeries.IsEmpty() then
            TestDataGenerator.CreateGenJnlDocNoSeries();
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
