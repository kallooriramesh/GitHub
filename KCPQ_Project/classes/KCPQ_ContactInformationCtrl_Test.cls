@isTest
public class KCPQ_ContactInformationCtrl_Test {
    public static testMethod void setTestData()
    {
        Test.startTest();
        Contact con = new Contact();
        con.LastName ='Keste HYD';
        insert con;
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        insert quote;
        KCPQ_ContactInformationCtrl.getContactInformationSave(quote.Id, json.serialize(con));
        KCPQ_ContactInformationCtrl.getContactRecord(quote.Id, json.serialize(con));
        KCPQ_ContactInformationCtrl.getFieldSetFields();
        KCPQ_ContactInformationCtrl.getpathprefixURL();
        Test.stopTest();
    }
}