codeunit 57812 "BCB SO Parallel Post"
{
    TableNo = "BCB Background Posting Params";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        IsSuccess: Boolean;
        StartTime: Time;
    begin
        Rec."Entity Record ID".GetRecord().SetTable(SalesHeader);
        StartTime := Time();
        IsSuccess := Codeunit.Run(Codeunit::"BCB Sales Order Posting - Run", SalesHeader);

        PerfBenchTests.SaveParallelSessionResult('SO_PARALLEL_POST', Rec."Iteration No.", StartTime, Time(), IsSuccess);
    end;
}
