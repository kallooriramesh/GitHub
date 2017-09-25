({
	doInit : function(component, event, helper) {
        helper.getPathPrefixURL(component);
        helper.getInventoryValue(component);
        helper.getMainProductNetPrice(component);
        helper.getMainProductDiscountValue(component);
        component.set("v.ProductOptionWrapper", []);
        helper.initializeProductOptionWrapper(component);
	},
    
    doCheckDiscountValue : function(component, event, helper) {
        var indexVal = event.getSource().get("v.value");
        var isError = false;
        if(indexVal > 100 || indexVal < 0){
            isError = true;
            component.set("v.messageTitle",'ERROR');
            component.set("v.messageText",'Invalid Discount, Cannot be negative or more than 100%'); 
        }
        if(isError == true){
            event.getSource().set("v.value",0);
        }else if(indexVal === '' || indexVal === null || indexVal === undefined){
            event.getSource().set("v.value",0);
            component.set("v.messageTitle",'');
            component.set("v.messageText",'');
        }else{
            component.set("v.messageTitle",'');
            component.set("v.messageText",'');
        }
    },
    
    /*doCheckDiscountValue : function(component, event, helper) {
        var indexVal = event.getSource().get("v.value");
        if(indexVal === '' || indexVal === null || indexVal === undefined){
            event.getSource().set("v.value",0);
        }
    },*/
    
    nextClicked : function(component, event, helper) {
        helper.next(component);
    },
    
    doBack : function(component, event, helper) {
        component.set("v.messageTitle",'');
        component.set("v.messageText",'');
        component.set("v.progressStageOrder",(component.get("v.progressStageOrder") - 1));
    },
})