public class KCPQ_ProductFeatureOptionsCtrl {
    
    @AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
    }
    
    @AuraEnabled
    public static String getbaseURL(){
        return site.getbaseurl();
    }
    
    @AuraEnabled
    public static String getInitializeProductOptionWrapper(){
        return JSON.serialize(new List<KCPQ_ProductOptionWrapperCtrl>());
    }
    
    @AuraEnabled
    public static List<KCPQ_ProductOptionWrapperCtrl> getProductOptionWra(String productOptionJSONStr, Id quoteId, String productJSONStr){
        
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        List<KCPQ_ProductOptionWrapperCtrl> productOptionWrapperLst = (List<KCPQ_ProductOptionWrapperCtrl>)JSON.deserialize(productOptionJSONStr, List<KCPQ_ProductOptionWrapperCtrl>.class);
        productOptionWrapperLst = KCPQ_Utility.getProductOptionWrapper(quoteId, prodObj);
        if(productOptionWrapperLst.size() > 0){
            return productOptionWrapperLst;
        }
        return null;
    }
    
    @AuraEnabled
    public static Integer getInventory(String productJSONStr){
        try{
            Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
            Set<Id> setProId = new Set<Id>();
            setProId.add(prodObj.Dummy_Product_Parent_Id__c);
            List<Product2> lstPro = new List<Product2>();
            if(setProId.size() > 0){
                lstPro = KCPQ_Utility.getListProducts(setProId);
            }
            //lstPro.add(prodObj);
            if(lstPro.size() > 0){
                List<KCPQ_InventoryWrapper> lstInventoryWrapper = KCPQ_Utility.getProductsInventory(lstPro);
                if(lstInventoryWrapper.size() > 0){
                    return lstInventoryWrapper[0].stockAvailable;
                }
            }
            return null;
        }catch(Exception ex){
            return null;
        }
    }
    
    @AuraEnabled
    public static Id doNext(String selectedProductIdsListJSONStr, String productJSONStr,Id quoteId){
        
        String str;
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        Type selIdArrType=Type.forName('List<Id>');
        List<Id> selectedProIds =(List<Id>) JSON.deserialize(selectedProductIdsListJSONStr, selIdArrType);
        selectedProIds.add(prodObj.Dummy_Product_Parent_Id__c);
        
        Set<Id> setQuoteLineProductIds = new Set<Id>();
        APIClassDefinitions.QuoteModel qModel = KCPQ_Utility.getQuoteModel(quoteId);
        for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
            setQuoteLineProductIds.add(qLineItems.record.SBQQ__Product__c);
        }
        //setQuoteLineProductIds = KCPQ_Utility.getQuoteLineProductIds(quoteId);
        
        Set<String> setProductAddingIds = new Set<String>();
        Set<Id> setQuoteLineProductDeleteIds = new Set<Id>();
        Set<Id> setAllSelectedProductIds = new Set<Id>();
        setAllSelectedProductIds.add(prodObj.Id);
        setAllSelectedProductIds.add(prodObj.Dummy_Product_Parent_Id__c);
        for(Id proId : selectedProIds){
            if(!setQuoteLineProductIds.contains(proId)){
                setProductAddingIds.add(proId+'');
            }
            setAllSelectedProductIds.add(proId);
        }
        //KCPQ_Utility.quoteLineItemsDelete(quoteId, setAllSelectedProductIds); 
        List<SBQQ__QuoteLine__c> lstQuoteLineItemsDelete = new List<SBQQ__QuoteLine__c>();
        //APIClassDefinitions.QuoteModel qModel = getQuoteModel(quoteId);
        for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
            if(!setAllSelectedProductIds.contains(qLineItems.record.SBQQ__Product__c)){
                lstQuoteLineItemsDelete.add(qLineItems.record);
            }
        }
        if(lstQuoteLineItemsDelete.size() > 0){
            delete lstQuoteLineItemsDelete;
        }   
        SBQQ__Quote__c quote = qModel.record;
        //SBQQ__Quote__c quote = KCPQ_Utility.getQuoteFromQuoteReader(quoteId+'');
       	if(Test.isRunningTest()==false)
        str = KCPQ_Utility.getQuoteIdAfterAddingProduct(prodObj, setProductAddingIds, quote.SBQQ__PriceBook__c, quoteId+'');
        if(str != null){
            return Id.valueOf(str);
        }else{
            return quoteId;
        }
    }
    
}