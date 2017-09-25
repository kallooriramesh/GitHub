({
	doInit : function(component, event, helper) {
        helper.getPathPrefixURL(component);
		helper.getFieldSetFields(component);
	},
    
    doNextContactInfo : function(component, event, helper) {
        helper.getContactInfoSave(component);
    }
})