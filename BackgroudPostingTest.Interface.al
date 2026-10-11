interface "BCB Background Posting Test"
{
    procedure StartSessions(EntityCodes: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer): List of [Integer];
}
