@isTest
public class KCPQ_QuoteWrapper_Test {
 public static testMethod void setTestData()
    {
        Test.startTest();
        KCPQ_QuoteWrapper ob=new KCPQ_QuoteWrapper();
        ob.pricebookID='12312312';
        ob.quoteId = '1231312';
        Test.stopTest();
    }
}