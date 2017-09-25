@isTest
public class KCPQ_DiscountsCtrl_Test {
    static testMethod void testDiscountsCtrl()
    {
        Test.startTest();  
        String pricebookId = Test.getStandardPricebookId();
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__PricebookId__c = pricebookId; 
        upsert quote;
        Product2 prod = new Product2();
        prod.Name = 'HONDA';
        upsert prod;
        
        Product2 prod1 = new Product2();
        prod1.Name = 'HONDA-Brio';
        upsert prod1;
        upsert prod;
        
        SBQQ__ProductFeature__c prFeature =  new SBQQ__ProductFeature__c();
        prFeature.Name='Featur 1';
        prFeature.SBQQ__Number__c=1;
        prFeature.SBQQ__ConfiguredSKU__c=prod.id;
        prFeature.SBQQ__MinOptionCount__c=1;
        prFeature.SBQQ__MaxOptionCount__c=5;
        upsert prFeature;
        
        SBQQ__ProductOption__c prOption = new SBQQ__ProductOption__c();
        prOption.SBQQ__ConfiguredSKU__c = prod.Id;
        prOption.SBQQ__OptionalSKU__c = prod1.Id;
        prOption.SBQQ__Number__c=1;
        prOption.SBQQ__Feature__c=prFeature.id;
        upsert prOption;
        
        Set<Id> setSummaryProductIds = new Set<Id>();
        setSummaryProductIds.add(prod.Id);
        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        quoteLine.SBQQ__Quote__c = quote.Id;
        quoteLine.SBQQ__Product__c = prod.Id;
        upsert quoteLine;
        
        String productJSONStr = JSON.serialize(prod);
        KCPQ_DiscountsCtrl.getInventory(productJSONStr);
        KCPQ_DiscountsCtrl.getMainProductNetPriceValue(quote.Id, productJSONStr);
        KCPQ_DiscountsCtrl.getInitializeProductOptionWrapper();
        KCPQ_DiscountsCtrl.getSummaryWrapperFromQuoteLine(quote.Id);
        KCPQ_DiscountsCtrl.getMainProductDiscountVal(quote.Id, productJSONStr);
        List<KCPQ_ProductOptionWrapperCtrl> poList = new List<KCPQ_ProductOptionWrapperCtrl>();
        KCPQ_ProductOptionWrapperCtrl opw = new KCPQ_ProductOptionWrapperCtrl();
        opw.configuredSKU = prod.Id;
        opw.disabledMsg = 'dis';
        opw.featureId = prFeature.id;
        opw.featureRecord = prFeature;
        opw.isCheckBox = true;
        opw.isDisabled = true;
        opw.isSelected = true;
        opw.mapDependentIds = null;
        opw.mapProductIdFeatureRecord = null;
        opw.maxOptionCount = 10;
        opw.minOptionCount = 1;
        opw.netPrice = 100;
        opw.optionalSKU = null;
        opw.productDescription = 'Test';
        opw.productImage = 'test';
        opw.productName = 'test';
        opw.productRecordId = prod.id;
        opw.setControllingGroupDependentProductIds = null;
        opw.setDependentIds = null;
        opw.setDependentProductIds = null;
        opw.unitPrice = 1000;
        opw.setControllingGroupsIds=null;
        poList.add(opw);
        
        KCPQ_DiscountsCtrl.doNext(quote.Id, Json.serialize(poList), productJSONStr, '1000');
        KCPQ_DiscountsCtrl.getProductOptionWra(Json.serialize(poList), quote.Id, productJSONStr);
        KCPQ_DiscountsCtrl.getpathprefixURL();
        Test.stopTest();
    }
}