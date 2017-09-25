public class KCPQ_Utility {    
    
    public KCPQ_Utility(){
        
    }
    
    /*====
        Create SBQQ__Quote__c Record
    ====*/
    //Method used to create quote record
    public static SBQQ__Quote__c createQuote(String pbookId,String quoteProId){
        try{
            Id userAccId = null;
            Id userConId = null;
            for(User u : [SELECT Id, Name, ContactId, AccountId, Account.Name FROM User WHERE Id =: UserInfo.getUserId() Limit 1]){
                if(u.ContactId != null){
                    userConId = u.ContactId;
                }
            }
            if(userConId != null){
                for(Contact c : [SELECT Id, Name, AccountId FROM Contact WHERE Id =: userConId Limit 1]){
                    userAccId = c.AccountId;
                }
            }
            SBQQ__Quote__c quoteRec = new SBQQ__Quote__c(); 
            quoteRec.SBQQ__PricebookId__c = pbookId;
            if(quoteProId != null){
                quoteRec.SBQQ__QuoteProcessId__c = quoteProId;
            }
            quoteRec.SBQQ__StartDate__c = System.today();
            quoteRec.SBQQ__SalesRep__c = UserInfo.getUserId();
            quoteRec.SBQQ__Primary__c = true;
            quoteRec.SBQQ__Type__c = 'Quote';
            if(userAccId != null){
                quoteRec.SBQQ__Account__c = userAccId;
            }
            insert quoteRec;
            
            String quoteRecName = null;
            for(SBQQ__Quote__c quote : [SELECT Id,Name FROM SBQQ__Quote__c WHERE Id =: quoteRec.Id Limit 1]){
                quoteRecName = quote.Name;
            }
            
            Opportunity opp = new Opportunity(); 
            opp.Name = quoteRecName + ' Opportunity';
            
            if(userAccId != null){
                opp.AccountId = userAccId;
            }
            opp.CloseDate = System.today();
            opp.StageName = 'Prospecting';
            opp.SBQQ__QuotePricebookId__c = pbookId;
            insert opp;
            
            quoteRec.SBQQ__Opportunity2__c = opp.Id;
            update quoteRec;
            
            return quoteRec;
        }catch(Exception ex){
            return null;
        }
    }
    
    /*====
        Related to Contact Information
    ====*/
    //Method used to save the contact information and Update Quote Record
    public static Contact getContactRecord(Id quoteId, Contact cont){
        SBQQ__Quote__c quoteRecord = [SELECT Id,Name,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
        if(quoteRecord.SBQQ__PrimaryContact__c != null){
            return getContactDetails(quoteRecord.SBQQ__PrimaryContact__c);
        } else {
            return cont;
        }
    }
    
    //Method used to getContactDetails by passing contact Id For KCPQ_ContactInformation Lightning component
    public static Contact getContactDetails(Id conId){
        List<Schema.FieldSetMember> contactFields = SObjectType.Contact.FieldSets.KCPQ_ContactInformation.getFields();
        String strQuery = '';
        strQuery = 'SELECT ';
        for(Schema.FieldSetMember f : contactFields) {
            strQuery += f.getFieldPath() + ', ';
        }
        strQuery = strQuery.substring(0, strQuery.lastIndexOf(','));
        strQuery += ' FROM Contact WHERE Id =\''+conId+'\'';
        List<Contact> lstContact = (List<Contact>)Database.query(strQuery);
        if(lstContact.size() > 0){
            return lstContact.get(0);
        }
        return null;
    }
    
    //Method used to save the contact information and Update Quote Record
    public static String doSaveContactInformation(Id quoteId,Contact cont){
        Account personAcc;
        Set<String> setFieldNames = new Set<String>();
        for(Schema.FieldSetMember field : SObjectType.Contact.FieldSets.getMap().get('KCPQ_ContactInformation').getFields()) {
            if(field.required == true || field.dbrequired == true){
                setFieldNames.add(field.getFieldPath());
            }
        }
        for(String str : setFieldNames){
            if(cont.get(str) == '' || cont.get(str) == null){
                return 'ERROR : Required Fields Are Missing';
                break;
            }
            if(str == 'Email' || str == 'PersonEmail'){
                String strEmail = cont.get(str) + '';
                if(!validateEmail(strEmail.trim())){
                    return 'ERROR : Email: Invalid email address';
                    break;
                }
            }
        }
        String startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId); 
        APIClassDefinitions.QuoteModel startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
            
        String strQuery = '';
        /*strQuery = 'SELECT ';
        for(String fNamestr : setFieldNames) {
            strQuery += fNamestr + ', ';
        }
        strQuery = strQuery.substring(0, strQuery.lastIndexOf(','));
        strQuery += ' FROM Contact WHERE Email =\''+cont.Email+'\'';
        List<Contact> lstContact = (List<Contact>)Database.query(strQuery);
        Boolean isDuplicateEmail = false;
        if(lstContact.size() > 0){
            isDuplicateEmail = true;
            cont = lstContact.get(0);
        }*/
        strQuery = 'SELECT Id, PersonContactId, FirstName, LastName, PersonEmail,PersonMobilePhone ';
        //strQuery = strQuery.substring(0, strQuery.lastIndexOf(','));
        strQuery += ' FROM Account WHERE PersonEmail =\''+cont.Email+'\'';
        List<Account> lstAccount = (List<Account>)Database.query(strQuery);
        
        Boolean isDuplicateEmail = false;
        if(lstAccount.size() > 0){
            isDuplicateEmail = true;
            personAcc = lstAccount.get(0);
        }
        SBQQ__Quote__c quoteRecord = [SELECT Id,Name,SBQQ__PrimaryContact__c,SBQQ__Opportunity2__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1];
        if(quoteRecord.SBQQ__PrimaryContact__c != null){
            upsert personAcc;
            Id personAccountId = null;
            if(personAcc.PersonContactId != null){
                for(Account a : [SELECT Id,PersonContactId FROM Account WHERE PersonContactId =: personAcc.PersonContactId]){
                    personAccountId = a.Id;
                }
            }         
            if(quoteRecord.SBQQ__Opportunity2__c != null && personAccountId != null){
                Id oppId = null;
                oppId = quoteRecord.SBQQ__Opportunity2__c;
                List<Opportunity> lstOpp = new List<Opportunity>();
                if(oppId != null){
                    for(Opportunity o : [SELECT Id,Customer_Person_Account__c FROM Opportunity WHERE Id =: oppId Limit 1]){
                        o.Customer_Person_Account__c = personAccountId;
                        lstOpp.add(o);
                    }
                }
                if(lstOpp.size() > 0){
                    upsert lstOpp;
                }
            }
            quoteRecord.SBQQ__PrimaryContact__c = personAcc.PersonContactId;
            startingModel.record = quoteRecord;
            String savedJson = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(startingModel));
            return personAcc.PersonContactId + '';
        } else if(quoteRecord.SBQQ__PrimaryContact__c == null){
            if(isDuplicateEmail){
                Id oppId = null;
                startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId); 
                startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
                SBQQ__Quote__c quoteRec = startingModel.record;
                quoteRec.SBQQ__PrimaryContact__c = personAcc.PersonContactId;
                oppId = quoteRec.SBQQ__Opportunity2__c;
                startingModel.record = quoteRec;
                String savedJson = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(startingModel)); 
                Id personAccountId = null;
                if(personAcc.PersonContactId != null){
                    for(Account a : [SELECT Id,PersonContactId FROM Account WHERE PersonContactId =: personAcc.PersonContactId]){
                        personAccountId = a.Id;
                    }
                }                
                List<Opportunity> lstOpp = new List<Opportunity>();
                if(oppId != null && personAccountId != null){
                    for(Opportunity o : [SELECT Id,Customer_Person_Account__c FROM Opportunity WHERE Id =: oppId Limit 1]){
                        o.Customer_Person_Account__c = personAccountId;
                        lstOpp.add(o);
                    }
                }
                if(lstOpp.size() > 0){
                    upsert lstOpp;
                }
                startingModel.record = quoteRec;
                savedJson = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(startingModel)); 
                return quoteRec.SBQQ__PrimaryContact__c + '';
            }else{
                //insert cont;
                Id oppId = null;
                Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                Account acc = new Account();
                acc.RecordTypeId = rt;
                acc.FirstName = cont.FirstName;
                acc.LastName = cont.LastName;
                acc.PersonEmail = cont.Email;
                acc.PersonMobilePhone = cont.MobilePhone;
                insert acc; 
                startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId); 
                startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
                SBQQ__Quote__c quoteRec = startingModel.record;
                //quoteRec.SBQQ__PrimaryContact__c = cont.Id;
                for(Account a : [SELECT Id,FirstName,LastName,PersonContactId FROM Account WHERE Id =: acc.Id Limit 1]){
                    quoteRec.SBQQ__PrimaryContact__c = a.PersonContactId;
                }
                oppId = quoteRec.SBQQ__Opportunity2__c;
                List<Opportunity> lstOpp = new List<Opportunity>();
                if(oppId != null){
                    for(Opportunity o : [SELECT Id,Customer_Person_Account__c FROM Opportunity WHERE Id =: oppId Limit 1]){
                        o.Customer_Person_Account__c = acc.Id;
                        lstOpp.add(o);
                    }
                }
                startingModel.record = quoteRec;
                String savedJson = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(startingModel)); 
                if(lstOpp.size() > 0){
                    upsert lstOpp;
                }
                return quoteRec.SBQQ__PrimaryContact__c + '';
                //return cont.Id + '';
            }
        }else{
            return null;
        }
    }
    
    //Method used to validate Email Address
    public static Boolean validateEmail(String email) {
        Boolean res = true;
        if(email == '')
            return true;
            
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
    
        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    }
    
    
    //Method used to get Quote From QuoteReader By Passing QuoteId
    public static SBQQ__Quote__c getQuoteFromQuoteReader(String quoteId){
        String startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId); 
        APIClassDefinitions.QuoteModel startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
        return startingModel.record;
    }
    
    
    //Method used to get QuoteModel By Passing QuoteId
    public static APIClassDefinitions.QuoteModel getQuoteModel(String quoteId){
        String startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId); 
        APIClassDefinitions.QuoteModel startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
        return startingModel;
    }
    
    
    //Method used to setUp TinyQuote
    public static APIClassDefinitions.TinyQuoteModel setUpTinyQuote(Id quoteId) { 
        SBQQ__Quote__c quoteRec = KCPQ_Utility.getQuoteFromQuoteReader(quoteId); 
        APIClassDefinitions.TinyQuoteModel tinyQuote = new APIClassDefinitions.TinyQuoteModel(); 
        tinyQuote.record = quoteRec; 
        return tinyQuote;
    } 
    
    
    //Method used to loadProductUsingProductAPI
    public static APIClassDefinitions.TinyProductModel loadProductUsingProductAPI(Id productId, Id pbookId) { 
        APIClassDefinitions.ProductLoadContext context = new APIClassDefinitions.ProductLoadContext(); 
        context.currencyCode = null; 
        context.pricebookId = pbookId; 
        String pJson = SBQQ.ServiceRouter.load('ProductAPI.ProductLoader', productId, JSON.serialize(context)); 
        APIClassDefinitions.TinyProductModel pModel = (APIClassDefinitions.TinyProductModel)JSON.deserialize(pJson, APIClassDefinitions.TinyProductModel.class); 
        return pModel; 
    } 
    
    
    //Method used to get Main Product from Quote
    public static Product2 getMainProductFromQuote(Id quoteId){
        
        Id productId;
        List<Product2> lstProduct = new List<Product2>();
        String startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId); 
        APIClassDefinitions.QuoteModel startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
        
        if(startingModel.lineItems.size() > 0 && startingModel.lineItems != null){
            Boolean isMainProductFound = false;
            for(APIClassDefinitions.QuoteLineModel qli : startingModel.lineItems){
                if(qli.record.SBQQ__ProductOption__c == null && qli.record.SBQQ__Product__c != null && qli.record.SBQQ__Number__c == 1){
                    productId = qli.record.SBQQ__Product__c;
                    isMainProductFound = true;
                }
            }
            Boolean isDummyProductAlreadyExist = false;
            for(Product2 p : [SELECT Id FROM Product2 WHERE Dummy_Product_Quote_Id__c =: quoteId AND 
                                                            Dummy_Product_Parent_Id__c =: productId]){
                isDummyProductAlreadyExist = true;
                productId = p.id;                                                
            }
            if(isDummyProductAlreadyExist == false){
                productId = cloneProductAndRelated(productId,quoteId);
            }
            if(isMainProductFound){
                String SOQL = prepareQuery('Product2');
                SOQL += ' WHERE Id =\''+productId+'\'';
                lstProduct = (List<Product2>)Database.query(SOQL);
                if(lstProduct.size() > 0){
                    return lstProduct.get(0);
                }
            }
        }
        
        return null;
    }
    
    /*====
        Get Products For Guided Selling using SBQQ.ProductAPI.ProductSuggester API
    ====*/
    //Method used for getting the products with pricebook entry
    public static List<PricebookEntry> getProductsForGuidedSelling(String quoteProcessId,SBQQ__Quote__c quoteRec, Product2 tempProd){
        APIClassDefinitions.QuoteModel qmodel = new APIClassDefinitions.QuoteModel(); 
        qmodel.record = quoteRec; 
        
        SBQQ__QuoteProcess__c qp = [SELECT Id, SBQQ__ProductAutoSelected__c, SBQQ__GuidedOnly__c, 
                                    (SELECT SBQQ__QuoteProcess__c, Id, Name, SBQQ__Active__c, SBQQ__DisplayOrder__c, SBQQ__InputField__c, SBQQ__Operator__c, SBQQ__ProductField__c, SBQQ__IntegerInput__c FROM SBQQ__Inputs__r) 
                                    FROM SBQQ__QuoteProcess__c WHERE Id =: quoteProcessId]; 
        /*qp.SBQQ__Inputs__r[0].Body_Style__c = 'Sedan'; 
        qp.SBQQ__Inputs__r[1].Seating__c = 'At Least 4 Passengers';
        qp.SBQQ__Inputs__r[2].Market__c = 'Personal Vehicles';
        */
        for(SBQQ__ProcessInput__c pi : qp.SBQQ__Inputs__r){
            sObject piObj = pi;
            sObject prodObj = tempProd;
            piObj.put(pi.SBQQ__ProductField__c, prodObj.get(pi.SBQQ__ProductField__c));
            pi = (SBQQ__ProcessInput__c)piObj;
        }
        
        APIClassDefinitions.SuggestContext context = new APIClassDefinitions.SuggestContext(); 
        context.quote = qmodel; 
        context.process = qp;
        
        String priceJsons = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductSuggester', null, JSON.serialize(context)); 
        PricebookEntry[] resultModels = (PricebookEntry[])JSON.deserialize(priceJsons, PricebookEntry[].class); 
        
        return resultModels;
    }
    
    public static KCPQ_ProcessInputWrapperCtrl buildProcessInputWrapper(SBQQ__ProcessInput__c processInput){
        KCPQ_ProcessInputWrapperCtrl piWra = new KCPQ_ProcessInputWrapperCtrl();
        piWra.label = processInput.SBQQ__Label__c;
        piWra.productField = processInput.SBQQ__ProductField__c;
        return piWra;
    }
    
    public static SBQQ__ProcessInput__c getProcessInputFromWrapper(KCPQ_ProcessInputWrapperCtrl piWra){
        SBQQ__ProcessInput__c piObj = new SBQQ__ProcessInput__c();
        piObj.SBQQ__Label__c = piWra.label;
        piObj.SBQQ__ProductField__c = piWra.productField;
        return piObj;
    }
    
    
    /*====
        Get QuoteId after adding product
    ====*/
    public static String getQuoteIdAfterAddingProduct(String productId, String pbookId,String quoteRecId){
        Set<String> pIds = new Set<String>();
        pIds.add(productId);
        return getQuoteIdAfterAddingProduct(null, pIds, pbookId,quoteRecId);
    }
    
    public static String getQuoteIdAfterAddingProduct(Product2 prd, String productId, String pbookId,String quoteRecId){
        Set<String> pIds = new Set<String>();
        pIds.add(productId);
        return getQuoteIdAfterAddingProduct(prd, pIds, pbookId,quoteRecId);
    }
    
    //Method used to get QuoteId after adding product
    public static String getQuoteIdAfterAddingProduct(Product2 parentPro, Set<String> setProductIds, String pbookId, String quoteRecId){
        
        Id qId = Id.valueOf(quoteRecId);
        APIClassDefinitions.TinyQuoteModel tinyQModel = setUpTinyQuote(qId);
        
        APIClassDefinitions.ConfigLoadContext loadContext = new APIClassDefinitions.ConfigLoadContext(); 
        loadContext.quote = tinyQModel;
        
        /*APIClassDefinitions.TinyProductModel loadModel = new APIClassDefinitions.TinyProductModel();
        if(parentPro != null){
            //loadContext.parentProduct = loadProductUsingProductAPI(parentPro.Id,pbookId);
            String loadString = SBQQ.ServiceRouter.load('ConfigAPI.ConfigLoader', parentPro.Id, JSON.serialize(loadContext)); 
            loadModel = (APIClassDefinitions.TinyProductModel)JSON.deserialize(loadString, APIClassDefinitions.TinyProductModel.class);
            
            if(loadModel.configuration != null){
                APIClassDefinitions.ValidationContext context = new APIClassDefinitions.ValidationContext(); 
                context.quote = tinyQModel; 
                context.configuration = loadModel.configuration;
                System.debug(LoggingLevel.INFO, JSON.serialize(loadModel.configuration)); 
                context.event = 'Always'; 
                
                String resultJson = SBQQ.ServiceRouter.load('ConfigAPI.ConfigurationValidator', '', JSON.serialize(context)); 
                APIClassDefinitions.TinyConfigurationModel resultModel = (APIClassDefinitions.TinyConfigurationModel)JSON.deserialize(resultJson, APIClassDefinitions.TinyConfigurationModel.class); 
            }
        }*/
        
        APIClassDefinitions.ProductLoadContext plContext = new APIClassDefinitions.ProductLoadContext(); 
        plContext.pricebookId = pbookId; 
        
        List<APIClassDefinitions.ProductModel> lstProductModel = new List<APIClassDefinitions.ProductModel>();
        for(String pid : setProductIds){
            String newProductJson = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader', pid, JSON.serialize(plContext)); 
            APIClassDefinitions.ProductModel newProductModel = (APIClassDefinitions.ProductModel)JSON.deserialize(newProductJson, APIClassDefinitions.ProductModel.class); 
            lstProductModel.add(newProductModel);
        }
        
        String startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteRecId); 
        APIClassDefinitions.QuoteModel startingQuoteModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
        
        Decimal startingTotal = startingQuoteModel.netTotal; 
        
        APIClassDefinitions.ProductAddContext paContext = new APIClassDefinitions.ProductAddContext(); 
        paContext.quote = startingQuoteModel; 
        paContext.products = lstProductModel; 
        paContext.ignoreCalculate = false; 
        
        String updatedQuoteJSON = SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteProductAdder', null, JSON.serialize(paContext)); 
        APIClassDefinitions.QuoteModel updatedQuoteModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(updatedQuoteJSON, APIClassDefinitions.QuoteModel.class); 
        
        String savedJson = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(updatedQuoteModel)); 
        return updatedQuoteModel.record.Id;
    }
    
    
    //Method used to get ProductWrapper From Product
    public static KCPQ_ProductWrapperCtrl buildProductWrapperFromProduct(Product2 pro, Id quoteId){
        
        APIClassDefinitions.QuoteModel qModel = getQuoteModel(quoteId);
        SBQQ__Quote__c quote = qModel.record;
        
        APIClassDefinitions.ProductLoadContext plc = new APIClassDefinitions.ProductLoadContext(); 
        plc.pricebookId = quote.SBQQ__PriceBook__c;
    
        String productJson = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader',pro.Id, JSON.serialize(plc)); 
        APIClassDefinitions.ProductModel pmodel = (APIClassDefinitions.ProductModel)JSON.deserialize(productJson, APIClassDefinitions.ProductModel.class);       
              
        KCPQ_ProductWrapperCtrl proWra = new KCPQ_ProductWrapperCtrl();
        proWra.productRecord = pmodel.record;
        for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
            if(qLineItems.record.SBQQ__Product__c == pro.Id || 
               qLineItems.record.SBQQ__Product__c == pro.Dummy_Product_Parent_Id__c){
                proWra.productPrice = qLineItems.record.SBQQ__ListPrice__c;
                proWra.productNetPrice = qLineItems.record.SBQQ__NetPrice__c;
            }
        }
        proWra.currencySymbol = pmodel.currencySymbol;
        proWra.featureCategories = pmodel.featureCategories;
        List<KCPQ_ProductOptionWrapper> lstProductOptionWrapper = new List<KCPQ_ProductOptionWrapper>();
        for(APIClassDefinitions.OptionModel opModel : pmodel.options){
            KCPQ_ProductOptionWrapper poWra = new KCPQ_ProductOptionWrapper();
            poWra.displaynumber = opModel.record.SBQQ__Number__c;
            poWra.quantity = opModel.record.SBQQ__Quantity__c;
            poWra.configuredSKU = opModel.record.SBQQ__ConfiguredSKU__c;
            poWra.optionalSKU = opModel.record.SBQQ__OptionalSKU__c;
            poWra.featureId = opModel.record.SBQQ__Feature__c;
            poWra.unitPrice = opModel.record.SBQQ__UnitPrice__c;
            lstProductOptionWrapper.add(poWra);
        }
        proWra.options = lstProductOptionWrapper;
        List<KCPQ_ProductFeatureWrapper> lstProductFeatureWrapper = new List<KCPQ_ProductFeatureWrapper>();
        for(APIClassDefinitions.FeatureModel featureModel : pmodel.features){
            KCPQ_ProductFeatureWrapper pfWra = new KCPQ_ProductFeatureWrapper();
            pfWra.featureId = featureModel.record.Id;
            pfWra.featureName = featureModel.record.Name;
            pfWra.minOptionCount = featureModel.record.SBQQ__MinOptionCount__c;
            pfWra.maxOptionCount = featureModel.record.SBQQ__MaxOptionCount__c;
            pfWra.category = featureModel.record.SBQQ__Category__c;
            pfWra.configuredSKU = featureModel.record.SBQQ__ConfiguredSKU__c;
            pfWra.optionSelectionMethod = featureModel.record.SBQQ__OptionSelectionMethod__c;
            lstProductFeatureWrapper.add(pfWra);
        }
        proWra.features = lstProductFeatureWrapper;
        return proWra;
    }
    
    
    //Method used to get Products
    public static List<Product2> getListProducts(Set<Id> setProductIds){
        List<Product2> lstProduct = new List<Product2>();
        String SOQL = prepareQuery('Product2');
        SOQL += ' WHERE Id IN :setProductIds';
        lstProduct = (List<Product2>)Database.query(soql);
        if(lstProduct.size() > 0){
            return lstProduct;
        }
        return null;
    }
    
    
    //Method used to get Quote Line Items ProductIds
    public static Set<Id> getQuoteLineProductIds(Id quoteId){
        Set<Id> setQuoteLineProductIds = new Set<Id>();
        APIClassDefinitions.QuoteModel qModel = getQuoteModel(quoteId);
        for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
            setQuoteLineProductIds.add(qLineItems.record.SBQQ__Product__c);
        }
        if(setQuoteLineProductIds.size() > 0){
            return setQuoteLineProductIds;
        }else{
            return null;
        }
    }
    
    
    //Method used to delete quoteLineItems
    public static void quoteLineItemsDelete(Id quoteId, Set<Id> setSummaryProductIds){
        List<SBQQ__QuoteLine__c> lstQuoteLineItemsDelete = new List<SBQQ__QuoteLine__c>();
        APIClassDefinitions.QuoteModel qModel = getQuoteModel(quoteId);
        for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
            if(!setSummaryProductIds.contains(qLineItems.record.SBQQ__Product__c)){
                lstQuoteLineItemsDelete.add(qLineItems.record);
            }
        }
        if(lstQuoteLineItemsDelete.size() > 0){
            delete lstQuoteLineItemsDelete;
        }
    }
    
    
    //Method used to get set of Product Ids
    public static Set<Id> getProductIdsFromPricebookEntries(Id quoteId){
        String startingQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId); 
        APIClassDefinitions.QuoteModel startingModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(startingQuoteJson, APIClassDefinitions.QuoteModel.class); 
        
        APIClassDefinitions.SearchContext context = new APIClassDefinitions.SearchContext(); 
        context.quote = startingModel; 
        context.filters = new SBQQ__SearchFilter__c[0]; 
        
        String pricebookJsons = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductSearcher', null, JSON.serialize(context)); 
        PricebookEntry[] resultEntries = (PricebookEntry[])JSON.deserialize(pricebookJsons, PricebookEntry[].class); 
        
        Set<Id> setProductIds = new Set<Id>();
        for(PricebookEntry pe : resultEntries){
            setProductIds.add(pe.Product2Id);
        }
        if(setProductIds.size() > 0){
            return setProductIds;
        }else{
            return null;
        }
    }
    
    
    //Method used to get SummaryWrapper From QuoteLine
    public static List<KCPQ_FeatureProductsWrapper> getSummaryWrapperFromQuoteLine(Id quoteId){
        List<KCPQ_FeatureProductsWrapper> lstFeatureProductsWrapper = new List<KCPQ_FeatureProductsWrapper>();
        List<KCPQ_FeatureProductsWrapper> lstFeatureProductsWrapper1 = new List<KCPQ_FeatureProductsWrapper>();
        APIClassDefinitions.QuoteModel qModel = getQuoteModel(quoteId);
        Set<Id> setProductIds = new Set<Id>();
        for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
            setProductIds.add(qLineItems.record.SBQQ__Product__c);
            KCPQ_FeatureProductsWrapper feaProWra = new KCPQ_FeatureProductsWrapper();
            feaProWra.productUnitPrice = qLineItems.record.SBQQ__ListPrice__c;
            feaProWra.featureProductId = qLineItems.record.SBQQ__Product__c;
            feaProWra.discountValue = qLineItems.record.SBQQ__Discount__c;
            if(qLineItems.record.SBQQ__NetTotal__c == null){
                feaProWra.productNetPrice = qLineItems.record.SBQQ__ListPrice__c;
            }else{
                feaProWra.productNetPrice = qLineItems.record.SBQQ__NetTotal__c;
            }
            lstFeatureProductsWrapper.add(feaProWra);
        }
        if(setProductIds.size() > 0){
            List<Product2> lstProduct = new List<Product2>();
            for(Id proId : setProductIds){
                lstProduct = getListProducts(setProductIds);
            }
            Map<Id,Product2> mapProduct = new Map<Id,Product2>();
            for(Product2 pro : lstProduct){
                mapProduct.put(pro.Id,pro);
            }
            for(KCPQ_FeatureProductsWrapper fpwr : lstFeatureProductsWrapper){
                fpwr.featureProduct = mapProduct.get(fpwr.featureProductId);
                lstFeatureProductsWrapper1.add(fpwr);
            }
        }
        return lstFeatureProductsWrapper1;
    }
    
    
    //Method used to get List<KCPQ_ProductOptionWrapperCtrl>
    @AuraEnabled
    public static List<KCPQ_ProductOptionWrapperCtrl> getProductOptionWrapper(Id quoteId, Product2 prodObj){
    
        List<KCPQ_ProductOptionWrapperCtrl> productOptionWrapperLst = new List<KCPQ_ProductOptionWrapperCtrl>();
         
        APIClassDefinitions.QuoteModel qModel = getQuoteModel(quoteId);
        APIClassDefinitions.TinyQuoteModel tinyQuote = new APIClassDefinitions.TinyQuoteModel(); 
        tinyQuote.record = qModel.record; 
        APIClassDefinitions.TinyQuoteModel tinyQModel = tinyQuote;
        
        Set<Id> setQlineItemProductIds = new Set<Id>();
        Map<Id,Decimal> mapProductIdDiscountValue = new Map<Id,Decimal>();
        Map<Id,Decimal> mapProductIdUnitPrice = new Map<Id,Decimal>();
        Map<Id,Decimal> mapProductIdNetPrice = new Map<Id,Decimal>();
        for(APIClassDefinitions.QuoteLineModel qLineItems : qModel.lineItems){
            setQlineItemProductIds.add(qLineItems.record.SBQQ__Product__c);
            mapProductIdDiscountValue.put(qLineItems.record.SBQQ__Product__c,qLineItems.record.SBQQ__Discount__c);
            mapProductIdUnitPrice.put(qLineItems.record.SBQQ__Product__c,qLineItems.record.SBQQ__ListPrice__c);
            mapProductIdNetPrice.put(qLineItems.record.SBQQ__Product__c,qLineItems.record.SBQQ__NetPrice__c);
        }
        
        SBQQ__Quote__c quote = qModel.record;
        Id pbookId = quote.SBQQ__PricebookId__c;
        Id parentProId = prodObj.Id;
        
        APIClassDefinitions.ConfigLoadContext loadContext = new APIClassDefinitions.ConfigLoadContext(); 
        loadContext.quote = tinyQModel;
        loadContext.parentProduct = loadProductUsingProductAPI(parentProId,pbookId); 
        
        APIClassDefinitions.ProductLoadContext plContext = new APIClassDefinitions.ProductLoadContext(); 
        plContext.pricebookId = pbookId; 
        
        List<APIClassDefinitions.ProductModel> lstProductModel = new List<APIClassDefinitions.ProductModel>();
        String loadString = SBQQ.ServiceRouter.load('ConfigAPI.ConfigLoader', parentProId, JSON.serialize(loadContext)); 
        APIClassDefinitions.TinyProductModel loadModel = (APIClassDefinitions.TinyProductModel)JSON.deserialize(loadString, APIClassDefinitions.TinyProductModel.class);
        
        Map<Id,SBQQ__ProductFeature__c> mapFeature = new Map<Id,SBQQ__ProductFeature__c>();
        for(APIClassDefinitions.TinyFeatureModel tof : loadModel.features){
            mapFeature.put(tof.record.Id,tof.record);
        }
        
        Map<Id,Id> mapDependentProductId = new Map<Id,Id>();
        for(APIClassDefinitions.TinyOptionModel tom : loadModel.options){
            mapDependentProductId.put(tom.record.Id,tom.record.SBQQ__OptionalSKU__c);
        }
        
        for(APIClassDefinitions.TinyOptionModel tom : loadModel.options){
            KCPQ_ProductOptionWrapperCtrl poWr = new KCPQ_ProductOptionWrapperCtrl();
            poWr.featureId = tom.record.SBQQ__Feature__c;
            poWr.featureRecord = mapFeature.get(tom.record.SBQQ__Feature__c);
            poWr.productRecordId = tom.record.SBQQ__OptionalSKU__c;
            poWr.productName = tom.record.SBQQ__ProductName__c;
            poWr.productDescription = tom.record.SBQQ__ProductDescription__c;
            poWr.productImage = tom.record.Product_Image__c;
            poWr.unitPrice = tom.record.SBQQ__UnitPrice__c;
            if(setQlineItemProductIds.contains(tom.record.SBQQ__OptionalSKU__c)){
                poWr.isSelected = true;
                if(mapProductIdDiscountValue.get(tom.record.SBQQ__OptionalSKU__c) != null){
                    poWr.discountValue = mapProductIdDiscountValue.get(tom.record.SBQQ__OptionalSKU__c);
                }else{
                    poWr.discountValue = 0;
                }
                poWr.netPrice = mapProductIdNetPrice.get(tom.record.SBQQ__OptionalSKU__c);
            }else{
                poWr.isSelected = tom.record.SBQQ__Selected__c;
                poWr.discountValue = 0;
                poWr.netPrice = tom.record.SBQQ__UnitPrice__c;
            }
            poWr.configuredSKU = tom.record.SBQQ__ConfiguredSKU__c;
            poWr.optionalSKU = tom.record.SBQQ__OptionalSKU__c;
            poWr.minOptionCount = Integer.valueOf(mapFeature.get(tom.record.SBQQ__Feature__c).SBQQ__MinOptionCount__c);
            if(mapFeature.get(tom.record.SBQQ__Feature__c).SBQQ__MaxOptionCount__c != null){
                poWr.maxOptionCount = Integer.valueOf(mapFeature.get(tom.record.SBQQ__Feature__c).SBQQ__MaxOptionCount__c);
            }
            
            Map<Id,SBQQ__ProductFeature__c> mapProductFeatureRecord = new Map<Id,SBQQ__ProductFeature__c>();
            mapProductFeatureRecord.put(tom.record.SBQQ__OptionalSKU__c,poWr.featureRecord);
            poWr.mapProductIdFeatureRecord = mapProductFeatureRecord;
            Map<Id,Set<Id>> mapProductDependentIds = new Map<Id,Set<Id>>();
            mapProductDependentIds.put(tom.record.SBQQ__OptionalSKU__c,tom.dependentIds);
            poWr.mapDependentIds = mapProductDependentIds;
            poWr.setDependentIds = tom.dependentIds;
            Set<Id> setDependentProIds = new Set<Id>();
            for(Id dependentId : tom.dependentIds){
                setDependentProIds.add(mapDependentProductId.get(dependentId));
            }
            poWr.setDependentProductIds = setDependentProIds;
            
            Set<Id> setControllingGrpsIds = new Set<Id>();
            for(Set<Id> setcontrollingGrpId : tom.controllingGroups.values()){
                for(Id contGrpIds : setcontrollingGrpId){
                    setControllingGrpsIds.add(contGrpIds);
                }
            }
            poWr.setControllingGroupsIds = setControllingGrpsIds;
            Set<Id> setDependentControllingGroupsProIds = new Set<Id>();
            for(Id cgDependentId : setControllingGrpsIds){
                setDependentControllingGroupsProIds.add(mapDependentProductId.get(cgDependentId));
            }
            poWr.setControllingGroupDependentProductIds = setDependentControllingGroupsProIds;
            if(poWr.featureRecord.SBQQ__MaxOptionCount__c == 1){
                poWr.isCheckBox = false;
            }else if(poWr.featureRecord.SBQQ__MaxOptionCount__c > 1 || poWr.featureRecord.SBQQ__MaxOptionCount__c == null){
                poWr.isCheckBox = true;
            }else{
                poWr.isCheckBox = true;
            }
            poWr.isDisabled = false;
            if(!poWr.isDisabled){
                poWr.disabledMsg = '';
            }
            productOptionWrapperLst.add(poWr);
        }
        return productOptionWrapperLst;
    }
    
    
    //Method used to Submit Quote
    public static String SubmitQuote(Id quoteId, Product2 prodObj){
        
        APIClassDefinitions.QuoteModel qModel = getQuoteModel(quoteId);
        APIClassDefinitions.TinyQuoteModel tinyQuote = new APIClassDefinitions.TinyQuoteModel(); 
        tinyQuote.record = qModel.record; 
        APIClassDefinitions.TinyQuoteModel tinyQModel = tinyQuote;
        //SBQQ__Quote__c quote = getQuoteFromQuoteReader(quoteId);
        Id pbookId = qModel.record.SBQQ__PricebookId__c;
        Id parentProId = prodObj.Id;
        
        Set<Id> setQuoteLineProductIds = new Set<Id>();
        for(APIClassDefinitions.QuoteLineModel qli : qModel.lineItems){
            setQuoteLineProductIds.add(qli.record.SBQQ__Product__c);
        }
        
        List<SBQQ__ProductOption__c> lstOptions = new List<SBQQ__ProductOption__c>();
        APIClassDefinitions.TinyProductModel mainProductModel = KCPQ_Utility.loadProductUsingProductAPI(parentProId, pbookId); 
        if(mainProductModel.options.size() > 0){
            for(APIClassDefinitions.TinyOptionModel o : mainProductModel.options){
                if(setQuoteLineProductIds.contains(o.record.SBQQ__OptionalSKU__c)){
                    o.record.SBQQ__Selected__c = true;
                    lstOptions.add(o.record);
                }
            }
            if(lstOptions.size() > 0){
                update lstOptions;
            }
        }
        
        mainProductModel = KCPQ_Utility.loadProductUsingProductAPI(parentProId, pbookId);
        APIClassDefinitions.TinyConfigurationModel resultModel;
        if(mainProductModel.configuration != null){
            APIClassDefinitions.ValidationContext context = new APIClassDefinitions.ValidationContext(); 
            context.quote = tinyQModel; 
            context.configuration = mainProductModel.configuration; 
            context.event = 'Save'; 
            
            String resultJson = SBQQ.ServiceRouter.load('ConfigAPI.ConfigurationValidator', '', JSON.serialize(context)); 
            resultModel = (APIClassDefinitions.TinyConfigurationModel)JSON.deserialize(resultJson, APIClassDefinitions.TinyConfigurationModel.class); 
            system.debug('===resultModel==='+ resultModel);
            system.debug('===resultModel.ValidationMessages==='+ resultModel.validationMessages);
        }
        //START - Commented - Because ProductOption SBQQ__Selected__c field value not changed to true by API
        if(resultModel != null && resultModel.validationMessages != null && resultModel.validationMessages.size() > 0){
            return 'ERROR : ' + resultModel.validationMessages;
        }else{
        //END - Commented
            String updatedQuoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId); 
            APIClassDefinitions.QuoteModel updatedQuoteModel = (APIClassDefinitions.QuoteModel)JSON.deserialize(updatedQuoteJson, APIClassDefinitions.QuoteModel.class); 
            updatedQuoteModel.record.SBQQ__Status__c = 'In Review';
            String savedJson = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', JSON.serialize(updatedQuoteModel));
            
            Double quoteDiscountPercent = null;
            for(SBQQ__Quote__c q : [SELECT Id,SBQQ__AverageCustomerDiscount__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1]){
                quoteDiscountPercent = q.SBQQ__AverageCustomerDiscount__c;
            }
            if(quoteDiscountPercent > 10){
                Approval.ProcessSubmitRequest app1 = new Approval.ProcessSubmitRequest();
                app1.setObjectId(quoteId);
                app1.setSubmitterId(userInfo.getUserid());
                app1.setProcessDefinitionNameOrId('KCPQ_QuoteApproval');
                Approval.ProcessResult result = Approval.process(app1);
            }
            Set<Id> setProductIdsForDelete = new Set<Id>();
            setProductIdsForDelete.add(parentProId);
            if(setProductIdsForDelete.size() > 0){
                deleteCloneProductAndRelated(setProductIdsForDelete);
            }
            return quoteId;
        }
        
    }
    
    
    //Method used to get Inventory Product Amounts
    public static List<KCPQ_InventoryWrapper> getProductsInventory(List<Product2> products){
        System.debug('products...'+products);
        Map<Id,Integer> herokuProducts=KCPQ_Integration.getProducts();
        List<KCPQ_InventoryWrapper> productswr=new List<KCPQ_InventoryWrapper>();
        for(Product2 p:products){
            KCPQ_InventoryWrapper product=new KCPQ_InventoryWrapper();
            product.product=p;
            System.debug('products...'+p.Exterior_Shade__c);
            System.debug('products...'+p.Interior_Shade__c);
            product.exteriorColorCode=p.Exterior_Shade__c;
            product.interiorColorCode=p.Interior_Shade__c;
            if(herokuProducts.get(p.Id)!=null)
                product.stockAvailable=herokuProducts.get(p.Id);//Math.round(Math.random()*1000);
            productswr.add(product);
        }
        return productswr;
    }
    
    
    //Method used to Check the Status of Quote Record and return order number
    public static Integer getProgressStageOrderValue(Id quoteId, Integer featureLstSize){
        SBQQ__Quote__c quote = [SELECT Id,SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id =: quoteId];
        if(quote.SBQQ__Status__c == 'Draft'){
            return 1;
        }else{
            if(featureLstSize == 0){
                return 3;
            }else{
                return featureLstSize + 3;
            }
        }
    }
    
    
    //Used in StartQuote/Guided Selling
    //Method used in KCPQ_SAQ_PBSelection Component to getPricebook picklist with selected value
    public static List<String> getPricebookPicklist(){
        
        Id userAccId = null;
        Id prbookId = null;
        for(User u : [SELECT Id, Name, ContactId, AccountId FROM User WHERE Id =: UserInfo.getUserId() Limit 1]){
            userAccId = u.AccountId;
        }
        if(userAccId != null){
            for(Account a : [SELECT Id,Name,Price_Book__c FROM Account WHERE Id =: userAccId LIMIT 1]){
                if(a.Price_Book__c != null){
                    prbookId = a.Price_Book__c;
                }
            }
        }
        if(prbookId == null){
            for(User u : [SELECT Id, Name, Price_Book_Id__c FROM User WHERE Id =: UserInfo.getUserId() Limit 1]){
                if(u.Price_Book_Id__c != null || u.Price_Book_Id__c != ''){
                    prbookId = u.Price_Book_Id__c;
                }
            }
            if(prbookId == null){
                String customLabelValue = System.Label.Standard_Price_Book_Id;
               
                if(customLabelValue != null){
                    if(customLabelValue instanceOf Id){
                        prbookId = Id.valueOf(customLabelValue);
                    }
                }
            }
        }
        
        List<String> pricebookList = new List<String>();
        pricebookList.add(''+'<##>'+'---Select---'+'<@@>'+false);
        for(Pricebook2 pb : [SELECT Id, Name, IsActive, IsArchived, Description, IsStandard FROM Pricebook2 WHERE IsActive = true ORDER By Name]){
            if(pb.Id == prbookId){
                pricebookList.add(pb.Id+'<##>'+pb.Name+'<@@>'+true);
            }else{
                pricebookList.add(pb.Id+'<##>'+pb.Name+'<@@>'+false);
            }
        }
        return pricebookList;
    }
    
    
    //Used in Guided Selling
    //Method used in KCPQ_GuidedSellingSelectionComp Component to getQuoteProcess picklist with selected value
    public static List<String> getQuoteProcessPicklist(){
        
        Id userAccId = null;
        Id quoteProcessId = null;
        for(User u : [SELECT Id, Name, ContactId, AccountId, Quote_Process_Id__c FROM User WHERE Id =: UserInfo.getUserId() Limit 1]){
            userAccId = u.AccountId;
            /*if(u.Quote_Process_Id__c != null || u.Quote_Process_Id__c != ''){
                quoteProcessId = u.Quote_Process_Id__c;
            }*/
        }
        if(userAccId != null && quoteProcessId == null){
            for(Account a : [SELECT Id,Name,Quote_Process_Id__c FROM Account WHERE Id =: userAccId LIMIT 1]){
                if(a.Quote_Process_Id__c != null){
                    quoteProcessId = a.Quote_Process_Id__c;
                }
            }
        }
        if(quoteProcessId == null){
            for(User u : [SELECT Id, Name, Quote_Process_Id__c FROM User WHERE Id =: UserInfo.getUserId() Limit 1]){
                if(u.Quote_Process_Id__c != null || u.Quote_Process_Id__c != ''){
                    quoteProcessId = u.Quote_Process_Id__c;
                }
            }
            if(quoteProcessId == null){
                String customLabelValue = System.Label.KCPQ_Quote_Process_Id;
                if(customLabelValue != null){
                    if(customLabelValue instanceOf Id){
                        quoteProcessId = Id.valueOf(customLabelValue);
                    }
                }
            }
        }
        
        List<String> quoteProcessList = new List<String>();
        quoteProcessList.add(''+'<##>'+'---Select---'+'<@@>'+false);
        for(SBQQ__QuoteProcess__c qp : [SELECT Id, Name, SBQQ__Default__c, SBQQ__GuidedOnly__c, SBQQ__ProductAutoSelected__c, 
                                        SBQQ__ProductConfigurationInitializer__c, SBQQ__ProductSearchExecutor__c, 
                                        SBQQ__SortOrder__c FROM SBQQ__QuoteProcess__c ORDER By Name]){
                                            
            if(qp.Id == quoteProcessId){
                quoteProcessList.add(qp.Id+'<##>'+qp.Name+'<@@>'+true);
            }else{
                quoteProcessList.add(qp.Id+'<##>'+qp.Name+'<@@>'+false);
            }
        }
        return quoteProcessList;
    }
    
    
    //Prepare SOQL query based on Object Name
    public static String prepareQuery(String objName){
        Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
        Schema.sObjectType objType = globalDescription.get(objName);
        Schema.DescribeSObjectResult r1 = objType.getDescribe(); 
        Map<String , Schema.SObjectField> mapFieldList = r1.fields.getMap();  
        String strQuery = '';
        strQuery = 'SELECT ';
        for(Schema.SObjectField field : mapFieldList.values()){  
            Schema.DescribeFieldResult fieldResult = field.getDescribe(); 
            if(fieldResult.isAccessible()){
                strQuery += fieldResult.getName() + ', ';
            }  
        }
        strQuery = strQuery.substring(0, strQuery.lastIndexOf(','));
        strQuery += ' FROM ' + objName + ' ';
        return strQuery;
    }
    
    
    public static Id cloneProductAndRelated(Id productId,Id quoteId) {
        Id clonedProductId = null;
        Set<Id> setProductIds = new Set<Id>();
        setProductIds.add(productId);
        List<Product2> lstProducts = new List<Product2>();
        List<Product2> lstProductToClone = new List<Product2>();
        String SOQL = KCPQ_Utility.prepareQuery('Product2');
        SOQL += ' WHERE Id IN :setProductIds';
        lstProducts = (List<Product2>)Database.query(SOQL);
        if(lstProducts.size() > 0){
            for(Product2 p : lstProducts){
                Product2 cloneProduct = p.clone(false, true);
                cloneProduct.Dummy_Product_Quote_Id__c = quoteId;
                cloneProduct.Dummy_Product_Parent_Id__c = p.Id;
                cloneProduct.isInventoryProduct__c = false;
                lstProductToClone.add(cloneProduct);
            }
            if(lstProductToClone.size() > 0){
                insert lstProductToClone;
            }
            clonedProductId = lstProductToClone.get(0).Id;
            
            List<SBQQ__ProductFeature__c> lstProductFeatures = new List<SBQQ__ProductFeature__c>();
            List<SBQQ__ProductFeature__c> lstProductFeaturesToClone = new List<SBQQ__ProductFeature__c>();
            Map<String,String> mappfc = new Map<String,String>();
            SOQL = KCPQ_Utility.prepareQuery('SBQQ__ProductFeature__c');
            SOQL += ' WHERE SBQQ__ConfiguredSKU__c IN :setProductIds';
            lstProductFeatures = (List<SBQQ__ProductFeature__c>)Database.query(SOQL);
            if(lstProductFeatures.size() > 0){
                for(SBQQ__ProductFeature__c pf : lstProductFeatures){
                    SBQQ__ProductFeature__c cloneProductFeature = pf.clone(false, true);
                    cloneProductFeature.External_Id__c = pf.Id;
                    cloneProductFeature.SBQQ__ConfiguredSKU__c = clonedProductId;
                    lstProductFeaturesToClone.add(cloneProductFeature);
                }
                if(lstProductFeaturesToClone.size() > 0){
                    insert lstProductFeaturesToClone;
                    for(SBQQ__ProductFeature__c pfc : lstProductFeaturesToClone){
                        mappfc.put(pfc.External_Id__c,pfc.id);
                    }
                }
            }
            
            List<SBQQ__ProductOption__c> lstProductOptions = new List<SBQQ__ProductOption__c>();
            List<SBQQ__ProductOption__c> lstProductOptionsToClone = new List<SBQQ__ProductOption__c>();
            Map<String,String> mappoc = new Map<String,String>();
            SOQL = KCPQ_Utility.prepareQuery('SBQQ__ProductOption__c');
            SOQL += ' WHERE SBQQ__ConfiguredSKU__c IN :setProductIds';
            lstProductOptions = (List<SBQQ__ProductOption__c>)Database.query(SOQL);
            if(lstProductOptions.size() > 0){
                for(SBQQ__ProductOption__c po : lstProductOptions){
                    SBQQ__ProductOption__c cloneProductOption = po.clone(false, true);
                    cloneProductOption.External_Id__c = po.Id;
                    cloneProductOption.SBQQ__ConfiguredSKU__c = clonedProductId;
                    if(mappfc.containsKey(cloneProductOption.SBQQ__Feature__c)){
                        cloneProductOption.SBQQ__Feature__c = mappfc.get(cloneProductOption.SBQQ__Feature__c);
                    }
                    lstProductOptionsToClone.add(cloneProductOption);
                }
                if(lstProductOptionsToClone.size() > 0){
                    insert lstProductOptionsToClone;
                    for(SBQQ__ProductOption__c poc : lstProductOptionsToClone){
                        mappoc.put(poc.External_Id__c,poc.id);
                    }
                }
            }
            
            List<SBQQ__OptionConstraint__c> lstProductOptionConstraints = new List<SBQQ__OptionConstraint__c>();
            List<SBQQ__OptionConstraint__c> lstProductOptionConstraintsToClone = new List<SBQQ__OptionConstraint__c>();
            SOQL = KCPQ_Utility.prepareQuery('SBQQ__OptionConstraint__c');
            SOQL += ' WHERE SBQQ__ConfiguredSKU__c IN :setProductIds';
            lstProductOptionConstraints = (List<SBQQ__OptionConstraint__c>)Database.query(SOQL);
            if(lstProductOptionConstraints.size() > 0){
                for(SBQQ__OptionConstraint__c poc : lstProductOptionConstraints){
                    SBQQ__OptionConstraint__c cloneOptionConstraint = poc.clone(false, true);
                    cloneOptionConstraint.External_Id__c = poc.Id;
                    cloneOptionConstraint.SBQQ__ConfiguredSKU__c = clonedProductId;
                    if(mappoc.containsKey(cloneOptionConstraint.SBQQ__ConstrainedOption__c)){
                        cloneOptionConstraint.SBQQ__ConstrainedOption__c = mappoc.get(cloneOptionConstraint.SBQQ__ConstrainedOption__c);
                    }
                    if(mappoc.containsKey(cloneOptionConstraint.SBQQ__ConstrainingOption__c)){
                        cloneOptionConstraint.SBQQ__ConstrainingOption__c = mappoc.get(cloneOptionConstraint.SBQQ__ConstrainingOption__c);
                    }
                    lstProductOptionConstraintsToClone.add(cloneOptionConstraint);
                }
                if(lstProductOptionConstraintsToClone.size() > 0){
                    insert lstProductOptionConstraintsToClone;
                }
            }
            
            List<SBQQ__ConfigurationRule__c> lstProductConfigurationRules = new List<SBQQ__ConfigurationRule__c>();
            List<SBQQ__ConfigurationRule__c> lstProductConfigurationRulesToClone = new List<SBQQ__ConfigurationRule__c>();
            SOQL = KCPQ_Utility.prepareQuery('SBQQ__ConfigurationRule__c');
            SOQL += ' WHERE SBQQ__Product__c IN :setProductIds';
            lstProductConfigurationRules = (List<SBQQ__ConfigurationRule__c>)Database.query(SOQL);
            if(lstProductConfigurationRules.size() > 0){
                for(SBQQ__ConfigurationRule__c pcr : lstProductConfigurationRules){
                    SBQQ__ConfigurationRule__c cloneConfigurationRules = pcr.clone(false, true);
                    cloneConfigurationRules.External_Id__c = pcr.Id;
                    cloneConfigurationRules.SBQQ__Product__c = clonedProductId;
                    if(mappfc.containsKey(cloneConfigurationRules.SBQQ__ProductFeature__c)){
                        cloneConfigurationRules.SBQQ__ProductFeature__c = mappfc.get(cloneConfigurationRules.SBQQ__ProductFeature__c);
                    }
                    lstProductConfigurationRulesToClone.add(cloneConfigurationRules);
                }
                if(lstProductConfigurationRulesToClone.size() > 0){
                    insert lstProductConfigurationRulesToClone;
                }
            }
            
            List<SBQQ__ProductAction__c> lstProductActions = new List<SBQQ__ProductAction__c>();
            List<SBQQ__ProductAction__c> lstProductActionsToClone = new List<SBQQ__ProductAction__c>();
            SOQL = KCPQ_Utility.prepareQuery('SBQQ__ProductAction__c');
            SOQL += ' WHERE SBQQ__Product__c IN :setProductIds';
            lstProductActions = (List<SBQQ__ProductAction__c>)Database.query(SOQL);
            if(lstProductActions.size() > 0){
                for(SBQQ__ProductAction__c pa : lstProductActions){
                    SBQQ__ProductAction__c cloneProductActions = pa.clone(false, true);
                    cloneProductActions.External_Id__c = pa.Id;
                    cloneProductActions.SBQQ__Product__c = clonedProductId;
                    lstProductActionsToClone.add(cloneProductActions);
                }
                if(lstProductActionsToClone.size() > 0){
                    insert lstProductActionsToClone;
                }
            }
            
        }
        return clonedProductId;
    }
    
    //Method used to delete dummy products
    public static void deleteCloneProductAndRelated(Set<Id> setProductIds) {
    
        if(setProductIds.size() > 0){
        
            delete [SELECT Id FROM SBQQ__ProductAction__c WHERE SBQQ__Product__c IN :setProductIds];
        
            delete [SELECT Id FROM SBQQ__ConfigurationRule__c WHERE SBQQ__Product__c IN :setProductIds];
            
            delete [SELECT Id FROM SBQQ__OptionConstraint__c WHERE SBQQ__ConfiguredSKU__c IN :setProductIds];
            
            delete [SELECT Id FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c IN :setProductIds];
            
            delete [SELECT Id FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c IN :setProductIds];
            
            delete [SELECT Id FROM Product2 WHERE Id IN :setProductIds AND Dummy_Product_Parent_Id__c != null AND Dummy_Product_Quote_Id__c != null];
        }
    }
    
}