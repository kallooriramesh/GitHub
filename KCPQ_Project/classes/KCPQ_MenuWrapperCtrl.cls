public class KCPQ_MenuWrapperCtrl {
    
    @AuraEnabled 
    public Menu__c menu {get;set;}
    @AuraEnabled 
    public Boolean isChildMenu {
        get {
        	return lstChildMenu == null || lstChildMenu.size() == 0;
    	}
        protected set;
    }
    @AuraEnabled 
    public List<KCPQ_MenuWrapperCtrl> lstChildMenu {get;set;}
    
    public KCPQ_MenuWrapperCtrl(Menu__c menu,List<KCPQ_MenuWrapperCtrl> lstChildMenu){
        this.menu = menu;
        this.lstChildMenu = lstChildMenu;
    }
}