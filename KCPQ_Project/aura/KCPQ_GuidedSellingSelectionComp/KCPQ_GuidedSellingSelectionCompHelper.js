({
	setQuoteProcessPickList : function(component){
        component.set("v.startLoading",true);
        var isOneTimeCompleted = component.get("v.runOneTimeOnlyCompleted");
        if(isOneTimeCompleted == true){
            component.set("v.runOneTimeOnly",true);
        }
        var action = component.get("c.getQuoteProcessPicklist");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var QuoteProcessList = response.getReturnValue();
                var QuoteProcessOptions = [];
                var quoteProcessFound = false;
                for(var i=0; i < QuoteProcessList.length; i++){
                    var qpInfo = QuoteProcessList[i].split('<##>');
                    var qpValue = qpInfo[1].split('<@@>');
                    if(qpInfo[0] != ''){
                        if(qpValue[1] == "true"){
                            QuoteProcessOptions.push({ class: "optionClass", value:qpInfo[0], label: qpValue[0], selected: "true"});
                        	quoteProcessFound = true;
                            component.set("v.quoteProcessPicklistVal",qpInfo[0]);
                        }else{
                            QuoteProcessOptions.push({ class: "optionClass", value:qpInfo[0], label: qpValue[0]});
                        }
                    }else{
                        QuoteProcessOptions.push({ class: "optionClass", value:qpInfo[0], label: qpValue[0], disabled: true});
                    }
                }
                var isSelectionShow = component.get("v.isShowSelection");
                if(quoteProcessFound == false || isSelectionShow == true){
                    component.set("v.isShowSelection",true);
                    component.find("quoteProcessPickListId").set("v.options", QuoteProcessOptions);
                }
                //component.find("quoteProcessPickListId").set("v.options", QuoteProcessOptions);
            } else if (state === "ERROR") {
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
            var pricebookValue = component.get("v.pricebookPicklistVal");
            if(pricebookValue === '' && isOneTimeCompleted == false){
                this.setPriceBookPickList(component);
            }
        });
        $A.enqueueAction(action);
    },
    
    setPriceBookPickList : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getPricebookPicklist");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var PricebookList = response.getReturnValue();
                var PricebookOptions = [];
                var priceBookFound = false;
                for(var i=0; i < PricebookList.length; i++){
                    var pbInfo = PricebookList[i].split('<##>');
                    var pbValue = pbInfo[1].split('<@@>');
                    if(pbInfo[0] != ''){
                        if(pbValue[1] == "true"){
                            PricebookOptions.push({ class: "optionClass", value:pbInfo[0], label: pbValue[0], selected: "true"});
                        	priceBookFound = true;
                            component.set("v.pricebookPicklistVal",pbInfo[0]);
                        }else{
                            PricebookOptions.push({ class: "optionClass", value:pbInfo[0], label: pbValue[0]});
                        }
                    }else{
                        PricebookOptions.push({ class: "optionClass", value:pbInfo[0], label: pbValue[0], disabled: true});
                    }
                }
                var quoteProcessValue = component.get("v.quoteProcessPicklistVal");
                if(priceBookFound == false || quoteProcessValue === ''){
                    component.set("v.isShowSelection",true);
                	component.find("pricebookPickListId").set("v.options", PricebookOptions);
                }
                //component.find("pricebookPickListId").set("v.options", PricebookOptions);
            } else if (state === "ERROR") {
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
            this.goNext(component);
        });
        $A.enqueueAction(action);
    },
    
    goNext : function(component){
        component.set("v.startLoading",true);
        var pricebookValue = component.get("v.pricebookPicklistVal");
        var quoteProcessValue = component.get("v.quoteProcessPicklistVal");
        if(quoteProcessValue === '' || pricebookValue === ''){
            var isQuickQuoteValue = component.get("v.isQuickQuote");
            if(isQuickQuoteValue == true){
                this.next(component);
            }
        }else{
            component.set("v.KCPQ_GuidedSellingSelectionBool",true);
        }
        component.set("v.startLoading",false);
    },
    
    next : function(component){
        component.set("v.startLoading",true);
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
            var oneTimeRun = component.get("v.runOneTimeOnly");
            if(oneTimeRun == false){
                component.set("v.runOneTimeOnlyCompleted",true);
                this.setQuoteProcessPickList(component);
            }
            component.set("v.startLoading",false);
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
            component.set("v.startLoading",false);
            component.set("v.KCPQ_GuidedSellingSelectionBool",true);
        }
    }
})