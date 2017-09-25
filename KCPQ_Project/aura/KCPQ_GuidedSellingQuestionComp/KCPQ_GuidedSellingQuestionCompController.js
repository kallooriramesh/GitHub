({
	doInit : function(component, event, helper) {
        component.set("v.ProcessInputWrapper", []);
        helper.initializeProcessInputWrapper(component);
        helper.getProcessInputWrapper(component);
        helper.getPathPrefixURL(component);
	},
    
    doSubmitQuestion : function(component, event, helper){
        component.set("v.isSubmitted",true);
    }
})