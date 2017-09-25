public class KCPQ_DiscountsCtrl {
    
    @AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
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
    public static List<KCPQ_FeatureProductsWrapper> getSummaryWrapperFromQuoteLine(Id quoteId){
        return KCPQ_Utility.getSummaryWrapperFromQuoteLine(quoteId);
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
    
    /*
    @AuraEnabled
    public static String doNext(Id quoteId, String myProductDiscountJSONStr, String productJSONStr){
        
        Type summProDiscountArrType=Type.forName('List<String>');
        List<String> lstMyProductDiscount =(List<String>) JSON.deserialize(myProductDiscountJSONStr, summProDiscountArrType);
        Map<String,String> mapProductDiscount = new Map<String,String>();
        for(String wp : lstMyProductDiscount){
            List<String> str = wp.split('<##>');
            if(str[1] != null){
                mapProductDiscount.put(str[0],str[1]);
            }else{
                mapProductDiscount.put(str[0],0+'');
            }
        }
        String startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId+''); 
        APIClassDefinitions.QuoteModel startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
        
        //List<SBQQ__QuoteLine__c> lstQuoteLine = new List<SBQQ__QuoteLine__c>();
        for(APIClassDefinitions.QuoteLineModel qline : startingModel.lineItems){
            qline.record.SBQQ__Discount__c = 0;
            try{
                qline.record.SBQQ__Discount__c = Decimal.valueOf(mapProductDiscount.get(qline.record.SBQQ__Product__c + ''));
            }catch(Exception e){}
            //lstQuoteLine.add(qline.record);
        }
        /*if(lstQuoteLine.size() > 0){
            upsert lstQuoteLine;
        }
        String savedJson = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(startingModel)); 
        return startingModel.record.Id;
        */
        //Calculate API
        /*Decimal startingTotal = startingModel.netTotal;
        APIClassDefinitions.CalculatorContext context = new APIClassDefinitions.CalculatorContext(); 
        context.quote = startingModel; 
        String resultJson = SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteCalculator', null, JSON.serialize(context)); 
        APIClassDefinitions.QuoteModel resultModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(resultJson, APIClassDefinitions.QuoteModel.class);
        String savedJson = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(resultModel));
        return startingModel.record.Id;
        //featureProductsWrapperLst = KCPQ_Utility.getSummaryWrapperFromQuoteLine(quoteId);
        //return quoteId;
    }*/
    
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
    public static List<KCPQ_ProductOptionWrapperCtrl> doNext(Id quoteId, String myProductDiscountJSONStr, String productJSONStr, String mainProductDiscountVal){
        
        List<KCPQ_ProductOptionWrapperCtrl> myProductOptionsLst = new List<KCPQ_ProductOptionWrapperCtrl>();
        if(myProductDiscountJSONStr != null){
            myProductOptionsLst = (List<KCPQ_ProductOptionWrapperCtrl>)JSON.deserialize(myProductDiscountJSONStr, List<KCPQ_ProductOptionWrapperCtrl>.class);
        }
        Product2 prodObj = (Product2)JSON.deserialize(productJSONStr, Product2.class);
        Decimal mainProductDisValue =(Decimal) JSON.deserialize(mainProductDiscountVal, Decimal.class);
        
        Map<Id,Decimal> mapProductIdDiscountValue = new Map<Id,Decimal>();
        Set<String> setProdIds = new Set<String>();
        if(mainProductDisValue == null){
            mapProductIdDiscountValue.put(prodObj.Id,0);
            mapProductIdDiscountValue.put(prodObj.Dummy_Product_Parent_Id__c,0);
        }else{
            mapProductIdDiscountValue.put(prodObj.Id,mainProductDisValue);
            mapProductIdDiscountValue.put(prodObj.Dummy_Product_Parent_Id__c,mainProductDisValue);
        }
        
        /*Set<Id> setQuoteLineProductIds = new Set<Id>();
        Set<Id> setDeleteIds = new Set<Id>();
        setDeleteIds.add(prodObj.Id);
        setQuoteLineProductIds = KCPQ_Utility.getQuoteLineProductIds(quoteId);*/
        
        if(myProductOptionsLst != null && myProductOptionsLst.size() > 0){
            for(KCPQ_ProductOptionWrapperCtrl prodOpt : myProductOptionsLst){
                mapProductIdDiscountValue.put(prodOpt.productRecordId,0);
                try{
                    mapProductIdDiscountValue.put(prodOpt.productRecordId,prodOpt.discountValue);
                }catch(Exception e){}
                /*if(prodOpt.isSelected == true){
                    if(!setQuoteLineProductIds.contains(prodOpt.productRecordId)){
                        setProdIds.add(prodOpt.productRecordId);
                    }
                    setDeleteIds.add(prodOpt.productRecordId);
                }*/
            }
        }
        
        /*APIClassDefinitions.QuoteModel qModel = KCPQ_Utility.getQuoteModel(quoteId);
        if(setQuoteLineProductIds.size() > 1){
            //KCPQ_Utility.quoteLineItemsDelete(quoteId, setDeleteIds);
            List<SBQQ__QuoteLine__c> lstQuoteLineItemsDelete = new List<SBQQ__QuoteLine__c>();
            for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
                if(!setDeleteIds.contains(qLineItems.record.SBQQ__Product__c)){
                    lstQuoteLineItemsDelete.add(qLineItems.record);
                }
            }
            if(lstQuoteLineItemsDelete.size() > 0){
                delete lstQuoteLineItemsDelete;
            }
        }
        
        //SBQQ__Quote__c quote = KCPQ_Utility.getQuoteFromQuoteReader(quoteId);
        //Id pbookId = quote.SBQQ__PricebookId__c;
        Id pbookId = qModel.record.SBQQ__PricebookId__c;
        if(setProdIds.size() > 0){
            quoteId = KCPQ_Utility.getQuoteIdAfterAddingProduct(prodObj,setProdIds,pbookId+'',quoteId+'');
        }*/
        
        String startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId+''); 
        APIClassDefinitions.QuoteModel startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class);
        
        for(APIClassDefinitions.QuoteLineModel qline : startingModel.lineItems){
            qline.record.SBQQ__Discount__c = 0;
            try{
                if(mapProductIdDiscountValue.containsKey(qline.record.SBQQ__Product__c)){
                    qline.record.SBQQ__Discount__c = mapProductIdDiscountValue.get(qline.record.SBQQ__Product__c);
                }
            }catch(Exception e){}
        } 
        
        Decimal startingTotal = startingModel.netTotal;
        APIClassDefinitions.CalculatorContext context = new APIClassDefinitions.CalculatorContext(); 
        context.quote = startingModel; 
        String resultJson = SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteCalculator', null, JSON.serialize(context)); 
        APIClassDefinitions.QuoteModel resultModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(resultJson, APIClassDefinitions.QuoteModel.class);
        String savedJson = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(resultModel));
        Map<Id,Decimal> mapLineProductIdDisValue = new Map<Id,Decimal>();
        for(APIClassDefinitions.QuoteLineModel qline : resultModel.lineItems){
            mapLineProductIdDisValue.put(qline.record.SBQQ__Product__c, qline.record.SBQQ__NetPrice__c);
        }
        
        List<KCPQ_ProductOptionWrapperCtrl> lstKCPQ_ProductOptionWrapperCtrl = new List<KCPQ_ProductOptionWrapperCtrl>();
        if(myProductOptionsLst != null && myProductOptionsLst.size() > 0){
            for(KCPQ_ProductOptionWrapperCtrl prodOpt : myProductOptionsLst){
                if(mapLineProductIdDisValue.containsKey(prodOpt.productRecordId)){
                    prodOpt.unitPrice = mapLineProductIdDisValue.get(prodOpt.productRecordId);
                }
                lstKCPQ_ProductOptionWrapperCtrl.add(prodOpt);
            }
        }
        if(lstKCPQ_ProductOptionWrapperCtrl.size() > 0){
            return lstKCPQ_ProductOptionWrapperCtrl;
        }
        return null;
    }
}