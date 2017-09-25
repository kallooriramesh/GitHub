@isTest
public class KCPQ_HomePageSidebarCompCtrl_Test {
public static testMethod void setTestData()
    {
        Test.startTest();
        List<KCPQ_MenuWrapperCtrl> mList =  new List<KCPQ_MenuWrapperCtrl>();
        Menu__c m1 = new Menu__c();
        m1.isActive__c = true;
        m1.Name = 'Home';
        m1.Order__c = 1;
        m1.Link__c ='https://www.google.co.in';
        Menu__c m2 = new Menu__c();
        m2.isActive__c = true;
        m2.Name = 'Home';
        m2.Order__c = 1;
        m2.Link__c ='https://www.google.co.in';
        m2.Parent_menu__c = m1.Id;
        insert m1;
        insert m2;
        KCPQ_MenuWrapperCtrl mwrap = new KCPQ_MenuWrapperCtrl(m1, mList);
        mwrap.lstChildMenu = null;
        Boolean ischild=mwrap.isChildMenu;
        //mwrap.isChildMenu = true;
        //mwrap.menu
        KCPQ_HomePageSidebarCompCtrl.getbaseURL();
        KCPQ_HomePageSidebarCompCtrl.getInitializeMenuWrapper();
        KCPQ_HomePageSidebarCompCtrl.getLogoutURL();
        KCPQ_HomePageSidebarCompCtrl.getPartnerWrapper();
        KCPQ_HomePageSidebarCompCtrl.getpathprefixURL();
        KCPQ_HomePageSidebarCompCtrl.getUserDetails();
        KCPQ_HomePageSidebarCompCtrl.getMenuWrapper(json.serialize(mList));
        Test.stopTest();
    }
}