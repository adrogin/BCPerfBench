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
        BackgroundPostingTest: Interface "BCB Background Posting Test";
    begin
        BackgroundPostingTest := Enum::"BCB Background Posting Test"::"Post General Journal";
        RunBackgroundPostingTestIterations(BackgroundPostingTest, TestCode, NoOfSessions, LinesPerSession);
    end;

    procedure RunItemJnlParallelPostingTest(TestCode: Code[20]; NoOfSessions: Integer; LinesPerSession: Integer)
    var
        BackgroundPostingTest: Interface "BCB Background Posting Test";
    begin
        BackgroundPostingTest := Enum::"BCB Background Posting Test"::"Post Item Journal";
        RunBackgroundPostingTestIterations(BackgroundPostingTest, TestCode, NoOfSessions, LinesPerSession);
    end;

    procedure RunSOParallelPostingTest(TestCode: Code[20]; NoOfSessions: Integer; LinesPerOrder: Integer)
    var
        BackgroundPostingTest: Interface "BCB Background Posting Test";
    begin
        BackgroundPostingTest := Enum::"BCB Background Posting Test"::"Post Sales Order";
        RunBackgroundPostingTestIterations(BackgroundPostingTest, TestCode, NoOfSessions, LinesPerOrder);
    end;

    procedure RunPOParallelPostingTest(TestCode: Code[20]; NoOfSessions: Integer; LinesPerOrder: Integer)
    var
        BackgroundPostingTest: Interface "BCB Background Posting Test";
    begin
        BackgroundPostingTest := Enum::"BCB Background Posting Test"::"Post Purchase Order";
        RunBackgroundPostingTestIterations(BackgroundPostingTest, TestCode, NoOfSessions, LinesPerOrder);
    end;

    procedure InitializeSessionPostingEntityParam(
        var BackgrounPostingParam: Record "BCB Background Posting Params";
        TestCode: Code[20];
        IterationNo: Integer;
        SessionNo: Integer;
        EntityRecId: RecordId)
    begin
        BackgrounPostingParam.SetRange("Test Code", TestCode);
        BackgrounPostingParam.SetRange("Iteration No.", IterationNo);
        BackgrounPostingParam.SetRange("Session No.", SessionNo);
        BackgrounPostingParam.DeleteAll();

        BackgrounPostingParam."Test Code" := TestCode;
        BackgrounPostingParam."Iteration No." := IterationNo;
        BackgrounPostingParam."Session No." := SessionNo;
        BackgrounPostingParam."Entity Record ID" := EntityRecId;
        BackgrounPostingParam.Insert();
    end;

    local procedure RunBackgroundPostingTestIterations(
        BackgroundPostingTest: Interface "BCB Background Posting Test";
        TestCode: Code[20];
        NoOfSessions: Integer;
        LinesPerSession: Integer)
    var
        EntityNames: List of [Code[20]];
        PostingSessionIds: List of [Integer];
        I: Integer;
    begin
        ClearParallelTestResult(TestCode);

        for I := 1 to 10 do begin
            while IsTestActive(PostingSessionIds) do
                Sleep(2000);

            Clear(EntityNames);
            BackgroundPostingTest.Initialize(EntityNames, NoOfSessions, LinesPerSession);
            Commit();
            BackgroundPostingTest.StartSessions(EntityNames, TestCode, I, PostingSessionIds);
        end;
    end;

    local procedure IsTestActive(TestSessionIds: List of [Integer]): Boolean
    var
        ActiveSession: Record "Active Session";
        SessionFilter: Text;
        PostingSessionId: Integer;
    begin
        if TestSessionIds.Count = 0 then
            exit(false);

        foreach PostingSessionId in TestSessionIds do
            SessionFilter := SessionFilter + Format(PostingSessionId) + '|';
        SessionFilter := DelChr(SessionFilter, '>', '|');

        ActiveSession.SetRange("Server Instance ID", ServiceInstanceId());
        ActiveSession.SetFilter("Session ID", SessionFilter);
        exit(not ActiveSession.IsEmpty());
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
