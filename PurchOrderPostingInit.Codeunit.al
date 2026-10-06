codeunit 57809 "BCB Purch Order Posting - Init"
{
    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        TestDataGenerator.SetDefaultInventorySetup();
        TestDataGenerator.CreatePurchaseOrder(1000);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
