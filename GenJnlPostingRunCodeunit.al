codeunit 57801 "BCB Gen. Jnl. Posting - Run"
{
    trigger OnRun()
    begin
        RunTest();
    end;

    procedure RunTest()
    begin
        PostGenJournalBatch(TestDataGenerator.GetGeneralJournalTemplateName(), TestDataGenerator.GetGeneralJournalBatchName());
    end;

    procedure PostGenJournalBatch(TemplateName: Code[10]; BatchName: Code[10])
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJournalLine.SetRange("Journal Template Name", TemplateName);
        GenJournalLine.SetRange("Journal Batch Name", BatchName);
        GenJournalLine.FindFirst();
        GenJnlPostBatch.Run(GenJournalLine);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
