codeunit 57817 "BCB Item Jnl. Parallel Test" implements "BCB Background Posting Test"
{
    procedure Initialize(var JnlBatchNames: List of [Code[20]]; NoOfSessions: Integer; LinesPerSession: Integer)
    var
        Item: Record Item;
        ItemsInBatch: Integer;
        I: Integer;
        JnlBatchName: Code[10];
    begin
        TestDataGenerator.CreateItemJnlDocNoSeriesIfNotExists();
        ItemsInBatch := Round(Item.Count() / NoOfSessions, 1, '<');

        for I := 1 to NoOfSessions do begin
            JnlBatchName := 'BGPOST' + Format(I).PadLeft(4, '0');
            TestDataGenerator.DeleteItemJournalLines(JnlBatchName);
            TestDataGenerator.CreateItemJournalLines(LinesPerSession, JnlBatchName, (I - 1) * ItemsInBatch + 1, I * ItemsInBatch);
            JnlBatchNames.Add(JnlBatchName);
        end;
    end;

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
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        SessionId: Integer;
    begin
        ItemJournalBatch.Get(TestDataGenerator.GetItemJournalTemplateName(), ItemBatchName);
        PerfBenchTests.InitializeSessionPostingEntityParam(BackgroundPostingParam, TestCode, IterationNo, SessionNo, ItemJournalBatch.RecordId);
        StartSession(SessionId, Codeunit::"BCB Item Jnl. Parallel Post", CompanyName, BackgroundPostingParam);
        exit(SessionId);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
