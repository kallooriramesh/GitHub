@isTest
public class KCPQ_QuickLinksCompCtrl_Test {
public static testMethod void setTestData()
    {
        Test.startTest();
        KCPQ_QuickLinksCompCtrl.getInitializeQuickLinkWrapper();
        
        KCPQ_Quick_Link__c kql= new KCPQ_Quick_Link__c();
        kql.Name='Quicklink';
        kql.Order__c=1;
        kql.Link__c='https://www.google.co.in';
        kql.isActive__c=true;
        insert kql;
        List<KCPQ_QuickLinksWrapperCtrl> qlList = new List<KCPQ_QuickLinksWrapperCtrl>();
        
        KCPQ_QuickLinksWrapperCtrl ql = new KCPQ_QuickLinksWrapperCtrl(kql);
        qlList.add(ql);
        
        KCPQ_QuickLinksCompCtrl.getQuickLinkWrapper(json.serialize(qlList));
        Test.stopTest();
    }
}