public class KCPQ_FeatureProductCountWrapper {
	
    @AuraEnabled public String featureName {get;set;}
    @AuraEnabled public Integer productsCount {get;set;}
    
    public KCPQ_FeatureProductCountWrapper(){
        
    }
}