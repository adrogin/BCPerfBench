codeunit 57817 "BCB Item Jnl. Parallel Test" implements "BCB Background Posting Test"
{
    procedure StartSessions(EntityCodes: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer): List of [Integer]
    begin
        exit(StartItemJnlPostingTasks(EntityCodes, TestCode, IterationNo));
    end;

    local procedure StartItemJnlPostingTasks(JnlBatchNames: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer): List of [Integer]
    var
        BatchNo: Integer;
        SessionIds: List of [Integer];
    begin
        for BatchNo := 1 to JnlBatchNames.Count do
            SessionIds.Add(StartItemJnlBackgroundPostingSession(JnlBatchNames.Get(BatchNo), TestCode, IterationNo, BatchNo));

        exit(SessionIds);
    end;

    local procedure StartItemJnlBackgroundPostingSession(ItemBatchName: Code[20]; TestCode: Code[20]; IterationNo: Integer; SessionNo: Integer): Integer
    var
        ItemJournalBatch: Record "Item Journal Batch";
        BackgroundPostingParam: Record "BCB Background Posting Params";
        TestDataGenerator: Codeunit "BCB Test Data Generator";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        SessionId: Integer;
    begin
        ItemJournalBatch.Get(TestDataGenerator.GetItemJournalTemplateName(), ItemBatchName);
        PerfBenchTests.InitializeSessionPostingEntityParam(BackgroundPostingParam, TestCode, IterationNo, SessionNo, ItemJournalBatch.RecordId);
        StartSession(SessionId, Codeunit::"BCB Item Jnl. Parallel Post", CompanyName, ItemJournalBatch);
        exit(SessionId);
    end;
}
