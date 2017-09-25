({
	doInit : function(component, event, helper) {
		helper.setPriceBookPickList(component);
	},
    
    handleError: function(component, event){
        /* do any custom error handling
         * logic desired here */
        // get v.errors, which is an Object[]
        var errorsArr  = event.getParam("errors");
        for (var i = 0; i < errorsArr.length; i++) {
            console.log("error " + i + ": " + JSON.stringify(errorsArr[i]));
        }
    },

    handleClearError: function(component, event) {
        /* do any custom error handling
         * logic desired here */
        var inputCmp = component.find("pricebookPickListId");
        var value = component.get("v.pricebookPicklist");
        if (value === '') {
            inputCmp.set("v.errors", [{message:"Required: Pricebook"}]);
        } else {
            inputCmp.set("v.errors", null);
            component.set("v.pricebookPicklistVal",value);
        }
    },
    
    doNextSelectionComp : function(component, event, helper) {
        helper.doNext(component, event);
        /*var pricebookinputCmp = component.find("pricebookPickListId");
        var pricebookValue = component.get("v.pricebookPicklist");
        
        if(pricebookValue === ''){
            pricebookinputCmp.set("v.errors", [{message:"Required: Pricebook"}]);
        }
        else {
            pricebookinputCmp.set("v.errors", null);
            var pricebookSelected = component.find("pricebookPickListId").get("v.value");
            if(pricebookSelected != ''){
                component.set("v.pricebookPicklistVal",pricebookSelected);
                helper.createQuote(component,event);
            }
        }*/
    }
    
})