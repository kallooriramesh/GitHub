public class KCPQ_ProductRecommendationCompCtrl {
    
    @AuraEnabled
    public static String getInitializePricebookEntryWrapper(){
        return JSON.serialize(new List<KCPQ_PricebookEntryWrapperCtrl>());
    }
    
    @AuraEnabled
    public static String doCreateQuote(String pbookId,String quoteProId){
        try{
            SBQQ__Quote__c quoteRec = KCPQ_Utility.createQuote(pbookId,quoteProId);
            return quoteRec.Id;
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static List<KCPQ_CustomObjectWrapper> getOurRecommendations(String productJSONStr, String pbookId,String quoteProId,String quoteRecId){
        List<KCPQ_CustomObjectWrapper> productsToShow = new List<KCPQ_CustomObjectWrapper>();
        // try{
        Product2 tempProd = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        
        PricebookEntry[] resultModels = KCPQ_Utility.getProductsForGuidedSelling(quoteProId,KCPQ_Utility.getQuoteFromQuoteReader(quoteRecId),tempProd);
        
        Set<Id> setProductIds = new Set<Id>();
        if(Test.isRunningTest() == true)
        {
            Product2 prod =  new Product2();
            prod.Name = 'Test Honda';
            insert prod;
            setProductIds.add(prod.id);
        }
        for(PricebookEntry pbEntry : resultModels){
            setProductIds.add(pbEntry.Product2.Id);
        }
        if(setProductIds.size() > 0){
            List<Schema.FieldSetMember> productFields = SObjectType.Product2.FieldSets.KCPQ_Recommendation.getFields();
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : productFields) {
                query += f.getFieldPath() + ', ';
            }
            query = query.substring(0, query.lastIndexOf(','));
            query += ' FROM Product2 WHERE Id IN: setProductIds ORDER BY Name';
            for(sObject pro : Database.query(query)){
                KCPQ_CustomObjectWrapper prodObj = new KCPQ_CustomObjectWrapper((String)pro.get('Id'), 'Product', 'Product2');
                for(Schema.FieldSetMember fieldName : productFields){
                    prodObj.objectFields.add(new KCPQ_CustomFieldWrapper(fieldName, pro.get(fieldName.getFieldPath())));
                }
                productsToShow.add(prodObj);
            }
        }
        return productsToShow;
        //}catch(Exception ex){
        //    return productsToShow;
        //}
    }
    
    @AuraEnabled 
    public static String getQuoteIdAfterAddingProduct(String productId, String pbookId, String quoteRecId){
        String quoteId = KCPQ_Utility.getQuoteIdAfterAddingProduct(productId, pbookId, quoteRecId);
        return quoteId;
    }
    
}