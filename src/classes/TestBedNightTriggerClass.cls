@isTest
private class TestBedNightTriggerClass {
	
	private static Id shelterRecordTypeID = Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter').getRecordTypeId();
	private static Id shelterChildrenRecordTypeID = Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter Child').getRecordTypeId();
	private static final List<String> statusList = new List<String>{'Intake to be completed', 'Intake Completed'};
	private static final List<Id> recTypeList = new List<Id>{shelterRecordTypeID, shelterChildrenRecordTypeID};
	
	
	//set up the test environment
    private class TestHarness {  
    	
    	Contact c;
    	Case_Record__c cr;
    	Bed_Night__c bn4;
    	Bed_Night__c bn3;
    	Bed_Night__c bn2;
    	    	
    	TestHarness() {
    		//create Client
    		c = new Contact(Lastname='Simpson', Firstname='Lisa');
    		insert c;
    		
    		//create case records      				    		
			cr = new Case_Record__c(Name='Test', 
									Status__c = 'Intake Completed', 
									RecordTypeId = recTypeList[1],
									Contact__c=c.id);    		    		    												
			insert cr;		
			
			Bed_Night__c bn1 = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(-4), Case_Record__c = cr.id);	
			insert bn1;
			
			bn2 = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(-3), Case_Record__c = cr.id);	
			insert bn2;
			
			bn3 = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(-2), Case_Record__c = cr.id);	
			insert bn3;		
			
			bn4 = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(-5), Case_Record__c = cr.id);	
			insert bn4;	
			
    	}
    }
    
    static testMethod void testInsertWithSuccess() {
    	TestHarness th = new TestHarness();
    	
    	//inserting a Bed_Night_c that doesn't exist anymore
    	Bed_Night__c bn = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(-1), Case_Record__c = th.cr.id);	
		insert bn;
    }
    
    static testMethod void testInsertWithFailure() {
    	TestHarness th = new TestHarness();
    	
    	//inserting a Bed_Night_c that doesn't exist anymore
    	Bed_Night__c bn = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(-2), Case_Record__c = th.cr.id);
    	try {	
    		// should throw an exception
			insert bn;
			System.assert(true == false);
    	} catch (System.DmlException e) {
    		// when trying to insert a duplicate an error message should be thrown
    		System.assert(e.getMessage().contains('Bed night with this date already exists'));
    	}
    }
    
 	static testMethod void testDeleteWithSuccess() {
    	TestHarness th = new TestHarness();
    	
    	// delete the oldest bednight
    	delete th.bn4;
    	
    	// delete the most recent bednight
    	delete th.bn3;
    }
    
    static testMethod void testDeleteWithFailure() {
    	TestHarness th = new TestHarness();
    	boolean exceptionThrown = false;
    	// delete the oldest bednight
    	try {
    		delete th.bn2;
    		System.assert(true == false);	
    	} catch (Exception e) {
    		exceptionThrown = true;    		
		}
		// when trying to insert a duplicate an exception should be thrown
    	System.assert(exceptionThrown);
    }
}