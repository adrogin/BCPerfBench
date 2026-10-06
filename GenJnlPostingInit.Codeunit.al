codeunit 57800 "BCB Gen. Jnl. Posting - Init"
{
    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        TestDataGenerator.DeleteGenJournalLines();
        TestDataGenerator.CreateGenJnlDocNoSeriesIfNotExists();
        TestDataGenerator.CreateGenJournalLines(1000);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
