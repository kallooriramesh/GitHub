public class KCPQ_QuickLinksWrapperCtrl {
	
    @AuraEnabled 
    public KCPQ_Quick_Link__c QuickLink {get;set;}
    
    public KCPQ_QuickLinksWrapperCtrl(KCPQ_Quick_Link__c QuickLink){
        this.QuickLink = QuickLink;
    }
}