({
	doInit : function(component, event, helper) {
		//helper.getProductTypes(component, event);
		//alert('Init');
		helper.getProductWithTypes(component, event);
	},
    addQuoteLineItems : function(component, event, helper) {
		helper.setQuoteLineItems(component, event);
	},
    showSpinner : function (component, event, helper) {
        component.set("v.startLoading",true);  
    },
    hideSpinner : function (component, event, helper) {
        component.set("v.startLoading",false);  
    }
})