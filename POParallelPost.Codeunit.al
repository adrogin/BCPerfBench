codeunit 57813 "BCB PO Parallel Post"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        IsSuccess: Boolean;
        StartTime: Time;
    begin
        StartTime := Time();
        IsSuccess := Codeunit.Run(Codeunit::"BCB Purch. Order Posting - Run", Rec);

        PerfBenchTests.SaveParallelSessionResult('PO_PARALLEL_POST', 1, StartTime, Time(), IsSuccess);
    end;
}
