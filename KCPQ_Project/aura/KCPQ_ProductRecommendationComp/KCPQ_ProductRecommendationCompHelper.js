({    
    createQuote : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.doCreateQuote");
        action.setParams({
            "pbookId" : component.get("v.pricebookId"),
            "quoteProId" : component.get("v.quoteProcessId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.quoteId",response.getReturnValue());
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert('==Error==' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
                    } else if (errors[0] && errors[0].pageErrors) {
                        //alert('==Error==' + errors[0].pageErrors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].pageErrors[0].message);
                    } else {
                        //alert('===Error=== Unknown error');
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",'Unknown error');
                    }
                }
            }
            component.set("v.startLoading",false);
            this.getRecommendations(component);
        });
        $A.enqueueAction(action);
    },
    
    getRecommendations : function(component){
        component.set("v.startLoading",true);
        var tempProductObj = component.get("v.tempProductObj");
        var action = component.get("c.getOurRecommendations");
        action.setParams({
            "productJSONStr" : JSON.stringify(tempProductObj),
            "pbookId" : component.get("v.pricebookId"),
            "quoteProId" : component.get("v.quoteProcessId"),
            "quoteRecId" : component.get("v.quoteId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var ourRecommendations = response.getReturnValue();
                component.set("v.recommProduct",ourRecommendations);
                component.set("v.isShowOurRecommendations",true);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert('==Error==' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
                    } else if (errors[0] && errors[0].pageErrors) {
                        //alert('==Error==' + errors[0].pageErrors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].pageErrors[0].message);
                    } else {
                        //alert('===Error=== Unknown error');
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",'Unknown error');
                    }
                }
            }
            component.set("v.startLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    quoteProductAdder : function(component, index, event) {
        component.set("v.startLoading",true);
        var action = component.get("c.getQuoteIdAfterAddingProduct");
        action.setParams({
            "productId" : index,
            "pbookId" : component.get("v.pricebookId"),
            "quoteRecId" : component.get("v.quoteId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.quoteId",response.getReturnValue());
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert('==Error==' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
                    } else if (errors[0] && errors[0].pageErrors) {
                        //alert('==Error==' + errors[0].pageErrors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].pageErrors[0].message);
                    } else {
                        //alert('===Error=== Unknown error');
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",'Unknown error');
                    }
                }
            }
            component.set("v.startLoading",false);
            this.redirectToQuoteDetail(component, event);
        });
        $A.enqueueAction(action);
    },
    
    redirectToQuoteDetail : function (component, event) {
        var qRecordId = component.get("v.quoteId");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/quote/" + qRecordId,
            "isredirect" : true
        });
        urlEvent.fire();
    }
})