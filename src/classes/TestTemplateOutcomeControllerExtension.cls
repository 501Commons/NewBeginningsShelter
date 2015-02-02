/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestTemplateOutcomeControllerExtension {

    static testMethod void testSaveTemplateOutcomeControllerExtension() {
    	Contract__c testContract = new Contract__c(Name='Test');  
    	insert testContract;
    	
    	ApexPages.StandardController stdContr = new ApexPages.StandardController(new Template_Outcome__c()); 
    	ApexPages.currentPage().getParameters().put('contractId', testContract.Id);
    	          
        TemplateOutcomeControllerExtension controller = new TemplateOutcomeControllerExtension(stdContr);
        controller.templateOutcome.Template_Outcome_Name__c = 'A Test';
        controller.templateOutcome.Template_Outcome_Detail__c = 'Details...';
        //test save
        System.assertEquals(testContract.Name, controller.getContract().Name);
		PageReference pr = controller.save();
		System.assertEquals('/'+controller.templateOutcome.id, pr.getUrl());				
    }
    
      static testMethod void testSaveAndNewTemplateOutcomeControllerExtension() {
    	Contract__c testContract = new Contract__c(Name='Test');  
    	insert testContract;
    	 
    	ApexPages.StandardController stdContr = new ApexPages.StandardController(new Template_Outcome__c());
    	ApexPages.currentPage().getParameters().put('contractId', testContract.Id);
    	          
        TemplateOutcomeControllerExtension controller = new TemplateOutcomeControllerExtension(stdContr);
        controller.templateOutcome.Template_Outcome_Name__c = 'A Test';
        controller.templateOutcome.Template_Outcome_Detail__c = 'Details...';      
				
		//test save and re-direct
		PageReference pr = controller.saveAnAddMilestone();
		
		String tName = [select name from Template_Outcome__c].Name;
		
		System.assertEquals('/a0Z/e?CF00Ni000000CTKH9='+tName, pr.getUrl());        
    }
}