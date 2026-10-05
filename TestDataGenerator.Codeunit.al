codeunit 57803 "BCB Test Data Generator"
{
    procedure CreateGenJournalLines(NoOfLines: Integer)
    var
        TempGLAccount: Record "G/L Account" temporary;
        GenJournalLine: Record "Gen. Journal Line";
        DocumentNo: Code[20];
        Balance: Decimal;
        I: Integer;
    begin
        DocumentNo := GetGenJnlDocumentNo();
        for I := 1 to NoOfLines do begin
            CreateGenJournalLine(GenJournalLine, DocumentNo, I, TempGLAccount);
            Balance += GenJournalLine.Amount;
        end;

        CreateGenJournalLine(GenJournalLine, DocumentNo, -Balance, I + 1, TempGLAccount);
    end;

    procedure CreateGenJournalLine(
        var GenJournalLine: Record "Gen. Journal Line";
        DocumentNo: Code[20];
        LineNo: Integer;
        var TempGLAccount: Record "G/L Account" temporary)
    var
        LineAmount: Decimal;
    begin
        LineAmount := Random(1000);
        CreateGenJournalLine(GenJournalLine, DocumentNo, LineAmount, LineNo, TempGLAccount);
    end;

    procedure CreateGenJournalLine(
        var GenJournalLine: Record "Gen. Journal Line";
        DocumentNo: Code[20];
        Amount: Decimal;
        LineNo: Integer;
        var TempGLAccount: Record "G/L Account" temporary)
    begin
        GenJournalLine.Validate("Journal Template Name", GetGeneralJournalTemplateName());
        GenJournalLine.Validate("Journal Batch Name", GetGeneralJournalBatchName());
        GenJournalLine.Validate("Line No.", LineNo);
        GenJournalLine.Validate("Document No.", DocumentNo);
        GenJournalLine.Validate("Posting Date", WorkDate());
        GenJournalLine.Validate("Account Type", Enum::"Gen. Journal Account Type"::"G/L Account");
        GenJournalLine.Validate("Account No.", SelectRandomGLAccount(TempGLAccount, true, Enum::"General Posting Type"::" "));

        GenJournalLine.Validate(Amount, Amount);
        GenJournalLine.Insert(true);
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

    procedure CreateItemJournalLines(NoOfLines: Integer)
    var
        TempItem: Record Item temporary;
        GenJournalLine: Record "Gen. Journal Line";
        DocumentNo: Code[20];
        I: Integer;
    begin
        DocumentNo := GetItemJnlDocumentNo();
        for I := 1 to NoOfLines do
            CreateItemJournalLine(GenJournalLine, DocumentNo, I, TempItem);
    end;

    procedure CreateItemJournalLine(var GenJournalLine: Record "Gen. Journal Line"; DocumentNo: Code[20]; LineNo: Integer; var TempItem: Record Item temporary)
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.Validate("Journal Template Name", GetItemJournalTemplateName());
        ItemJournalLine.Validate("Journal Batch Name", GetItemJournalBatchName());
        ItemJournalLine.Validate("Line No.", LineNo);
        ItemJournalLine.Validate("Entry Type", Enum::"Item Journal Entry Type"::Purchase);
        ItemJournalLine.Validate("Document Type", Enum::"Item Ledger Document Type"::"Purchase Receipt");
        ItemJournalLine.Validate("Document No.", DocumentNo);
        ItemJournalLine.Validate("Item No.", SelectRandomItem(TempItem));
        ItemJournalLine.Validate(Quantity, Random(10));
        ItemJournalLine.Validate("Unit Amount", Random(100));
        ItemJournalLine.Validate("Posting Date", WorkDate());
        ItemJournalLine.Insert(true);
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

    local procedure GetItemJnlDocumentNo(): Code[20]
    var
        NoSeries: Codeunit "No. Series";
    begin
        exit(NoSeries.GetNextNo(GetItemJnlDocNoSeriesCode()));
    end;

    procedure CreateSalesOrder(LinesCount: Integer)
    var
        SalesHeader: Record "Sales Header";
        TempItem: Record Item temporary;
        I: Integer;
    begin
        CreateSalesOrderHeader(SalesHeader, Enum::"Sales Document Type"::Order);

        for I := 1 to LinesCount do
            CreateSalesLine(SalesHeader, I, TempItem);
    end;

    procedure CreateSalesOrderHeader(var SalesHeader: Record "Sales Header"; DocType: Enum "Sales Document Type")
    begin
        SalesHeader.Validate("Document Type", DocType);
        SalesHeader.Validate("Posting Date", WorkDate());
        SalesHeader.Validate("Sell-to Customer No.", SelectRandomCustomer());
        SalesHeader.Validate(Ship, true);
        SalesHeader.Validate(Invoice, true);
        SalesHeader.Insert(true);
    end;

    procedure CreateSalesLine(SalesHeader: Record "Sales Header"; LineNo: Integer; var TempItem: Record Item temporary)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate("Line No.", LineNo);
        SalesLine.Validate(Type, Enum::"Sales Line Type"::Item);
        SalesLine.Validate("No.", SelectRandomItem(TempItem));
        SalesLine.Validate(Quantity, Random(10));
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
        if TempItem.IsEmpty() then
            ReadItemsToTempTable(TempItem);

        TempItem.FindSet();
        TempItem.Next(Random(TempItem.Count) - 1);
        exit(TempItem."No.");
    end;

    procedure SelectRandomCustomer(): Code[20]
    var
        Customer: Record Customer;
    begin
        Customer.SetRange(Blocked, Enum::"Customer Blocked"::" ");
        Customer.FindSet();
        Customer.Next(Random(Customer.Count) - 1);
        exit(Customer."No.");
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
}
