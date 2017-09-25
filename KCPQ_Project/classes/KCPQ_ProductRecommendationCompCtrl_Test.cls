@isTest
public class KCPQ_ProductRecommendationCompCtrl_Test {
    public static testMethod void setTestData()
    {
       test.startTest();
        KCPQ_ProductRecommendationCompCtrl.getInitializePricebookEntryWrapper();
        KCPQ_ProductRecommendationCompCtrl.doCreateQuote(Test.getStandardPricebookId(),null);
        String productJSONStr;
        Product2 prod =  new Product2();
        prod.Name = 'Test Honda';
        insert prod;
        productJSONStr = json.serialize(prod);
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        //insert quote;
        SBQQ__QuoteProcess__c process = new SBQQ__QuoteProcess__c();
        process.Name = 'Test Process';
        
        insert process;
        quote.SBQQ__QuoteProcessId__c=process.id;
        upsert quote;
        SBQQ__ProcessInput__c processInput= new SBQQ__ProcessInput__c();
        processInput.Name='Input Process';
        processInput.SBQQ__QuoteProcess__c = process.Id;
        processInput.SBQQ__Label__c = 'TEST Label';
        processInput.SBQQ__InputField__c = 'Type_of_Accessory__c';
        processInput.SBQQ__ConditionsMet__c = 'All';
        processInput.SBQQ__DisplayOrder__c = 1;
        processInput.SBQQ__ProductField__c = 'Name';
        processInput.SBQQ__Active__c = true;
        
        upsert processInput;
        PricebookEntry pre = new PricebookEntry();
        pre.Pricebook2Id = Test.getStandardPricebookId();
        pre.Product2Id = prod.id;
        pre.UnitPrice = 1000;
        insert pre;
        
        //getOurRecommendations(String productJSONStr, String pbookId,String quoteProId,String quoteRecId)
        KCPQ_ProductRecommendationCompCtrl.getOurRecommendations(json.serialize(new Product2()), Test.getStandardPricebookId(), process.Id, quote.id);
        //processInput.SBQQ__ProductField__c = null;
        //upsert processInput;
        KCPQ_ProductRecommendationCompCtrl.getOurRecommendations(json.serialize(new Product2()), Test.getStandardPricebookId(), process.Id, quote.id);
        KCPQ_ProductRecommendationCompCtrl.getQuoteIdAfterAddingProduct(prod.Id, Test.getStandardPricebookId(), quote.id);
        test.stopTest();
    }
}