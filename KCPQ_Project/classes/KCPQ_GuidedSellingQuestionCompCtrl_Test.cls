@isTest
public class KCPQ_GuidedSellingQuestionCompCtrl_Test {
 public static testMethod void setTestData()
    {
        Test.startTest();
        KCPQ_GuidedSellingQuestionCompCtrl.getpathprefixURL();
        KCPQ_GuidedSellingQuestionCompCtrl.getInitializeProcessInputWrapper();
        Product2 prod =  new Product2();
        prod.Name = 'Test Honda';
        insert prod;
        //productJSONStr = json.serialize(prod);
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        insert quote;
        SBQQ__QuoteProcess__c process = new SBQQ__QuoteProcess__c();
        process.Name = 'Test Process';
        insert process;
        SBQQ__ProcessInput__c processInput= new SBQQ__ProcessInput__c();
        List<KCPQ_ProcessInputWrapperCtrl> priList= new List<KCPQ_ProcessInputWrapperCtrl>();
        KCPQ_ProcessInputWrapperCtrl pri = new KCPQ_ProcessInputWrapperCtrl();
        pri.label = 'Name';
        pri.productField = 'Name';
        String processInputJSONStr = json.serialize(priList);
        KCPQ_GuidedSellingQuestionCompCtrl.getFieldSetFields(processInputJSONStr);
        KCPQ_GuidedSellingQuestionCompCtrl.getProcessInputWrapper(processInputJSONStr, process.Id);
        Test.stopTest();
    }
}