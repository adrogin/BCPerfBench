page 57800 "BCB Perf. Benchmark"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    actions
    {
        area(Processing)
        {
            group(RunTests)
            {
                Caption = 'Run Tests';

                action(GenJournalPosting)
                {
                    Caption = 'Gen. Journal Posting';

                    trigger OnAction()
                    begin
                        PerfBenchTests.RunTest('GENJNLPOST', Codeunit::"BCB Gen. Jnl. Posting - Init", Codeunit::"BCB Gen. Jnl. Posting - Run");
                    end;
                }
                action(ItemJournalPosting)
                {
                    Caption = 'Item Journal Posting';

                    trigger OnAction()
                    var
                        InventorySetup: Record "Inventory Setup";
                    begin
                        InventorySetup.Get();
                        InventorySetup.Validate("Automatic Cost Posting", true);
                        InventorySetup.Validate("Automatic Cost Adjustment", Enum::"Automatic Cost Adjustment Type"::Always);
                        InventorySetup.Modify();

                        PerfBenchTests.RunTest('ITEMJNLPOST', Codeunit::"BCB Item Jnl. Posting - Init", Codeunit::"BCB Item Jnl. Posting - Run");
                    end;
                }
                action(ItemJournalPostingNoCostInGL)
                {
                    Caption = 'Item Journal Posting - No cost in G/L';

                    trigger OnAction()
                    var
                        InventorySetup: Record "Inventory Setup";
                    begin
                        InventorySetup.Get();
                        InventorySetup.Validate("Automatic Cost Posting", false);
                        InventorySetup.Validate("Automatic Cost Adjustment", Enum::"Automatic Cost Adjustment Type"::Never);
                        InventorySetup.Modify();

                        PerfBenchTests.RunTest('ITEMJNLNOCOST', Codeunit::"BCB Item Jnl. Posting - Init", Codeunit::"BCB Item Jnl. Posting - Run");
                    end;
                }
                action(SalesOrderPosting)
                {
                    Caption = 'Sales Order Posting';

                    trigger OnAction()
                    begin
                        PerfBenchTests.RunTest('SALESORDERPOST', Codeunit::"BCB Sales Order Posting - Init", Codeunit::"BCB Sales Order Posting - Run");
                    end;
                }
            }
        }
    }

    var
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
}
