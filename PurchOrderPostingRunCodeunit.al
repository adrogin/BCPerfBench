codeunit 57808 "BCB Purch. Order Posting - Run"
{
    trigger OnRun()
    begin
        RunTest();
    end;

    procedure RunTest()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
        NoSeries: Codeunit "No. Series";
    begin
        PurchaseHeader.Get(Enum::"Purchase Document Type"::Order, NoSeries.GetLastNoUsed(TestDataGenerator.GetPurchaseOrdersNoSeriesCode()));
        PurchPost.Run(PurchaseHeader);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
