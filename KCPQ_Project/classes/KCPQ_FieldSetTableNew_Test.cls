@isTest
private class KCPQ_FieldSetTableNew_Test {
    static testMethod void validateKCPQ_FieldSetTableNew()
    {
        System.Test.startTest();
        Lead lead = new Lead();
        lead.LastName = 'Keste India';
        lead.Company = 'Keste USA';
        lead.Status = 'New';
        //lead.OwnerId = Userinfo.getUserId();
        
        insert lead;
        System.assertNotEquals(null, KCPQ_FieldSetTableNew.getsObjRecords('SBQQ__Quote__c', 'KCPQ_HomeLatestCustomerQuotes', 'CreatedDate', 'ASC', '10'));
        
        KCPQ_FieldSetTableNew.updateLeadOwner(lead.id);
        String quoteId = KCPQ_Utility.createQuote(Test.getStandardPricebookId(), null).ID;
        
        KCPQ_FieldSetTableNew.getsRecordDetails('SBQQ__Quote__c', 'KCPQ_HomeLatestCustomerQuotes', quoteId);
        KCPQ_FieldSetTableNew.getpathprefixURL();
        KCPQ_FieldSetTableNew.FieldSetWrapper fwrap= new KCPQ_FieldSetTableNew.FieldSetWrapper('Name','Name', null);
        System.Test.stopTest();
    }
}