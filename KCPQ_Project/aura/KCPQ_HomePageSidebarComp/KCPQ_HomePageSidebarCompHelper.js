({
    getPartnerWrap : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getPartnerWrapper");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
				var resultResponse = response.getReturnValue();
                console.log(resultResponse);
                component.set("v.pWrapper", resultResponse);
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
    
	initializeMenuWrapper : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getInitializeMenuWrapper");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var menuJSOnStr = response.getReturnValue();
                var menuList = JSON.parse(menuJSOnStr); 
                component.set("v.MenuWrapper",menuList);
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
    
    getMenuWrapper : function(component){
        component.set("v.startLoading",true);
        var menuLstValue = component.get("v.MenuWrapper");
        var action = component.get("c.getMenuWrapper");
        action.setParams({
            "menuJSONStr" : JSON.stringify(menuLstValue)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var menuWraObj = response.getReturnValue();
                component.set("v.MenuWrapper",menuWraObj);
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
    
    getUserInfo : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getUserDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
				var UserOb = response.getReturnValue();
                component.set("v.userInfo", UserOb);
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
    
    getbaseURL : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getbaseURL");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.baseURL", response.getReturnValue());
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