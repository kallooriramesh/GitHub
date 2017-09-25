({
    doInit : function(component, event, helper) {
        var resourceId = (location.search.split('id=')[1]).split('&')[0];
        var articleType = location.search.split('type=')[1];
        component.set("v.recordId",resourceId);
        component.set("v.type",articleType);
        
        if(articleType == 'media')
        {
            component.set("v.sObjectAPIName",'Media__kav');
        }
        else if(articleType == 'faq')
        {
            component.set("v.sObjectAPIName",'FAQ__kav');
        }
            else if(articleType == 'resources')
            {
                component.set("v.sObjectAPIName",'Resource__kav');
            }
        helper.getHeadderDetails(component);
        
    },
    gotoURL : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var articleType =  component.get("v.type");
        urlEvent.setParams({
            "url": '/content-resources'
        });
        urlEvent.fire();
    },
    showSpinner : function (component, event, helper) {
        component.set("v.startLoading",true);   
    },
    hideSpinner : function (component, event, helper) {
        component.set("v.startLoading",false);    
    }
    
})