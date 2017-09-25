public class KCPQ_PricebookEntryWrapperCtrl {
	
    @AuraEnabled 
    public PricebookEntry pbEntry {get;set;}
    
    public KCPQ_PricebookEntryWrapperCtrl(PricebookEntry pbEntry){
        this.pbEntry = pbEntry;
    }
}