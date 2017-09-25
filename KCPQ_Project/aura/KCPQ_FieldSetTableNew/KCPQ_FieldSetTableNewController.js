({
    doInit : function(component, event, helper) {
        helper.getPathPrefixURL(component);
        helper.getsObjectRecs(component);
    },
    
    displaySelectedEntities :function(component, event, helper) {
        //component.set("v.offset",0);
        component.set("v.startLoading",true); 
        component.set("v.selectedPageNumber", 1);
        helper.setPaginationTable(component);
        helper.setDisplayRecords(component,component.get("v.selectedPageNumber"));
    },
    showSpinner : function (component, event, helper) {
        component.set("v.startLoading",true);  
    },
    hideSpinner : function (component, event, helper) {
        component.set("v.startLoading",false);  
    },
    /* gotoSelectedPage : function(component, event, helper)
    {
        var selectedPageNumber = event.target.id;
        console.log(event.target);
        alert(event.target.className);
        component.set("v.selectedPageNumber", selectedPageNumber);
        helper.setDisplayRecords(component, selectedPageNumber);
        event.target.className='pageSelected';
        //$A.util.addClass(selectedPageNumber, 'pageSelected');
    },*/
    nextPage : function(component, event, helper) {
        component.set("v.startLoading",true);
        var selectedPageNumber; 
        console.log(event.target);
        //alert(event.target.style.background-color);
        if(event.target.id=='firstpage')
        {
            component.set("v.lastStyle",'');
            component.set("v.firstStyle",'pointer-events:none;opacity:0.5;');  
            selectedPageNumber = 1;
        }
        else if(event.target.id=='nextpage')
        {
            var totalPages = component.get("v.totalPages");
            component.set("v.firstStyle",'');
            selectedPageNumber = component.get("v.selectedPageNumber");
            selectedPageNumber++;
            if(selectedPageNumber == totalPages)
            {
            	component.set("v.lastStyle",'pointer-events:none;opacity:0.5;');
            }
        }else if(event.target.id=='previouspage'){
            selectedPageNumber = component.get("v.selectedPageNumber");
            component.set("v.lastStyle",'');
            if(selectedPageNumber !=1)
            {
                selectedPageNumber--;
                if(selectedPageNumber ==1)
                {
                    component.set("v.firstStyle",'pointer-events:none;opacity:0.5;');  
                    
                }
            }
        } else if(event.target.id =='lastpage' ){
            selectedPageNumber = component.get("v.totalPages");
            component.set("v.firstStyle",'');
            component.set("v.lastStyle",'pointer-events:none;opacity:0.5;');
        }
        
        if(selectedPageNumber <= component.get("v.pagesCountTable").length)
        {
            component.set("v.selectedPageNumber", selectedPageNumber);
            helper.setDisplayRecords(component, selectedPageNumber);
            helper.setPaginationTable(component);
        }
    },
    
    doSort : function(component, event, helper)
    {
        component.set("v.orderByField", event.target.id);
        var orderBy=component.get("v.orderBy");
        if(orderBy == 'ASC')
        {
            component.set("v.orderBy",'DESC');
        }else if(orderBy == 'DESC')
        {
            component.set("v.orderBy",'ASC');
        }
        
        helper.getsObjectRecs(component);
    },
    
    acceptLead : function(component, event, helper)
    {
        helper.updateLeadOwner(component, event);
    },
    
    declineLead : function(component, event, helper)
    {
        
    }
})