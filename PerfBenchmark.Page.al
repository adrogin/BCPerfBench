page 57800 "BCB Perf. Benchmark"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    actions
    {
        area(Processing)
        {
            group(CreateData)
            {
                Caption = 'Create Data';

                action(CreateItems)
                {
                    Caption = 'Create Items';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        Item: Record Item;
                        ItemsAlreadyCreatedQst: Label 'Items have already been created in this company. Do you want to continue?';
                    begin
                        if Item.Count() > 1000 then
                            if not Confirm(ItemsAlreadyCreatedQst) then
                                exit;

                        TestDataGenerator.CreateItems(1000);
                    end;
                }
            }
            group(RunTests)
            {
                Caption = 'Run Tests';

                action(GenJournalPosting)
                {
                    Caption = 'Gen. Journal Posting';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PerfBenchTests.RunTest('GENJNLPOST', Codeunit::"BCB Gen. Jnl. Posting - Init", Codeunit::"BCB Gen. Jnl. Posting - Run");
                    end;
                }
                action(ItemJournalPosting)
                {
                    Caption = 'Item Journal Posting';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PerfBenchTests.RunTest('ITEMJNLPOST', Codeunit::"BCB Item Jnl. Posting - Init", Codeunit::"BCB Item Jnl. Posting - Run");
                    end;
                }
                action(SalesOrderPosting)
                {
                    Caption = 'Sales Order Posting';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PerfBenchTests.RunTest('SALESORDERPOST', Codeunit::"BCB Sales Order Posting - Init", Codeunit::"BCB Sales Order Posting - Run");
                    end;
                }
                action(PurchOrderPosting)
                {
                    Caption = 'Purch Order Posting';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PerfBenchTests.RunTest('PURCHORDERPOST', Codeunit::"BCB Purch Order Posting - Init", Codeunit::"BCB Purch. Order Posting - Run");
                    end;
                }
                action(GenJnlParallelPosting)
                {
                    Caption = 'Gen. Jnl. - Parallel Posting';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PerfBenchTests.RunGenJnlParallelPostingTest('GENJNL_PARALLEL_POST', 10, 100);
                    end;
                }
                action(itemJnlParallelPosting)
                {
                    Caption = 'Item Jnl. - Parallel Posting';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PerfBenchTests.RunItemJnlParallelPostingTest('ITEMJ_PARALLEL_POST', 10, 100);
                    end;
                }
            }
        }
    }

    var
        PerfBenchTests: Codeunit "BCB Perf. Bench Tests";
        TestDataGenerator: Codeunit "BCB Test Data Generator";
}
