enum 57800 "BCB Background Posting Test" implements "BCB Background Posting Test"
{
    Extensible = true;

    value(1; "Post General Journal")
    {
        Caption = 'Post General Journal';
        Implementation = "BCB Background Posting Test" = "BCB Gen. Jnl. Parallel Test";
    }
    value(2; "Post Item Journal")
    {
        Caption = 'Post Item Journal';
        Implementation = "BCB Background Posting Test" = "BCB Item Jnl. Parallel Test";
    }
    value(3; "Post Sales Order")
    {
        Caption = 'Post Sales Order';
        Implementation = "BCB Background Posting Test" = "BCB SO Parallel Posting Test";
    }
    value(4; "Post Purchase Order")
    {
        Caption = 'Post Purchase Order';
        Implementation = "BCB Background Posting Test" = "BCB PO Parallel Posting Test";
    }
}
