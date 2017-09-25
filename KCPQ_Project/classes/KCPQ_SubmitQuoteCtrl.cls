public class KCPQ_SubmitQuoteCtrl {
	
    @AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
    }
}