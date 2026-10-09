codeunit 57812 "BCB SO Parallel Post"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        IsSuccess: Boolean;
        StartTime: Time;
    begin
        StartTime := Time();
        IsSuccess := Codeunit.Run(Codeunit::"BCB Sales Order Posting - Run", Rec);

        PerfBenchTests.SaveParallelSessionResult('SO_PARALLEL_POST', 1, StartTime, Time(), IsSuccess);
    end;
}
