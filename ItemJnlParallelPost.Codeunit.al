codeunit 57811 "BCB Item Jnl. Parallel Post"
{
    TableNo = "BCB Background Posting Params";

    trigger OnRun()
    var
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        IsSuccess: Boolean;
        StartTime: Time;
    begin
        Rec."Entity Record ID".GetRecord().SetTable(ItemJournalBatch);
        ItemJournalLine.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", ItemJournalBatch.Name);
        ItemJournalLine.FindFirst();

        StartTime := Time();
        IsSuccess := Codeunit.Run(Codeunit::"BCB Item Jnl. Posting - Run", ItemJournalLine);

        PerfBenchTests.SaveParallelSessionResult(Rec."Test Code", Rec."Iteration No.", StartTime, Time(), IsSuccess);
    end;
}
