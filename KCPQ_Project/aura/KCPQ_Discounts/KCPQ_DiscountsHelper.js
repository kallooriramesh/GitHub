({
	/*getSummaryWrapper : function(component, event){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getSummaryWrapperFromQuoteLine");
        action.setParams({
            "quoteId" : component.get("v.quoteId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var responseResults = response.getReturnValue();
                var totalValue = 0;
                var wrappers = new Array();
                var currencySymbolVal = component.get("v.proCurrencySymbol");
                for (var idx=0; idx<responseResults.length; idx++) {
                    var wrapper = { 'featureProduct' : responseResults[idx].featureProduct, 
                                   'featureProductId' : responseResults[idx].featureProductId,
                                   'currencySymbol' : currencySymbolVal,
                                   'productUnitPrice' : responseResults[idx].productUnitPrice,
                                   'discountValue' : responseResults[idx].discountValue,
                                   'productNetPrice' : responseResults[idx].productNetPrice
                                  };
                    totalValue += responseResults[idx].productNetPrice;
                    wrappers.push(wrapper);
                }
                component.set('v.summaryWrappers', wrappers);
                component.set("v.total",totalValue);
                component.set("v.isGetSummaryWrapper",true);
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
            component.set("v.startLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    initializeProductOptionWrapper : function(component){
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
            this.getProductOptionWrapper(component);
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
                var totVal = component.get("v.mainProductPrice");
                if(component.get("v.ProductOptionWrapper") != null){
                    var productOptionWrapperLst = component.get("v.ProductOptionWrapper");
                    for(var ids = 0; ids<productOptionWrapperLst.length; ids++){
                        if(productOptionWrapperLst[ids].isSelected){
                            totVal += productOptionWrapperLst[ids].unitPrice;
                        }
                    }
                }
                component.set("v.total",totVal);
                component.set("v.isShow",true);
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

    
    /*next : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.doNext");
        var summWrappers = component.get("v.summaryWrappers");
        var mainProd = component.get("v.mainProduct");
        var myProductDiscount = new Array();
        for (var idx=0; idx<summWrappers.length; idx++) {
            if(summWrappers[idx].discountValue === ""){
                myProductDiscount.push(summWrappers[idx].featureProduct.Id + "<##>" + 0);
            }else{
                myProductDiscount.push(summWrappers[idx].featureProduct.Id + "<##>" + summWrappers[idx].discountValue);
            }
        }
        action.setParams({
            "quoteId" : component.get("v.quoteId"),
            "myProductDiscountJSONStr" : JSON.stringify(myProductDiscount),
            "productJSONStr" : JSON.stringify(mainProd)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.quoteId",response.getReturnValue());
                component.set("v.messageTitle",'');
        		component.set("v.messageText",'');
                component.set("v.progressStageOrder",(component.get("v.progressStageOrder") + 1));
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
    
    next : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.doNext");
        var summWrappers = component.get("v.summaryWrappers");
        var mainProd = component.get("v.mainProduct");
        var productOptionWrapperLst = null;
        if(component.get("v.ProductOptionWrapper") != null){
            productOptionWrapperLst = component.get("v.ProductOptionWrapper");
            for(var ids = 0; ids<productOptionWrapperLst.length; ids++){
                if(productOptionWrapperLst[ids].isSelected && productOptionWrapperLst[ids].discountValue == undefined){
                    productOptionWrapperLst[ids].discountValue = 0;
                }
            }
        }
        var mainProductDisVal = component.get("v.mainProductDiscountValue");
        action.setParams({
            "quoteId" : component.get("v.quoteId"),
            "myProductDiscountJSONStr" : JSON.stringify(productOptionWrapperLst),
            "productJSONStr" : JSON.stringify(mainProd),
            "mainProductDiscountVal" : JSON.stringify(mainProductDisVal)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.ProductOptionWrapper",response.getReturnValue());
                component.set("v.messageTitle",'');
        		component.set("v.messageText",'');
                component.set("v.progressStageOrder",(component.get("v.progressStageOrder") + 1));
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
})