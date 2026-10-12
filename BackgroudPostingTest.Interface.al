interface "BCB Background Posting Test"
{
    procedure Initialize(var EntityNames: List of [Code[20]]; NoOfSessions: Integer; LinesPerSession: Integer);
    procedure StartSessions(EntityCodes: List of [Code[20]]; TestCode: Code[20]; IterationNo: Integer): List of [Integer];
}
