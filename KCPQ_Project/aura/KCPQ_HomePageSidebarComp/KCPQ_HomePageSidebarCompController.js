({
	doInit : function(component, event, helper) {
        helper.getPartnerWrap(component);
        component.set("v.MenuWrapper", []);
        helper.initializeMenuWrapper(component);
        helper.getMenuWrapper(component);
        helper.getUserInfo(component);
        helper.getbaseURL(component);
        helper.getPathPrefixURL(component);
	},
    
})