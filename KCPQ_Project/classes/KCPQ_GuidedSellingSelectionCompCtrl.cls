public class KCPQ_GuidedSellingSelectionCompCtrl {
	
    @AuraEnabled
    public static List<String> getQuoteProcessPicklist(){
        return KCPQ_Utility.getQuoteProcessPicklist();
    }
    
    @AuraEnabled
    public static List<String> getPricebookPicklist(){
        return KCPQ_Utility.getPricebookPicklist();
    }
}