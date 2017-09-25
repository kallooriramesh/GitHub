public class KCPQ_ProductGroupper {
    @AuraEnabled public String groupName {get; set;}
    @AuraEnabled public List<Product2> products {get; set;}
    
    public KCPQ_ProductGroupper(String groupName){
        this.groupName = groupName;
        products = new List<Product2>();
    }
}