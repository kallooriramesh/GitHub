public class KCPQ_PartnerWrapper {
	
    @AuraEnabled public String logoName {get; set;}
    @AuraEnabled public String sidebarColor {get; set;}
    @AuraEnabled public Boolean showCompanyLogoOnly {get; set;}
    
    public KCPQ_PartnerWrapper(){
		
    }
}