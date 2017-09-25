({
    doInit : function(component, event, helper) {
        helper.loadResourceDetails(component);
    },
    gotoURL : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/resource-detail?id='+event.target.id+'&type=resources'
        });
        urlEvent.fire();
    }
})