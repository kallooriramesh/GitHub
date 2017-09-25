public class KCPQ_FAQCtrl {

    
@AuraEnabled
    public static List<FAQ__kav> getFaqDetails()
    {
        List<FAQ__kav> faqs=[SELECT Id, Summary, Title, ArticleType, PublishStatus 
                                   FROM FAQ__kav
                                   Where PublishStatus = 'Online'];
        return faqs;
    }
    
    @AuraEnabled
    public static List<Resource__kav> getResources()
    {
        List<Resource__kav> Resources=[SELECT Id, Summary, Title, ArticleType, PublishStatus, UrlName
                                   FROM Resource__kav
                                   Where PublishStatus = 'Online'];
        return Resources;
    }
    
    @AuraEnabled
    public static List<Media__kav> getMediaResources()
    {
        List<Media__kav> Resources=[SELECT Id, Summary, Title, ArticleType, PublishStatus, UrlName, Media_URL__c
                                   FROM Media__kav
                                   Where PublishStatus = 'Online'];
        return Resources;
    }
    @AuraEnabled
    public static String getpathprefixURL(){
        return site.getpathprefix();
    }
}