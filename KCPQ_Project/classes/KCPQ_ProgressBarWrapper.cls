public class KCPQ_ProgressBarWrapper {
	
	@AuraEnabled public String stageName {get; set;}
    @AuraEnabled public Integer stageOrder {get; set;}
    
    public KCPQ_ProgressBarWrapper(String stageName, Integer stageOrder){
        this.stageName = stageName;
        this.stageOrder = stageOrder;
    }
}