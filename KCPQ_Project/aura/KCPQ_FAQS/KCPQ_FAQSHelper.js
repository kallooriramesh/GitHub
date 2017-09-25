({
	loadFAQDetails : function(component) {
		var action = component.get("c.getFaqDetails");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            component.set("v.faqList",response.getReturnValue()); 
            }
            else if (state === "INCOMPLETE") {
               
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    }
})