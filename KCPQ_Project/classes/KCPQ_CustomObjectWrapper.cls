public class KCPQ_CustomObjectWrapper {
    @AuraEnabled public String objectLabel {get; set;}
    @AuraEnabled public String objectApiName {get; set;}
    @AuraEnabled public String recordId {get; set;}
    @AuraEnabled public List<KCPQ_CustomFieldWrapper> objectFields {get; set;}
    @AuraEnabled public Integer fieldCount {
        get{
            return objectFields.size();
        }
        protected set;
    }
    
    public KCPQ_CustomObjectWrapper(String rId, String objName, String apiName){
        recordId = rId;
        objectLabel = objName;
        objectApiName = apiName;
        objectFields = new List<KCPQ_CustomFieldWrapper>();
    }
}