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
                field("Test Code"; Rec."Test Code")
                {
                    ApplicationArea = All;
                }
                field("Iteration No."; Rec."Iteration No.")
                {
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                }
                field(TestDuration; TestDuration)
                {
                    ApplicationArea = All;
                }
                field("Init. Codeunit No."; Rec."Init. Codeunit No.")
                {
                    ApplicationArea = All;
                }
                field("Run Codeunit No."; Rec."Run Codeunit No.")
                {
                    ApplicationArea = All;
                }
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
