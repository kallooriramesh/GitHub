({  
    getInventoryValue : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getInventory");
        action.setParams({
            "productJSONStr" : JSON.stringify(productObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.inventory",response.getReturnValue());
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert('Error' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
                    }
                } else {
                    //alert('===Error=== Unknown error');
                    component.set("v.messageTitle",'ERROR');
                    component.set("v.messageText",'Unknown error');
                }
            }
            this.getProgressBarWrapper(component);
            component.set("v.startLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    getProgressBarWrapper : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getProgressBar");
        action.setParams({
            "featureNames" : component.get("v.featureNames")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.progressWrapper",response.getReturnValue());
                component.set("v.isProgressBarShow",true);
            }else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						//alert('Error' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
					}
				} else {
					//alert('===Error=== Unknown error');
                    component.set("v.messageTitle",'ERROR');
                    component.set("v.messageText",'Unknown error');
				}
			}
            component.set("v.startLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    /*initializeProductOptionWrapper : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getInitializeProductOptionWrapper");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var productOptionJSONStr = response.getReturnValue();
                var productOptionWrapperList = JSON.parse(productOptionJSONStr); 
                component.set("v.ProductOptionWrapper",productOptionWrapperList);
            }else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						//alert('Error' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
					}
				} else {
					//alert('===Error=== Unknown error');
                    component.set("v.messageTitle",'ERROR');
                    component.set("v.messageText",'Unknown error');
				}
			}
            component.set("v.startLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    getProductOptionWrapper : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var productOptionWraLstValue = component.get("v.ProductOptionWrapper");
        var action = component.get("c.getProductOptionWra");
        action.setParams({
            "productOptionJSONStr" : JSON.stringify(productOptionWraLstValue),
            "quoteId" : component.get("v.quoteId"),
            "productJSONStr" : JSON.stringify(productObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.ProductOptionWrapper",response.getReturnValue());
                console.log('==ProductOptionWrapper==');
                console.log(response.getReturnValue());
            }else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						//alert('Error' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
					}
				} else {
					//alert('===Error=== Unknown error');
                    component.set("v.messageTitle",'ERROR');
                    component.set("v.messageText",'Unknown error');
				}
			}
            component.set("v.startLoading",false);
        });
        $A.enqueueAction(action);
    },*/
})