page 57801 "BCB Perf. Test Result"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCB Perf. Test Result";
    Caption = 'Performance Test Results';

    layout
    {
        area(Content)
        {
            repeater(TestResults)
            {
                field("Test Code"; Rec."Test Code") { }
                field("Iteration No."; Rec."Iteration No.") { }
                field("Start Time"; Rec."Start Time") { }
                field("End Time"; Rec."End Time") { }
                field(TestDuration; TestDuration) { }
                field("Init. Codeunit No."; Rec."Init. Codeunit No.") { }
                field("Run Codeunit No."; Rec."Run Codeunit No.") { }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TestDuration := Rec."End Time" - Rec."Start Time";
    end;

    var
        TestDuration: Duration;
}
