public class KCPQ_CustomFieldWrapper {
    @AuraEnabled public String fieldLabel {get; set;}
    @AuraEnabled public String fieldAPI {get; set;}
    @AuraEnabled public String fieldValue {get; set;}
    @AuraEnabled public String dataType {get; set;}
    @AuraEnabled public Boolean isRequired {get; set;}
    
    public KCPQ_CustomFieldWrapper(String fl, String fapi, String dt, Boolean flag, Object fv){
        fieldLabel = fl;
        fieldAPI = fapi;
        dataType = dt;
        isRequired = flag;
        fieldValue = String.valueOf(fv);
    }
    
    public KCPQ_CustomFieldWrapper(Schema.FieldSetMember fld, Object fv){
        fieldLabel = fld.getLabel();
        fieldAPI = fld.getFieldPath();
        dataType = ''+fld.getType();
        isRequired = fld.getRequired();
        fieldValue = String.valueOf(fv);
    }
}