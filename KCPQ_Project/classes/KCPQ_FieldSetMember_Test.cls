@isTest
public class KCPQ_FieldSetMember_Test {
public static testMethod void setTestData()
    {
        Test.startTest();
        List<String> pickvalues=new List<String>();
        pickvalues.add('element');
        pickvalues.add('element1');
        KCPQ_ProcessInputWrapperCtrl prw = new KCPQ_ProcessInputWrapperCtrl();
        prw.label = 'Name';
        prw.productField = 'Name';
        
        KCPQ_FieldSetMember fm = new KCPQ_FieldSetMember('Contact' , prw, 'String');
        fm.DBRequired = true;
        fm.fieldPath = 'Name';
        fm.label = 'Name';
        fm.required = true;
        fm.sObjName = 'Contact';
        fm.type = 'picklist';
        
        fm.picklistValues=pickvalues;
        fm.fetchPicklistValues();
        KCPQ_FieldSetMember fm1 = new KCPQ_FieldSetMember('Lead', SObjectType.Lead.FieldSets.KCPQ_LatestLeadsHome.getFields()[0]);
        Test.stopTest();
    }
}