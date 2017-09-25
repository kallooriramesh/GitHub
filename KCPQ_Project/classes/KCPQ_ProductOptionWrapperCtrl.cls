public class KCPQ_ProductOptionWrapperCtrl {
    
    @AuraEnabled public Id featureId {get;set;}
    @AuraEnabled public SBQQ__ProductFeature__c featureRecord {get;set;}
    @AuraEnabled public Id productRecordId {get;set;}
    @AuraEnabled public String productName {get;set;}
    @AuraEnabled public String productDescription {get;set;}
    @AuraEnabled public String productImage {get;set;}
    @AuraEnabled public Decimal unitPrice {get;set;}
    @AuraEnabled public Boolean isSelected {get;set;}
    @AuraEnabled public Boolean isDisabled {get;set;}
    @AuraEnabled public String disabledMsg {get;set;}
    @AuraEnabled public Boolean isCheckBox {get;set;}
    @AuraEnabled public Set<Id> setDependentIds {get;set;}
    @AuraEnabled public Set<Id> setControllingGroupsIds {get;set;}
    @AuraEnabled public Id configuredSKU {get;set;}
    @AuraEnabled public Id optionalSKU {get;set;}
    @AuraEnabled public Map<Id,SBQQ__ProductFeature__c> mapProductIdFeatureRecord {get;set;}
    @AuraEnabled public Map<Id,Set<Id>> mapDependentIds{get;set;}
    @AuraEnabled public Set<Id> setDependentProductIds {get;set;}
    @AuraEnabled public Set<Id> setControllingGroupDependentProductIds {get;set;}
    @AuraEnabled public Integer minOptionCount {get;set;}
    @AuraEnabled public Integer maxOptionCount {get;set;}
    @AuraEnabled public Decimal discountValue {get;set;}
    @AuraEnabled public Decimal netPrice {get;set;}
    
    public KCPQ_ProductOptionWrapperCtrl(){
        
    }
}