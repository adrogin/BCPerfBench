codeunit 57808 "BCB Purch. Order Posting - Run"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
        NoSeries: Codeunit "No. Series";
        TestDataGenerator: Codeunit "BCB Test Data Generator";
    begin
        if Rec."No." <> '' then
            PurchaseHeader := Rec
        else
            PurchaseHeader.Get(Enum::"Sales Document Type"::Order, NoSeries.GetLastNoUsed(TestDataGenerator.GetPurchaseOrdersNoSeriesCode()));

        PurchPost.Run(PurchaseHeader);
    end;
}
