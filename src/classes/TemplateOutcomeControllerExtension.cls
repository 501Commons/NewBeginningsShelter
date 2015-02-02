/** 
* Written by Nineta Martinov , copyright (c) 2013 501Commons
* Controller extension for creating new template outcome and overriding the Save button
*/
public without sharing class TemplateOutcomeControllerExtension {
    private Contract__c c;
    private Id contractId;  
    public Template_Outcome__c templateOutcome {get; private set;}  
    
    public TemplateOutcomeControllerExtension(ApexPages.StandardController stdController) { 
        init();
    }       
    
    public void init() {              
       contractId = ApexPages.currentPage().getParameters().get('contractId');       
       c = [select id, name from Contract__c where id = :contractId limit 1];
       templateOutcome = new Template_Outcome__c(Contract__c=contractId);             
    }
    
    public Contract__c getContract() {
        return c;
    }   
     
    public PageReference save() {
        insert templateOutcome;             
        PageReference pageRef = new PageReference ('/'+templateOutcome.Id);                       
        pageRef.setRedirect(true);        
        return pageRef;
    }    
    
    public PageReference saveAnAddMilestone() {
        insert templateOutcome;                     
        String templateName = [select id, name from Template_Outcome__c where id = :templateOutcome.id limit 1].Name;
        PageReference pageRef = new PageReference ('/a0Z/e?CF00Ni000000CTKH9='+templateName);                         
        pageRef.setRedirect(true);        
        return pageRef;
    }   
}