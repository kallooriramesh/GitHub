({
    getRecordDetails : function(component) 
    {
     var action = component.get("c.getsRecordDetails");
     
     action.setParams({
         "sObj" : component.get("v.sObjectAPIName"),
         "fSetName" : component.get("v.FieldSetAPIName"),
         "recordId": component.get("v.recordId")
     });
     action.setCallback(this, function(resp) {
         var state=resp.getState();
         //alert(state);
         var fieldTable ='<ul class="slds-card__body_inner slds-grid slds-wrap slds-grid_pull-padded slds-grid slds-page-header__detail-row">';
         if(state === "SUCCESS"){
             console.log(resp.getReturnValue());
             var response = resp.getReturnValue();
             
             component.set("v.recordDetails",response);
             
             console.log(component.get("v.recordDetails"));
             for(var i=0;i<response.length;i++)
             {
                 //alert(response[i].fAPIName);
                 if(response[i].fAPIName != 'Summary' && response[i].fAPIName !='Content__c' && response[i].fAPIName !='Title')
                 fieldTable = fieldTable+'<li class="slds-p-horizontal_large slds-size_1-of-1 slds-page-header__detail-block"><p class="slds-section__title slds-theme_shade" style="font-size:14px;background-color:white;font-weight: bold;">'+response[i].fLabel+'</p><p class="slds-section__title slds-theme_shade" style="font-size:14px;background-color:white;">'+response[i].fValue+'</p></li>';
             }
             fieldTable = fieldTable+'</ul>';
             component.set("v.fieldTable",fieldTable);
         }
         
         else if (state === "INCOMPLETE") {
             // do something
         }
             else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log("Error message: " + 
                                     errors[0].message);
                         
                         component.set("v.messageTitle",'ERROR');
                         component.set("v.messageText",errors[0].message);
                     }
                 } else {
                     console.log("Unknown error");
                 }
             }
     });
     $A.enqueueAction(action);
    },
    
    getHeadderDetails : function(component)
     {
     var action = component.get("c.getsRecordDetails");
     
     action.setParams({
         "sObj" : component.get("v.sObjectAPIName"),
         "fSetName" : component.get("v.headerFieldSetName"),
         "recordId": component.get("v.recordId")
     });
     action.setCallback(this, function(resp) {
         var state=resp.getState();
         //alert(state);
         if(state === "SUCCESS"){
             console.log(resp.getReturnValue());
             var response = resp.getReturnValue();
             //alert(response);
             this.getRecordDetails(component);
             component.set("v.headderDetails",response);
             
             console.log('headder details..');
             console.log(component.get("v.headderDetails"));
             
         }
         
         else if (state === "INCOMPLETE") {
             // do something
         }
             else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log("Error message: " + 
                                     errors[0].message);
                         
                         component.set("v.messageTitle",'ERROR');
                         component.set("v.messageText",errors[0].message);
                     }
                 } else {
                     console.log("Unknown error");
                 }
             }
     });
     $A.enqueueAction(action);
    },
})