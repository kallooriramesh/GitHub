public class KCPQ_InventoryWrapper {
    @AuraEnabled Public Product2 product{get;set;}
    @AuraEnabled public Integer stockAvailable{get;set;}
    @AuraEnabled public String exteriorColorCode{get;set;}
    @AuraEnabled public String interiorColorCode{get;set;}
}