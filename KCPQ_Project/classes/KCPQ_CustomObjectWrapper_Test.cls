@isTest
public class KCPQ_CustomObjectWrapper_Test {
    public static testMethod void setTestData()
    {
        Test.startTest();
        Contact con = new Contact();
        con.LastName = 'Keste Lastname';
        upsert con;
        KCPQ_CustomObjectWrapper wrap = new KCPQ_CustomObjectWrapper(con.Id,'Contact','Contact');
        Integer count = wrap.fieldCount;
        Test.stopTest();
    }
}