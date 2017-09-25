@isTest
private class KCPQ_Inventory_CheckCtrl_Test {
    static testMethod void validateKCPQ_Inventory_CheckCtrl()
    {
        System.Test.startTest();
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 product = new Product2();
        product.Name = 'DELL Latitude';
        Product.IsActive = true;
        insert product;
        
        PriceBookEntry pEntry = new PriceBookEntry();
        pEntry.IsActive = true;
        pEntry.Pricebook2Id = pricebookId;
        pEntry.Product2Id = product.Id;
        pEntry.UnitPrice = 1000;
        insert pEntry;
        
        System.assertNotEquals(null, KCPQ_Inventory_CheckCtrl.getProducts());
        KCPQ_Inventory_CheckCtrl.createProductQuote(product.Id);
        KCPQ_InventoryWrapper wr =new KCPQ_InventoryWrapper();
        wr.exteriorColorCode = '#12345';
        wr.interiorColorCode = '#43215';
        wr.product = product;
        wr.stockAvailable = 100;
        System.Test.stopTest();
    }
}