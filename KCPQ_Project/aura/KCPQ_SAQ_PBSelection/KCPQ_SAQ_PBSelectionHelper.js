({
	setPriceBookPickList : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getPricebookPicklist");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var PricebookList = response.getReturnValue();
                var PricebookOptions = [];
                var isPricebookFound = false;
                for(var i=0; i < PricebookList.length; i++){
                    var pbInfo = PricebookList[i].split('<##>');
                    var pbValue = pbInfo[1].split('<@@>');
                    if(pbInfo[0] != ''){
                        if(pbValue[1] == "true"){
                            PricebookOptions.push({ class: "optionClass", value:pbInfo[0], label: pbValue[0], selected: "true"});
                            isPricebookFound = true;
                            component.set("v.pricebookPicklistVal",pbInfo[0]);
                        	this.createQuote(component,event);
                        }else{
                            PricebookOptions.push({ class: "optionClass", value:pbInfo[0], label: pbValue[0]});
                        }
                    }else{
                        PricebookOptions.push({ class: "optionClass", value:pbInfo[0], label: pbValue[0], disabled: true});
                    }
                }
                if(isPricebookFound == false){
                    component.set("v.isShowPriceBookSelection",true);
                	component.find("pricebookPickListId").set("v.options", PricebookOptions);
                	this.doNext(component,event);
                }
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
        });
        $A.enqueueAction(action);
    },
    
    doNext : function(component,event){
        component.set("v.startLoading",true);
		var pricebookinputCmp = component.find("pricebookPickListId");
        var pricebookValue = component.get("v.pricebookPicklist");
        
        if(pricebookValue === ''){
            pricebookinputCmp.set("v.errors", [{message:"Required: Pricebook"}]);
            component.set("v.isShowNextButton",true);
        }
        else {
            pricebookinputCmp.set("v.errors", null);
            var pricebookSelected = component.find("pricebookPickListId").get("v.value");
            if(pricebookSelected != ''){
                component.set("v.pricebookPicklistVal",pricebookSelected);
                this.createQuote(component,event);
            }
        }
        component.set("v.startLoading",false);
    },
    
    createQuote :function(component,event){
        component.set("v.startLoading",true);
        var priceBookSeleted=component.get("v.pricebookPicklistVal");
        var action = component.get("c.createPriceBookQuote");
        action.setParams({pricebookID : priceBookSeleted});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                
                var quote=response.getReturnValue();
                console.log(quote);
                component.set("v.quote",quote);
                
                component.set("v.isPriceBookSeleted",true);
            }
             else if (state === "INCOMPLETE") {
                  var errors = response.getError();
                alert('Error' + errors[0].message);
            }
            else if (state === "ERROR") {
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

    }
})