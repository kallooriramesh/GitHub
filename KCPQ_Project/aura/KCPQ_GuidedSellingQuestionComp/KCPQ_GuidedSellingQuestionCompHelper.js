({
	initializeProcessInputWrapper : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getInitializeProcessInputWrapper");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var ProcessInputJSONStr = response.getReturnValue();
                var ProcessInputList = JSON.parse(ProcessInputJSONStr); 
                component.set("v.ProcessInputWrapper",ProcessInputList);
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
    
    getProcessInputWrapper : function(component){
        component.set("v.startLoading",true);
        var ProcessInputLstValue = component.get("v.ProcessInputWrapper");
        var action = component.get("c.getProcessInputWrapper");
        action.setParams({
            "processInputJSONStr" : JSON.stringify(ProcessInputLstValue),
            "quoteProId" : component.get("v.quoteProcessId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var ProcessInputWraObj = response.getReturnValue();
                component.set("v.ProcessInputWrapper",ProcessInputWraObj);
                this.getFieldSetFields(component);
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
        var ProcessInputLstValue = component.get("v.ProcessInputWrapper");
        var action = component.get("c.getFieldSetFields");
        action.setParams({
            "processInputJSONStr" : JSON.stringify(ProcessInputLstValue)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var fieldSetFields = response.getReturnValue();
                component.set("v.fieldSetFields",fieldSetFields);
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
            
            component.set("v.isInitialized",true);
            component.set("v.startLoading",false);
        });
        $A.enqueueAction(action);
    },
    
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