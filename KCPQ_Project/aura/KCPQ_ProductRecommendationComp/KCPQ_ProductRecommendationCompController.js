({
	doInit : function(component, event, helper) {
        helper.createQuote(component);
	},
    
    doBuild: function(component, event, helper){
        var self = this;
        var index = event.target.dataset.index;
        helper.quoteProductAdder(component,index,event);
    },
    
    doBack : function(component, event, helper){
        component.set("v.isSubmitted",false);
    },
})