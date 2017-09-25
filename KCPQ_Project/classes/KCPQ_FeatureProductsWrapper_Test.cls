@isTest
public class KCPQ_FeatureProductsWrapper_Test {
    public static testMethod void setTestData()
    {
        Test.startTest();
        KCPQ_FeatureProductsWrapper ob=new KCPQ_FeatureProductsWrapper();
        ob.currencySymbol='USD';
        ob.discountValue=100.00;
        ob.featureProduct = null;
        ob.featureProductId = null;
        ob.productNetPrice = 1000.00;
        ob.productUnitPrice = 2000.00;
        ob.selected = true;
        Test.stopTest();
    }
}