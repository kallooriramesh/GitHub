({
    getPathPrefixURL : function(component){
        component.set("v.startLoading",true);
        var action = component.get("c.getpathprefixURL");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.pathprefixURL", response.getReturnValue());
			}else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						alert('Error' + errors[0].message);
					}
				} else {
					alert('===Error=== Unknown error');
				}
			}
            component.set("v.startLoading",false);
		});
        $A.enqueueAction(action);
    },
    
    getsObjectRecs : function(component) {
        var action = component.get("c.getsObjRecords");
        if(component.get("v.limit") == 'Latest 5')
        {
            component.set("v.displayLimit",5);
        }else if(component.get("v.displayLimit") == null){
             component.set("v.displayLimit",10);
        }
        action.setParams({
            "sObj" : component.get("v.sObjectAPIName"),
            "fSetName" : component.get("v.FieldSetAPIName"),
            "orderByField": component.get("v.orderByField"),
            "orderBy": component.get("v.orderBy"),
            "recordsLimit": component.get("v.limit")
        });
        action.setCallback(this, function(resp) {
            var state=resp.getState();
            if(state === "SUCCESS"){
                console.log(resp.getReturnValue());
                var response = resp.getReturnValue();
                
                var sObjlist = response["sObjlist"];
                var fSetlist = response["fieldSetlist"];
                
                component.set("v.fieldlist", fSetlist);
                
                var objWrapperlist = [];
                var sObjWrapperTotallist = [];
                for (var sObj=0; sObj<sObjlist.length; sObj++){
                    var objRec = [];
                    for (var fSet=0; fSet<fSetlist.length; fSet++){
                        var fAPIname = fSetlist[fSet].fAPIName;
                        console.log('record details...');
                        console.log(sObjlist[sObj].sObjRecord);
                        var fValue = sObjlist[sObj].sObjRecord[fAPIname];
                        var jsonStr = JSON.parse(fSetlist[fSet].fSetMember);
                        console.log(jsonStr);
                        objRec.push({"fvalue" : fValue,
                                     "fDetails" : jsonStr,
                                     "rid" : sObjlist[sObj].sObjRecord.Id
                                    
                                    });
                    }
                    objRec.push({"fvalue" : sObjlist[sObj].sObjRecord.Id,"fDetails" : 'Id'});                                                               
                    
                    sObjWrapperTotallist.push(objRec);
                }
                //console.log(objWrapperlist.length);
                
                component.set("v.totalRecordsCount", sObjWrapperTotallist.length);
                //component.set("v.sObjWrapperlist", objWrapperlist);
                component.set("v.sObjWrapperTotallist", sObjWrapperTotallist);
                var displayLimit = component.get("v.displayLimit");
                for(var i=0;i<displayLimit;i++)
                {
                    objWrapperlist.push(sObjWrapperTotallist[i]);               
                }
                component.set("v.sObjWrapperlist", objWrapperlist);
                component.set("v.startCount",1);
                
                if(sObjWrapperTotallist.length <= displayLimit)
                    component.set("v.endCount",sObjWrapperTotallist.length);
                else
                    component.set("v.endCount",displayLimit);
                
                this.setPaginationTable(component);
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
        var pagesCountTable = new Array();
        for(var i=1;i<=pagesCount;i++)
        {
            pagesCountTable.push(i);
        }
        component.set("v.pagesCountTable",pagesCountTable);
        component.set("v.startLoading",false); 
        component.set("v.totalPages",pagesCount); 
        
    },
    
    setDisplayRecords : function(component,selectedPageNumber){
        var sObjWrapperTotallist = component.get("v.sObjWrapperTotallist");
        var objWrapperlist = [];
        var displayLimit = component.get("v.displayLimit");
        var displayLimitEnd;
        if((displayLimit*selectedPageNumber) <= component.get("v.sObjWrapperTotallist").length)
        {
            displayLimitEnd = (displayLimit*selectedPageNumber);
        }else{
            displayLimitEnd = component.get("v.sObjWrapperTotallist").length;
        }
        for(var j=(displayLimit*(selectedPageNumber-1)); j<displayLimitEnd;j++)
        {
            objWrapperlist.push(sObjWrapperTotallist[j]);               
        }
        component.set("v.sObjWrapperlist", objWrapperlist);
        component.set("v.startCount",((displayLimit*(selectedPageNumber-1))+1));
        
        component.set("v.endCount",displayLimitEnd);
        component.set("v.startLoading",false);
    },
    
    updateLeadOwner :function(component, event)
    {
        
        var action = component.get("c.updateLeadOwner");
        action.setParams({ leadId : event.target.id });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.messageTitle",'SUCCESS');
                component.set("v.messageText",'Lead accepted successfully.');
                this.getsObjectRecs(component);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            component.set("v.messageTitle",'ERROR');
                            component.set("v.messageText",errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        
        $A.enqueueAction(action);
    }
})