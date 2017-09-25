@isTest
private class KCPQ_SAQ_PBSelectionCtrl_Test {
    public static Contact cont;
    public static Account acc;
    public enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
  
    static testMethod void validateKCPQ_SAQ_ProductsCtrl()
    {
        System.Test.startTest();
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 product = new Product2();
        product.Name = 'DELL Latitude';
        Product.IsActive = true;
        Product.isInventoryProduct__c=true;
        insert product;
        
        PriceBookEntry pEntry = new PriceBookEntry();
        pEntry.IsActive = true;
        pEntry.Pricebook2Id = pricebookId;
        pEntry.Product2Id = product.Id;
        pEntry.UnitPrice = 1000;
        insert pEntry;
        
        String quoteId = KCPQ_Utility.createQuote(pricebookId, null).ID;
        KCPQ_SAQ_ProductsCtrl.createQuoteLineItems(product.id, pricebookId, quoteId);
        KCPQ_SAQ_ProductsCtrl.getProductsWithGroup(quoteId, 'Body_Style__c');
        System.Test.stopTest();
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
            
            
            System.Test.startTest();
            Product2 product = new Product2();
            product.Name = 'DELL Latitude';
            Product.IsActive = true;
            insert product;
            
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            System.assertNotEquals(null, KCPQ_SAQ_PBSelectionCtrl.getPricebookPicklist());
            KCPQ_SAQ_PBSelectionCtrl.createPriceBookQuote(Test.getStandardPricebookId());
            SBQQ__Quote__c quote= new SBQQ__Quote__c();
            
            insert quote;
            KCPQ_SAQ_PBSelectionCtrl.getProductsForQuote(KCPQ_Utility.createQuote(Test.getStandardPricebookId(),quote.Id).id);
            
        }
        
        /* Get any profile for the given type.*/
        Profile p = [select id 
                     from profile 
                     where usertype = :portalType.name() 
                     limit 1];   
        
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