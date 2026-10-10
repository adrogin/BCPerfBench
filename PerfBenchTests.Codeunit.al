codeunit 57802 "BCB Perf. Bench Tests"
{
    procedure RunTest(TestCode: Code[20]; InitCodeunitNo: Integer; RunCodeunitNo: Integer)
    var
        StartTime: Time;
        EndTime: Time;
        IterationNo: Integer;
    begin
        ClearTestResult(TestCode);

        for IterationNo := 1 to 10 do begin
            Codeunit.Run(InitCodeunitNo);
            Commit();

            StartTime := Time;
            Codeunit.Run(RunCodeunitNo);
            EndTime := Time;

            SaveResult(TestCode, IterationNo, StartTime, EndTime, InitCodeunitNo, RunCodeunitNo);
            Commit();
        end;
    end;

    procedure SaveResult(TestCode: Code[20]; IterationNo: Integer; StartTime: Time; EndTime: Time; InitCodeunitNo: Integer; RunCodeunitNo: Integer)
    var
        PerfTestResult: Record "BCB Perf. Test Result";
    begin
        PerfTestResult.Validate("Test Code", TestCode);
        PerfTestResult.Validate("Iteration No.", IterationNo);
        PerfTestResult.Validate("Init. Codeunit No.", InitCodeunitNo);
        PerfTestResult.Validate("Run Codeunit No.", RunCodeunitNo);
        PerfTestResult.Validate("Start Time", StartTime);
        PerfTestResult.Validate("End Time", EndTime);
        PerfTestResult.Insert(true);
    end;

    procedure SaveParallelSessionResult(TestCode: Code[20]; IterationNo: Integer; StartTime: Time; EndTime: Time; IsSuccess: Boolean)
    var
        PerfParallelTestResult: Record "BCB Perf. Parallel Test Result";
    begin
        PerfParallelTestResult.Validate("Test Code", TestCode);
        PerfParallelTestResult.Validate("Iteration No.", IterationNo);
        PerfParallelTestResult.Validate("Session ID", SessionId());
        PerfParallelTestResult.Validate("Start Time", StartTime);
        PerfParallelTestResult.Validate("End Time", EndTime);
        PerfParallelTestResult.Validate("Is Success", IsSuccess);

        if not IsSuccess then begin
            PerfParallelTestResult.Validate("Error Text", CopyStr(GetLastErrorText(), 1, MaxStrLen(PerfParallelTestResult."Error Text")));
            PerfParallelTestResult.Validate("Error Call Stack", CopyStr(GetLastErrorCallStack, 1, MaxStrLen(PerfParallelTestResult."Error Call Stack")));
        end;
        PerfParallelTestResult.Insert(true);
    end;

    local procedure ClearTestResult(TestCode: Code[20])
    var
        PerfTestResult: Record "BCB Perf. Test Result";
    begin
        PerfTestResult.SetRange("Test Code", TestCode);
        PerfTestResult.DeleteAll();
    end;

    local procedure ClearParallelTestResult(TestCode: Code[20])
    var
        PerfParallelTestResult: Record "BCB Perf. Parallel Test Result";
    begin
        PerfParallelTestResult.SetRange("Test Code", TestCode);
        PerfParallelTestResult.DeleteAll();
    end;

    procedure RunGenJnlParallelPostingTest(TestCode: Code[20]; NoOfSessions: Integer; LinesPerSession: Integer)
    var
        JnlBatchNames: List of [Code[20]];
    begin
        ClearParallelTestResult(TestCode);
        InitializeGenJnlParallelPostingTest(JnlBatchNames, NoOfSessions, LinesPerSession);
        Commit();

        StartGenJnlPostingTasks(JnlBatchNames);
    end;

    local procedure InitializeGenJnlParallelPostingTest(var JnlBatchNames: List of [Code[20]]; NoOfSessions: Integer; LinesPerSession: Integer)
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

    local procedure StartGenJnlPostingTasks(JnlBatchNames: List of [Code[20]])
    var
        BatchName: Code[20];
    begin
        foreach BatchName in JnlBatchNames do
            StartGenJnlBackgroundPostingSession(BatchName);
    end;

    local procedure StartGenJnlBackgroundPostingSession(JnlBatchName: Code[20])
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        SessionId: Integer;
    begin
        GenJournalBatch.Get(TestDataGenerator.GetGeneralJournalTemplateName(), JnlBatchName);
        StartSession(SessionId, Codeunit::"BCB Gen. Jnl. Parallel Post", CompanyName, GenJournalBatch);
    end;

    procedure RunItemJnlParallelPostingTest(TestCode: Code[20]; NoOfSessions: Integer; LinesPerSession: Integer)
    var
        JnlBatchNames: List of [Code[20]];
    begin
        ClearParallelTestResult(TestCode);
        InitializeItemJnlParallelPostingTest(JnlBatchNames, NoOfSessions, LinesPerSession);
        Commit();

        StartItemJnlPostingTasks(JnlBatchNames);
    end;

    local procedure InitializeItemJnlParallelPostingTest(var JnlBatchNames: List of [Code[20]]; NoOfSessions: Integer; LinesPerSession: Integer)
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

    local procedure StartItemJnlPostingTasks(JnlBatchNames: List of [Code[20]])
    var
        BatchName: Code[20];
    begin
        foreach BatchName in JnlBatchNames do
            StartItemJnlBackgroundPostingSession(BatchName);
    end;

    local procedure StartItemJnlBackgroundPostingSession(JnlBatchName: Code[20])
    var
        ItemJournalBatch: Record "Item Journal Batch";
        SessionId: Integer;
    begin
        ItemJournalBatch.Get(TestDataGenerator.GetItemJournalTemplateName(), JnlBatchName);
        StartSession(SessionId, Codeunit::"BCB Item Jnl. Parallel Post", CompanyName, ItemJournalBatch);
    end;

    procedure RunSOParallelPostingTest(TestCode: Code[20]; NoOfSessions: Integer; LinesPerOrder: Integer)
    var
        DocumentNos: List of [Code[20]];
    begin
        ClearParallelTestResult(TestCode);
        InitializeSalesOrderParallelPostingTest(DocumentNos, NoOfSessions, LinesPerOrder);
        Commit();

        StartSalesOrderPostingTasks(DocumentNos);
    end;

    procedure InitializeSalesOrderParallelPostingTest(var DocumentNos: List of [Code[20]]; NoOfSessions: Integer; LinesPerOrder: Integer)
    var
        Item: Record Item;
        I: Integer;
        ItemsInBatch: Integer;
    begin
        ItemsInBatch := Round(Item.Count() / NoOfSessions, 1, '<');

        for I := 1 to NoOfSessions do
            DocumentNos.Add(TestDataGenerator.CreateSalesOrder(LinesPerOrder, (I - 1) * ItemsInBatch + 1, I * ItemsInBatch));
    end;

    local procedure StartSalesOrderPostingTasks(DocumentNos: List of [Code[20]])
    var
        DocNo: Code[20];
    begin
        foreach DocNo in DocumentNos do
            StartSalesOrderBackgroundPostingSession(DocNo);
    end;

    local procedure StartSalesOrderBackgroundPostingSession(DocumentNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SessionId: Integer;
    begin
        SalesHeader.Get(Enum::"Sales Document Type"::Order, DocumentNo);
        StartSession(SessionId, Codeunit::"BCB SO Parallel Post", CompanyName, SalesHeader);
    end;

    procedure RunPOParallelPostingTest(TestCode: Code[20]; NoOfSessions: Integer; LinesPerOrder: Integer)
    var
        DocumentNos: List of [Code[20]];
    begin
        ClearParallelTestResult(TestCode);
        InitializePurchaseOrderParallelPostingTest(DocumentNos, NoOfSessions, LinesPerOrder);
        Commit();

        StartPurchaseOrderPostingTasks(DocumentNos);
    end;

    procedure InitializePurchaseOrderParallelPostingTest(var DocumentNos: List of [Code[20]]; NoOfSessions: Integer; LinesPerOrder: Integer)
    var
        Item: Record Item;
        I: Integer;
        ItemsInBatch: Integer;
    begin
        ItemsInBatch := Round(Item.Count() / NoOfSessions, 1, '<');

        for I := 1 to NoOfSessions do
            DocumentNos.Add(TestDataGenerator.CreatePurchaseOrder(LinesPerOrder, (I - 1) * ItemsInBatch + 1, I * ItemsInBatch));
    end;

    local procedure StartPurchaseOrderPostingTasks(DocumentNos: List of [Code[20]])
    var
        DocNo: Code[20];
    begin
        foreach DocNo in DocumentNos do
            StartPurchaseOrderBackgroundPostingSession(DocNo);
    end;

    local procedure StartPurchaseOrderBackgroundPostingSession(DocumentNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        SessionId: Integer;
    begin
        PurchaseHeader.Get(Enum::"Sales Document Type"::Order, DocumentNo);
        StartSession(SessionId, Codeunit::"BCB PO Parallel Post", CompanyName, PurchaseHeader);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
