codeunit 57811 "BCB Item Jnl. Parallel Post"
{
    TableNo = "Item Journal Batch";

    trigger OnRun()
    var
        ItemJournalLine: Record "Item Journal Line";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        IsSuccess: Boolean;
        StartTime: Time;
    begin
        ItemJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", Rec.Name);
        ItemJournalLine.FindFirst();

        StartTime := Time();
        IsSuccess := Codeunit.Run(Codeunit::"BCB Item Jnl. Posting - Run", ItemJournalLine);

        PerfBenchTests.SaveParallelSessionResult('ITEMJ_PARALLEL_POST', 1, StartTime, Time(), IsSuccess);
    end;
}
