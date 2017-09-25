public class KCPQ_ProductWrapperCtrl {
	
    @AuraEnabled public Product2 productRecord {get; set;}
    @AuraEnabled public Decimal productPrice {get;set;}
    @AuraEnabled public String[] featureCategories {get; set;}
    @AuraEnabled public KCPQ_ProductOptionWrapper[] options {get; set;} 
    @AuraEnabled public KCPQ_ProductFeatureWrapper[] features {get; set;}
    @AuraEnabled public String currencySymbol {get;set;}
    @AuraEnabled public Decimal productNetPrice {get;set;}
    
    public KCPQ_ProductWrapperCtrl(){
        
    }
}