codeunit 57805 "BCB Item Jnl. Posting - Run"
{
    trigger OnRun()
    begin
        RunTest();
    end;

    procedure RunTest()
    begin
        PostItemJournalBatch(TestDataGenerator.GetItemJournalTemplateName(), TestDataGenerator.GetItemJournalBatchName());
    end;

    procedure PostItemJournalBatch(TemplateName: Code[10]; BatchName: Code[10])
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        ItemJournalLine.SetRange("Journal Template Name", TemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", BatchName);
        ItemJournalLine.FindFirst();
        ItemJnlPostBatch.Run(ItemJournalLine);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
