@isTest
private class KCPQ_DummyProductsDeletionBatch_Test {
	static testMethod void myUnitTest() {
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        insert quote;
        
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
        
        Product2 dummyProduct = new Product2();
        dummyProduct.Name = 'DELL Latitude';
        dummyProduct.IsActive = true;
        dummyProduct.Dummy_Product_Parent_Id__c = product.Id;
        dummyProduct.Dummy_Product_Quote_Id__c = quote.Id;
        insert dummyProduct;
        
        Test.startTest();
        KCPQ_DummyProductsDeletionBatch batchScheduler = new KCPQ_DummyProductsDeletionBatch();
        String sch = '0 0 23 * * ?';
        system.schedule('Dummy Products Deletion',sch , batchScheduler);
        Test.stopTest();
    }
}