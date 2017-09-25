public with sharing class KCPQ_FieldSetTableNew {
    
    private static List<FieldSetWrapper> getFieldSet(String sObj, String fSetName){
        Schema.FieldSet sObjFset = Schema.getGlobalDescribe().get(sObj).getDescribe().fieldSets.getMap().get(fSetName);
        
        List<Schema.FieldSetMember> fieldSet = sObjFset.getFields();
        List<FieldSetWrapper> fMaplist = new List<FieldSetWrapper>();
        for (Schema.FieldSetMember fmem: fieldSet) {
            fMaplist.add(new FieldSetWrapper(fmem.getLabel(), fmem.getFieldPath(), fmem.getType(), fmem));
        }
       
        return fMaplist;
    }
    
    // fetches the sObjRecords for the passed sObject and the Field Set Name
    @AuraEnabled
    public static Map<String, List<FieldSetWrapper>> getsObjRecords(String sObj, String fSetName, String orderByField, String orderBy, String recordsLimit){
        
        String whereClause;
        if(sObj == 'Lead')
        {
            whereClause=' WHERE OwnerId =\''+Label.Lead_Queue_ID+'\' AND CREATEDDATE=TODAY';
        }else{
            whereClause=' WHERE OwnerId =\''+Userinfo.getUserId()+'\'';
        }
        String orderByClause=' Order BY '+orderByField+' '+orderBy+' NULLS LAST';
        String limitClause;
         limitClause=' LIMIT 10000';
        /*if(recordsLimit == 'Latest 5')
        {
            limitClause= ' LIMIT 5';
        }else {
            limitClause=' LIMIT 1000';
        }*/
        
        List<FieldSetWrapper> fSetlist = getFieldSet(sObj, fSetName);
        String fAPIname = '';
        for(FieldSetWrapper fName : fSetlist){
            fAPIname += fName.fAPIName + ',';
        }
        //fAPIname += ' Id ';
        fAPIname = fAPIname.removeEnd(',');
        String soqlQuery = 'Select ' + fAPIname + ' from ' + sObj + whereClause + orderByClause + limitClause;
        List<sObject> sObjRecs = Database.query(soqlQuery);
        
        List<FieldSetWrapper> fSetWrapperlist = new List<FieldSetWrapper>();
        for(sObject sObjRec : sObjRecs){
            fSetWrapperlist.add(new FieldSetWrapper(sObjRec));
        }
        Map<String, List<FieldSetWrapper>> fSetWrapperMap = new Map<String, List<FieldSetWrapper>>();
        fSetWrapperMap.put('sObjlist', fSetWrapperlist);
        fSetWrapperMap.put('fieldSetlist', fSetlist);
        
        return fSetWrapperMap;
    }
   
    
     @AuraEnabled
    public static List<KCPQ_FieldSetViewWrapper> getsRecordDetails(String sObj, String fSetName, String recordId){
        List<KCPQ_FieldSetViewWrapper> recordDetails = new List<KCPQ_FieldSetViewWrapper>();
        String whereClause=' WHERE Id =\''+recordId+'\'';
        String limitClause=' LIMIT 1';
      
        
        List<FieldSetWrapper> fSetlist = getFieldSet(sObj, fSetName);
        String fAPIname = '';
        for(FieldSetWrapper fName : fSetlist){
            fAPIname += fName.fAPIName + ',';
        }
        if(fAPIname.contains('Id'))
        {
            fAPIname = fAPIname.removeEnd(',');
        }else{
        fAPIname += ' Id ';
        }
        String soqlQuery = 'Select ' + fAPIname + ' from ' + sObj + whereClause  + limitClause;
        System.debug('soqlQuery...'+soqlQuery);
        List<sObject> sObjRecs = Database.query(soqlQuery);
        
        List<FieldSetWrapper> fSetWrapperlist = new List<FieldSetWrapper>();
        for(sObject sObjRec : sObjRecs){
            
            for(FieldSetWrapper fr:fSetlist)
            {
                KCPQ_FieldSetViewWrapper record=new KCPQ_FieldSetViewWrapper();
                record.fAPIName=fr.fAPIName;
                record.fLabel = fr.fLabel;
                record.fType = fr.fType;
                record.fValue = String.valueOf(sObjRec.get(fr.fAPIName));
               	System.debug('Value..'+record);
                recordDetails.add(record);
            }
            
            //fSetWrapperlist.add(new FieldSetWrapper(sObjRec));
        }
       /* Map<String, List<FieldSetWrapper>> fSetWrapperMap = new Map<String, List<FieldSetWrapper>>();
        fSetWrapperMap.put('sObjlist', fSetWrapperlist);
        fSetWrapperMap.put('fieldSetlist', fSetlist);
        System.debug('fSetWrapperlist...'+fSetWrapperlist);
        System.debug('fSetlist...'+fSetlist);*/
        
        return recordDetails;
    }
   
    @AuraEnabled 
    public static void updateLeadOwner(String leadId)
    {
        Lead lead = [Select ID,OwnerId from Lead where ID=:leadId];
        lead.OwnerId = Userinfo.getUserId();
        update lead;
    }
    
   
    /*
* Wrapper Class to hold
* Field Labels, their APIName, FieldSetMember and
* sObject Record
*/
    public class FieldSetWrapper {
        @AuraEnabled public String fLabel;
        @AuraEnabled public String fAPIName;
        @AuraEnabled public Schema.DisplayType fType;
        @AuraEnabled public String fSetMember;
        @AuraEnabled public sObject sObjRecord;
        
        public FieldSetWrapper(String fieldlabel, String fieldAPIName, FieldSetMember fSetMem){
            fLabel = fieldlabel;
            fAPIName = fieldAPIName;
            fSetMember = JSON.serialize(fSetMem);
        }
        
        public FieldSetWrapper(String fieldlabel, String fieldAPIName, Schema.DisplayType fType,FieldSetMember fSetMem){
            fLabel = fieldlabel;
            fAPIName = fieldAPIName;
            fType = fType;
            fSetMember = JSON.serialize(fSetMem);
        }
        public FieldSetWrapper(sObject sObjRec){
            sObjRecord = sObjRec;
        }
    }
    
    @AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
    }
}