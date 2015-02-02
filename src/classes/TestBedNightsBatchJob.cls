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
private class TestBedNightsBatchJob {
	private static Id shelterRecordTypeID = Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter').getRecordTypeId();
	private static Id shelterChildrenRecordTypeID = Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter Child').getRecordTypeId();
	private static final List<String> statusList = new List<String>{'Intake to be completed', 'Intake Completed'};
	private static final List<Id> recTypeList = new List<Id>{shelterRecordTypeID, shelterChildrenRecordTypeID};
  	
  	static testMethod void testBatchCreation() {
  	TestHarness th = new TestHarness();
        
        test.startTest();
  
		BedNightsBatchJob.createBedNights();
        
        test.stopTest();
    
		List<Bed_Night__c> bedNights1 = [select id, Bednight_Date__c, Case_Record__c
									from Bed_Night__c where Case_Record__c = :th.cr1.id];
									
		System.assertEquals(Date.today(), bedNights1[0].Bednight_Date__c);
        	
  		List<Bed_Night__c> bedNights2 = [select id, Bednight_Date__c, Case_Record__c
									from Bed_Night__c where Case_Record__c = :th.cr2.id
									order by Bednight_Date__c desc];
		
		System.assertEquals(Date.today(), bedNights2[0].Bednight_Date__c);
		System.assertEquals(Date.today().addDays(-1), bedNights2[1].Bednight_Date__c);
		System.assertEquals(Date.today().addDays(-2), bedNights2[2].Bednight_Date__c);
		System.assertEquals(Date.today().addDays(-3), bedNights2[3].Bednight_Date__c);
		System.assertEquals(Date.today().addDays(-4), bedNights2[4].Bednight_Date__c);
		
  	}
  	
	static testMethod void testCreateBedNights() {
        TestHarness th = new TestHarness();
        
        test.startTest();
  
		BedNightsBatchJob.createBedNights(th.caseRecords);
		
		List<Bed_Night__c> bedNights1 = [select id, Bednight_Date__c, Case_Record__c
									from Bed_Night__c where Case_Record__c = :th.cr1.id];
									
		System.assertEquals(Date.today(), bedNights1[0].Bednight_Date__c);
        
        List<Bed_Night__c> bedNights2 = [select id, Bednight_Date__c, Case_Record__c
									from Bed_Night__c where Case_Record__c = :th.cr2.id
									order by Bednight_Date__c desc];
		
		System.assertEquals(Date.today(), bedNights2[0].Bednight_Date__c);
		System.assertEquals(Date.today().addDays(-1), bedNights2[1].Bednight_Date__c);
		System.assertEquals(Date.today().addDays(-2), bedNights2[2].Bednight_Date__c);
		System.assertEquals(Date.today().addDays(-3), bedNights2[3].Bednight_Date__c);
		System.assertEquals(Date.today().addDays(-4), bedNights2[4].Bednight_Date__c);
		
        test.stopTest();
    }
    
    //set up the test environment
    private class TestHarness {  
    	
    	Contact c;
    	Case_Record__c cr1;
    	Case_Record__c cr2;
    	Map<Id, Case_Record__c> caseRecords = new Map<Id, Case_Record__c>();
    	    	
    	TestHarness() {
    		//create Client
    		c = new Contact(Lastname='Simpson', Firstname='Lisa');
    		insert c;
    		
    		//create case records      				    		
    		cr1 = new Case_Record__c(Name='Test', 
    								Status__c = 'Intake to be completed', 
    								RecordTypeId = recTypeList[0],
    								Contact__c=c.id);    		    		    												
			insert cr1;
			
			cr2 = new Case_Record__c(Name='Test', 
									Status__c = 'Intake Completed', 
									RecordTypeId = recTypeList[1],
									Contact__c=c.id);    		    		    												
			insert cr2;		
			
			Bed_Night__c bn1 = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(-4), Case_Record__c = cr2.id);	
			insert bn1;
			
			Bed_Night__c bn2 = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(-3), Case_Record__c = cr2.id);	
			insert bn2;
			
			Bed_Night__c bn3 = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(-2), Case_Record__c = cr2.id);	
			insert bn3;		
			
			caseRecords = new Map<id, Case_Record__c>([select id, CreatedDate, Most_Recent_Bed_Night__c from Case_Record__c]);
						
    	}
    }
}