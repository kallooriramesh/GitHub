public class KCPQ_BuildWizardCtrl {
    
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
    public static List<KCPQ_ProgressBarWrapper> getProgressBar(List<String> featureNames){
        
        List<KCPQ_ProgressBarWrapper> lstProgressBar = new List<KCPQ_ProgressBarWrapper>();
        lstProgressBar.add(new KCPQ_ProgressBarWrapper('Contact Information',1));
        
        if(featureNames != null && featureNames.size() > 0){
            Integer i = 2;
            for(String str : featureNames){
                lstProgressBar.add(new KCPQ_ProgressBarWrapper(str,i));
                i++;
            }
            lstProgressBar.add(new KCPQ_ProgressBarWrapper('Discounts',(featureNames.size() + 2)));
            lstProgressBar.add(new KCPQ_ProgressBarWrapper('Summary',(featureNames.size() + 3)));
        }else{
            lstProgressBar.add(new KCPQ_ProgressBarWrapper('Discounts',2));
            lstProgressBar.add(new KCPQ_ProgressBarWrapper('Summary',3));
        }
        
        if(lstProgressBar.size() > 0){
            return lstProgressBar;
        }
        return null;
    }
    
    /*@AuraEnabled
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
    }*/
}