({
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
    
    getFieldSetFields : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getFieldSetFields");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.fieldSetFields",response.getReturnValue());
                component.set("v.messageTitle",'');
                component.set("v.messageText",'');
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
            this.getContact(component);
        });
        $A.enqueueAction(action);
    },
    
    getContact : function(component){
        component.set("v.startLoading",true);
        var contactObj = component.get("v.contactObj");
        var action = component.get("c.getContactRecord");
        action.setParams({
            "quoteId" : component.get("v.quoteId"),
            "contactJSONStr" : JSON.stringify(contactObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.contactObj",response.getReturnValue());
                component.set("v.messageTitle",'');
                component.set("v.messageText",'');
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
            component.set("v.isContactInformationFormShow",true);
        });
        $A.enqueueAction(action);
    },
    
    getContactInfoSave : function(component, index, event) {
        component.set("v.startLoading",true);
        var contactObj = component.get("v.contactObj");
        var action = component.get("c.getContactInformationSave");
        action.setParams({
            "quoteId" : component.get("v.quoteId"),
            "contactJSONStr" : JSON.stringify(contactObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var resultString = response.getReturnValue();
                if(resultString.startsWith("ERROR")){
                    component.set("v.messageTitle",'ERROR');
                    component.set("v.messageText",resultString);
                }else{
                    component.set("v.contactId",resultString);
                    component.set("v.messageTitle",'');
                    component.set("v.messageText",'');
                    component.set("v.progressStageOrder",2);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert('==Error==' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
                    } else if (errors[0] && errors[0].pageErrors) {
                        //alert('==Error==' + errors[0].pageErrors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].pageErrors[0].message);
                    } else {
                        //alert('===Error=== Unknown error');
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",'Unknown error');
                    }
                }
            }
            component.set("v.startLoading",false);
        });
        $A.enqueueAction(action);
    },
})