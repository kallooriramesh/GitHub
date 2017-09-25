@isTest
public class KCPQ_BuildWizardCtrl_Test {
    public static testMethod void setTestData()
    {
        Test.startTest();
        string productJSONStr;
        Product2 prod = new Product2();
        prod.Name = 'Maruthi';
        upsert prod;
        KCPQ_BuildWizardCtrl.getInventory(productJSONStr);
        productJSONStr = Json.serialize(prod);
        KCPQ_BuildWizardCtrl.getInventory(productJSONStr);
        List<String> featureNames = new List<String>();
        SBQQ__ProductFeature__c prFeature =  new SBQQ__ProductFeature__c();
        prFeature.Name='Featur 1';
        prFeature.SBQQ__Number__c=1;
        prFeature.SBQQ__ConfiguredSKU__c=prod.id;
        prFeature.SBQQ__MinOptionCount__c=1;
        prFeature.SBQQ__MaxOptionCount__c=5;
        upsert prFeature;
        KCPQ_BuildWizardCtrl.getProgressBar(featureNames);
        featureNames.add(prFeature.Name);
        KCPQ_BuildWizardCtrl.getProgressBar(featureNames);
        Test.stopTest();
    }
}