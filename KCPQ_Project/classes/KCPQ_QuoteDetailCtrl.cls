public class KCPQ_QuoteDetailCtrl {
    
    @AuraEnabled
    public static Product2 getMainProduct(Id quoteId){
        Product2 prod = KCPQ_Utility.getMainProductFromQuote(quoteId);
        return prod;
    }
    
    @AuraEnabled
    public static KCPQ_ProductWrapperCtrl getProductWrapper(String productJSONStr, Id quoteId){
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        return KCPQ_Utility.buildProductWrapperFromProduct(prodObj,quoteId);
    }
    
    @AuraEnabled
    public static List<String> getFeatureNames(String productJSONStr, Id quoteId){
        List<String> lstFeatureNames = new List<String>();
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        KCPQ_ProductWrapperCtrl proWra = KCPQ_Utility.buildProductWrapperFromProduct(prodObj,quoteId);
        Set<Id> setFeatureIds = new Set<Id>();
        for(KCPQ_ProductOptionWrapper proOptions : proWra.options){
            setFeatureIds.add(proOptions.featureId);
        }
        for(KCPQ_ProductFeatureWrapper proFeatures : proWra.features){
            if(setFeatureIds.contains(proFeatures.featureId) && proFeatures.maxOptionCount != 0){
                lstFeatureNames.add(proFeatures.featureName);
            }
        }
        if(lstFeatureNames.size() > 0){
            return lstFeatureNames;
        }
        return null;
    }
    
    @AuraEnabled
    public static List<String> getFeatureIds(String productJSONStr, Id quoteId){
        List<String> lstFeatureIds = new List<String>();
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        KCPQ_ProductWrapperCtrl proWra = KCPQ_Utility.buildProductWrapperFromProduct(prodObj,quoteId);
        Set<Id> setFeatureIds = new Set<Id>();
        for(KCPQ_ProductOptionWrapper proOptions : proWra.options){
            setFeatureIds.add(proOptions.featureId);
        }
        Set<Id> setLstIds = new Set<Id>();
        for(KCPQ_ProductFeatureWrapper proFeatures : proWra.features){
            if(setFeatureIds.contains(proFeatures.featureId) && !setLstIds.contains(proFeatures.featureId) && 
               proFeatures.maxOptionCount != 0){
                lstFeatureIds.add(proFeatures.featureId);
                setLstIds.add(proFeatures.featureId);
            }
        }
        if(lstFeatureIds.size() > 0){
            return lstFeatureIds;
        }
        return null;
    }
    
    @AuraEnabled
    public static List<String> getColorNamesLst(Id quoteId, String productJSONStr){
        
        List<String> lstColorNames = new List<String>();
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        
        APIClassDefinitions.QuoteModel qModel = KCPQ_Utility.getQuoteModel(quoteId);
        APIClassDefinitions.TinyQuoteModel tinyQuote = new APIClassDefinitions.TinyQuoteModel(); 
        tinyQuote.record = qModel.record; 
        APIClassDefinitions.TinyQuoteModel tinyQModel = tinyQuote;
        
        //APIClassDefinitions.TinyQuoteModel tinyQModel = KCPQ_Utility.setUpTinyQuote(quoteId);
        
        //Id pbookId = (KCPQ_Utility.getQuoteFromQuoteReader(quoteId+'')).SBQQ__PricebookId__c;
        Id pbookId = qModel.record.SBQQ__PricebookId__c;
        Id parentProId = prodObj.Id;
        APIClassDefinitions.ConfigLoadContext loadContext = new APIClassDefinitions.ConfigLoadContext(); 
        loadContext.quote = tinyQModel;
        loadContext.parentProduct = KCPQ_Utility.loadProductUsingProductAPI(parentProId,pbookId); 
        
        List<APIClassDefinitions.ProductModel> lstProductModel = new List<APIClassDefinitions.ProductModel>();
        String loadString = SBQQ.ServiceRouter.load('ConfigAPI.ConfigLoader', parentProId, JSON.serialize(loadContext)); 
        APIClassDefinitions.TinyProductModel loadModel = (APIClassDefinitions.TinyProductModel)JSON.deserialize(loadString, APIClassDefinitions.TinyProductModel.class);
        
        Map<Id,SBQQ__ProductFeature__c> mapFeature = new Map<Id,SBQQ__ProductFeature__c>();
        for(APIClassDefinitions.TinyFeatureModel tof : loadModel.features){
            mapFeature.put(tof.record.Id,tof.record);
        }
        
        if(loadModel.options.size() > 0){
            for(APIClassDefinitions.TinyOptionModel tom : loadModel.options){
                if((mapFeature.get(tom.record.SBQQ__Feature__c)).Name == 'Paint' || 
                   (mapFeature.get(tom.record.SBQQ__Feature__c)).Name == 'Color'){
                    lstColorNames.add(tom.record.SBQQ__ProductName__c);
                }
            }
        }
        if(lstColorNames.size() > 0){
            return lstColorNames;
        }
        return null;
    }
    
    @AuraEnabled
    public static Integer getProgressStageOrderValue(Id quoteId, String featureLstSizeJSON){
        Integer featureLstSize = (Integer) JSON.deserialize(featureLstSizeJSON, Integer.class);
        return KCPQ_Utility.getProgressStageOrderValue(quoteId, featureLstSize);
    }
    
}