codeunit 57810 "BCB Gen. Jnl. Parallel Post"
{
    TableNo = "BCB Background Posting Params";

    trigger OnRun()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        IsSuccess: Boolean;
        StartTime: Time;
    begin
        Rec."Entity Record ID".GetRecord().SetTable(GenJournalBatch);
        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        GenJournalLine.FindFirst();

        StartTime := Time();
        IsSuccess := Codeunit.Run(Codeunit::"BCB Gen. Jnl. Posting - Run", GenJournalLine);

        PerfBenchTests.SaveParallelSessionResult(Rec."Test Code", Rec."Iteration No.", StartTime, Time(), IsSuccess);
    end;
}
