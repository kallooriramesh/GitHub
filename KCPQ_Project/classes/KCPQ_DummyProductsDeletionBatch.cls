global with sharing class KCPQ_DummyProductsDeletionBatch implements Database.Batchable<sObject>,Schedulable{ 
    
    global Database.QueryLocator start(Database.BatchableContext BC){    
        return Database.getQueryLocator([SELECT Id FROM Product2 
                                        WHERE Dummy_Product_Parent_Id__c != null AND Dummy_Product_Quote_Id__c != null]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Set<Id> setProductIdsForDeletion = new Set<Id>();
        for(Product2 p : (List<Product2>)scope){
            setProductIdsForDeletion.add(p.Id);
        }
        if(setProductIdsForDeletion.size() > 0){
            KCPQ_Utility.deleteCloneProductAndRelated(setProductIdsForDeletion);
        }
    }
    
    global void finish(Database.BatchableContext BC){
      
    }
 
    global void execute(SchedulableContext SC) {
         Database.executeBatch(new KCPQ_DummyProductsDeletionBatch(), 50);
    }
}