codeunit 57806 "BCB Sales Order Posting - Init"
{
    trigger OnRun()
    begin
        Initialize();
    end;

    procedure Initialize()
    begin
        TestDataGenerator.SetDefaultInventorySetup();
        TestDataGenerator.CreateSalesOrder(1000);
    end;

    var
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
