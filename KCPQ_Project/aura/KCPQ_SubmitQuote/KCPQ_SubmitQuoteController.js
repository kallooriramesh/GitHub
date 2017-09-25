({
	doInit : function(component, event, helper) {
		helper.getPathPrefixURL(component);
	},
    
    doPrintQuote : function(component, event, helper){
        var url = component.get("v.printQuoteURL") + component.get("v.quoteId") + '&isdtp=mn';
        var quoteId = component.get("v.quoteId");
        window.open(url,"_blank",'Popup', quoteId, 'height=600,width=1250,left=40,top=10,resizable=yes,scrollbars=yes,toolbar=no,status=no');
    },
})