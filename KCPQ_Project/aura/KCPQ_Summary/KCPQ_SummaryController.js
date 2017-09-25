({
	doInit : function(component, event, helper) {
        if(component.get("v.isSubmitButtonDisabled")){
            component.set("v.onlyShowBuildSummaryTableClass",'slds-medium-size_8-of-8');
        }
        helper.getPathPrefixURL(component);
        helper.getMainProductNetPrice(component);
        helper.getMainProductDiscountValue(component);
        if(component.get("v.isSubmitButtonDisabled") == false){
        	helper.getFeatureProductCountWrapper(component);
        }else{
            helper.getProductOptionWrap(component);
        }
	},
    
    pressChangeLink : function(component, event, helper) {
        var index = event.target.dataset.index;
        var changeIndex = parseInt(index) + 2;
        component.set("v.messageTitle",'');
        component.set("v.messageText",'');
        component.set("v.progressStageOrder",changeIndex);
    },
    
    pressSubmitQuote : function(component, event, helper) {
        helper.doSubmit(component);
    },
    
})