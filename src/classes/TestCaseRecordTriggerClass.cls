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
private class TestCaseRecordTriggerClass {
    
    static testMethod void testExitingCaseRecords() {
    	TestHarness2 th2 = new TestHarness2();
    	test.startTest();
    	//try to exit the parent case record
    	th2.crParent.Status__c = 'Exited';
    	try {
    		update th2.crParent;
    	} catch (System.DmlException e){
    		System.assert(e.getMessage().contains('You cannot exit this case record while the participant\'s children have Active case records.'));
    	}
    	
    	System.assertNotEquals('Exited', [select Status__c from Case_Record__c where id =: th2.crParent.Id].Status__c);
    	 
    	th2.crChild1 = [select id, name, Status__c from Case_Record__c where id = :th2.crChild1.id];    	
    	th2.crChild1.Status__c = 'Exited';
    	update th2.crChild1;
    	
    	th2.crChild2 = [select id, name, Status__c from Case_Record__c where id = :th2.crChild2.id];	
    	th2.crChild2.Status__c = 'Exited';
    	update th2.crChild2;
    	
    	th2.crParent = [select id, name, Status__c from Case_Record__c where id = :th2.crParent.id];
    	th2.crParent.Status__c = 'Exited';
    	update th2.crParent;
    	
    	System.assertEquals('Exited', [select Status__c from Case_Record__c where id =: th2.crParent.Id].Status__c);
    	
    	test.stopTest();
    }
    
    //set up the test environment
    private class TestHarness {    	
    	Contact c;
    	Case_Record__c cr1;
    	Case_Record__c cr2;
    	    	
    	TestHarness() {
    		//create Client
    		c = new Contact(Lastname='Simpson', Firstname='Lisa');
    		insert c;
    		
    		//create case records      				    		
    		cr1 = new Case_Record__c(Name='Test', Contact__c=c.id);    		    		    												
			insert cr1;
			
			cr2 = new Case_Record__c(Name='Test', Contact__c=c.id);    		    		    												
			insert cr2;								
    	}
    }
    
     //set up the test environment
    private class TestHarness2 {    	
    	Contact parent;
    	Contact child1, child2;
    	
    	Case_Record__c crParent;
    	Case_Record__c crChild1;
    	Case_Record__c crChild2;
    	    	
    	TestHarness2() {
    		Id parentRecTypeId = [select id from RecordType where name='Participant'].id;
    		Id childRecTypeId = [select id from RecordType where name='Child'].id;
    		
    		npo02__Household__c household = new npo02__Household__c(Name='Test Household');
    		insert household;
    		
    		//create Parent Client
    		parent = new Contact(Lastname='Simpson', Firstname='Lisa', RecordTypeId=parentRecTypeId, npo02__Household__c=household.Id);
    		insert parent;
    		    		    		
    		child1 = new Contact(Lastname='Test1', Firstname='Abby', RecordTypeId=childRecTypeId, npo02__Household__c=household.id);
    		insert child1;
    		
    		child2 = new Contact(Lastname='Test2', Firstname='Child', RecordTypeId=childRecTypeId, npo02__Household__c=household.id);
    		insert child2;
    		
    		//create case records      				    		
    		crParent = new Case_Record__c(Name='Parent Case Record', Contact__c=parent.id, Household__c=household.id);    		    		    												
			insert crParent;
			
			crChild1 = new Case_Record__c(Name='Child 1 case Record', Contact__c=child1.id, Household__c=household.id);    		    		    												
			insert crChild1;			
						
			crChild2 = new Case_Record__c(Name='Child 2 case Record', Contact__c=child2.id, Household__c=household.id);    		    		    												
			insert crChild2;										
    	}
    }
}