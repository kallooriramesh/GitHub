public class KCPQ_QuickLinksCompCtrl {
	
    @AuraEnabled
    public static String getInitializeQuickLinkWrapper(){
        return JSON.serialize(new List<KCPQ_QuickLinksWrapperCtrl>());
    }
    
    @AuraEnabled
    public static List<KCPQ_QuickLinksWrapperCtrl> getQuickLinkWrapper(String quickLinkJSONStr){
        List<KCPQ_QuickLinksWrapperCtrl> quickLinksLst = (List<KCPQ_QuickLinksWrapperCtrl>)JSON.deserialize(quickLinkJSONStr, List<KCPQ_QuickLinksWrapperCtrl>.class);
        for(KCPQ_Quick_Link__c quickLink : [SELECT Id, Name, Description__c, Link__c, Order__c, isActive__c, Labels__c 
                                            FROM KCPQ_Quick_Link__c WHERE isActive__c = true ORDER BY Order__c ASC]){
        	quickLinksLst.add(new KCPQ_QuickLinksWrapperCtrl(quickLink));
        }
        return quickLinksLst;
    }
    
    /*@AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
    }*/
}