({
    /*getWrapper : function(component){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var action = component.get("c.getFeatureProductWrapper");
        action.setParams({
            "productJSONStr" : JSON.stringify(productObj),
            "productFeatureId" : component.get("v.featureId"),
            "quoteId" : component.get("v.quoteId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.wrappers",response.getReturnValue());
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
    
    getbaseURL : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getbaseURL");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.baseURL", response.getReturnValue());
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
                var prodOptWra = response.getReturnValue();
                for(var i = 0;i<prodOptWra.length;i++){
                    var proImg = prodOptWra[i].productImage.split('/servlet/');
                    prodOptWra[i].productImage = '<img src="' + component.get("v.baseURL") + '/servlet/' + proImg[1];
                }
                component.set("v.ProductOptionWrapper",response.getReturnValue());
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
            this.checkRules(component);
        });
        $A.enqueueAction(action);
    },
    
    checkRules : function(component){
        component.set("v.startLoading",true);
        var productOptionWraList = component.get("v.ProductOptionWrapper");
        var prodFeatId = component.get("v.featureId");
        for(var idz = 0; idz<productOptionWraList.length; idz++){
            if(productOptionWraList[idz].isSelected == true){
                var indexText = productOptionWraList[idz].productRecordId;        
                var productOptionWrapperLst = component.get("v.ProductOptionWrapper");
                var checkBoxCheck = false;
                var proFeatureId = '';
                var minOptionAllowed;
                var maxOptionAllowed;
                for(var idx = 0; idx<productOptionWrapperLst.length; idx++) {
                    if(productOptionWrapperLst[idx].productRecordId == indexText){
                        checkBoxCheck = productOptionWrapperLst[idx].isCheckBox;
                        proFeatureId = productOptionWrapperLst[idx].featureId;
                        minOptionAllowed = productOptionWrapperLst[idx].minOptionCount;
                        maxOptionAllowed = productOptionWrapperLst[idx].maxOptionCount;
                    }
                }
                
                if(!checkBoxCheck){
                    for(var idxx = 0; idxx<productOptionWrapperLst.length; idxx++) {
                        if(proFeatureId == productOptionWrapperLst[idxx].featureId && 
                           productOptionWrapperLst[idxx].productRecordId != indexText){
                            productOptionWrapperLst[idxx].isSelected = false;
                        }
                    }
                }
                var setProDependentIds = new Array();
                var setProDependentProductName = new Array();
                var setSelectedProductDependentIds = new Array();
                for(var idxx = 0; idxx<productOptionWrapperLst.length; idxx++) {
                    if(proFeatureId == productOptionWrapperLst[idxx].featureId && 
                       productOptionWrapperLst[idxx].productRecordId != indexText){
                        var setDepProductIds = productOptionWrapperLst[idxx].setDependentProductIds;
                        for(var dpIdx = 0; dpIdx<setDepProductIds.length; dpIdx++){
                            setProDependentIds.push(productOptionWrapperLst[idxx].setDependentProductIds[dpIdx]);
                            setProDependentProductName.push(productOptionWrapperLst[idxx].productName);
                        }
                    }else if(proFeatureId == productOptionWrapperLst[idxx].featureId && 
                             productOptionWrapperLst[idxx].productRecordId == indexText){
                        var setDepProIds = productOptionWrapperLst[idxx].setDependentProductIds;
                        for(var dpIdxx = 0; dpIdxx<setDepProIds.length; dpIdxx++){
                            setSelectedProductDependentIds.push(productOptionWrapperLst[idxx].setDependentProductIds[dpIdxx]);
                        }
                    }
                }
                for(var idxxx = 0; idxxx<productOptionWrapperLst.length; idxxx++){
                    var pNameInt = 0;
                    if(setProDependentIds.includes(productOptionWrapperLst[idxxx].productRecordId)){
                        productOptionWrapperLst[idxxx].isDisabled = true;
                        productOptionWrapperLst[idxxx].isSelected = false;
                        productOptionWrapperLst[idxxx].disabledMsg = 'Requires ' + setProDependentProductName[pNameInt];
                        pNameInt++;
                    }
                    if(setSelectedProductDependentIds.includes(productOptionWrapperLst[idxxx].productRecordId)){
                        productOptionWrapperLst[idxxx].isDisabled = false;
                        productOptionWrapperLst[idxxx].isSelected = false;
                        productOptionWrapperLst[idxxx].disabledMsg = '';
                    }
                }
                
                var lstIds = new Array();
                for (var idss = 0; idss<productOptionWrapperLst.length; idss++) {
                    if (proFeatureId == productOptionWrapperLst[idss].featureId && 
                        productOptionWrapperLst[idss].isSelected) {
                        lstIds.push(idss);
                    }
                }
                if(maxOptionAllowed != undefined && lstIds.length > maxOptionAllowed){
                    component.set("v.messageTitle",'ERROR');
                    component.set("v.messageText",'Only ' + maxOptionAllowed + ' options are allowed to proceed');
                }else{
                    component.set("v.messageTitle",'');
                    component.set("v.messageText",'');
                }
                component.set("v.ProductOptionWrapper",productOptionWrapperLst);
            }
        }
        var totVal = component.get("v.mainProductPrice");
        var prodOptWrapperList = component.get("v.ProductOptionWrapper");
        for(var ids = 0; ids<prodOptWrapperList.length; ids++){
            if(prodOptWrapperList[ids].isSelected){
                totVal += prodOptWrapperList[ids].unitPrice;
            }
        }
        component.set("v.total",totVal);
        component.set("v.startLoading",false);
        component.set("v.isShowDetails",true);
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
    
    goNext : function(component, lstSelectedProductIds){
        component.set("v.startLoading",true);
        var productObj = component.get("v.mainProduct");
        var selectedProdIdsListJSONStr = JSON.stringify(lstSelectedProductIds);
        var action = component.get("c.doNext");
        action.setParams({
            "selectedProductIdsListJSONStr": selectedProdIdsListJSONStr,
            "productJSONStr" : JSON.stringify(productObj),
            "quoteId" : component.get("v.quoteId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.quoteId",response.getReturnValue());
                component.set("v.messageTitle",'');
                component.set("v.messageText",'');
                component.set("v.progressStageOrder",(component.get("v.progressStageOrder") + 1));
            } else if (state === "ERROR") {
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