@isTest
public class KCPQ_Utility_Test {
    public static Id pricebookId;
    public static SBQQ__Quote__c quote;
    public static Contact cont;
    public static Account acc;
    public static Account a;
    public static Contact c;
    public enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }

    public static testMethod void setTestData()
    {
        pricebookId = Test.getStandardPricebookId(); 
        quote = new SBQQ__Quote__c();
        usertest();
        /*cont = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            //AccountId = portalAccount1.Id,
            Email = 'Test123@KCPQ.com'
        );*/
        
    }
    static testMethod void testcreateQuote()
    {
        Test.startTest();
        setTestData();
        insert quote;
        
        KCPQ_Utility util = new KCPQ_Utility();
        KCPQ_Utility.createQuote(pricebookId,quote.Id);
        Test.stopTest();
    }
    
    
    static testMethod void testgetContactRecord()
    {
        Test.startTest();
        setTestData();
        
        
        Database.upsert(cont);
        quote.SBQQ__PrimaryContact__c=cont.Id;
        upsert quote;
        
        
        KCPQ_Utility.getContactDetails(cont.Id);
        KCPQ_Utility.getContactRecord(quote.Id, cont);
        Test.stopTest();
    }
    
    static testMethod void testdoSaveContactInformation()
    {
        Test.startTest();
        setTestData();
        upsert quote;
        cont.Email='keste@customer.com';
        upsert cont;
        //KCPQ_Utility.doSaveContactInformation(quote.Id, cont);
        //User.UserRole=[select UserRoleId from UserRole where Name='CEO'].UserRoleId;
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        acc = new Account(
            RecordTypeID=recordTypeId,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='KESTE HYD',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=cont.Email,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678' 
        );
        
        upsert acc;
        
        KCPQ_Utility.doSaveContactInformation(quote.Id, cont);
        //cont.Email = 'Abcd@keste.com';
        //upsert cont;
        quote.SBQQ__PrimaryContact__c = cont.id;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName = 'Draft';
        opp.CloseDate = System.today()+7;
        insert opp;
        quote.SBQQ__Opportunity2__c = opp.Id;
        upsert quote;
        KCPQ_Utility.doSaveContactInformation(quote.Id, cont);
        quote.SBQQ__PrimaryContact__c=null;
        upsert quote;
        KCPQ_Utility.doSaveContactInformation(quote.Id, cont);
        
        cont.Email = 'Contact_Keste@Keste.com';
        upsert cont;
        quote.SBQQ__PrimaryContact__c = null;
        upsert quote;
        KCPQ_Utility.doSaveContactInformation(quote.Id, cont);
        
        Test.stopTest();
    }
    
    static testMethod void testgetQuoteFromQuoteReader()
    {
        Test.startTest();
        setTestData();
        upsert quote;
        KCPQ_Utility.getQuoteFromQuoteReader(quote.Id);
        Test.stopTest();
        
    }
    
    static testMethod void testgetQuoteModel()
    {
        Test.startTest();
        setTestData();
        upsert quote;
        KCPQ_Utility.getQuoteModel(quote.Id);
        Test.stopTest();
        
    }
    
    static testMethod void testsetUpTinyQuote()
    {
        Test.startTest();
        setTestData();
        upsert quote;
        KCPQ_Utility.setUpTinyQuote(quote.Id);
        Test.stopTest();
        
    }
    
    static testMethod void testloadProductUsingProductAPI()
    {
        Test.startTest();
        setTestData();
        //upsert quote;
        Product2 prod = new Product2();
        prod.Name = 'HONDA';
        insert prod;
        KCPQ_Utility.loadProductUsingProductAPI(prod.Id, pricebookId);
        Test.stopTest();
        
    }
    static testMethod void testgetMainProductFromQuote()
    {
        Test.startTest();
        setTestData();
        upsert quote;
        Product2 prod = new Product2();
        prod.Name = 'HONDA';
        
        upsert prod;
        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        quoteLine.SBQQ__Quote__c = quote.Id;
        quoteLine.SBQQ__Product__c = prod.Id;
        quoteline.SBQQ__Number__c =1;
        upsert quoteLine;
        KCPQ_Utility.getMainProductFromQuote(quote.Id);
        KCPQ_Utility.getQuoteLineProductIds(quote.Id);
        Test.stopTest();
        
    }
    public static testMethod void testgetProductsForGuidedSelling()
    {
        Test.startTest();
        setTestData();
       
        SBQQ__QuoteProcess__c process = new SBQQ__QuoteProcess__c();
        process.Name = 'Test Process';
        insert process;
        quote.SBQQ__QuoteProcessId__c=process.id;
        upsert quote;
        
        KCPQ_Utility.getProductsForGuidedSelling(process.id, quote, new Product2());
        Test.stopTest();
    }
    
    static testMethod void testbuildProcessInputWrapper()
    {
        Test.startTest();
        SBQQ__QuoteProcess__c process = new SBQQ__QuoteProcess__c();
        process.Name = 'Test Process';
        upsert process;
        SBQQ__ProcessInput__c processInput= new SBQQ__ProcessInput__c();
        processInput.Name='Input Process';
        processInput.SBQQ__QuoteProcess__c = process.Id;
        processInput.SBQQ__Label__c = 'TEST Label';
        processInput.SBQQ__InputField__c = 'Type_of_Accessory__c';
        processInput.SBQQ__ConditionsMet__c = 'All';
        processInput.SBQQ__DisplayOrder__c = 1;
        upsert processInput;
        KCPQ_Utility.buildProcessInputWrapper(processInput);
        Test.stopTest();
        
    }
    
    static testMethod void testgetProcessInputFromWrapper()
    {
        Test.startTest();
        KCPQ_ProcessInputWrapperCtrl piWra = new KCPQ_ProcessInputWrapperCtrl();
        piWra.label = 'Label';
        piWra.productField ='Name';
        KCPQ_Utility.getProcessInputFromWrapper(piWra);
        Test.stopTest();
    }
    
    static testMethod void testgetQuoteIdAfterAddingProduct()
    {
        Test.startTest();
        setTestData();
        upsert quote;
        Product2 prod = new Product2();
        prod.Name = 'HONDA';
        upsert prod;
        set<String> setProductIds =new Set<String>();
        setProductIds.add(prod.Id);
        KCPQ_Utility.getQuoteIdAfterAddingProduct(prod.id, pricebookId, quote.Id);
        KCPQ_Utility.getQuoteIdAfterAddingProduct(prod, prod.Id, pricebookId, quote.Id);
        KCPQ_Utility.getQuoteIdAfterAddingProduct(prod, setProductIds, pricebookId, quote.Id);
        set<ID> setProductIds1 =new Set<ID>();
        setProductIds1.add(prod.Id);
        KCPQ_Utility.getListProducts(setProductIds1);
        Test.stopTest();
    }
    
    static testMethod void testbuildProductWrapperFromProduct()
    {
        Test.startTest();
        setTestData();
        upsert quote;
        Product2 prod = new Product2();
        prod.Name = 'HONDA';
        upsert prod;
        KCPQ_Utility.buildProductWrapperFromProduct(prod, quote.Id);
        Test.stopTest();
    }
    
    
    static testMethod void testquoteLineItemsDelete()
    {
        Test.startTest();
        setTestData();
        
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
        
        KCPQ_Utility.quoteLineItemsDelete(quote.Id, setSummaryProductIds);
        KCPQ_Utility.getProductIdsFromPricebookEntries(quote.Id);
        KCPQ_Utility.getSummaryWrapperFromQuoteLine(quote.Id);
        
        KCPQ_Utility.SubmitQuote(quote.Id, prod);
        List<Product2> products = new List<Product2>();
        products.add(prod);
        KCPQ_Utility.getProductsInventory(products);
        quote.SBQQ__Status__c='Draft';
        upsert quote;
        KCPQ_Utility.getProgressStageOrderValue(quote.Id,1);
        quote.SBQQ__Status__c=null;
        upsert quote;
        KCPQ_Utility.getProgressStageOrderValue(quote.Id,0);
        KCPQ_Utility.getProgressStageOrderValue(quote.Id,3);
        Test.stopTest();
    }
    
    public static testMethod void testgetPricebookPicklist()
    {
        Test.startTest();
        KCPQ_Utility.getPricebookPicklist();
        KCPQ_Utility.getQuoteProcessPicklist();
        Test.stopTest();
    }
    
    public static testMethod void testgetProductOptionWrapper(){
        Test.startTest();
        setTestData();
        quote.SBQQ__PricebookId__c=pricebookId;
        upsert quote;
        Product2 prod = new Product2();
        prod.Name = 'HONDA';
        Product2 prod1 = new Product2();
        prod1.Name = 'HONDA-Brio';
        upsert prod1;
        upsert prod;
        
        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        quoteLine.SBQQ__Quote__c = quote.Id;
        quoteLine.SBQQ__Product__c = prod.Id;
        upsert quoteLine;
        
        
        
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
        
        KCPQ_Utility.getProductOptionWrapper(quote.Id, prod);
        Test.stopTest();
    }
    public static testMethod void testKCPQ_LoginCtrl(){
        Test.startTest();
        KCPQ_LoginCtrl.getbaseURL();
        Test.stopTest();
    }
    
    
    
  public static testmethod void usertest() {
        User pu = getPortalUser(PortalType.PowerPartner, null, true);
        System.assert([select isPortalEnabled 
                         from user 
                        where id = :pu.id].isPortalEnabled,
                      'User was not flagged as portal enabled.');       
        
        System.RunAs(pu) {
            System.assert([select isPortalEnabled 
                             from user 
                            where id = :UserInfo.getUserId()].isPortalEnabled, 
                          'User wasnt portal enabled within the runas block. ');
        }
    }
    
     public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
    
        /* Make sure the running user has a role otherwise an exception 
           will be thrown. */
        if(userWithRole == null) {   
            
            if(UserInfo.getUserRoleId() == null) {

                UserRole r = new UserRole(name = 'TEST ROLE');
                Database.insert(r);
                
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            
            System.assert(userWithRole.userRoleId != null, 
                          'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }

        
        System.runAs(userWithRole) {

            acc = new Account(name = 'TEST ACCOUNT');
            Database.insert(acc);
            
            cont = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = acc.Id,
            Email = 'Test123@KCPQ.com'
                );
            //cont = new Contact(AccountId = acc.id, lastname = 'lastname');
            Database.insert(cont);

        }
        
        /* Get any profile for the given type.*/
        Profile p = [select id 
                      from profile 
                     where usertype = :portalType.name() 
                     limit 1];   
        System.debug('p'+p);
         System.debug('portalType.name()'+portalType.name());
        String testemail = 'puser000@keste.com';
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = cont.id);
        
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
    }
}