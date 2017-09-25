({
	doInit : function(component, event, helper) {
        helper.setQuoteProcessPickList(component);
        //helper.setPriceBookPickList(component);
        //var quoteProcessvalue = component.get("v.quoteProcessPicklist");
        //component.set("v.quoteProcessPicklistVal",quoteProcessvalue);
	},
    
    onQuoteProcessChange : function(component, event, helper) {
        var quoteProcessinputCmp = component.find("quoteProcessPickListId");
        var quoteProcessvalue = component.get("v.quoteProcessPicklist");
        if (quoteProcessvalue === '') {
            quoteProcessinputCmp.set("v.errors", [{message:"Required: Quote Process"}]);
        } else {
            quoteProcessinputCmp.set("v.errors", null);
            component.set("v.quoteProcessPicklistVal",quoteProcessvalue);
        }
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
        var pricebookinputCmp = component.find("pricebookPickListId");
        var pricebookValue = component.get("v.pricebookPicklist");
        var quoteprocessinputCmp = component.find("quoteProcessPickListId");
        var quoteprocessValue = component.get("v.quoteProcessPicklist");
        if(quoteprocessValue === '' || pricebookValue === ''){
            if(quoteprocessValue === ''){
                quoteprocessinputCmp.set("v.errors", [{message:"Required: Quote Process"}]);
            }
            if(pricebookValue === ''){
                pricebookinputCmp.set("v.errors", [{message:"Required: Pricebook"}]);
            }
        } else {
            pricebookinputCmp.set("v.errors", null);
            quoteprocessinputCmp.set("v.errors", null);
            var pricebookSelected = component.find("pricebookPickListId").get("v.value");
            if(pricebookSelected !== ''){
                component.set("v.pricebookPicklistVal",pricebookSelected);
            }
            var quoteProcessSelected = component.find("quoteProcessPickListId").get("v.value");
            if(quoteProcessSelected !== ''){
                component.set("v.quoteProcessPicklistVal",quoteProcessSelected);
            }
            component.set("v.KCPQ_GuidedSellingSelectionBool",true);
        }
	},
})