@isTest
public class KCPQ_ProductFeatureWrapper_Test {
    public static testMethod void setTestData()
    {
        Test.startTest();
        KCPQ_ProductFeatureWrapper wrap=new KCPQ_ProductFeatureWrapper();
        wrap.category='category';
        wrap.configuredSKU=null;
        wrap.featureId=null;
        wrap.featureName='Test';
        wrap.maxOptionCount=10;
        wrap.minOptionCount=1;
        wrap.optionSelectionMethod='add';
        Test.stopTest();
    }
}