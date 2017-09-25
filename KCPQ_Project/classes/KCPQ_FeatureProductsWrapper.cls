public class KCPQ_FeatureProductsWrapper {
	
    @AuraEnabled public Product2 featureProduct {get; set;}
    @AuraEnabled public Id featureProductId {get; set;}
    @AuraEnabled public String currencySymbol {get;set;}
    @AuraEnabled public Decimal productUnitPrice {get; set;}
    @AuraEnabled public boolean selected {get; set;}
    @AuraEnabled public Decimal discountValue {get;set;}
    @AuraEnabled public Decimal productNetPrice {get;set;}
    
    public KCPQ_FeatureProductsWrapper(){
        
    }
}