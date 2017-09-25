({
    getAllProducts : function(component, event) {
        var action = component.get("c.getProducts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                var allProducts = response.getReturnValue();
                var allProductsList = [];
                for(var j=0;j<allProducts.length;j++)
                {
                    if(allProducts[j].product.Product_Image_New__c != null)
                    {
                        allProductsList.push(allProducts[j]);
                    }
                }
                
                component.set("v.allProducts",allProductsList);
                var productslist = [];
                //alert(allProductsList.length);
                component.set("v.totalRecordsCount", allProductsList.length);
                var displayLimit = component.get("v.displayLimit");
                for(var i=0;i<allProductsList.length;i++)
                {
                    if(productslist.length<displayLimit)
                    {
                        if(allProductsList[i].product.Product_Image_New__c != null)
                        {
                            productslist.push(allProductsList[i]);    
                            
                        }
                    }
                    else{
                        break;
                    }
                }
                component.set("v.products", productslist);
                this.setPaginationTable(component);
                this.setDisplayRecords(component,component.get("v.selectedPageNumber"));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert('Error' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
                    }
                } else {
                    alert('===Error=== Unknown error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    createProductQuote : function(component, event) {
        var action = component.get("c.createProductQuote");
        action.setParams({productId : event.target.id});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                
                console.log(response.getReturnValue());
                //component.set("v.products",response.getReturnValue());
                this.gotoQuoteURL(component, event, response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert('Error' + errors[0].message);
                        component.set("v.messageTitle",'ERROR');
                        component.set("v.messageText",errors[0].message);
                    }
                } else {
                    alert('===Error=== Unknown error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    gotoQuoteURL : function (component, event, quoteId) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/quote/"+quoteId
        });
        urlEvent.fire();
    },
    
    setDisplayRecords : function(component,selectedPageNumber){
        var allProducts = component.get("v.allProducts");
        var objWrapperlist = [];
        var displayLimit = component.get("v.displayLimit");
        var displayLimitEnd;
        if((displayLimit*selectedPageNumber) <= component.get("v.allProducts").length)
        {
            displayLimitEnd = (displayLimit*selectedPageNumber);
        }else{
            displayLimitEnd = component.get("v.allProducts").length;
        }
        for(var j=(displayLimit*(selectedPageNumber-1)); j<displayLimitEnd;j++)
        {
            objWrapperlist.push(allProducts[j]);               
        }
        component.set("v.products", objWrapperlist);
        component.set("v.startCount",((displayLimit*(selectedPageNumber-1))+1));
        
        component.set("v.endCount",displayLimitEnd);
        component.set("v.startLoading",false);
    },
    
    setPaginationTable: function(component){
        var limit = component.get("v.displayLimit");
        var recordsCount = component.get("v.totalRecordsCount");
        var pagesCount;
        if(Math.ceil(recordsCount/limit)<1)
        {
            pagesCount = 1;
        }
        else{
            pagesCount = Math.ceil(recordsCount/limit);
        }
        component.set("v.totalPages",pagesCount); 
        
    },
    
    
})