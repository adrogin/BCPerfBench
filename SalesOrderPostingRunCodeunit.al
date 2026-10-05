codeunit 57807 "BCB Sales Order Posting - Run"
{
    trigger OnRun()
    begin
        RunTest();
    end;

    procedure RunTest()
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        NoSeries: Codeunit "No. Series";
    begin
        SalesHeader.Get(Enum::"Sales Document Type"::Order, NoSeries.GetLastNoUsed(TestDataGenerator.GetSalesOrdersNoSeriesCode()));
        SalesPost.Run(SalesHeader);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
