({
	getMainProductRecord : function(component){
        component.set("v.startLoading",true);
        var productLstValue = component.get("v.mainProduct");
        var action = component.get("c.getMainProduct");
        action.setParams({
        	"quoteId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var productRecord = response.getReturnValue();
                if(productRecord != null){
                    console.log('==New Cloned Product Id==' + productRecord.Id);
                    component.set("v.mainProduct",productRecord);
                    this.getProductWrapperCtrl(component);
                }else{
                    component.set("v.noProductFound",true);
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
    
    getProductWrapperCtrl : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getProductWrapper");
        action.setParams({
            "productJSONStr" : JSON.stringify(productObj),
            "quoteId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var proWra = response.getReturnValue();
                component.set("v.productWrapper",proWra);
                component.set("v.currencySymbol",proWra.currencySymbol);
                component.set("v.mainProductPrice",proWra.productPrice);
                component.set("v.mainProductNetPrice",proWra.productNetPrice);
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
            this.getFeatureNames(component);
        });
        $A.enqueueAction(action);
    },
    
    getFeatureNames : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getFeatureNames");
        action.setParams({
            "productJSONStr" : JSON.stringify(productObj),
            "quoteId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.featureNames",response.getReturnValue());
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
            this.getFeatureIds(component);
        });
        $A.enqueueAction(action);
    },
    
    getFeatureIds : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getFeatureIds");
        action.setParams({
            "productJSONStr" : JSON.stringify(productObj),
            "quoteId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.featureIds",response.getReturnValue());
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
            this.getProgressStageOrder(component);
        });
        $A.enqueueAction(action);
    },
    
    getProgressStageOrder : function(component){
        component.set("v.startLoading",true);
        var featureNamesSize;
        if(component.get("v.featureNames") != null){
            var featureNames = component.get("v.featureNames");
            featureNamesSize = featureNames.length;
        }else{
            featureNamesSize = 0;
        }
        var action = component.get("c.getProgressStageOrderValue");
        action.setParams({
            "quoteId" : component.get("v.recordId"),
            "featureLstSizeJSON" : JSON.stringify(featureNamesSize)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() != 1){
                    component.set("v.isSubmitButtonDisabled",true);
                }
                component.set("v.progressStageOrder",response.getReturnValue());
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
            this.getColorNames(component);
        });
        $A.enqueueAction(action);
    },
    
    getColorNames : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getColorNamesLst");
        action.setParams({
            "quoteId" : component.get("v.recordId"),
            "productJSONStr" : JSON.stringify(productObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() != null){
                    var colorNamesResponse = new Array();
                    colorNamesResponse = response.getReturnValue();
                    var colorNamesLst = new Array();
                    for(var idx=0;idx<colorNamesResponse.length; idx++){
                        var proName = colorNamesResponse[idx];
                        proName = proName.split(' ').join('_');
                        colorNamesLst.push(proName);
                    }
                    component.set("v.colorNames",colorNamesLst);
                }else{
                    component.set("v.colorNames",null);
                }
                component.set("v.iscolorNamesGet",true);
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