public class KCPQ_ProductFeatureWrapper {
	
    @AuraEnabled public Id featureId {get;set;}
    @AuraEnabled public String featureName {get;set;}
    @AuraEnabled public Decimal minOptionCount {get;set;}
    @AuraEnabled public Decimal maxOptionCount {get;set;}
    @AuraEnabled public String category {get;set;}
    @AuraEnabled public Id configuredSKU {get;set;}
    @AuraEnabled public String optionSelectionMethod {get;set;}
    
    public KCPQ_ProductFeatureWrapper(){
        
    }
}