public class KCPQ_Integration {
    
    public class ExternalProduct {
        public String id {get; set;}//SFDC ID
        public Integer orderId {get; set;}//inventory amount has stored in this property
    }
    
    public static Map<Id,Integer> getProducts() {
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(Label.KCPQ_Inventory_Endpoint);
        req.setHeader('Content-Type', 'application/json');
        System.debug('req....'+req);
        Http http = new Http();
        // then use it to send the configured HTTPrequest
        HTTPResponse res;
        if(Test.isRunningTest() == false)
        {
            res = http.send(req);
        }
        else{
            Product2 product = new Product2();
            product.Name = 'DELL Latitude';
            Product.IsActive = true;
            insert product;
            res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('[{"orderId":115,"id":\"'+product.Id+'\"}]');
        }
        if (res.getStatusCode() != 200) {
            System.debug('Error from ' + req.getEndpoint() + ' : ' +
                         res.getStatusCode() + ' ' + res.getStatus());
            return null;
        }
        
        else {
            
            
            List<ExternalProduct> products =(List<ExternalProduct>)JSON.deserialize(res.getBody(),List<ExternalProduct>.class);
            System.debug('json result orders'+products );
            Map<Id,Integer> productInventory=new Map<Id,Integer>();
            for(ExternalProduct ep:products)
            {
                productInventory.put(ep.Id,ep.orderId);
            }
            return productInventory;
            
        }
    }
}