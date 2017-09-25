public class KCPQ_Inventory_CheckCtrl {

    @AuraEnabled
    public static List<KCPQ_InventoryWrapper> getProducts()
    {
        List<Product2> products=[Select ID,Name,Product_Image__c,Product_Image_New__c,Exterior_Shade__c,Interior_Shade__c
                                 FROM Product2 where isActive=true AND isInventoryProduct__c=TRUE 
                                ORDER BY NAME LIMIT 1000];
        return KCPQ_Utility.getProductsInventory(products);
        
    }
    
    @AuraEnabled
    public static String  createProductQuote(String productId)
    {
        System.debug('productId...'+productId);
        String priceBookId = [Select ID,Name,Pricebook2Id from PriceBookEntry where Product2Id=:productId].Pricebook2Id;
        KCPQ_Utility.createQuote(priceBookId, null);
        SBQQ__Quote__c quoteRecord = KCPQ_Utility.createQuote(priceBookId, null);
        System.debug('quoteRecord...'+quoteRecord);
        if(quoteRecord != null)
        return KCPQ_Utility.getQuoteIdAfterAddingProduct(productId, priceBookId, quoteRecord.Id);
        else
            return null;
        
    }
        
    
}