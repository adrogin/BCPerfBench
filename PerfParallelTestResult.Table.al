table 57801 "BCB Perf. Parallel Test Result"
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
        field(3; "Session ID"; Integer)
        {
            Caption = 'Session ID';
        }
        field(4; "Start Time"; Time)
        {
            Caption = 'Start Time';
        }
        field(5; "End Time"; Time)
        {
            Caption = 'End Time';
        }
        field(6; "Is Success"; Boolean)
        {
            Caption = 'Is Success';
        }
        field(7; "Error Text"; Text[500])
        {
            Caption = 'Error Text';
        }
        field(8; "Error Call Stack"; Text[2048])
        {
            Caption = 'Error Call Stack';
        }
    }
    
    keys
    {
        key(PK; "Test Code", "Iteration No.", "Session ID")
        {
            Clustered = true;
        }
    }
}