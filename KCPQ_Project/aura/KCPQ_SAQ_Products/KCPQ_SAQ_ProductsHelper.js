({
        
    getProductWithTypes : function(component, event) {
        component.set("v.startLoading",true);
        var quoteId= component.get("v.quoteId");
        var gbField= component.get("v.productGroupByField");
        //alert('quoteId '+quoteId+' gbField '+gbField);
        var action = component.get("c.getProductsWithGroup");
        action.setParams({quoteId : quoteId, groupByField: gbField});
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('state '+state);
            console.log(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //alert('response.getReturnValue() '+response.getReturnValue());
                component.set("v.productWrapper",response.getReturnValue());
                component.set("v.isProductsLoaded",true);
            }
             else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert('Error' + errors[0].message);
                    }
                } else {
                    alert('===Error=== Unknown error');
                }
            }
            component.set("v.startLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    setQuoteLineItems : function(component, event) {
        var quoteId= component.get("v.quoteId");
        var priceBookId= component.get("v.priceBookId");
        var productId= event.target.id;
        console.log('quoteId in setQuoteLineItems.'+quoteId);
        console.log('priceBookId in setQuoteLineItems.'+priceBookId);
        console.log('productId in setQuoteLineItems.'+productId);
        var action = component.get("c.createQuoteLineItems");
        action.setParams({productId : productId,
                          pbookId :priceBookId,
                          quoteRecId : quoteId
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.quoteSubmittedStatus",response.getReturnValue());
                component.set("v.isSubmitted",true);
                
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/quote/' + quoteId
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})