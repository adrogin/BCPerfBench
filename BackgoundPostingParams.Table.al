table 57802 "BCB Background Posting Params"
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
        field(3; "Session No."; Integer)
        {
            Caption = 'Session No.';
        }
        field(4; "Entity Record ID"; RecordId)
        {
            Caption = 'Entity Record ID';
        }
    }

    keys
    {
        key(PK; "Test Code", "Iteration No.", "Session No.")
        {
            Clustered = true;
        }
    }
}
