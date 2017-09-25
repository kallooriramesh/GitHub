@isTest
public class KCPQ_SummaryCtrl_Test {
    public static SBQQ__Quote__c quote;
    public static string productJSONStr;
    public static Product2 pr;
    public static Id pricebookId;
    public static testMethod void setTestData()
    {
        pricebookId = Test.getStandardPricebookId(); 
        quote = new SBQQ__Quote__c();
        quote.SBQQ__PriceBook__c=pricebookId;
        quote.SBQQ__PricebookId__c=pricebookId;
        pr=new Product2();
        pr.Name='Apple8s';
        
        
    }
    public static testMethod void testgetSummaryWrapperFromQuoteLine()
    {
        Test.startTest();
        setTestData();
        
        insert quote;
        KCPQ_SummaryCtrl.getSummaryWrapperFromQuoteLine(quote.Id);
        Test.stopTest();
    }
    
    public static testMethod void testdoSubmitQuote()
    {
        Test.startTest();
        setTestData();
        insert quote;
        upsert pr;
        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        quoteLine.SBQQ__Quote__c = quote.Id;
        quoteLine.SBQQ__Product__c = pr.Id;
        upsert quoteLine;
        
        
        productJSONStr=JSON.serialize(pr);
        //KCPQ_SummaryCtrl.doSubmitQuote(quote.Id, productJSONStr);
        KCPQ_SummaryCtrl.getMainProductNetPriceValue(quote.Id, productJSONStr);
        KCPQ_SummaryCtrl.getMainProductDiscountVal(quote.Id, productJSONStr);
        KCPQ_SummaryCtrl.getProductOptionWra(quote.Id, productJSONStr);
        List<String> featureNames=new List<String>();
        featureNames.add('futurw 1');
        KCPQ_SummaryCtrl.getFeatureProductCountWrap(quote.Id, productJSONStr, JSON.serialize(featureNames));
        KCPQ_SummaryCtrl.getpathprefixURL();
        KCPQ_SummaryCtrl.doSubmitQuote(quote.Id, productJSONStr);
        Test.stopTest();
    }    
    
    
    
}