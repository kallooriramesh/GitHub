@isTest
public class KCPQ_ProductFeatureOptionsCtrl_Test {
    public static testMethod void setTestData()
    {
        Test.startTest();
        KCPQ_ProductFeatureOptionsCtrl.getbaseURL();
        KCPQ_ProductFeatureOptionsCtrl.getInitializeProductOptionWrapper();
        Product2 pr=new Product2();
        pr.name='Nokia';
        insert pr;
        KCPQ_ProductFeatureOptionsCtrl.getInventory(Json.serialize(pr));
        List<Id> selectedIds=new List<Id>();
        selectedIds.add(pr.Id);
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__PriceBook__c=Test.getStandardPricebookId();
        quote.SBQQ__PricebookId__c=Test.getStandardPricebookId();
        upsert quote;
        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        quoteLine.SBQQ__Quote__c = quote.Id;
        quoteLine.SBQQ__Product__c = pr.Id;
        upsert quoteLine;
        
        
        
        
        Product2 prod1 = new Product2();
        prod1.Name = 'HONDA-Brio';
        upsert prod1;
        
        SBQQ__ProductFeature__c prFeature =  new SBQQ__ProductFeature__c();
        prFeature.Name='Featur 1';
        prFeature.SBQQ__Number__c=1;
        prFeature.SBQQ__ConfiguredSKU__c=pr.id;
        prFeature.SBQQ__MinOptionCount__c=1;
        prFeature.SBQQ__MaxOptionCount__c=5;
        upsert prFeature;
        
        SBQQ__ProductOption__c prOption = new SBQQ__ProductOption__c();
        prOption.SBQQ__ConfiguredSKU__c = pr.Id;
        prOption.SBQQ__OptionalSKU__c = prod1.Id;
        prOption.SBQQ__Number__c=1;
        prOption.SBQQ__Feature__c=prFeature.id;
        upsert prOption;
        
        KCPQ_ProductOptionWrapperCtrl option = new KCPQ_ProductOptionWrapperCtrl();
        option.configuredSKU = pr.id;
        option.disabledMsg = 'Test';
        option.discountValue=100.00;
        option.featureId=prFeature.id;
        option.isCheckBox=true;
        option.isDisabled=false;
        option.optionalSKU=prod1.Id;
        List<KCPQ_ProductOptionWrapperCtrl> optionList=new List<KCPQ_ProductOptionWrapperCtrl>();
        optionList.add(option);
        KCPQ_ProductFeatureOptionsCtrl.getProductOptionWra(json.serialize(optionList), quote.Id,json.serialize(pr));
        KCPQ_ProductFeatureOptionsCtrl.doNext(json.serialize(selectedIds), Json.serialize(pr), quote.Id);
        KCPQ_ProductFeatureOptionsCtrl.getpathprefixURL();
        Test.stopTest();
    }
}