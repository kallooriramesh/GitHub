public class KCPQ_ProductOptionWrapper {
	
    @AuraEnabled public Decimal displaynumber {get; set;}
    @AuraEnabled public Decimal quantity {get; set;}
    @AuraEnabled public Id configuredSKU {get;set;}
    @AuraEnabled public Id optionalSKU {get;set;}
    @AuraEnabled public Id featureId {get;set;}
    @AuraEnabled public Decimal unitPrice {get;set;}
    
    public KCPQ_ProductOptionWrapper(){
	
    }
}