@isTest
public class KCPQ_FieldSetViewWrapper_Test {
 static testMethod void testcreateFieldSetViewWrapper()
    {
        Test.startTest();
        KCPQ_FieldSetViewWrapper wrap =new KCPQ_FieldSetViewWrapper();
        wrap.fAPIName = 'Name';
        wrap.fLabel = 'Name';
        wrap.fType = null;
        //wrap.fValue = 'Keste';
        Test.stopTest();
    }
}