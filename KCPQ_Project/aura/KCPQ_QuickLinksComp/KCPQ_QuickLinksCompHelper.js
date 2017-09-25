({
	initializeQuickLinkWrapper : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getInitializeQuickLinkWrapper");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var quickLinkJSONStr = response.getReturnValue();
                var quickLinkList = JSON.parse(quickLinkJSONStr); 
                component.set("v.QuickLinkWrapper",quickLinkList);
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
    
    getQuickLinkWrapper : function(component){
        component.set("v.startLoading",true);
        var quickLinkLstValue = component.get("v.QuickLinkWrapper");
        var action = component.get("c.getQuickLinkWrapper");
        action.setParams({
            "quickLinkJSONStr" : JSON.stringify(quickLinkLstValue)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var quickLinkWraObj = response.getReturnValue();
                component.set("v.QuickLinkWrapper",quickLinkWraObj);
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
    
    /*getPathPrefixURL : function(component){
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
    }, */
	
})