@isTest
public class KCPQ_CustomFieldWrapper_Test {
    public static testMethod void setTestData()
    {
        Test.startTest();
        KCPQ_CustomFieldWrapper wrap = new KCPQ_CustomFieldWrapper('Name', 'Name', 'String', true, New Account());
        KCPQ_CustomFieldWrapper wrap1=new KCPQ_CustomFieldWrapper(SObjectType.Lead.FieldSets.KCPQ_LatestLeadsHome.getFields()[0],null);
        Test.stopTest();
    }
}