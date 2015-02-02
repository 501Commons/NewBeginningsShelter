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
private class TestServiceParticipationTriggerClass {
	
	static testMethod void testSetChildField() {
		TestHarness th = new TestHarness();
		th.createChildEnrollment();
		th.insertServiceParticipation();
		//check that the Child field on the service participation has 
		//been set to the the Child field on the Enrollment
		ServiceParticipation__c sp = [select id, Child__c from ServiceParticipation__c].get(0);		
		System.assertEquals(th.enr.Child__c, sp.Child__c);
	}

    static testMethod void testAttachContracts() {
        TestHarness th = new TestHarness();
        
        //lock contract 
        th.c.Lock_Contract__c = true;
        update th.c;
        
        //add an enrollment
        th.createEnrollment();
        
        //add service participation
        th.insertServiceParticipation();
     	
     	//check that contract has been attached
     	ContractParticipation__c cp = [select id, Contract__c, Service_Participation__c 
     									from ContractParticipation__c].get(0);
		System.assertNotEquals(null, cp);
		System.assertEquals(th.c.Id, cp.Contract__c);
		System.assertEquals(th.sp.Id, cp.Service_Participation__c);		     									   
    }
    
    static testMethod void deleteServiceParticipation() {
    	TestHarness th = new TestHarness();
        
        //lock contract 
        th.c.Lock_Contract__c = true;
        update th.c;
        
        //add an enrollment
        th.createEnrollment();
        
        //add service participation
        th.insertServiceParticipation();
        
        //check that contract has been attached
     	List<ContractParticipation__c> cpList = [select id, Contract__c, Service_Participation__c 
     									from ContractParticipation__c];     									
        System.assertEquals(1, cpList.size());
        
        List<Milestone__c> mlList = [select id from Milestone__c];
        System.assertEquals(10, mlList.size());
        
        //delete service participation, make sure contract participation has been deleted
        delete th.sp;
        cpList = [select id, Contract__c, Service_Participation__c 
     									from ContractParticipation__c];
        System.assertEquals(0, cpList.size());
        
        //make sure all milestones have been deleted too
        mlList = [select id from Milestone__c];
        System.assertEquals(0, mlList.size());
    }
    
    //this will test that we also clean up outcomes without milestones
    static testMethod void deleteServiceParticipation2() {
    	TestHarness th = new TestHarness();
        
        //add one more contract
        th.createAdditionalContractWithOutcomesNoMilestones();
        
        //lock contract 
        th.c.Lock_Contract__c = true;
        th.c2.Lock_Contract__c = true;
        update th.c;
        update th.c2;
        
        //add an enrollment
        th.createEnrollment();
        
        //add service participation
        th.insertServiceParticipation();
        
        //check that contracts have been attached
     	List<ContractParticipation__c> cpList = [select id, Contract__c, Service_Participation__c 
     									from ContractParticipation__c];     									
        System.assertEquals(2, cpList.size());
        
        //check that outcomes were created 
        List<Outcome__c> outcomeList = [select id from Outcome__c];
        System.assertEquals(12, outcomeList.size());
        
        //delete the service participation
        delete th.sp;
        
        //make sure all milestones and outcome have been deleted 
        List<Milestone__c> mlList = [select id from Milestone__c];
        System.assertEquals(0, mlList.size());
        
        outcomeList = [select id from Outcome__c];
        System.assertEquals(0, outcomeList.size());
    }
    
    static testMethod void updateServiceParticipationWithGoal(){
    	TestHarness th = new TestHarness();
    	
    	// add enrolment to create an Case_Record__c 
    	th.createEnrollment();
    	
    	// insert a Service Participation
    	th.insertServiceParticipation();
    	Case_Record__c ci = [SELECT Id, Goals_Not_Met__c FROM Case_Record__c WHERE id = :th.cr.id];
    	System.assert(!ci.Goals_Not_Met__c.contains(th.initialGoal));
    	
    	String updatedGoal = ServiceParticipationTriggerClass.allGoalsMap().values().get(1);    		
    	th.sp.Goals__c = updatedGoal;
    	update th.sp;
    	
    	Case_Record__c cu = [SELECT Id, Goals_Not_Met__c FROM Case_Record__c WHERE id = :th.cr.id];
    	System.assert(!cu.Goals_Not_Met__c.contains(updatedGoal));
        }
}