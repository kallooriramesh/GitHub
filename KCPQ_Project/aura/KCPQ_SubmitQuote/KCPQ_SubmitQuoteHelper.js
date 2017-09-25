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
})