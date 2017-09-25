@isTest
public class KCPQ_ProductOptionWrapper_Test {
 public static testMethod void setTestData()
    {
        Test.startTest();
        KCPQ_ProductOptionWrapper wrap = new KCPQ_ProductOptionWrapper();
        wrap.configuredSKU = null;
        wrap.displaynumber = 1;
        wrap.featureId = null;
        wrap.optionalSKU = null;
        wrap.quantity = 10.0;
        wrap.unitPrice = 100.00;
        Test.stopTest();
    }
}