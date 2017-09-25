@isTest
public class KCPQ_FAQCtrl_Test {
    public static testMethod void setTestData()
    {
        Test.startTest();
        FAQ__kav faq = new FAQ__kav();
        faq.Title='Test';
        faq.Summary = 'testing';
        faq.UrlName='https-partners-salesforce-com-loginswitcher-startURL-456435645';
        upsert faq;
        faq = [SELECT KnowledgeArticleId FROM FAQ__kav WHERE Id = :faq.Id];
        KbManagement.PublishingService.publishArticle(faq.KnowledgeArticleId,false);
        
        
        Resource__kav res = new Resource__kav();
        res.Title='Test';
        res.Summary = 'testing';
        res.UrlName='https-www-slideshare-net-slideshow-embed-code-213123';
        upsert res;
        res = [SELECT KnowledgeArticleId FROM Resource__kav WHERE Id = :res.Id];
        KbManagement.PublishingService.publishArticle(res.KnowledgeArticleId,false);
        
        Media__kav media=new Media__kav();
        media.Title='Test';
        media.Summary = 'testing';
        media.UrlName='https-partners-salesforce-com-loginswitcher-startURL-64454';
        upsert media;
        
        media = [SELECT KnowledgeArticleId FROM Media__kav WHERE Id = :media.Id];
        KbManagement.PublishingService.publishArticle(media.KnowledgeArticleId,false);
        
        //KbManagement.PublishingService.publishArticle(media.KnowledgeArticleId,true);
        
        KCPQ_FAQCtrl.getFaqDetails();
        KCPQ_FAQCtrl.getMediaResources();
        KCPQ_FAQCtrl.getpathprefixURL();
        KCPQ_FAQCtrl.getResources();
        Test.stopTest();
    }
}