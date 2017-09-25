({
	doInit : function(component, event, helper) {
		helper.loadMediaResources(component);
	},
    gotoURL : function (component, event, helper) {
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
        "url": '/resource-detail?id='+event.target.id+'&type=media'
    });
    urlEvent.fire();
}
})