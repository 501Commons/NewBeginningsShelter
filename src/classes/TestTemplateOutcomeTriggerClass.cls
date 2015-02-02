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
private class TestTemplateOutcomeTriggerClass {

    static testMethod void testOutcomeEditing() {
        TestHarness th = new TestHarness();
        //lock contract 
        th.c.Lock_Contract__c = true;
        update th.c;
        
        //try to update template outcomes       
        for (Template_Outcome__c to : th.templateOutcomes) {
     		to.Template_Outcome_Detail__c = 'Test';   	
        }
        try{
        	update th.templateOutcomes;
        } catch (System.DmlException e){
    		System.assert(e.getMessage().contains('The parent contract has been locked, you cannot edit this template outcome.'));
    	}
    }
    
    static testMethod void testOutcomeDelete() {
    	TestHarness th = new TestHarness();
        //lock contract 
        th.c.Lock_Contract__c = true;
        update th.c;
        
        //try to delete template outcome
        try{
        	delete th.templateOutcomes;
        } catch (System.DmlException e){
    		System.assert(e.getMessage().contains('The parent contract has been locked, you cannot delete this template outcome.'));
    	}
    }
    
    static testMethod void testMilestoneEditing() {
        TestHarness th = new TestHarness();
        //lock contract 
        th.c.Lock_Contract__c = true;
        update th.c;
        
        //try to update template outcomes       
        for (Template_Milestone__c tm : th.templateMilestones) {
     		tm.Description__c = 'Test';   	
        }
        try{
        	update th.templateMilestones;
        } catch (System.DmlException e){
    		System.assert(e.getMessage().contains('The parent contract has been locked, you cannot edit this template milestone.'));
    	}
    }
    
    static testMethod void testMilestoneDelete() {
    	TestHarness th = new TestHarness();
        //lock contract 
        th.c.Lock_Contract__c = true;
        update th.c;
        
        //try to delete template outcomes              
        try{
        	delete th.templateMilestones;
        } catch (System.DmlException e){
    		System.assert(e.getMessage().contains('The parent contract has been locked, you cannot delete this template milestone.'));
    	}
    }
}