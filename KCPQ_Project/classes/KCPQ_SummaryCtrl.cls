public class KCPQ_SummaryCtrl {
    
    @AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
    }
    
    @AuraEnabled
    public static List<KCPQ_FeatureProductsWrapper> getSummaryWrapperFromQuoteLine(Id quoteId){
        return KCPQ_Utility.getSummaryWrapperFromQuoteLine(quoteId);
    }
    
    @AuraEnabled
    public static String doSubmitQuote(Id quoteId, String productJSONStr){
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        return KCPQ_Utility.SubmitQuote(quoteId, prodObj);
    }
    
    @AuraEnabled
    public static Decimal getMainProductNetPriceValue(Id quoteId, String productJSONStr){
        Decimal mainProductNetPrice = 0;
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        APIClassDefinitions.QuoteModel qModel = KCPQ_Utility.getQuoteModel(quoteId);
         for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
            if(qLineItems.record.SBQQ__Product__c == prodObj.Id || 
               qLineItems.record.SBQQ__Product__c == prodObj.Dummy_Product_Parent_Id__c){
                mainProductNetPrice = qLineItems.record.SBQQ__NetPrice__c;
                break;
            }
        }
        return mainProductNetPrice;
    }
    
    @AuraEnabled
    public static Decimal getMainProductDiscountVal(Id quoteId, String productJSONStr){
        Decimal mainProductDiscountValue = 0;
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        APIClassDefinitions.QuoteModel qModel = KCPQ_Utility.getQuoteModel(quoteId);
        for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
            if(qLineItems.record.SBQQ__Product__c == prodObj.Id || 
               qLineItems.record.SBQQ__Product__c == prodObj.Dummy_Product_Parent_Id__c){
                mainProductDiscountValue = qLineItems.record.SBQQ__Discount__c;
                break;
            }
        }
        return mainProductDiscountValue;
    }
    
    @AuraEnabled
    public static List<KCPQ_ProductOptionWrapperCtrl> getProductOptionWra(Id quoteId, String productJSONStr){
        
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        List<KCPQ_ProductOptionWrapperCtrl> productOptionWrapperLst = new List<KCPQ_ProductOptionWrapperCtrl>();
        productOptionWrapperLst = KCPQ_Utility.getProductOptionWrapper(quoteId, prodObj);
        if(productOptionWrapperLst.size() > 0){
            return productOptionWrapperLst;
        }
        return null;
    }
    
    @AuraEnabled
    public static List<KCPQ_FeatureProductCountWrapper> getFeatureProductCountWrap(Id quoteId, String productJSONStr, String featureNamesJSONStr){
        
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        List<String> lstFeatureNames = (List<String>)JSON.deserialize(featureNamesJSONStr, List<String>.class);
        List<KCPQ_FeatureProductCountWrapper> lstFeatureProductCountWrapper = new List<KCPQ_FeatureProductCountWrapper>();
        
        APIClassDefinitions.QuoteModel qModel = KCPQ_Utility.getQuoteModel(quoteId);
        APIClassDefinitions.TinyQuoteModel tinyQuote = new APIClassDefinitions.TinyQuoteModel(); 
        tinyQuote.record = qModel.record; 
        APIClassDefinitions.TinyQuoteModel tinyQModel = tinyQuote;
        //APIClassDefinitions.TinyQuoteModel tinyQModel = KCPQ_Utility.setUpTinyQuote(quoteId);
        
        APIClassDefinitions.ConfigLoadContext loadContext = new APIClassDefinitions.ConfigLoadContext(); 
        loadContext.quote = tinyQModel;
        //loadContext.parentProduct = loadProductUsingProductAPI(parentProId,pbookId); 
        
        List<APIClassDefinitions.ProductModel> lstProductModel = new List<APIClassDefinitions.ProductModel>();
        String loadString = SBQQ.ServiceRouter.load('ConfigAPI.ConfigLoader', prodObj.Id, JSON.serialize(loadContext)); 
        APIClassDefinitions.TinyProductModel loadModel = (APIClassDefinitions.TinyProductModel)JSON.deserialize(loadString, APIClassDefinitions.TinyProductModel.class);
        
        Map<Id,SBQQ__ProductFeature__c> mapFeature = new Map<Id,SBQQ__ProductFeature__c>();
        for(APIClassDefinitions.TinyFeatureModel tof : loadModel.features){
            mapFeature.put(tof.record.Id,tof.record);
        }
        
        Map<Id,String> mapProductFeatureName = new Map<Id,String>();
        for(APIClassDefinitions.TinyOptionModel tom : loadModel.options){
            mapProductFeatureName.put(tom.record.SBQQ__OptionalSKU__c, mapFeature.get(tom.record.SBQQ__Feature__c).Name);
        }
        
        //String startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId); 
        //APIClassDefinitions.QuoteModel startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
        
        Map<String,List<Id>> mapFeatureProductlst = new Map<String,List<Id>>();
        //for(APIClassDefinitions.QuoteLineModel qli : startingModel.lineItems){
        for(APIClassDefinitions.QuoteLineModel qli : qModel.lineItems){
            if(!mapFeatureProductlst.containsKey(mapProductFeatureName.get(qli.record.SBQQ__Product__c))){
                mapFeatureProductlst.put(mapProductFeatureName.get(qli.record.SBQQ__Product__c),new List<Id>());
            }
            mapFeatureProductlst.get(mapProductFeatureName.get(qli.record.SBQQ__Product__c)).add(qli.record.SBQQ__Product__c);
        }
        
        if(lstFeatureNames != null && lstFeatureNames.size() > 0){
            for(String str : lstFeatureNames){
                KCPQ_FeatureProductCountWrapper featureProCount = new KCPQ_FeatureProductCountWrapper();
                featureProCount.featureName = str;
                if(mapFeatureProductlst.containsKey(str)){
                    featureProCount.productsCount = (mapFeatureProductlst.get(str)).size();
                }else{
                    featureProCount.productsCount = 0;
                }
                lstFeatureProductCountWrapper.add(featureProCount);
            }
        }
        
        if(lstFeatureProductCountWrapper.size() > 0){
            return lstFeatureProductCountWrapper;
        }
        return null;
    }
}