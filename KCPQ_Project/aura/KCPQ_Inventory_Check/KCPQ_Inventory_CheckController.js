({
	doInit : function(component, event, helper) {
		helper.getAllProducts(component, event);
	},
    showSpinner : function (component, event, helper) {
        component.set("v.startLoading",true);  
    },
    hideSpinner : function (component, event, helper) {
        component.set("v.startLoading",false);  
    },
    createQuote : function (component, event, helper) {
        helper.createProductQuote(component, event);
    },
    
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
        
        if(selectedPageNumber <= component.get("v.totalPages"))
        {
            component.set("v.selectedPageNumber", selectedPageNumber);
            helper.setDisplayRecords(component, selectedPageNumber);
            helper.setPaginationTable(component);
        }
    },
    
})