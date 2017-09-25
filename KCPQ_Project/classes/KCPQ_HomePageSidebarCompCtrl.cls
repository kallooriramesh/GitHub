public class KCPQ_HomePageSidebarCompCtrl {
	
    @AuraEnabled
    public static KCPQ_PartnerWrapper getPartnerWrapper(){
        
        KCPQ_PartnerWrapper partnerWrapperObj = new KCPQ_PartnerWrapper();
        Id userAccId = null;
        Id userConId = null;
        for(User u : [SELECT Id, Name, ContactId FROM User WHERE Id =: UserInfo.getUserId() Limit 1]){
            userConId = u.ContactId;
        }
        if(userConId != null){
            for(Contact c : [SELECT Id, Name, AccountId FROM Contact WHERE Id =: userConId Limit 1]){
                userAccId = c.AccountId;
            }
        }
        if(userAccId != null){
            for(Account a : [SELECT Id,Logo_Name__c,Sidebar_Color__c,Show_Company_Logo_Only__c FROM Account WHERE Id =: userAccId LIMIT 1]){
                partnerWrapperObj.logoName = a.Logo_Name__c;
                partnerWrapperObj.sidebarColor = a.Sidebar_Color__c;
                partnerWrapperObj.showCompanyLogoOnly = a.Show_Company_Logo_Only__c;
            }
        }
        if(userAccId == null || partnerWrapperObj.logoName == null){
            String customLabelValue = System.Label.KCPQ_Company_Logo;
            partnerWrapperObj.logoName = customLabelValue;
        }
        if(userAccId == null){
            Boolean customLabelValue = false;
            if(System.Label.KCPQ_Show_Company_Logo_Only == 'True' || System.Label.KCPQ_Show_Company_Logo_Only == 'true'){
                customLabelValue = true;
            }
            partnerWrapperObj.showCompanyLogoOnly = customLabelValue;
        }
        return partnerWrapperObj;
    }
    
    @AuraEnabled
    public static User getUserDetails(){
        return [SELECT Id, Name, FullPhotoUrl, SmallPhotoUrl, MediumPhotoUrl FROM User WHERE Id =: UserInfo.getUserId()];
    }
    
    @AuraEnabled
    public static String getInitializeMenuWrapper(){
        return JSON.serialize(new List<KCPQ_MenuWrapperCtrl>());
    }
    
    @AuraEnabled
    public static List<KCPQ_MenuWrapperCtrl> getMenuWrapper(String menuJSONStr){
        List<KCPQ_MenuWrapperCtrl> myMenu = (List<KCPQ_MenuWrapperCtrl>)JSON.deserialize(menuJSONStr, List<KCPQ_MenuWrapperCtrl>.class);
        Map<Id,Menu__c> mapMenu = new Map<Id,Menu__c>();
        Map<Id,List<KCPQ_MenuWrapperCtrl>> mapForChildMenus = new Map<Id,List<KCPQ_MenuWrapperCtrl>>();
        for(Menu__c m : [SELECT Id, Name, Icon__c, Parent_menu__c, Link__c, Order__c, isActive__c 
                         FROM Menu__c WHERE isActive__c = true ORDER BY Parent_menu__c,Order__c ASC]){
            mapMenu.put(m.Id,m);
            if(m.Parent_menu__c != null){
                mapForChildMenus.get(m.Parent_menu__c).add(new KCPQ_MenuWrapperCtrl(m,null));
            }else{
                mapForChildMenus.put(m.Id,new List<KCPQ_MenuWrapperCtrl>());
            }
        }
        if(mapForChildMenus != null && mapForChildMenus.size() > 0){
            for(Id menuId : mapForChildMenus.keySet()){
                myMenu.add(new KCPQ_MenuWrapperCtrl(mapMenu.get(menuId),mapForChildMenus.get(menuId)));
            }
        }
        return myMenu;
    }
    
    @AuraEnabled
    public static String getLogoutURL(){
    	return site.getbaseurl() + '/secur/logout.jsp';
    }
    
    @AuraEnabled
    public static String getbaseURL(){
        return site.getbaseurl();
    }
    
    @AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
    }
}