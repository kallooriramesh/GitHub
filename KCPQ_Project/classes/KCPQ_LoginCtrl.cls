public class KCPQ_LoginCtrl {
	
    @AuraEnabled
    public static String getbaseURL(){
        return site.getbaseurl();
    }
}