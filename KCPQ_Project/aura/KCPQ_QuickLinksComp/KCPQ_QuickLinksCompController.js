({
	doInit : function(component, event, helper) {
        component.set("v.QuickLinkWrapper", []);
        helper.initializeQuickLinkWrapper(component);
        helper.getQuickLinkWrapper(component);
        /*helper.getPathPrefixURL(component);*/
	},
    
})