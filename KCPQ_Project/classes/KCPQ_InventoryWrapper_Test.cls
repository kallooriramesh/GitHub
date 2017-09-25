@isTest
public class KCPQ_InventoryWrapper_Test {
public static testMethod void testAPIClassDefinitions()
    {
        Test.startTest();
        KCPQ_InventoryWrapper wrap = new KCPQ_InventoryWrapper();
        wrap.exteriorColorCode = 'test';
        wrap.interiorColorCode = 'test';
        wrap.product = null;
        wrap.stockAvailable = 100;
        Test.stopTest();
    }
}