codeunit 57815 "BCB PO Parallel Posting Test" implements "BCB Background Posting Test"
{
    procedure StartSessions(EntityCodes: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer): List of [Integer]
    begin
        StartPurchaseOrderPostingTasks(EntityCodes, TestCode, IterationNo);
    end;

    local procedure StartPurchaseOrderPostingTasks(DocumentNos: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer): List of [Integer]
    var
        DocNo: Integer;
        SessionIds: List of [Integer];
    begin
        for DocNo := 1 to DocumentNos.Count do
            SessionIds.Add(StartPurchaseOrderBackgroundPostingSession(DocumentNos.Get(DocNo), TestCode, IterationNo, DocNo));

        exit(SessionIds);
    end;

    local procedure StartPurchaseOrderBackgroundPostingSession(DocumentNo: Code[20]; TestCode: Code[20]; IterationNo: Integer; SessionNo: Integer): Integer
    var
        PurchaseHeader: Record "Purchase Header";
        BackgroundPostingParam: Record "BCB Background Posting Params";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        SessionId: Integer;
    begin
        PurchaseHeader.Get(Enum::"Sales Document Type"::Order, DocumentNo);
        PerfBenchTests.InitializeSessionPostingEntityParam(BackgroundPostingParam, TestCode, IterationNo, SessionNo, PurchaseHeader.RecordId);
        StartSession(SessionId, Codeunit::"BCB PO Parallel Post", CompanyName, PurchaseHeader);
        exit(SessionId);
    end;
}
