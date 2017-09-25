@isTest
public class APIClassDefinitions_Test {
    private class ProductModel { 
        public Product2 record; 
        public String currencyCode; 
    } 
    public static testMethod void testAPIClassDefinitions()
    {
        Test.startTest();
        //APIClassDefinitions.ProductModel
        //APIClassDefinitions def = new APIClassDefinitions();
        
      
        
        APIClassDefinitions.ProductModel prModel = new APIClassDefinitions.ProductModel();
        Product2 prod = prModel.record;
        Id upgradedAssetId = prModel.upgradedAssetId;
        String currencySymbol = prModel.currencySymbol;
        String currencyCode = prModel.currencyCode;
        String[] featureCategories = prModel.featureCategories;
        prModel.options = null;
        APIClassDefinitions.FeatureModel[] farray= prModel.features;
        APIClassDefinitions.ConfigurationModel conModel = prModel.configuration;
        APIClassDefinitions.ConfigAttributeModel[] configMd = prModel.configurationAttributes;
        APIClassDefinitions.ConfigAttributeModel[]  conAttModel = prModel.inheritedConfigurationAttributes;
        APIClassDefinitions.OptionModel opModel= new APIClassDefinitions.OptionModel();
        
        
        APIClassDefinitions.ProductLoadContext pc = new APIClassDefinitions.ProductLoadContext();
        pc.currencyCode = 'USD';
        pc.pricebookId = Test.getStandardPricebookId();
        System.assertEquals('USD',pc.currencyCode);
        
        //configModel.
        //APIClassDefinitions.ConstraintModel cModel= new APIClassDefinitions.ConstraintModel();
        //cModel.priorOptionExists=true;
        //cModel.record=null;
        Test.stopTest();
    }
}