codeunit 57803 "BCB Test Data Generator"
{
    procedure CreateGenJnlBatch(BatchName: Code[10])
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if GenJournalBatch.Get(GetGeneralJournalTemplateName(), BatchName) then
            exit;

        GenJournalBatch.Validate("Journal Template Name", GetGeneralJournalTemplateName());
        GenJournalBatch.Validate(Name, BatchName);
        GenJournalBatch.Insert(true);
    end;

    procedure CreateGenJournalLines(NoOfLines: Integer)
    begin
        CreateGenJournalLines(NoOfLines, GetGeneralJournalBatchName());
    end;

    procedure CreateGenJournalLines(NoOfLines: Integer; JnlBatchName: Code[10])
    var
        TempGLAccount: Record "G/L Account" temporary;
        GenJournalLine: Record "Gen. Journal Line";
        DocumentNo: Code[20];
        Balance: Decimal;
        I: Integer;
    begin
        CreateGenJnlBatch(JnlBatchName);
        DocumentNo := GetGenJnlDocumentNo();
        for I := 1 to NoOfLines do begin
            CreateGenJournalLine(GenJournalLine, JnlBatchName, DocumentNo, I, TempGLAccount);
            Balance += GenJournalLine.Amount;
        end;

        CreateGenJournalLine(GenJournalLine, JnlBatchName, DocumentNo, -Balance, I + 1, TempGLAccount);
    end;

    procedure CreateGenJournalLine(
        var GenJournalLine: Record "Gen. Journal Line";
        JnlBatchName: Code[10];
        DocumentNo: Code[20];
        LineNo: Integer;
        var TempGLAccount: Record "G/L Account" temporary)
    var
        LineAmount: Decimal;
    begin
        LineAmount := Random(1000);
        CreateGenJournalLine(GenJournalLine, JnlBatchName, DocumentNo, LineAmount, LineNo, TempGLAccount);
    end;

    procedure CreateGenJournalLine(
        var GenJournalLine: Record "Gen. Journal Line";
        JnlBatchName: Code[10];
        DocumentNo: Code[20];
        Amount: Decimal;
        LineNo: Integer;
        var TempGLAccount: Record "G/L Account" temporary)
    begin
        GenJournalLine.Validate("Journal Template Name", GetGeneralJournalTemplateName());
        GenJournalLine.Validate("Journal Batch Name", JnlBatchName);
        GenJournalLine.Validate("Line No.", LineNo);
        GenJournalLine.Validate("Document No.", DocumentNo);
        GenJournalLine.Validate("Posting Date", WorkDate());
        GenJournalLine.Validate("Account Type", Enum::"Gen. Journal Account Type"::"G/L Account");
        GenJournalLine.Validate("Account No.", SelectRandomGLAccount(TempGLAccount, true, Enum::"General Posting Type"::" "));

        GenJournalLine.Validate(Amount, Amount);
        GenJournalLine.Insert(true);
    end;

    procedure DeleteGenJournalLines(JnlBatchName: Code[10])
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", GetGeneralJournalTemplateName());
        GenJournalLine.SetRange("Journal Batch Name", JnlBatchName);
        GenJournalLine.DeleteAll();
    end;

    procedure DeleteGenJournalLines()
    begin
        DeleteGenJournalLines(GetGeneralJournalBatchName());
    end;

    procedure GetGeneralJournalTemplateName(): Code[10]
    begin
        exit('GENERAL');
    end;

    procedure GetGeneralJournalBatchName(): Code[10]
    begin
        exit('DEFAULT');
    end;

    procedure GetGenJnlDocNoSeriesCode(): Code[20]
    begin
        exit('GENJNLPERF');
    end;

    procedure CreateGenJnlDocNoSeriesIfNotExists()
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.SetRange(Code, GetGenJnlDocNoSeriesCode());
        if NoSeries.IsEmpty() then
            CreateGenJnlDocNoSeries();
    end;

    procedure CreateGenJnlDocNoSeries()
    begin
        CreateNoSeries(GetGenJnlDocNoSeriesCode());
    end;

    local procedure GetGenJnlDocumentNo(): Code[20]
    var
        NoSeries: Codeunit "No. Series";
    begin
        exit(NoSeries.GetNextNo(GetGenJnlDocNoSeriesCode()));
    end;

    procedure CreateItemJnlBatch(BatchName: Code[10])
    var
        ItemJournalBatch: Record "Item Journal Batch";
    begin
        if ItemJournalBatch.Get(GetItemJournalTemplateName(), BatchName) then
            exit;

        ItemJournalBatch.Validate("Journal Template Name", GetItemJournalTemplateName());
        ItemJournalBatch.Validate(Name, BatchName);
        ItemJournalBatch.Insert(true);
    end;

    procedure CreateItemJournalLines(NoOfLines: Integer)
    begin
        CreateItemJournalLines(NoOfLines, GetItemJournalBatchName());
    end;

    procedure CreateItemJournalLines(NoOfLines: Integer; JnlBatchName: Code[10])
    var
        Item: Record Item;
    begin
        CreateItemJournalLines(NoOfLines, JnlBatchName, 1, Item.Count);
    end;

    procedure CreateItemJournalLines(NoOfLines: Integer; JnlBatchName: Code[10]; MinItemIndex: Integer; MaxItemIndex: Integer)
    var
        TempItem: Record Item temporary;
        GenJournalLine: Record "Gen. Journal Line";
        DocumentNo: Code[20];
        I: Integer;
    begin
        CreateItemJnlBatch(JnlBatchName);
        DocumentNo := GetItemJnlDocumentNo();
        for I := 1 to NoOfLines do
            CreateItemJournalLine(GenJournalLine, JnlBatchName, DocumentNo, I, MinItemIndex, MaxItemIndex, TempItem);
    end;

    procedure CreateItemJournalLine(
        var GenJournalLine: Record "Gen. Journal Line";
        JnlBatchName: Code[10];
        DocumentNo: Code[20];
        LineNo: Integer;
        MinItemIndex: Integer;
        MaxItemIndex: Integer;
        var TempItem: Record Item temporary)
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.Validate("Journal Template Name", GetItemJournalTemplateName());
        ItemJournalLine.Validate("Journal Batch Name", JnlBatchName);
        ItemJournalLine.Validate("Line No.", LineNo);
        ItemJournalLine.Validate("Entry Type", Enum::"Item Journal Entry Type"::Purchase);
        ItemJournalLine.Validate("Document Type", Enum::"Item Ledger Document Type"::"Purchase Receipt");
        ItemJournalLine.Validate("Document No.", DocumentNo);
        ItemJournalLine.Validate("Item No.", SelectRandomItem(TempItem, MinItemIndex, MaxItemIndex));
        ItemJournalLine.Validate(Quantity, Random(10));
        ItemJournalLine.Validate("Unit Amount", Random(100));
        ItemJournalLine.Validate("Posting Date", WorkDate());
        ItemJournalLine.Insert(true);
    end;

    procedure DeleteItemJournalLines(JnlBatchName: Code[10])
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.SetRange("Journal Template Name", GetItemJournalTemplateName());
        ItemJournalLine.SetRange("Journal Batch Name", JnlBatchName);
        ItemJournalLine.DeleteAll();
    end;

    procedure DeleteItemJournalLines()
    begin
        DeleteItemJournalLines(GetItemJournalBatchName());
    end;

    procedure GetItemJournalTemplateName(): Code[10]
    begin
        exit('ITEM');
    end;

    procedure GetItemJournalBatchName(): Code[10]
    begin
        exit('DEFAULT');
    end;

    procedure GetItemJnlDocNoSeriesCode(): Code[20]
    begin
        exit('ITEMJNLPERF');
    end;

    procedure CreateItemJnlDocNoSeries()
    begin
        CreateNoSeries(GetItemJnlDocNoSeriesCode());
    end;

    procedure CreateItemJnlDocNoSeriesIfNotExists()
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.SetRange(Code, GetItemJnlDocNoSeriesCode());
        if NoSeries.IsEmpty() then
            CreateItemJnlDocNoSeries();
    end;

    local procedure GetItemJnlDocumentNo(): Code[20]
    var
        NoSeries: Codeunit "No. Series";
    begin
        exit(NoSeries.GetNextNo(GetItemJnlDocNoSeriesCode()));
    end;

    procedure CreateSalesOrder(LinesCount: Integer): Code[20]
    begin
        exit(CreateSalesOrder(LinesCount, 0, 0));
    end;

    procedure CreateSalesOrder(LinesCount: Integer; MinItemIndex: Integer; MaxItemIndex: Integer): Code[20]
    var
        SalesHeader: Record "Sales Header";
        TempItem: Record Item temporary;
        I: Integer;
    begin
        CreateSalesOrderHeader(SalesHeader, Enum::"Sales Document Type"::Order);

        for I := 1 to LinesCount do
            CreateSalesLine(SalesHeader, I, TempItem, MinItemIndex, MaxItemIndex);

        exit(SalesHeader."No.");
    end;

    procedure CreateSalesOrderHeader(var SalesHeader: Record "Sales Header"; DocType: Enum "Sales Document Type")
    begin
        SalesHeader.Validate("Document Type", DocType);
        SalesHeader.Insert(true);

        SalesHeader.Validate("Posting Date", WorkDate());
        SalesHeader.Validate("Sell-to Customer No.", SelectRandomCustomer());
        SalesHeader.Validate("Location Code", '');
        SalesHeader.Validate(Ship, true);
        SalesHeader.Validate(Invoice, true);
        SalesHeader.Modify(true);
    end;

    procedure CreateSalesLine(SalesHeader: Record "Sales Header"; LineNo: Integer; var TempItem: Record Item temporary)
    begin
        CreateSalesLine(SalesHeader, LineNo, TempItem, 0, 0);
    end;

    procedure CreateSalesLine(SalesHeader: Record "Sales Header"; LineNo: Integer; var TempItem: Record Item temporary; MinItemIndex: Integer; MaxItemIndex: Integer)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate("Line No.", LineNo);
        SalesLine.Validate(Type, Enum::"Sales Line Type"::Item);
        SalesLine.Validate("No.", SelectRandomItem(TempItem, MinItemIndex, MaxItemIndex));
        SalesLine.Validate(Quantity, Random(10));
        SalesLine.Validate("Qty. to Ship", SalesLine.Quantity);
        SalesLine.Validate("Qty. to Invoice", SalesLine.Quantity);
        SalesLine.Validate("Unit Cost", Random(100));
        SalesLine.Insert(true);
    end;

    procedure GetSalesOrdersNoSeriesCode(): Code[20]
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        exit(SalesSetup."Order Nos.");
    end;

    procedure CreatePurchaseOrder(LinesCount: Integer): Code[20]
    begin
        exit(CreatePurchaseOrder(LinesCount, 0, 0));
    end;

    procedure CreatePurchaseOrder(LinesCount: Integer; MinItemIndex: Integer; MaxItemIndex: Integer): Code[20]
    var
        PurchaseHeader: Record "Purchase Header";
        TempItem: Record Item temporary;
        I: Integer;
    begin
        CreatePurchaseOrderHeader(PurchaseHeader, Enum::"Purchase Document Type"::Order);

        for I := 1 to LinesCount do
            CreatePurchaseLine(PurchaseHeader, I, TempItem, MinItemIndex, MaxItemIndex);

        exit(PurchaseHeader."No.");
    end;

    procedure CreatePurchaseOrderHeader(var PurchaseHeader: Record "Purchase Header"; DocType: Enum "Purchase Document Type")
    begin
        PurchaseHeader.Validate("Document Type", DocType);
        PurchaseHeader.Insert(true);

        PurchaseHeader.Validate("Posting Date", WorkDate());
        PurchaseHeader.Validate("Buy-from Vendor No.", SelectRandomVendor());
        PurchaseHeader.Validate("Location Code", '');
        PurchaseHeader.Validate(Receive, true);
        PurchaseHeader.Validate(Invoice, true);
        PurchaseHeader.Validate("Vendor Invoice No.", PurchaseHeader."No.");
        PurchaseHeader.Modify(true);
    end;

    procedure CreatePurchaseLine(PurchaseHeader: Record "Purchase Header"; LineNo: Integer; var TempItem: Record Item temporary)
    begin
        CreatePurchaseLine(PurchaseHeader, LineNo, TempItem, 0, 0);
    end;

    procedure CreatePurchaseLine(PurchaseHeader: Record "Purchase Header"; LineNo: Integer; var TempItem: Record Item temporary; MinItemIndex: Integer; MaxItemIndex: Integer)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Validate("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
        PurchaseLine.Validate("Line No.", LineNo);
        PurchaseLine.Validate(Type, Enum::"Purchase Line Type"::Item);
        PurchaseLine.Validate("No.", SelectRandomItem(TempItem, MinItemIndex, MaxItemIndex));
        PurchaseLine.Validate(Quantity, Random(10));
        PurchaseLine.Validate("Qty. to Receive", PurchaseLine.Quantity);
        PurchaseLine.Validate("Qty. to Invoice", PurchaseLine.Quantity);
        PurchaseLine.Validate("Unit Cost", Random(100));
        PurchaseLine.Insert(true);
    end;

    procedure GetPurchaseOrdersNoSeriesCode(): Code[20]
    var
        PurchaseSetup: Record "Purchases & Payables Setup";
    begin
        PurchaseSetup.Get();
        exit(PurchaseSetup."Order Nos.");
    end;

    local procedure SelectRandomGLAccount(
        var TempGLAccount: Record "G/L Account";
        DirectPosting: Boolean;
        GenPostingType: Enum "General Posting Type"): Code[20]
    begin
        if TempGLAccount.IsEmpty() then
            ReadGLAccountsToTempTable(TempGLAccount, DirectPosting, GenPostingType);

        TempGLAccount.FindSet();
        TempGLAccount.Next(Random(TempGLAccount.Count) - 1);
        exit(TempGLAccount."No.");
    end;

    local procedure SelectRandomItem(var TempItem: Record Item): Code[20]
    begin
        exit(SelectRandomItem(TempItem, 0, 0));
    end;

    local procedure SelectRandomItem(var TempItem: Record Item; MinItemIndex: Integer; MaxItemIndex: Integer): Code[20]
    begin
        InitTempItemIfEmpty(TempItem);

        if (MinItemIndex = 0) or (MaxItemIndex = 0) then begin
            MinItemIndex := 1;
            MaxItemIndex := TempItem.Count();
        end;

        TempItem.FindSet();
        TempItem.Next(MinItemIndex - 1);
        TempItem.Next(Random(MaxItemIndex - MinItemIndex));
        exit(TempItem."No.");
    end;

    local procedure InitTempItemIfEmpty(var TempItem: Record Item temporary)
    begin
        if TempItem.IsEmpty() then
            ReadItemsToTempTable(TempItem);
    end;

    procedure SelectRandomCustomer(): Code[20]
    var
        Customer: Record Customer;
    begin
        Customer.SetRange(Blocked, Enum::"Customer Blocked"::" ");
        Customer.SetRange("IC Partner Code", '');
        Customer.FindSet();
        Customer.Next(Random(Customer.Count) - 1);
        exit(Customer."No.");
    end;

    procedure SelectRandomVendor(): Code[20]
    var
        Vendor: Record Vendor;
    begin
        Vendor.SetRange(Blocked, Enum::"Vendor Blocked"::" ");
        Vendor.SetRange("IC Partner Code", '');
        Vendor.FindSet();
        Vendor.Next(Random(Vendor.Count) - 1);
        exit(Vendor."No.");
    end;

    procedure CreateNoSeries(SeriesCode: Code[20])
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Validate(Code, SeriesCode);
        NoSeries.Validate("Default Nos.", true);
        NoSeries.Validate("Date Order", false);
        NoSeries.Insert(true);

        NoSeriesLine.Validate("Series Code", NoSeries.Code);
        NoSeriesLine.Validate("Line No.", 1);
        NoSeriesLine.Validate("Starting No.", NoSeries.Code + '00001');
        NoSeriesLine.Insert(true);
    end;

    local procedure ReadGLAccountsToTempTable(
        var TempGLAccount: Record "G/L Account" temporary;
        DirectPosting: Boolean;
        GenPostingType: Enum "General Posting Type")
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.SetRange("Gen. Posting Type", GenPostingType);
        if DirectPosting then
            GLAccount.SetRange("Direct Posting", true);

        if GenPostingType = Enum::"General Posting Type"::" " then begin
            GLAccount.SetRange("Gen. Bus. Posting Group", '');
            GLAccount.SetRange("Gen. Prod. Posting Group", '');
            GLAccount.SetRange("VAT Bus. Posting Group", '');
            GLAccount.SetRange("VAT Prod. Posting Group", '');
        end;

        GLAccount.FindSet();
        repeat
            TempGLAccount := GLAccount;
            TempGLAccount.Insert();
        until GLAccount.Next() = 0;
    end;

    local procedure ReadItemsToTempTable(var TempItem: Record Item temporary)
    var
        Item: Record Item;
    begin
        Item.SetRange(Blocked, false);
        Item.SetRange(Type, Enum::"Item Type"::Inventory);
        Item.SetRange("Item Tracking Code", '');
        Item.SetRange("Gen. Prod. Posting Group", 'RETAIL');
        Item.FindSet();
        repeat
            TempItem := Item;
            TempItem.Insert();
        until Item.Next() = 0;
    end;

    procedure SetDefaultInventorySetup()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        InventorySetup.Validate("Automatic Cost Posting", true);
        InventorySetup.Validate("Automatic Cost Adjustment", Enum::"Automatic Cost Adjustment Type"::Never);
        InventorySetup.Modify();
    end;

    procedure CreateItems(NoOfItems: Integer)
    var
        Item: Record Item;
        ItemTemplMgt: Codeunit "Item Templ. Mgt.";
        IsHandled: Boolean;
        I: Integer;
    begin
        for I := 1 to NoOfItems do begin
            Clear(Item);
            ItemTemplMgt.CreateItemFromTemplate(Item, IsHandled, 'ITEM');
        end;
    end;

    procedure ResetCustomersCreditLimits()
    var
        Customer: Record Customer;
    begin
        Customer.SetFilter("Credit Limit (LCY)", '>0');
        if Customer.FindSet() then
            repeat
                Customer.Validate("Credit Limit (LCY)", 0);
                Customer.Modify(true);
            until Customer.Next() = 0;
    end;
}
