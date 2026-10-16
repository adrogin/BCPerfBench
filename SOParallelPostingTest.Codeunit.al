codeunit 57814 "BCB SO Parallel Posting Test" implements "BCB Background Posting Test"
{
    procedure Initialize(var DocumentNos: List of [Code[20]]; NoOfSessions: Integer; LinesPerOrder: Integer)
    var
        Item: Record Item;
        TestDataGenerator: Codeunit "BCB Test Data Generator";
        I: Integer;
        ItemsInBatch: Integer;
    begin
        ItemsInBatch := Round(Item.Count() / NoOfSessions, 1, '<');

        for I := 1 to NoOfSessions do
            DocumentNos.Add(TestDataGenerator.CreateSalesOrder(LinesPerOrder, (I - 1) * ItemsInBatch + 1, I * ItemsInBatch));
    end;

    procedure StartSessions(EntityCodes: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer): List of [Integer]
    begin
        exit(StartSalesOrderPostingTasks(EntityCodes, TestCode, IterationNo));
    end;

    local procedure StartSalesOrderPostingTasks(DocumentNos: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer): List of [Integer]
    var
        DocNo: Integer;
        SessionIds: List of [Integer];
    begin
        for DocNo := 1 to DocumentNos.Count do
            SessionIds.Add(StartSalesOrderBackgroundPostingSession(DocumentNos.Get(DocNo), TestCode, IterationNo, DocNo));

        exit(SessionIds);
    end;

    local procedure StartSalesOrderBackgroundPostingSession(DocumentNo: Code[20]; TestCode: Code[20]; IterationNo: Integer; SessionNo: Integer): Integer
    var
        SalesHeader: Record "Sales Header";
        BackgroundPostingParam: Record "BCB Background Posting Params";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        SessionId: Integer;
    begin
        SalesHeader.Get(Enum::"Sales Document Type"::Order, DocumentNo);
        PerfBenchTests.InitializeSessionPostingEntityParam(BackgroundPostingParam, TestCode, IterationNo, SessionNo, SalesHeader.RecordId);
        StartSession(SessionId, Codeunit::"BCB SO Parallel Post", CompanyName, BackgroundPostingParam);
        exit(SessionId);
    end;
}
