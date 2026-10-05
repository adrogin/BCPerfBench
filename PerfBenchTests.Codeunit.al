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

    local procedure ClearTestResult(TestCode: Code[20])
    var
        PerfTestResult: Record "BCB Perf. Test Result";
    begin
        PerfTestResult.SetRange("Test Code", TestCode);
        PerfTestResult.DeleteAll();
    end;
}
