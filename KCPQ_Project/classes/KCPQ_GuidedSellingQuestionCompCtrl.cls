public class KCPQ_GuidedSellingQuestionCompCtrl {
    
    @AuraEnabled
    public static String getInitializeProcessInputWrapper(){
        return JSON.serialize(new List<KCPQ_ProcessInputWrapperCtrl>());
    }
    
    @AuraEnabled
    public static List<KCPQ_FieldSetMember> getFieldSetFields(String processInputJSONStr){
        List<KCPQ_FieldSetMember> fields = new List<KCPQ_FieldSetMember>();
        List<KCPQ_ProcessInputWrapperCtrl> processInputLst = (List<KCPQ_ProcessInputWrapperCtrl>)JSON.deserialize(processInputJSONStr, List<KCPQ_ProcessInputWrapperCtrl>.class);
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Product2').getDescribe().fields.getMap(); 
        for(KCPQ_ProcessInputWrapperCtrl wr : processInputLst){
            fields.add(new KCPQ_FieldSetMember('Product2', wr, ''+fieldMap.get(wr.productField).getDescribe().getType()));
        }
        return fields;
    }
    
    @AuraEnabled
    public static List<KCPQ_ProcessInputWrapperCtrl> getProcessInputWrapper(String processInputJSONStr,String quoteProId){
        List<KCPQ_ProcessInputWrapperCtrl> processInputLst = (List<KCPQ_ProcessInputWrapperCtrl>)JSON.deserialize(processInputJSONStr, List<KCPQ_ProcessInputWrapperCtrl>.class);
        String soql = 'SELECT '; String glue = '';
        Map<String, Schema.SobjectField> fields = Schema.SobjectType.SBQQ__ProcessInput__c.fields.getMap();
        for(String s : fields.keySet()) {   
            if(fields.get(s).getDescribe().isAccessible()){
                soql += glue + s;
                glue = ', ';
            }         
        }
        soql += ' FROM SBQQ__ProcessInput__c WHERE SBQQ__Active__c = true ';
        soql += ' AND SBQQ__QuoteProcess__c =\''+quoteProId+'\'';
        soql += ' ORDER BY SBQQ__DisplayOrder__c';
        
        for(SBQQ__ProcessInput__c proInput : (List<SBQQ__ProcessInput__c>)Database.query(soql)){
            processInputLst.add(KCPQ_Utility.buildProcessInputWrapper(proInput));
        }
        return processInputLst;
    }
    
    @AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
    }
}