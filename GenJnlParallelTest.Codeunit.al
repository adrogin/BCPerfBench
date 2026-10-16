codeunit 57816 "BCB Gen. Jnl. Parallel Test" implements "BCB Background Posting Test"
{
    procedure Initialize(var JnlBatchNames: List of [Code[20]]; NoOfSessions: Integer; LinesPerSession: Integer)
    var
        I: Integer;
        JnlBatchName: Code[10];
    begin
        TestDataGenerator.CreateGenJnlDocNoSeriesIfNotExists();

        for I := 1 to NoOfSessions do begin
            JnlBatchName := 'BGPOST' + Format(I).PadLeft(4, '0');
            TestDataGenerator.DeleteGenJournalLines(JnlBatchName);
            TestDataGenerator.CreateGenJournalLines(LinesPerSession, JnlBatchName);
            JnlBatchNames.Add(JnlBatchName);
        end;
    end;

    procedure StartSessions(EntityCodes: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer; SessionIds: List of [Integer])
    begin
        StartGenJnlPostingTasks(EntityCodes, TestCode, IterationNo, SessionIds);
    end;

    local procedure StartGenJnlPostingTasks(JnlBatchNames: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer; SessionIds: List of [Integer])
    var
        BatchNo: Integer;
    begin
        for BatchNo := 1 to JnlBatchNames.Count do
            SessionIds.Add(StartGenJnlBackgroundPostingSession(JnlBatchNames.Get(BatchNo), TestCode, IterationNo, BatchNo));
    end;

    local procedure StartGenJnlBackgroundPostingSession(JnlBatchName: Code[20]; TestCode: Code[20]; IterationNo: Integer; SessionNo: Integer): Integer
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        BackgroundPostingParam: Record "BCB Background Posting Params";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        SessionId: Integer;
    begin
        GenJournalBatch.Get(TestDataGenerator.GetGeneralJournalTemplateName(), JnlBatchName);
        PerfBenchTests.InitializeSessionPostingEntityParam(BackgroundPostingParam, TestCode, IterationNo, SessionNo, GenJournalBatch.RecordId);
        StartSession(SessionId, Codeunit::"BCB Gen. Jnl. Parallel Post", CompanyName, BackgroundPostingParam);
        exit(SessionId);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
