codeunit 57805 "BCB Item Jnl. Posting - Run"
{
    TableNo = "Item Journal Line";

    trigger OnRun()
    begin
        RunTest(Rec);
    end;

    procedure RunTest(ItemJournalLine: Record "Item Journal Line")
    var
        JnlTemplateName: Code[10];
        JnlBatchName: Code[10];
    begin
        JnlTemplateName := ItemJournalLine."Journal Template Name";
        JnlBatchName := ItemJournalLine."Journal Batch Name";
    
        if (JnlTemplateName = '') or (JnlBatchName = '') then begin
            JnlTemplateName := TestDataGenerator.GetGeneralJournalTemplateName();
            JnlBatchName := TestDataGenerator.GetGeneralJournalBatchName();
        end;

        PostItemJournalBatch(JnlTemplateName, JnlBatchName);
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
