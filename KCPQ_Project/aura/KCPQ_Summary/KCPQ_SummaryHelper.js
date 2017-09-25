({
    getPathPrefixURL : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getpathprefixURL");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.pathprefixURL", response.getReturnValue());
			}else if (state === "ERROR") {
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
    
    getMainProductNetPrice : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getMainProductNetPriceValue");
        action.setParams({
            "quoteId" : component.get("v.quoteId"),
            "productJSONStr" : JSON.stringify(productObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.mainProductNetPrice",response.getReturnValue());
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
    
    getMainProductDiscountValue : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getMainProductDiscountVal");
        action.setParams({
            "quoteId" : component.get("v.quoteId"),
            "productJSONStr" : JSON.stringify(productObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() != null){
                    component.set("v.mainProductDiscountValue",response.getReturnValue());
                }else{
                    component.set("v.mainProductDiscountValue",0);
                }
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
    
    getFeatureProductCountWrapper : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var lstFeatureNames = component.get("v.featureNames");
        var action = component.get("c.getFeatureProductCountWrap");
        action.setParams({
            "quoteId" : component.get("v.quoteId"),
            "productJSONStr" : JSON.stringify(productObj),
            "featureNamesJSONStr" : JSON.stringify(lstFeatureNames)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.featureProductCountWrapper",response.getReturnValue());
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
            this.getProductOptionWrap(component);
        });
        $A.enqueueAction(action);
    },
    
    getProductOptionWrap : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getProductOptionWra");
        action.setParams({
            "quoteId" : component.get("v.quoteId"),
            "productJSONStr" : JSON.stringify(productObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.ProductOptionWrapper",response.getReturnValue());
                
                var totMSRPVal = component.get("v.mainProductPrice");
                if(component.get("v.ProductOptionWrapper") != null){
                    var productOptionWrapperLst = component.get("v.ProductOptionWrapper");
                    for(var ids = 0; ids<productOptionWrapperLst.length; ids++){
                        if(productOptionWrapperLst[ids].isSelected){
                            totMSRPVal += productOptionWrapperLst[ids].unitPrice;
                        }
                    }
                }
                component.set("v.total",totMSRPVal);
                
                var totNetVal;
                if(component.get("v.mainProductNetPrice") == undefined){
                    totNetVal = 0;
                }else{
                    totNetVal = component.get("v.mainProductNetPrice");
                }
                if(component.get("v.ProductOptionWrapper") != null){
                    var productOptionWrapperList = component.get("v.ProductOptionWrapper");
                    for(var idss = 0; idss<productOptionWrapperList.length; idss++){
                        if(productOptionWrapperList[idss].isSelected){
                            totNetVal += productOptionWrapperList[idss].netPrice;
                        }
                    }
                }
                component.set("v.netPriceTotal",totNetVal);
                
                component.set("v.isGetProductOptionWrapper",true);
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
    
    doSubmit : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.doSubmitQuote");
        action.setParams({
            "quoteId" : component.get("v.quoteId"),
            "productJSONStr" : JSON.stringify(productObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var resultString = response.getReturnValue();
                if(resultString.startsWith("ERROR")){
                    component.set("v.messageTitle",'ERROR');
                    component.set("v.messageText",resultString);
                }else{
                    component.set("v.quoteId",response.getReturnValue());
                    component.set("v.messageTitle",'');
                    component.set("v.messageText",'');
                    component.set("v.isSuccessfullySubmitted",true);
                }
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
})