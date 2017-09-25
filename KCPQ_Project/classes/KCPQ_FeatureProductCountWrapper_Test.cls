@isTest
public class KCPQ_FeatureProductCountWrapper_Test {
    public static testMethod void testKCPQ_FeatureProductCountWrapper()
    {
        Test.startTest();
        	KCPQ_FeatureProductCountWrapper fWrap=new KCPQ_FeatureProductCountWrapper();
        	fWrap.featureName='Test';
        	fWrap.productsCount=10;
        Test.stopTest();
    }
}