@isTest
public class KCPQ_PartnerWrapper_Test {
    public static testMethod void setTestData()
    {
        Test.startTest();
        KCPQ_PartnerWrapper pw = new KCPQ_PartnerWrapper();
        pw.logoName = 'Honda';
        pw.sidebarColor = 'Red';
        Test.stopTest();
    }
}