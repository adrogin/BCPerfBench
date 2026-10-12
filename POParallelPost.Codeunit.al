codeunit 57813 "BCB PO Parallel Post"
{
    TableNo = "BCB Background Posting Params";

    trigger OnRun()
    var
        PurchaseHeader: Record "Purchase Header";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        IsSuccess: Boolean;
        StartTime: Time;
    begin
        Rec."Entity Record ID".GetRecord().SetTable(PurchaseHeader);
        PurchaseHeader.Find();
        StartTime := Time();
        IsSuccess := Codeunit.Run(Codeunit::"BCB Purch. Order Posting - Run", PurchaseHeader);

        PerfBenchTests.SaveParallelSessionResult(Rec."Test Code", Rec."Iteration No.", StartTime, Time(), IsSuccess);
    end;
}
