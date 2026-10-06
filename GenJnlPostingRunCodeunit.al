codeunit 57801 "BCB Gen. Jnl. Posting - Run"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        RunTest(Rec);
    end;

    procedure RunTest(GenJournalLine: Record "Gen. Journal Line")
    var
        JnlTemplateName: Code[10];
        JnlBatchName: Code[10];
    begin
        JnlTemplateName := GenJournalLine."Journal Template Name";
        JnlBatchName := GenJournalLine."Journal Batch Name";
    
        if (JnlTemplateName = '') or (JnlBatchName = '') then begin
            JnlTemplateName := TestDataGenerator.GetGeneralJournalTemplateName();
            JnlBatchName := TestDataGenerator.GetGeneralJournalBatchName();
        end;

        PostGenJournalBatch(JnlTemplateName, JnlBatchName);
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
