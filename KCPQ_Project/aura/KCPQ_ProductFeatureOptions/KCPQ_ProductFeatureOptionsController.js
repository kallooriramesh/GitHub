({
    doInit : function(component, event, helper) {
        helper.getPathPrefixURL(component);
        helper.getbaseURL(component);
        helper.getInventoryValue(component);
        component.set("v.ProductOptionWrapper", []);
        helper.initializeProductOptionWrapper(component);
    },
    
    onChangeCheck : function(component, event, helper) {
        var indexText = event.getSource().get("v.text");
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
        var totVal = component.get("v.mainProductPrice");
        for(var ids = 0; ids<productOptionWrapperLst.length; ids++){
            if(productOptionWrapperLst[ids].isSelected){
                totVal += productOptionWrapperLst[ids].unitPrice;
            }
        }
        component.set("v.total",totVal);
    },
    
    nextClicked : function(component, event, helper) {
        
        var productOptionWrapperLst = component.get("v.ProductOptionWrapper");
        var proFeatureId = component.get("v.featureId");
        var minOptionAllowed;
        var maxOptionAllowed;
        for(var idx = 0; idx<productOptionWrapperLst.length; idx++) {
            if(proFeatureId == productOptionWrapperLst[idx].featureId){
                minOptionAllowed = productOptionWrapperLst[idx].minOptionCount;
                maxOptionAllowed = productOptionWrapperLst[idx].maxOptionCount;
            }
        }
        var lstIds = new Array();
        var lstSelectedProductIds = new Array();
        for (var idss = 0; idss<productOptionWrapperLst.length; idss++) {
            if (proFeatureId == productOptionWrapperLst[idss].featureId && 
                productOptionWrapperLst[idss].isSelected) {
                lstIds.push(idss);
            }
            if (productOptionWrapperLst[idss].isSelected) {
                lstSelectedProductIds.push(productOptionWrapperLst[idss].productRecordId);
            }
        }
        if(minOptionAllowed == 1 && maxOptionAllowed == 1 && lstIds.length > 1){
            component.set("v.messageTitle",'ERROR');
            component.set("v.messageText",'Please select only one option to proceed');
        } else if(minOptionAllowed == 1 && lstIds.length == 0){
        	component.set("v.messageTitle",'ERROR');
            component.set("v.messageText",'Atleast one option is required to proceed');
        } else if(lstIds.length > maxOptionAllowed){
            component.set("v.messageTitle",'ERROR');
            component.set("v.messageText",'Only ' + maxOptionAllowed + ' options are allowed to proceed');
        } else {
            component.set("v.messageTitle",'');
            component.set("v.messageText",'');
            component.set("v.ProductOptionWrapper",productOptionWrapperLst);
            helper.goNext(component, lstSelectedProductIds);
        	//component.set("v.progressStageOrder",(component.get("v.progressStageOrder") + 1));
        }
        
    },
    
    doBack : function(component, event, helper) {
        component.set("v.messageTitle",'');
        component.set("v.messageText",'');
        var prodOptWrapper = component.get("v.ProductOptionWrapper");
        component.set("v.ProductOptionWrapper",prodOptWrapper);
        component.set("v.progressStageOrder",(component.get("v.progressStageOrder") - 1));
    },
})