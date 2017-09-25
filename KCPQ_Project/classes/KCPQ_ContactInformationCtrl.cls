public class KCPQ_ContactInformationCtrl {
    
    @AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
    }
    
    @AuraEnabled
    public static Contact getContactRecord(Id quoteId, String contactJSONStr){
        Contact con = (Contact)JSON.deserialize(contactJSONStr, Contact.class);
        return KCPQ_Utility.getContactRecord(quoteId,con);
    }
    
    @AuraEnabled
    public static List<KCPQ_FieldSetMember> getFieldSetFields(){
        List<KCPQ_FieldSetMember> fields = new List<KCPQ_FieldSetMember>();
        List<Schema.FieldSetMember> contactFields = SObjectType.Contact.FieldSets.KCPQ_ContactInformation.getFields();
        for(Schema.FieldSetMember f : contactFields) {
            fields.add(new KCPQ_FieldSetMember('Contact', f));
        }
        return fields;
    }
    
    @AuraEnabled
    public static String getContactInformationSave(Id quoteId, String contactJSONStr){
        Contact con = (Contact)JSON.deserialize(contactJSONStr, Contact.class);
        return KCPQ_Utility.doSaveContactInformation(quoteId,con);
    }
}