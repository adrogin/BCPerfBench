codeunit 57807 "BCB Sales Order Posting - Run"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        TestDataGenerator: Codeunit "BCB Test Data Generator";
    begin
        if Rec."No." <> '' then
            SalesHeader := Rec
        else
            SalesHeader.Get(Enum::"Sales Document Type"::Order, TestDataGenerator.GetNoSeriesLastNoUsed(TestDataGenerator.GetSalesOrdersNoSeriesCode()));

        SalesPost.Run(SalesHeader);
    end;
}
