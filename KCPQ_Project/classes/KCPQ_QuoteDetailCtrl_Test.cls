@isTest
public class KCPQ_QuoteDetailCtrl_Test {
    public static Id pricebookId;
    public static SBQQ__Quote__c quote;
    public static Contact cont;
    public static Account acc;
    public static testMethod void setTestData()
    {
        pricebookId = Test.getStandardPricebookId(); 
        quote = new SBQQ__Quote__c();
        cont = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            //AccountId = portalAccount1.Id,
            Email = 'Test123@KCPQ.com'
        );
        
    }
    public static testMethod void testQuoteDetailMethods()
    {
        Test.startTest();
        setTestData();
        insert quote;
        Product2 prod = new Product2();
        prod.Name = 'HONDA';
        Product2 prod1 = new Product2();
        prod1.Name = 'HONDA-Brio';
        upsert prod1;
        upsert prod;
        SBQQ__ProductFeature__c prFeature =  new SBQQ__ProductFeature__c();
        prFeature.Name='Featur 1';
        prFeature.SBQQ__Number__c=1;
        prFeature.SBQQ__ConfiguredSKU__c=prod.id;
        prFeature.SBQQ__MinOptionCount__c=1;
        prFeature.SBQQ__MaxOptionCount__c=5;
        upsert prFeature;
        
        SBQQ__ProductOption__c prOption = new SBQQ__ProductOption__c();
        prOption.SBQQ__ConfiguredSKU__c = prod.Id;
        prOption.SBQQ__OptionalSKU__c = prod1.Id;
        prOption.SBQQ__Number__c=1;
        prOption.SBQQ__Feature__c=prFeature.id;
        upsert prOption;
        String productJSONStr = Json.serialize(prod);
        KCPQ_QuoteDetailCtrl.getMainProduct(quote.Id);
        KCPQ_QuoteDetailCtrl.getColorNamesLst(quote.Id, productJSONStr);
        KCPQ_QuoteDetailCtrl.getFeatureIds(productJSONStr, quote.Id);
        KCPQ_QuoteDetailCtrl.getProductWrapper(productJSONStr, quote.Id);
        KCPQ_QuoteDetailCtrl.getFeatureNames(productJSONStr, quote.Id);
        KCPQ_QuoteDetailCtrl.getProgressStageOrderValue(quote.Id, '10');
        Test.stopTest();
    }
}