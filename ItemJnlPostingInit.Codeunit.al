codeunit 57804 "BCB Item Jnl. Posting - Init"
{
    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        TestDataGenerator.DeleteItemJournalLines();
        TestDataGenerator.SetDefaultInventorySetup();
        TestDataGenerator.CreateItemJnlDocNoSeriesIfNotExists();
        TestDataGenerator.CreateItemJournalLines(1000);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
