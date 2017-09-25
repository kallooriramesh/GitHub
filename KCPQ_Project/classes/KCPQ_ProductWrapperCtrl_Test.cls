@isTest
public class KCPQ_ProductWrapperCtrl_Test {
    public static testMethod void testKCPQ_ProductWrapperCtrl()
    {
        Test.startTest();
        KCPQ_ProductWrapperCtrl prWrap = new KCPQ_ProductWrapperCtrl();
        prWrap.currencySymbol='USD';
        prWrap.featureCategories = null;
        prWrap.features = null;
        prWrap.options = null;
        prWrap.productNetPrice = 100.00;
        prWrap.productPrice = 200.00;
        prWrap.productRecord = null;
        Test.stopTest();
    }
}