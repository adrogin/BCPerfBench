codeunit 57810 "BCB Gen. Jnl. Parallel Post"
{
    TableNo = "Gen. Journal Batch";

    trigger OnRun()
    var
        GenJournalLine: Record "Gen. Journal Line";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        IsSuccess: Boolean;
        StartTime: Time;
    begin
        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", Rec.Name);
        GenJournalLine.FindFirst();

        StartTime := Time();
        IsSuccess := Codeunit.Run(Codeunit::"BCB Gen. Jnl. Posting - Run", GenJournalLine);

        PerfBenchTests.SaveParallelSessionResult('GENJNL_PARALLEL_POST', 1, StartTime, Time(), IsSuccess);
    end;
}