codeunit 57807 "BCB Sales Order Posting - Run"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        NoSeries: Codeunit "No. Series";
        TestDataGenerator: Codeunit "BCB Test Data Generator";
    begin
        if Rec."No." <> '' then
            SalesHeader := Rec
        else
            SalesHeader.Get(Enum::"Sales Document Type"::Order, NoSeries.GetLastNoUsed(TestDataGenerator.GetSalesOrdersNoSeriesCode()));

        SalesPost.Run(SalesHeader);
    end;
}
