public class KCPQ_SAQ_PBSelectionCtrl {
    
    
    @AuraEnabled
    public static List<String> getPricebookPicklist(){
        return KCPQ_Utility.getPricebookPicklist();
    }
    
    @AuraEnabled
    public static KCPQ_QuoteWrapper createPriceBookQuote(String pricebookID){
        KCPQ_QuoteWrapper quoteWrapper=new KCPQ_QuoteWrapper();
        quoteWrapper.quoteId=KCPQ_Utility.createQuote(pricebookID, null).ID;
        return quoteWrapper;
    }
    
    public static List<Product2> getProductsForQuote(String quoteId){
        Set<Id> productIDs=KCPQ_Utility.getProductIdsFromPricebookEntries(quoteId);
        List<Product2> resultModels=[Select ID,name,Body_Style__c,Product_Image__c from Product2 where ID IN:productIDs AND IsActive=true];
        return resultModels;
    }
}