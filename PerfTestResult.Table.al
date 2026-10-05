table 57800 "BCB Perf. Test Result"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Test Code"; Code[20])
        {
            Caption = 'Test Code';
        }
        field(2; "Iteration No."; Integer)
        {
            Caption = 'Iteration No.';
        }
        field(3; "Start Time"; Time)
        {
            Caption = 'Start Time';
        }
        field(4; "End Time"; Time)
        {
            Caption = 'End Time';
        }
        field(5; "Init. Codeunit No."; Integer)
        {
            Caption = 'Init. Codeunit No.';
        }
        field(6; "Run Codeunit No."; Integer)
        {
            Caption = 'Run Codeunit No.';
        }
    }

    keys
    {
        key(PK; "Test Code", "Iteration No.")
        {
            Clustered = true;
        }
    }
}
