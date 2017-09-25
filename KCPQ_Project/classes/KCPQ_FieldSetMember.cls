public class KCPQ_FieldSetMember {
	@AuraEnabled public String sObjName { get;set; }
    @AuraEnabled public Boolean DBRequired { get;set; }
    @AuraEnabled public String fieldPath { get;set; }
    @AuraEnabled public String label { get;set; }
    @AuraEnabled public Boolean required { get;set; }
    @AuraEnabled public String type { get; set; }
    @AuraEnabled public List<String> picklistValues { get; set; }
    
    public void fetchPicklistValues(){
        if(type == 'picklist' || type == 'multipicklist'){
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap(); 
            list<Schema.PicklistEntry> values = fieldMap.get(fieldPath).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a : values){ 
                string sValue=a.getValue();
                picklistValues.add(sValue);
            }
        }
    }
    
    public KCPQ_FieldSetMember(String sObjName, KCPQ_ProcessInputWrapperCtrl pi, String dataType) {
        this.sObjName = sObjName;
        this.DBRequired = false;
        this.fieldPath = pi.productField;
        this.label = pi.label;
        this.required = false;
        this.type = dataType;
        this.picklistValues = new List<String>();
        fetchPicklistValues();
    }
    
    public KCPQ_FieldSetMember(String sObjName, Schema.FieldSetMember fsm) {
        this.sObjName = sObjName;
        this.DBRequired = fsm.getDbRequired();
        this.fieldPath = fsm.getFieldPath();
        this.label = fsm.getLabel();
        this.required = fsm.getRequired();
        this.type = fsm.getType()+'';
        this.picklistValues = new List<String>();
        fetchPicklistValues();
    }
    
}