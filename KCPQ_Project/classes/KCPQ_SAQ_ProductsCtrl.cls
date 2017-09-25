public class KCPQ_SAQ_ProductsCtrl {
    
    @AuraEnabled
    public static String createQuoteLineItems(String productId, String pbookId,String quoteRecId){
        return KCPQ_Utility.getQuoteIdAfterAddingProduct(productId, pbookId,quoteRecId);
    }
    
    @AuraEnabled
    public static List<KCPQ_ProductGroupper> getProductsWithGroup(String quoteId, String groupByField){
        Map<String, KCPQ_ProductGroupper> productGrp = new Map<String, KCPQ_ProductGroupper>();
        List<String> grpOrder = new List<String>();
        Set<Id> productIDs=KCPQ_Utility.getProductIdsFromPricebookEntries(quoteId);
        String query='Select Id, Name, Product_Image__c, Product_Image_New__c, '+groupByField;
        query += ' from Product2 where ID IN: productIDs AND isInventoryProduct__c=TRUE Order By '+groupByField+' DESC NULLS LAST, Name ASC NULLS LAST';
        for(sObject obj : Database.query(query)){
            String grpFldVal = (String)obj.get(groupByField);
            if(!productGrp.containsKey(grpFldVal)){
                productGrp.put(grpFldVal, new KCPQ_ProductGroupper(grpFldVal));
                grpOrder.add(grpFldVal);
            }
            productGrp.get(grpFldVal).products.add((Product2)obj);
        }
        List<KCPQ_ProductGroupper> productsToReturn = new List<KCPQ_ProductGroupper>();
        for(String grpFldVal : grpOrder){
            productsToReturn.add(productGrp.get(grpFldVal));
        }
        return productsToReturn;
    }
}